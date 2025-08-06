-- Tipos ENUM
CREATE TYPE tipo_refeicao_enum AS ENUM ('café', 'almoço', 'jantar', 'lanche', 'sobremesa');
CREATE TYPE dificuldade_enum AS ENUM ('fácil', 'médio', 'difícil', 'expert');
CREATE TYPE unidade_medida_enum AS ENUM ('g', 'ml', 'colheres', 'xícaras', 'unidades');

-- Ingredientes
CREATE TABLE IF NOT EXISTS Ingredientes (
    id_ingrediente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    calorias_por_100g DECIMAL(10,2) NOT NULL,
    proteinas_por_100g DECIMAL(10,2) NOT NULL,
    carboidratos_por_100g DECIMAL(10,2) NOT NULL,
    fibras_por_100g DECIMAL(10,2) DEFAULT 0,
    gorduras_por_100g DECIMAL(10,2) NOT NULL,
    gorduras_saturadas_por_100g DECIMAL(10,2) DEFAULT 0,
    sodio_por_100g DECIMAL(10,2) DEFAULT 0,

    contem_gluten BOOLEAN DEFAULT FALSE,
    contem_lactose BOOLEAN DEFAULT FALSE,
    vegano BOOLEAN DEFAULT TRUE,
    vegetariano BOOLEAN DEFAULT TRUE,
    ingrediente_cruelty_free BOOLEAN DEFAULT TRUE,
    organic_o BOOLEAN DEFAULT FALSE,

    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE
);

-- Receitas
CREATE TABLE IF NOT EXISTS Receitas (
    id_receita SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    tipo_refeicao tipo_refeicao_enum NOT NULL,
    tempo_preparo INT NOT NULL,
    tempo_cozimento INT,
    dificuldade dificuldade_enum NOT NULL,
    porcoes INT DEFAULT 1,

    calorias_totais DECIMAL(10,2),
    proteinas_totais DECIMAL(10,2),
    carboidratos_totais DECIMAL(10,2),
    fibras_totais DECIMAL(10,2),
    gorduras_totais DECIMAL(10,2),

    gluten_free BOOLEAN DEFAULT FALSE,
    lactose_free BOOLEAN DEFAULT FALSE,
    vegano BOOLEAN DEFAULT FALSE,
    vegetariano BOOLEAN DEFAULT TRUE,
    low_carb BOOLEAN DEFAULT FALSE,
    high_protein BOOLEAN DEFAULT FALSE,

    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,
    visualizacoes INT DEFAULT 0,
    avaliacao_media DECIMAL(3,2) DEFAULT 0.00
);

-- Receita_Ingredientes
CREATE TABLE IF NOT EXISTS Receita_Ingredientes (
    id_receita INT NOT NULL,
    id_ingrediente INT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    unidade_medida unidade_medida_enum DEFAULT 'g',
    observacoes VARCHAR(255),
    opcional BOOLEAN DEFAULT FALSE,

    PRIMARY KEY (id_receita, id_ingrediente),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Passos_Preparo
CREATE TABLE IF NOT EXISTS Passos_Preparo (
    id_passo SERIAL PRIMARY KEY,
    id_receita INT NOT NULL,
    numero_ordem INT NOT NULL,
    descricao TEXT NOT NULL,
    tempo_estimado INT,

    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita) ON DELETE CASCADE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categorias
CREATE TABLE IF NOT EXISTS Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT,
    icone VARCHAR(30)
);

-- Receita_Categorias
CREATE TABLE IF NOT EXISTS Receita_Categorias (
    id_receita INT NOT NULL,
    id_categoria INT NOT NULL,

    PRIMARY KEY (id_receita, id_categoria),
    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita) ON DELETE CASCADE,
    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria) ON DELETE CASCADE
);

-- Utensilios
CREATE TABLE IF NOT EXISTS Utensilios (
    id_utensilio SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT
);

-- Receita_Utensilios
CREATE TABLE IF NOT EXISTS Receita_Utensilios (
    id_receita INT NOT NULL,
    id_utensilio INT NOT NULL,

    PRIMARY KEY (id_receita, id_utensilio),
    FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita) ON DELETE CASCADE,
    FOREIGN KEY (id_utensilio) REFERENCES Utensilios(id_utensilio) ON DELETE CASCADE
);
