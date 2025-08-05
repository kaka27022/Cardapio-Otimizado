-- =============================================
-- GATILHO PRINCIPAL: ATUALIZAÇÃO NUTRICIONAL
-- =============================================

DELIMITER //

CREATE TRIGGER atualizar_nutrientes_receita
AFTER INSERT ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    DECLARE total_calorias DECIMAL(10,2);
    DECLARE total_proteinas DECIMAL(10,2);
    DECLARE total_carboidratos DECIMAL(10,2);
    DECLARE total_fibras DECIMAL(10,2);
    DECLARE total_gorduras DECIMAL(10,2);
    
    -- Calcula os totais nutricionais baseados nos ingredientes
    SELECT 
        SUM(ri.quantidade * i.calorias_por_100g / 100),
        SUM(ri.quantidade * i.proteinas_por_100g / 100),
        SUM(ri.quantidade * i.carboidratos_por_100g / 100),
        SUM(ri.quantidade * i.fibras_por_100g / 100),
        SUM(ri.quantidade * i.gorduras_por_100g / 100)
    INTO 
        total_calorias, total_proteinas, 
        total_carboidratos, total_fibras, total_gorduras
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = NEW.id_receita;
    
    -- Atualiza os valores na receita
    UPDATE Receitas
    SET 
        calorias_totais = total_calorias,
        proteinas_totais = total_proteinas,
        carboidratos_totais = total_carboidratos,
        fibras_totais = total_fibras,
        gorduras_totais = total_gorduras,
        
        -- Atualiza flags automáticas baseadas nos valores
        low_carb = (total_carboidratos < 30), -- menos de 30g de carboidratos
        high_protein = (total_proteinas > 20)  -- mais de 20g de proteínas
    WHERE id_receita = NEW.id_receita;
END//

-- Gatilho para atualização quando um ingrediente é removido
CREATE TRIGGER atualizar_nutrientes_after_delete
AFTER DELETE ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    -- Reutiliza a mesma lógica do gatilho de inserção
    DECLARE total_calorias DECIMAL(10,2);
    DECLARE total_proteinas DECIMAL(10,2);
    DECLARE total_carboidratos DECIMAL(10,2);
    DECLARE total_fibras DECIMAL(10,2);
    DECLARE total_gorduras DECIMAL(10,2);
    
    SELECT 
        SUM(ri.quantidade * i.calorias_por_100g / 100),
        SUM(ri.quantidade * i.proteinas_por_100g / 100),
        SUM(ri.quantidade * i.carboidratos_por_100g / 100),
        SUM(ri.quantidade * i.fibras_por_100g / 100),
        SUM(ri.quantidade * i.gorduras_por_100g / 100)
    INTO 
        total_calorias, total_proteinas, 
        total_carboidratos, total_fibras, total_gorduras
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = OLD.id_receita;
    
    UPDATE Receitas
    SET 
        calorias_totais = COALESCE(total_calorias, 0),
        proteinas_totais = COALESCE(total_proteinas, 0),
        carboidratos_totais = COALESCE(total_carboidratos, 0),
        fibras_totais = COALESCE(total_fibras, 0),
        gorduras_totais = COALESCE(total_gorduras, 0),
        low_carb = (COALESCE(total_carboidratos, 0) < 30,
        high_protein = (COALESCE(total_proteinas, 0) > 20)
    WHERE id_receita = OLD.id_receita;
END//

-- Gatilho para atualização quando um ingrediente é modificado
CREATE TRIGGER atualizar_nutrientes_after_update
AFTER UPDATE ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    -- Atualiza a receita antiga (se o ingrediente foi movido para outra receita)
    IF OLD.id_receita != NEW.id_receita THEN
        -- Chama a lógica do gatilho de DELETE para a receita antiga
        DECLARE total_calorias_old DECIMAL(10,2);
        DECLARE total_proteinas_old DECIMAL(10,2);
        -- ... outros campos
        
        SELECT 
            SUM(ri.quantidade * i.calorias_por_100g / 100),
            SUM(ri.quantidade * i.proteinas_por_100g / 100)
            -- ... outros cálculos
        INTO 
            total_calorias_old, total_proteinas_old
            -- ... outros campos
        FROM Receita_Ingredientes ri
        JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
        WHERE ri.id_receita = OLD.id_receita;
        
        UPDATE Receitas
        SET 
            calorias_totais = COALESCE(total_calorias_old, 0),
            proteinas_totais = COALESCE(total_proteinas_old, 0)
            -- ... outros campos
        WHERE id_receita = OLD.id_receita;
    END IF;
    
    -- Chama a lógica do gatilho de INSERT para a receita nova
    DECLARE total_calorias_new DECIMAL(10,2);
    DECLARE total_proteinas_new DECIMAL(10,2);
    -- ... outros campos
    
    SELECT 
        SUM(ri.quantidade * i.calorias_por_100g / 100),
        SUM(ri.quantidade * i.proteinas_por_100g / 100)
        -- ... outros cálculos
    INTO 
        total_calorias_new, total_proteinas_new
        -- ... outros campos
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = NEW.id_receita;
    
    UPDATE Receitas
    SET 
        calorias_totais = COALESCE(total_calorias_new, 0),
        proteinas_totais = COALESCE(total_proteinas_new, 0)
        -- ... outros campos
    WHERE id_receita = NEW.id_receita;
END//

-- =============================================
-- GATILHOS ADICIONAIS PARA INTEGRIDADE
-- =============================================

-- Garante que a quantidade não seja negativa
CREATE TRIGGER valida_quantidade_ingrediente
BEFORE INSERT ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    IF NEW.quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade deve ser maior que zero';
    END IF;
END//

-- Atualiza data de modificação automaticamente
CREATE TRIGGER atualiza_data_modificacao_receita
BEFORE UPDATE ON Receitas
FOR EACH ROW
BEGIN
    SET NEW.data_atualizacao = CURRENT_TIMESTAMP;
END//

-- =============================================
-- GATILHO PARA ATUALIZAÇÃO DE RESTRIÇÕES
-- =============================================

CREATE TRIGGER atualizar_restricoes_receita
AFTER INSERT ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    DECLARE tem_gluten BOOLEAN;
    DECLARE tem_lactose BOOLEAN;
    DECLARE tem_nao_vegano BOOLEAN;
    DECLARE tem_nao_vegetariano BOOLEAN;
    
    -- Verifica se há ingredientes que invalidam as restrições
    SELECT 
        MAX(i.contem_gluten),
        MAX(i.contem_lactose),
        MAX(NOT i.vegano),
        MAX(NOT i.vegetariano)
    INTO 
        tem_gluten, tem_lactose, tem_nao_vegano, tem_nao_vegetariano
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = NEW.id_receita;
    
    -- Atualiza os flags na receita
    UPDATE Receitas
    SET 
        gluten_free = NOT tem_gluten,
        lactose_free = NOT tem_lactose,
        vegano = NOT tem_nao_vegano,
        vegetariano = NOT tem_nao_vegetariano
    WHERE id_receita = NEW.id_receita;
END//

DELIMITER ;