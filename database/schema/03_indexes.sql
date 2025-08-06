-- =============================================
-- ÍNDICES PARA TABELA DE INGREDIENTES
-- =============================================

-- Índice para busca por nome (case-insensitive)
CREATE INDEX idx_ingrediente_nome_lower ON Ingredientes (LOWER(nome));

-- Índices para filtros por restrições alimentares
CREATE INDEX idx_ingrediente_contem_gluten ON Ingredientes (contem_gluten);
CREATE INDEX idx_ingrediente_contem_lactose ON Ingredientes (contem_lactose);
CREATE INDEX idx_ingrediente_vegano ON Ingredientes (vegano);
CREATE INDEX idx_ingrediente_vegetariano ON Ingredientes (vegetariano);

-- Índice composto para buscas nutricionais (sem DESC, porque não é suportado no índice)
CREATE INDEX idx_ingrediente_nutricao ON Ingredientes (
    proteinas_por_100g, 
    carboidratos_por_100g, 
    gorduras_por_100g
);

-- =============================================
-- ÍNDICES PARA TABELA DE RECEITAS
-- =============================================

-- Índices para tipos de refeição e dificuldade
CREATE INDEX idx_receita_tipo_refeicao ON Receitas (tipo_refeicao);
CREATE INDEX idx_receita_dificuldade ON Receitas (dificuldade);

-- Índices compostos para restrições alimentares
CREATE INDEX idx_receita_restricoes ON Receitas (
    gluten_free, 
    lactose_free, 
    vegano, 
    vegetariano, 
    low_carb, 
    high_protein
);

-- Índices para busca nutricional (sem DESC, PostgreSQL não suporta ordem em índices compostos)
CREATE INDEX idx_receita_calorias ON Receitas (calorias_totais);
CREATE INDEX idx_receita_proteinas ON Receitas (proteinas_totais);
CREATE INDEX idx_receita_carboidratos ON Receitas (carboidratos_totais);

-- Índice para tempo de preparo
CREATE INDEX idx_receita_tempo_preparo ON Receitas (tempo_preparo);

-- Índice para receitas mais populares
CREATE INDEX idx_receita_popularidade ON Receitas (visualizacoes, avaliacao_media);

-- =============================================
-- ÍNDICES PARA TABELAS DE RELAÇÃO
-- =============================================

CREATE INDEX idx_ri_quantidade ON Receita_Ingredientes (quantidade);

CREATE INDEX idx_passos_ordem ON Passos_Preparo (id_receita, numero_ordem);

-- =============================================
-- ÍNDICES PARA TABELAS AUXILIARES
-- =============================================

CREATE INDEX idx_categoria_nome ON Categorias (nome);

CREATE INDEX idx_utensilio_nome ON Utensilios (nome);

-- =============================================
-- ÍNDICES FULL-TEXT PARA BUSCA TEXTUAL
-- =============================================

-- Para full-text search, primeiro crie colunas tsvector (opcional)
-- ou crie índices GIN usando expressões to_tsvector

CREATE INDEX ft_ingrediente_nome_idx ON Ingredientes USING GIN (
    to_tsvector('portuguese', coalesce(nome, ''))
);

CREATE INDEX ft_receita_nome_desc_idx ON Receitas USING GIN (
    to_tsvector('portuguese', coalesce(nome, '') || ' ' || coalesce(descricao, ''))
);

CREATE INDEX ft_passos_desc_idx ON Passos_Preparo USING GIN (
    to_tsvector('portuguese', coalesce(descricao, ''))
);

-- =============================================
-- ÍNDICES ESPECIAIS PARA O ALGORITMO CSP (Índices parciais)
-- =============================================

CREATE INDEX idx_csp_ingredientes_compatíveis ON Ingredientes (
    contem_gluten,
    contem_lactose,
    vegano,
    vegetariano
) WHERE ativo = TRUE;

CREATE INDEX idx_csp_receitas_compatíveis ON Receitas (
    gluten_free,
    lactose_free,
    vegano,
    vegetariano,
    tipo_refeicao
) WHERE ativo = TRUE;

CREATE INDEX idx_csp_ingredientes_disponiveis ON Receita_Ingredientes (
    id_ingrediente,
    id_receita
);
