-- =============================================
-- Função para atualizar nutrientes totais de uma receita
-- =============================================
CREATE OR REPLACE FUNCTION atualizar_nutrientes_receita_func() RETURNS TRIGGER AS $$
DECLARE
    total_calorias NUMERIC(10,2);
    total_proteinas NUMERIC(10,2);
    total_carboidratos NUMERIC(10,2);
    total_fibras NUMERIC(10,2);
    total_gorduras NUMERIC(10,2);
BEGIN
    SELECT 
        COALESCE(SUM(ri.quantidade * i.calorias_por_100g / 100),0),
        COALESCE(SUM(ri.quantidade * i.proteinas_por_100g / 100),0),
        COALESCE(SUM(ri.quantidade * i.carboidratos_por_100g / 100),0),
        COALESCE(SUM(ri.quantidade * i.fibras_por_100g / 100),0),
        COALESCE(SUM(ri.quantidade * i.gorduras_por_100g / 100),0)
    INTO
        total_calorias, total_proteinas, total_carboidratos, total_fibras, total_gorduras
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = COALESCE(NEW.id_receita, OLD.id_receita);

    UPDATE Receitas
    SET 
        calorias_totais = total_calorias,
        proteinas_totais = total_proteinas,
        carboidratos_totais = total_carboidratos,
        fibras_totais = total_fibras,
        gorduras_totais = total_gorduras,
        low_carb = (total_carboidratos < 30),
        high_protein = (total_proteinas > 20)
    WHERE id_receita = COALESCE(NEW.id_receita, OLD.id_receita);

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Função para atualizar flags de restrição (vegano, lactose, etc)
-- =============================================
CREATE OR REPLACE FUNCTION atualizar_flags_restricao_func() RETURNS TRIGGER AS $$
DECLARE
    tem_gluten BOOLEAN;
    tem_lactose BOOLEAN;
    tem_nao_vegano BOOLEAN;
    tem_nao_vegetariano BOOLEAN;
BEGIN
    SELECT 
        BOOL_OR(i.contem_gluten),
        BOOL_OR(i.contem_lactose),
        BOOL_OR(NOT i.vegano),
        BOOL_OR(NOT i.vegetariano)
    INTO
        tem_gluten, tem_lactose, tem_nao_vegano, tem_nao_vegetariano
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = NEW.id_receita;

    UPDATE Receitas
    SET 
        gluten_free = NOT tem_gluten,
        lactose_free = NOT tem_lactose,
        vegano = NOT tem_nao_vegano,
        vegetariano = NOT tem_nao_vegetariano
    WHERE id_receita = NEW.id_receita;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Função para verificar que uma receita vegana não tem ingredientes não veganos (item 7)
-- =============================================
CREATE OR REPLACE FUNCTION verifica_vegano_func() RETURNS TRIGGER AS $$
DECLARE
    ingrediente_nao_vegano_count INT;
BEGIN
    IF NEW.vegano THEN
        SELECT COUNT(*)
        INTO ingrediente_nao_vegano_count
        FROM Receita_Ingredientes ri
        JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
        WHERE ri.id_receita = NEW.id_receita AND i.vegano = FALSE;

        IF ingrediente_nao_vegano_count > 0 THEN
            RAISE EXCEPTION 'Receita não pode ser vegana pois contém ingredientes não veganos';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- Trigger para atualizar nutrientes após INSERT, UPDATE e DELETE em Receita_Ingredientes
-- =============================================
CREATE TRIGGER atualizar_nutrientes_receita_after_insert
AFTER INSERT ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION atualizar_nutrientes_receita_func();

CREATE TRIGGER atualizar_nutrientes_receita_after_update
AFTER UPDATE ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION atualizar_nutrientes_receita_func();

CREATE TRIGGER atualizar_nutrientes_receita_after_delete
AFTER DELETE ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION atualizar_nutrientes_receita_func();

-- =============================================
-- Trigger para atualizar flags de restrição após INSERT em Receita_Ingredientes
-- =============================================
CREATE TRIGGER atualizar_flags_restricao_after_insert
AFTER INSERT ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION atualizar_flags_restricao_func();

CREATE TRIGGER atualizar_flags_restricao_after_update
AFTER UPDATE ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION atualizar_flags_restricao_func();

CREATE TRIGGER atualizar_flags_restricao_after_delete
AFTER DELETE ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION atualizar_flags_restricao_func();

-- =============================================
-- Trigger para verificar integridade vegana antes de atualizar Receitas
-- =============================================
CREATE TRIGGER verifica_vegano_before_update
BEFORE UPDATE ON Receitas
FOR EACH ROW EXECUTE FUNCTION verifica_vegano_func();

-- =============================================
-- Trigger para validar quantidade positiva antes de inserir Receita_Ingredientes
-- =============================================
CREATE OR REPLACE FUNCTION valida_quantidade_positiva_func() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantidade <= 0 THEN
        RAISE EXCEPTION 'Quantidade deve ser maior que zero';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER valida_quantidade_ingrediente_before_insert
BEFORE INSERT ON Receita_Ingredientes
FOR EACH ROW EXECUTE FUNCTION valida_quantidade_positiva_func();

-- =============================================
-- Trigger para atualizar data de modificação da receita antes de UPDATE
-- =============================================
CREATE OR REPLACE FUNCTION atualiza_data_modificacao_func() RETURNS TRIGGER AS $$
BEGIN
    NEW.data_atualizacao = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualiza_data_modificacao_receita_before_update
BEFORE UPDATE ON Receitas
FOR EACH ROW EXECUTE FUNCTION atualiza_data_modificacao_func();
