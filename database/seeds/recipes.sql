INSERT INTO Receitas 
(id_receita, nome, tipo_refeicao, tempo_preparo, dificuldade, ativo, vegano, vegetariano, lactose_free, gluten_free, calorias_totais, proteinas_totais, gorduras_totais)
VALUES
(1, 'Arroz com feijão', 'almoço', 40, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(2, 'Frango grelhado', 'jantar', 30, 'fácil', TRUE, FALSE, FALSE, TRUE, TRUE, NULL, NULL, NULL),
(3, 'Omelete', 'café', 15, 'fácil', TRUE, FALSE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(4, 'Vitamina de banana com aveia', 'café', 10, 'fácil', TRUE, TRUE, TRUE, FALSE, FALSE, NULL, NULL, NULL),
(5, 'Purê de batata com carne', 'almoço', 45, 'fácil', TRUE, FALSE, FALSE, TRUE, TRUE, NULL, NULL, NULL),
(6, 'Tofu com espinafre e quinoa', 'almoço', 35, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(7, 'Macarrão ao molho com queijo', 'jantar', 25, 'fácil', TRUE, TRUE, TRUE, FALSE, FALSE, NULL, NULL, NULL),
(8, 'Sanduíche natural de tofu', 'lanche', 15, 'fácil', TRUE, TRUE, TRUE, TRUE, FALSE, NULL, NULL, NULL),
(9, 'Salada de grão-de-bico', 'almoço', 20, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(10, 'Lentilha com arroz', 'almoço', 35, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(11, 'Abobrinha refogada com alho e arroz', 'almoço', 25, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(12, 'Panqueca de ovo com espinafre', 'café', 20, 'fácil', TRUE, FALSE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(13, 'Salada fria de lentilha com tomate e cenoura', 'almoço', 20, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(14, 'Pão integral com ricota e tomate', 'lanche', 10, 'fácil', TRUE, FALSE, TRUE, FALSE, FALSE, NULL, NULL, NULL),
(15, 'Quibe assado com trigo e carne bovina', 'jantar', 50, 'fácil', TRUE, FALSE, FALSE, TRUE, FALSE, NULL, NULL, NULL),
(16, 'Purê de batata-doce', 'almoço', 40, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(17, 'Salmão grelhado com quinoa', 'jantar', 35, 'médio', TRUE, FALSE, FALSE, TRUE, TRUE, NULL, NULL, NULL),
(18, 'Panqueca de chia e linhaça', 'café', 20, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(19, 'Salada fresca de berinjela e pepino', 'lanche', 15, 'fácil', TRUE, TRUE, TRUE, TRUE, TRUE, NULL, NULL, NULL),
(20, 'Granola com leite de amêndoas e frutas', 'café', 10, 'fácil', TRUE, TRUE, TRUE, TRUE, FALSE, NULL, NULL, NULL);
