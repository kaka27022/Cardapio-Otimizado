-- Receita_Ingredientes (use coluna quantidade e opcional)
INSERT INTO Receita_Ingredientes (id_receita, id_ingrediente, quantidade, opcional)
VALUES
(1, 1, 200, FALSE), -- arroz
(1, 2, 150, FALSE), -- feijão
(2, 3, 200, FALSE), -- frango
(3, 4, 100, FALSE), -- ovo
(4, 6, 40, FALSE),  -- aveia
(4, 7, 100, FALSE), -- banana
(4, 5, 200, TRUE),  -- leite (opcional)
-- Receita 5: Purê de batata com carne
(5, 8, 200, FALSE), -- batata
(5, 9, 150, FALSE), -- carne bovina
(5, 14, 50, TRUE),  -- tomate (opcional)

-- Receita 6: Tofu com espinafre e quinoa
(6, 10, 150, FALSE), -- tofu
(6, 16, 100, FALSE), -- espinafre
(6, 19, 120, FALSE), -- quinoa

-- Receita 7: Macarrão com molho e queijo
(7, 11, 200, FALSE), -- macarrão
(7, 14, 100, FALSE), -- tomate
(7, 17, 50, TRUE),   -- queijo mussarela (opcional)

-- Receita 8: Sanduíche natural
(8, 12, 100, FALSE), -- pão integral
(8, 10, 80, FALSE),  -- tofu
(8, 15, 50, TRUE),   -- cenoura ralada (opcional)

-- Receita 9: Salada de grão-de-bico
(9, 18, 150, FALSE), -- grão-de-bico
(9, 14, 70, FALSE),  -- tomate
(9, 16, 50, TRUE),   -- espinafre (opcional)

-- Receita 10: Lentilha com arroz
(10, 20, 100, FALSE), -- lentilha
(10, 1, 100, FALSE),  -- arroz
(10, 15, 30, TRUE),   -- cenoura (opcional)

-- Receita 11: Abobrinha refogada com alho e arroz
(11, 21, 150, FALSE), -- abobrinha
(11, 25, 10, FALSE),  -- alho
(11, 1, 100, FALSE),  -- arroz

-- Receita 12: Panqueca de ovo com espinafre
(12, 4, 100, FALSE),  -- ovo
(12, 16, 50, FALSE),  -- espinafre
(12, 14, 30, TRUE),   -- tomate (opcional)

-- Receita 13: Salada fria de lentilha com tomate e cenoura
(13, 20, 100, FALSE), -- lentilha
(13, 14, 50, FALSE),  -- tomate
(13, 15, 50, FALSE),  -- cenoura

-- Receita 14: Pão integral com ricota e tomate
(14, 12, 100, FALSE), -- pão integral
(14, 27, 50, FALSE),  -- ricota
(14, 14, 30, TRUE),   -- tomate (opcional)

-- Receita 15: Quibe assado com trigo e carne bovina
(15, 28, 120, FALSE), -- trigo para quibe
(15, 9, 150, FALSE),  -- carne bovina
(15, 24, 40, TRUE),   -- cebola (opcional)

(16, 31, 200, FALSE), -- batata-doce
(16, 25, 10, TRUE),  -- alho (opcional)

-- Receita 17: Salmão grelhado com quinoa
(17, 33, 180, FALSE), -- salmão
(17, 19, 120, FALSE), -- quinoa
(17, 24, 20, TRUE),   -- cebola (opcional)

-- Receita 18: Panqueca de chia e linhaça
(18, 36, 30, FALSE), -- chia
(18, 37, 30, FALSE), -- linhaça
(18, 4, 100, FALSE), -- ovo

-- Receita 19: Salada fresca de berinjela e pepino
(19, 38, 150, FALSE), -- berinjela
(19, 44, 100, FALSE), -- pepino
(19, 25, 5, TRUE),    -- alho (opcional)

-- Receita 20: Granola com leite de amêndoas e frutas
(20, 50, 80, FALSE), -- granola
(20, 35, 200, FALSE), -- leite de amêndoas
(20, 32, 100, FALSE), -- manga
(20, 43, 50, TRUE);  -- morango (opcional)
