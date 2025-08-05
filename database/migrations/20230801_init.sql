-- =============================================
-- SCRIPT DE INICIALIZAÇÃO DO BANCO DE DADOS
-- Versão: 1.0
-- Data: 2023-08-01
-- Descrição: Criação inicial do schema completo
-- =============================================

START TRANSACTION;

-- =============================================
-- TABELA: INGREDIENTES
-- =============================================
CREATE TABLE IF NOT EXISTS Ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    calorias_por_100g DECIMAL(10,2) NOT NULL COMMENT 'kcal por 100g',
    proteinas_por_100g DECIMAL(10,2) NOT NULL COMMENT 'g por 100g',
    carboidratos_por_100g DECIMAL(10,2) NOT NULL COMMENT 'g por 100g',
    fibras_por_100g DECIMAL(10,2) DEFAULT 0.00,
    acucares_por_100g DECIMAL(10,2) DEFAULT 0.00,
    gorduras_por_100g DECIMAL(10,2) NOT NULL COMMENT 'g por 100g',
    gorduras_saturadas_por_100g DECIMAL(10,2) DEFAULT 0.00,
    colesterol_por_100g DECIMAL(10,2) DEFAULT 0.00 COMMENT 'mg por 100g',
    sodio_por_100g DECIMAL(10,2) DEFAULT 0.00 COMMENT 'mg por 100g',
    
    -- Flags de restrição alimentar
    contem_gluten BOOLEAN DEFAULT FALSE,
    contem_lactose BOOLEAN DEFAULT FALSE,
    vegano BOOLEAN DEFAULT TRUE,
    vegetariano BOOLEAN DEFAULT TRUE,
    alergenico BOOLEAN DEFAULT FALSE,
    ingrediente_cruelty_free BOOLEAN DEFAULT TRUE,
    organic_o BOOLEAN DEFAULT FALSE,
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    
    -- Constraints
    CONSTRAINT uk_ingrediente_nome UNIQUE (nome),
    CONSTRAINT chk_calorias_positivas CHECK (calorias_por_100g >= 0),
    CONSTRAINT chk_proteinas_positivas CHECK (proteinas_por_100g >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABELA: RECEITAS
-- =============================================
CREATE TABLE IF NOT EXISTS Receitas (
    id_receita INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    tipo_refeicao ENUM('café', 'almoço', 'jantar', 'lanche', 'sobremesa', 'bebida') NOT NULL,
    tempo_preparo INT NOT NULL COMMENT 'Minutos',
    tempo_cozimento INT COMMENT 'Minutos',
    porcoes INT NOT NULL DEFAULT 1,
    dificuldade ENUM('fácil', 'médio', 'difícil', 'expert') NOT NULL DEFAULT 'fácil',
    
    -- Informações nutricionais totais (calculadas)
    calorias_totais DECIMAL(10,2),
    calorias_por_porcao DECIMAL(10,2),
    proteinas_totais DECIMAL(10,2),
    carboidratos_totais DECIMAL(10,2),
    fibras_totais DECIMAL(10,2),
    gorduras_totais DECIMAL(10,2),
    
    -- Flags de restrição
    gluten_free BOOLEAN DEFAULT TRUE,
    lactose_free BOOLEAN DEFAULT TRUE,
    vegano BOOLEAN DEFAULT FALSE,
    vegetariano BOOLEAN DEFAULT TRUE,
    low_carb BOOLEAN DEFAULT FALSE,
    high_protein BOOLEAN DEFAULT FALSE,
    diabetic_friendly BOOLEAN DEFAULT FALSE,
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    visualizacoes INT DEFAULT 0,
    avaliacao_media DECIMAL(3,2) DEFAULT 0.00,
    
    -- Constraints
    CONSTRAINT uk_receita_nome UNIQUE (nome),
    CONSTRAINT chk_tempo_preparo_positivo CHECK (tempo_preparo > 0),
    CONSTRAINT chk_porcoes_positivas CHECK (porcoes > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABELA: RECEITA_INGREDIENTES
-- =============================================
CREATE TABLE IF NOT EXISTS Receita_Ingredientes (
    id_receita INT NOT NULL,
    id_ingrediente INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL COMMENT 'Quantidade base',
    unidade_medida ENUM('g', 'ml', 'colher de sopa', 'colher de chá', 'xícara', 'unidade', 'pitada') DEFAULT 'g',
    observacoes VARCHAR(255),
    opcional BOOLEAN DEFAULT FALSE,
    parte_utilizada VARCHAR(100) COMMENT 'Ex: folhas, polpa, casca',
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    PRIMARY KEY (id_receita, id_ingrediente),
    CONSTRAINT chk_quantidade_positiva CHECK (quantidade > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABELA: PASSOS_PREPARO
-- =============================================
CREATE TABLE IF NOT EXISTS Passos_Preparo (
    id_passo INT AUTO_INCREMENT PRIMARY KEY,
    id_receita INT NOT NULL,
    numero_ordem INT NOT NULL,
    descricao TEXT NOT NULL,
    tempo_estimado INT COMMENT 'Minutos',
    utensilios_sugeridos VARCHAR(255),
    foto VARCHAR(255),
    
    -- Constraints
    CONSTRAINT uk_ordem_receita UNIQUE (id_receita, numero_ordem),
    CONSTRAINT chk_ordem_positiva CHECK (numero_ordem > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- TABELAS AUXILIARES
-- =============================================

-- CATEGORIAS/TAGS
CREATE TABLE IF NOT EXISTS Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    icone VARCHAR(30),
    cor_hex VARCHAR(7) DEFAULT '#6c757d',
    
    CONSTRAINT uk_categoria_nome UNIQUE (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELAÇÃO RECEITA-CATEGORIA
CREATE TABLE IF NOT EXISTS Receita_Categorias (
    id_receita INT NOT NULL,
    id_categoria INT NOT NULL,
    
    PRIMARY KEY (id_receita, id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- UTENSÍLIOS
CREATE TABLE IF NOT EXISTS Utensilios (
    id_utensilio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT,
    essencial BOOLEAN DEFAULT FALSE,
    
    CONSTRAINT uk_utensilio_nome UNIQUE (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- RELAÇÃO RECEITA-UTENSÍLIO
CREATE TABLE IF NOT EXISTS Receita_Utensilios (
    id_receita INT NOT NULL,
    id_utensilio INT NOT NULL,
    
    PRIMARY KEY (id_receita, id_utensilio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================
-- RELAÇÕES ENTRE TABELAS
-- =============================================

-- Receita-Ingredientes
ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT fk_receita_ingrediente_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT fk_receita_ingrediente_ingrediente
FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- Passos-Preparo
ALTER TABLE Passos_Preparo
ADD CONSTRAINT fk_passo_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Receita-Categorias
ALTER TABLE Receita_Categorias
ADD CONSTRAINT fk_rc_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Receita_Categorias
ADD CONSTRAINT fk_rc_categoria
FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Receita-Utensílios
ALTER TABLE Receita_Utensilios
ADD CONSTRAINT fk_ru_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE Receita_Utensilios
ADD CONSTRAINT fk_ru_utensilio
FOREIGN KEY (id_utensilio) REFERENCES Utensilios(id_utensilio)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- =============================================
-- ÍNDICES PARA OTIMIZAÇÃO
-- =============================================

-- Índices para Ingredientes
CREATE INDEX idx_ingrediente_nome ON Ingredientes(nome);
CREATE INDEX idx_ingrediente_restricoes ON Ingredientes(contem_gluten, contem_lactose, vegano, vegetariano);
CREATE INDEX idx_ingrediente_nutricao ON Ingredientes(proteinas_por_100g DESC, carboidratos_por_100g ASC);

-- Índices para Receitas
CREATE INDEX idx_receita_tipo ON Receitas(tipo_refeicao);
CREATE INDEX idx_receita_restricoes ON Receitas(gluten_free, lactose_free, vegano, vegetariano);
CREATE INDEX idx_receita_nutricao ON Receitas(calorias_por_porcao, proteinas_totais DESC);
CREATE INDEX idx_receita_dificuldade ON Receitas(dificuldade);

-- Índices para Receita_Ingredientes
CREATE INDEX idx_ri_ingrediente ON Receita_Ingredientes(id_ingrediente);

-- Índices para Passos_Preparo
CREATE INDEX idx_pp_ordem ON Passos_Preparo(id_receita, numero_ordem);

-- =============================================
-- GATILHOS (TRIGGERS)
-- =============================================

DELIMITER //

-- Gatilho para cálculo automático de nutrientes
CREATE TRIGGER tr_atualiza_nutrientes_insert
AFTER INSERT ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    CALL AtualizarNutrientesReceita(NEW.id_receita);
END//

CREATE TRIGGER tr_atualiza_nutrientes_update
AFTER UPDATE ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    IF OLD.id_receita != NEW.id_receita THEN
        CALL AtualizarNutrientesReceita(OLD.id_receita);
    END IF;
    CALL AtualizarNutrientesReceita(NEW.id_receita);
END//

CREATE TRIGGER tr_atualiza_nutrientes_delete
AFTER DELETE ON Receita_Ingredientes
FOR EACH ROW
BEGIN
    CALL AtualizarNutrientesReceita(OLD.id_receita);
END//

-- Procedimento para cálculo de nutrientes
CREATE PROCEDURE AtualizarNutrientesReceita(IN p_id_receita INT)
BEGIN
    DECLARE v_calorias DECIMAL(10,2);
    DECLARE v_proteinas DECIMAL(10,2);
    DECLARE v_carboidratos DECIMAL(10,2);
    DECLARE v_fibras DECIMAL(10,2);
    DECLARE v_gorduras DECIMAL(10,2);
    DECLARE v_porcoes INT;
    
    -- Obtém número de porções
    SELECT porcoes INTO v_porcoes FROM Receitas WHERE id_receita = p_id_receita;
    
    -- Calcula totais
    SELECT 
        SUM(ri.quantidade * i.calorias_por_100g / 100),
        SUM(ri.quantidade * i.proteinas_por_100g / 100),
        SUM(ri.quantidade * i.carboidratos_por_100g / 100),
        SUM(ri.quantidade * i.fibras_por_100g / 100),
        SUM(ri.quantidade * i.gorduras_por_100g / 100)
    INTO 
        v_calorias, v_proteinas, v_carboidratos, v_fibras, v_gorduras
    FROM Receita_Ingredientes ri
    JOIN Ingredientes i ON ri.id_ingrediente = i.id_ingrediente
    WHERE ri.id_receita = p_id_receita;
    
    -- Atualiza receita
    UPDATE Receitas
    SET 
        calorias_totais = COALESCE(v_calorias, 0),
        calorias_por_porcao = COALESCE(v_calorias, 0) / v_porcoes,
        proteinas_totais = COALESCE(v_proteinas, 0),
        carboidratos_totais = COALESCE(v_carboidratos, 0),
        fibras_totais = COALESCE(v_fibras, 0),
        gorduras_totais = COALESCE(v_gorduras, 0),
        low_carb = (COALESCE(v_carboidratos, 0) < 30,
        high_protein = (COALESCE(v_proteinas, 0) > 20)
    WHERE id_receita = p_id_receita;
END//

DELIMITER ;

-- =============================================
-- DADOS INICIAIS (SEEDS)
-- =============================================

-- Inserção de categorias básicas
INSERT INTO Categorias (nome, descricao, icone, cor_hex) VALUES
('Saudável', 'Receitas com baixo teor calórico e balanceadas', 'heart', '#28a745'),
('Rápido', 'Receitas que podem ser preparadas em menos de 30 minutos', 'clock', '#17a2b8'),
('Proteico', 'Receitas com alto teor proteico', 'dumbbell', '#ffc107'),
('Vegetariano', 'Receitas sem carne', 'leaf', '#20c997'),
('Sobremesa', 'Doces e sobremesas', 'cake', '#dc3545');

-- Inserção de utensílios básicos
INSERT INTO Utensilios (nome, descricao, essencial) VALUES
('Faca de cozinha', 'Faca afiada para cortar ingredientes', TRUE),
('Tábua de cortar', 'Superfície para cortar alimentos', TRUE),
('Panela média', 'Panela de tamanho médio para cozinhar', TRUE),
('Frigideira', 'Para grelhar e fritar alimentos', TRUE),
('Espátula', 'Para mexer alimentos na frigideira', TRUE);

COMMIT;

-- =============================================
-- MENSAGEM DE CONCLUSÃO
-- =============================================
SELECT 'Migração inicial concluída com sucesso!' AS mensagem;