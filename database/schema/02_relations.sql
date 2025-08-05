-- 1. Relações da tabela Receita_Ingredientes
ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT fk_receita_ingrediente_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT fk_receita_ingrediente_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
ON DELETE RESTRICT  -- Impede deletar ingrediente usado em receitas
ON UPDATE CASCADE;

-- 2. Relações da tabela Passos_Preparo
ALTER TABLE Passos_Preparo
ADD CONSTRAINT fk_passo_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE  -- Se a receita for deletada, os passos também são
ON UPDATE CASCADE;

-- 3. Relações da tabela Receita_Categorias
ALTER TABLE Receita_Categorias
ADD CONSTRAINT fk_rc_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Receita_Categorias
ADD CONSTRAINT fk_rc_categoria
FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
ON DELETE CASCADE  -- Se categoria for deletada, remove das receitas
ON UPDATE CASCADE;

-- 4. Relações da tabela Receita_Utensilios
ALTER TABLE Receita_Utensilios
ADD CONSTRAINT fk_ru_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Receita_Utensilios
ADD CONSTRAINT fk_ru_utensilio
FOREIGN KEY (id_utensilio) REFERENCES Utensilios(id_utensilio)
ON DELETE RESTRICT  -- Impede deletar utensílio em uso
ON UPDATE CASCADE;

-- 5. Índices adicionais para otimização de joins
CREATE INDEX idx_receita_ingrediente_ingrediente ON Receita_Ingredientes(id_ingrediente);
CREATE INDEX idx_passo_receita ON Passos_Preparo(id_receita);
CREATE INDEX idx_rc_categoria ON Receita_Categorias(id_categoria);
CREATE INDEX idx_ru_utensilio ON Receita_Utensilios(id_utensilio);

-- 6. Restrições de verificação (CHECK constraints)
ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT chk_quantidade_positiva
CHECK (quantidade > 0);

ALTER TABLE Passos_Preparo
ADD CONSTRAINT chk_ordem_positiva
CHECK (numero_ordem > 0);

ALTER TABLE Receitas
ADD CONSTRAINT chk_tempo_preparo_positivo
CHECK (tempo_preparo > 0);

-- 7. Relações derivadas (para integridade lógica)
DELIMITER //
CREATE TRIGGER tr_verifica_vegano_ingredientes
BEFORE UPDATE ON Receitas
FOR EACH ROW
BEGIN
    DECLARE ingrediente_nao_vegano INT;
    
    -- Verifica se há ingredientes não veganos em receitas marcadas como veganas
    IF NEW.vegano = TRUE THEN
        SELECT COUNT(*) INTO ingrediente_nao_vegano
        FROM Receita_Ingredientes ri
        JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
        WHERE ri.id_receita = NEW.id_receita AND i.vegano = FALSE;
        
        IF ingrediente_nao_vegano > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Receita não pode ser vegana pois contém ingredientes não veganos';
        END IF;
    END IF;
END//
DELIMITER ;

-- 8. Gatilho para atualização automática de flags
DELIMITER //
CREATE TRIGGER tr_atualiza_flags_receita
AFTER INSERT ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    DECLARE tem_gluten INT;
    DECLARE tem_lactose INT;
    DECLARE tem_nao_vegano INT;
    DECLARE tem_nao_vegetariano INT;
    
    -- Verifica restrições baseadas nos ingredientes
    SELECT 
        COUNT(CASE WHEN i.contem_gluten THEN 1 END),
        COUNT(CASE WHEN i.contem_lactose THEN 1 END),
        COUNT(CASE WHEN NOT i.vegano THEN 1 END),
        COUNT(CASE WHEN NOT i.vegetariano THEN 1 END)
    INTO tem_gluten, tem_lactose, tem_nao_vegano, tem_nao_vegetariano
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = NEW.id_receita;
    
    -- Atualiza os flags na receita
    UPDATE Receitas r
    SET 
        r.gluten_free = (tem_gluten = 0),
        r.lactose_free = (tem_lactose = 0),
        r.vegano = (tem_nao_vegano = 0),
        r.vegetariano = (tem_nao_vegetariano = 0)
    WHERE r.id_receita = NEW.id_receita;
END//
DELIMITER ;