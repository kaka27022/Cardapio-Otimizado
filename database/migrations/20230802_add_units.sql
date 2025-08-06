-- =============================================
-- MIGRAÇÃO: SUPORTE A UNIDADES DE MEDIDA
-- Versão: 1.1
-- Data: 2023-08-02
-- Descrição: Adiciona sistema completo de unidades de medida
-- =============================================

START TRANSACTION;

-- =============================================
-- 1. CRIAÇÃO DA TABELA DE UNIDADES DE MEDIDA
-- =============================================
CREATE TABLE IF NOT EXISTS UnidadesMedida (
    id_unidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    abreviacao VARCHAR(10) NOT NULL,
    tipo ENUM('peso', 'volume', 'unidade', 'outro') NOT NULL,
    gramas_equivalente DECIMAL(10,4) COMMENT 'Equivalente em gramas para conversão',
    ml_equivalente DECIMAL(10,4) COMMENT 'Equivalente em ml para conversão',
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT uk_unidade_nome UNIQUE (nome),
    CONSTRAINT uk_unidade_abreviacao UNIQUE (abreviacao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- 2. MODIFICAÇÃO DA TABELA RECEITA_INGREDIENTES
-- =============================================
-- Renomeia a coluna quantidade_gramas para quantidade_base
ALTER TABLE Receita_Ingredientes 
CHANGE COLUMN quantidade_gramas quantidade_base DECIMAL(10,2) NOT NULL COMMENT 'Quantidade na unidade base';

-- Adiciona coluna de unidade de medida e fator de conversão
ALTER TABLE Receita_Ingredientes
ADD COLUMN id_unidade INT AFTER id_ingrediente,
ADD COLUMN fator_conversao DECIMAL(10,4) DEFAULT 1.0 AFTER quantidade_base,
ADD COLUMN quantidade_gramas DECIMAL(10,2) GENERATED ALWAYS AS (
    CASE 
        WHEN (SELECT gramas_equivalente FROM UnidadesMedida WHERE id_unidade = Receita_Ingredientes.id_unidade) IS NOT NULL 
        THEN quantidade_base * (SELECT gramas_equivalente FROM UnidadesMedida WHERE id_unidade = Receita_Ingredientes.id_unidade) * fator_conversao
        ELSE quantidade_base * fator_conversao
    END
) STORED AFTER fator_conversao;

-- Adiciona a chave estrangeira
ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT fk_ri_unidade
FOREIGN KEY (id_unidade) REFERENCES UnidadesMedida(id_unidade)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- =============================================
-- 3. POPULAÇÃO DAS UNIDADES DE MEDIDA BÁSICAS
-- =============================================
INSERT INTO UnidadesMedida (nome, abreviacao, tipo, gramas_equivalente, ml_equivalente, descricao) VALUES
-- Unidades de peso
('grama', 'g', 'peso', 1.0, NULL, 'Unidade métrica básica de peso'),
('quilograma', 'kg', 'peso', 1000.0, NULL, 'Mil gramas'),
('libra', 'lb', 'peso', 453.592, NULL, 'Unidade de peso do sistema imperial'),
('onça', 'oz', 'peso', 28.3495, NULL, 'Onça avoirdupois'),

-- Unidades de volume
('mililitro', 'ml', 'volume', NULL, 1.0, 'Unidade métrica básica de volume'),
('litro', 'l', 'volume', NULL, 1000.0, 'Mil mililitros'),
('colher de chá', 'c.c.', 'volume', NULL, 5.0, 'Colher de chá padrão'),
('colher de sopa', 'c.s.', 'volume', NULL, 15.0, 'Colher de sopa padrão'),
('xícara', 'xíc.', 'volume', NULL, 240.0, 'Xícara padrão de 240ml'),
('copo americano', 'copo', 'volume', NULL, 240.0, 'Copo padrão de 240ml'),

-- Unidades de contagem
('unidade', 'un', 'unidade', NULL, NULL, 'Item inteiro'),
('dúzia', 'dz', 'unidade', NULL, NULL, 'Doze unidades'),
('pitada', 'pit.', 'outro', NULL, NULL, 'Pequena quantidade entre os dedos'),
('a gosto', 'q.b.', 'outro', NULL, NULL, 'Quantidade conforme preferência');

-- =============================================
-- 4. ATUALIZAÇÃO DOS DADOS EXISTENTES
-- =============================================
-- Atribui 'grama' como unidade padrão para registros existentes
UPDATE Receita_Ingredientes 
SET id_unidade = (SELECT id_unidade FROM UnidadesMedida WHERE abreviacao = 'g')
WHERE id_unidade IS NULL;

-- =============================================
-- 5. ATUALIZAÇÃO DE GATILHOS PARA SUPORTAR UNIDADES
-- =============================================
DELIMITER //

-- Atualiza o procedimento de cálculo nutricional para usar quantidade_gramas
CREATE OR REPLACE PROCEDURE AtualizarNutrientesReceita(IN p_id_receita INT)
BEGIN
    DECLARE v_calorias DECIMAL(10,2);
    DECLARE v_proteinas DECIMAL(10,2);
    DECLARE v_carboidratos DECIMAL(10,2);
    DECLARE v_fibras DECIMAL(10,2);
    DECLARE v_gorduras DECIMAL(10,2);
    DECLARE v_porcoes INT;
    
    SELECT porcoes INTO v_porcoes FROM Receitas WHERE id_receita = p_id_receita;
    
    SELECT 
        SUM(ri.quantidade_gramas * i.calorias_por_100g / 100),
        SUM(ri.quantidade_gramas * i.proteinas_por_100g / 100),
        SUM(ri.quantidade_gramas * i.carboidratos_por_100g / 100),
        SUM(ri.quantidade_gramas * i.fibras_por_100g / 100),
        SUM(ri.quantidade_gramas * i.gorduras_por_100g / 100)
    INTO 
        v_calorias, v_proteinas, v_carboidratos, v_fibras, v_gorduras
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = p_id_receita;
    
    UPDATE Receitas
    SET 
        calorias_totais = COALESCE(v_calorias, 0),
        calorias_por_porcao = COALESCE(v_calorias, 0) / v_porcoes,
        proteinas_totais = COALESCE(v_proteinas, 0),
        carboidratos_totais = COALESCE(v_carboidratos, 0),
        fibras_totais = COALESCE(v_fibras, 0),
        gorduras_totais = COALESCE(v_gorduras, 0),
        low_carb = (COALESCE(v_carboidratos, 0) < 30),
        high_protein = (COALESCE(v_proteinas, 0) > 20)
    WHERE id_receita = p_id_receita;
END//

DELIMITER ;

-- =============================================
-- 6. NOVAS RESTRIÇÕES E VALIDAÇÕES
-- =============================================
-- Garante que a unidade seja compatível com o tipo de ingrediente
DELIMITER //

CREATE TRIGGER valida_unidade_ingrediente
BEFORE INSERT ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    DECLARE tipo_unidade VARCHAR(20);
    DECLARE tipo_ingrediente VARCHAR(20);
    
    -- Obtém o tipo da unidade
    SELECT tipo INTO tipo_unidade 
    FROM UnidadesMedida 
    WHERE id_unidade = NEW.id_unidade;
    
    -- Determina o tipo esperado para o ingrediente
    SELECT 
        CASE 
            WHEN nome LIKE '%líquido%' OR nome LIKE '%óleo%' THEN 'volume'
            ELSE 'peso'
        END INTO tipo_ingrediente
    FROM Ingredientes
    WHERE id_ingrediente = NEW.id_ingrediente;
    
    -- Valida a compatibilidade
    IF tipo_unidade != tipo_ingrediente AND tipo_unidade != 'unidade' AND tipo_unidade != 'outro' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de unidade incompatível com o ingrediente';
    END IF;
END//

DELIMITER ;

COMMIT;

-- =============================================
-- MENSAGEM DE CONCLUSÃO
-- =============================================
SELECT 'Migração de unidades de medida concluída com sucesso!' AS mensagem;