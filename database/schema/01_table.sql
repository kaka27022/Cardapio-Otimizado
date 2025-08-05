-- Tabela de Ingredientes (contém informações nutricionais e flags de restrição)
CREATE TABLE IF NOT EXISTS Ingredientes (
    id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    calorias_por_100g DECIMAL(10,2) NOT NULL COMMENT 'Calorias em kcal por 100g',
    proteinas_por_100g DECIMAL(10,2) NOT NULL COMMENT 'Proteínas em gramas por 100g',
    carboidratos_por_100g DECIMAL(10,2) NOT NULL COMMENT 'Carboidratos em gramas por 100g',
    fibras_por_100g DECIMAL(10,2) DEFAULT 0 COMMENT 'Fibras em gramas por 100g',
    gorduras_por_100g DECIMAL(10,2) NOT NULL COMMENT 'Gorduras totais em gramas por 100g',
    gorduras_saturadas_por_100g DECIMAL(10,2) DEFAULT 0,
    sodio_por_100g DECIMAL(10,2) DEFAULT 0 COMMENT 'Sódio em mg por 100g',
    
    -- Flags de restrição
    contem_gluten BOOLEAN DEFAULT FALSE,
    contem_lactose BOOLEAN DEFAULT FALSE,
    vegano BOOLEAN DEFAULT TRUE,
    vegetariano BOOLEAN DEFAULT TRUE,
    ingrediente_cruelty_free BOOLEAN DEFAULT TRUE,
    organic_o BOOLEAN DEFAULT FALSE,
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Receitas (contém informações sobre as preparações)
CREATE TABLE IF NOT EXISTS Receitas (
    id_receita INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    tipo_refeicao ENUM('café', 'almoço', 'jantar', 'lanche', 'sobremesa') NOT NULL,
    tempo_preparo INT NOT NULL COMMENT 'Tempo em minutos',
    tempo_cozimento INT COMMENT 'Tempo em minutos (opcional)',
    dificuldade ENUM('fácil', 'médio', 'difícil', 'expert') NOT NULL,
    porcoes INT DEFAULT 1 COMMENT 'Número de porções',
    
    -- Informações nutricionais totais (calculadas)
    calorias_totais DECIMAL(10,2),
    proteinas_totais DECIMAL(10,2),
    carboidratos_totais DECIMAL(10,2),
    fibras_totais DECIMAL(10,2),
    gorduras_totais DECIMAL(10,2),
    
    -- Flags de restrição
    gluten_free BOOLEAN DEFAULT FALSE,
    lactose_free BOOLEAN DEFAULT FALSE,
    vegano BOOLEAN DEFAULT FALSE,
    vegetariano BOOLEAN DEFAULT TRUE,
    low_carb BOOLEAN DEFAULT FALSE,
    high_protein BOOLEAN DEFAULT FALSE,
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    visualizacoes INT DEFAULT 0,
    avaliacao_media DECIMAL(3,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de relação entre Receitas e Ingredientes
CREATE TABLE IF NOT EXISTS Receita_Ingredientes (
    id_receita INT NOT NULL,
    id_ingrediente INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL COMMENT 'Quantidade em gramas ou ml',
    unidade_medida ENUM('g', 'ml', 'colheres', 'xícaras', 'unidades') DEFAULT 'g',
    observacoes VARCHAR(255) COMMENT 'Ex: picado, ralado, etc.',
    opcional BOOLEAN DEFAULT FALSE,
    
    PRIMARY KEY (id_receita, id_ingrediente),
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Passos de Preparo
CREATE TABLE IF NOT EXISTS Passos_Preparo (
    id_passo INT AUTO_INCREMENT PRIMARY KEY,
    id_receita INT NOT NULL,
    numero_ordem INT NOT NULL,
    descricao TEXT NOT NULL,
    tempo_estimado INT COMMENT 'Tempo em minutos',
    
    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita) ON DELETE CASCADE,
    
    -- Metadados
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Categorias/Tags
CREATE TABLE IF NOT EXISTS Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    icone VARCHAR(30)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de relação Receita-Categoria
CREATE TABLE IF NOT EXISTS Receita_Categorias (
    id_receita INT NOT NULL,
    id_categoria INT NOT NULL,
    
    PRIMARY KEY (id_receita, id_categoria),
    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de Utensílios necessários
CREATE TABLE IF NOT EXISTS Utensilios (
    id_utensilio INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de relação Receita-Utensílio
CREATE TABLE IF NOT EXISTS Receita_Utensilios (
    id_receita INT NOT NULL,
    id_utensilio INT NOT NULL,
    
    PRIMARY KEY (id_receita, id_utensilio),
    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita) ON DELETE CASCADE,
    FOREIGN KEY (id_utensilio) REFERENCES Utensilios(id_utensilio) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;