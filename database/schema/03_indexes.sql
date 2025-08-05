-- =============================================
-- ÍNDICES PARA TABELA DE INGREDIENTES
-- =============================================

-- Índice para busca por nome (case-insensitive)
CREATE INDEX idx_ingrediente_nome ON Ingredientes(nome);
CREATE INDEX idx_ingrediente_nome_lower ON Ingredientes(LOWER(nome));

-- Índices para filtros por restrições alimentares
CREATE INDEX idx_ingrediente_gluten ON Ingredientes(contem_gluten);
CREATE INDEX idx_ingrediente_lactose ON Ingredientes(contem_lactose);
CREATE INDEX idx_ingrediente_vegano ON Ingredientes(vegano);
CREATE INDEX idx_ingrediente_vegetariano ON Ingredientes(vegetariano);

-- Índice composto para buscas nutricionais
CREATE INDEX idx_ingrediente_nutricao ON Ingredientes(
    proteinas_por_100g DESC, 
    carboidratos_por_100g ASC, 
    gorduras_por_100g ASC
);

-- =============================================
-- ÍNDICES PARA TABELA DE RECEITAS
-- =============================================

-- Índices para tipos de refeição e dificuldade
CREATE INDEX idx_receita_tipo_refeicao ON Receitas(tipo_refeicao);
CREATE INDEX idx_receita_dificuldade ON Receitas(dificuldade);

-- Índices compostos para restrições alimentares
CREATE INDEX idx_receita_restricoes ON Receitas(
    gluten_free, 
    lactose_free, 
    vegano, 
    vegetariano, 
    low_carb, 
    high_protein
);

-- Índices para busca nutricional
CREATE INDEX idx_receita_calorias ON Receitas(calorias_totais);
CREATE INDEX idx_receita_proteinas ON Receitas(proteinas_totais DESC);
CREATE INDEX idx_receita_carboidratos ON Receitas(carboidratos_totais);
CREATE INDEX idx_receita_balanceamento ON Receitas(
    (proteinas_totais/(calorias_totais+0.1)) DESC
);

-- Índice para tempo de preparo
CREATE INDEX idx_receita_tempo_preparo ON Receitas(tempo_preparo);

-- Índice para receitas mais populares
CREATE INDEX idx_receita_popularidade ON Receitas(visualizacoes DESC, avaliacao_media DESC);

-- =============================================
-- ÍNDICES PARA TABELAS DE RELAÇÃO
-- =============================================

-- Receita_Ingredientes (já criado em 02_relations.sql)
-- CREATE INDEX idx_receita_ingrediente_ingrediente ON Receita_Ingredientes(id_ingrediente);

-- Índice para busca por quantidade de ingredientes
CREATE INDEX idx_ri_quantidade ON Receita_Ingredientes(quantidade DESC);

-- Índice para Passos_Preparo (já criado em 02_relations.sql)
-- CREATE INDEX idx_passo_receita ON Passos_Preparo(id_receita);

-- Índice para ordenação de passos
CREATE INDEX idx_passos_ordem ON Passos_Preparo(id_receita, numero_ordem);

-- =============================================
-- ÍNDICES PARA TABELAS AUXILIARES
-- =============================================

-- Categorias
CREATE INDEX idx_categoria_nome ON Categorias(nome);

-- Utensílios
CREATE INDEX idx_utensilio_nome ON Utensilios(nome);

-- =============================================
-- ÍNDICES FULL-TEXT PARA BUSCA TEXTUAL
-- =============================================

-- Busca full-text em ingredientes
ALTER TABLE Ingredientes ADD FULLTEXT INDEX ft_ingrediente_nome_desc (nome, descricao);

-- Busca full-text em receitas
ALTER TABLE Receitas ADD FULLTEXT INDEX ft_receita_nome_desc (nome, descricao);

-- Busca full-text em passos de preparo
ALTER TABLE Passos_Preparo ADD FULLTEXT INDEX ft_passos_desc (descricao);

-- =============================================
-- ÍNDICES ESPECIAIS PARA O ALGORITMO CSP
-- =============================================

-- Índice para consultas do algoritmo de satisfação de restrições
CREATE INDEX idx_csp_ingredientes_compatíveis ON Ingredientes(
    contem_gluten,
    contem_lactose,
    vegano,
    vegetariano
) WHERE ativo = TRUE;

-- Índice para consultas de matching de receitas
CREATE INDEX idx_csp_receitas_compatíveis ON Receitas(
    gluten_free,
    lactose_free,
    vegano,
    vegetariano,
    tipo_refeicao
) WHERE ativo = TRUE;

-- Índice para busca por ingredientes disponíveis
CREATE INDEX idx_csp_ingredientes_disponiveis ON Receita_Ingredientes(
    id_ingrediente,
    id_receita
);