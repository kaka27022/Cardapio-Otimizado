-- Receita_Ingredientes (use coluna quantidade e opcional)
INSERT INTO Receita_Ingredientes (id_receita, id_ingrediente, quantidade, opcional)
VALUES
(1, 1, 200, FALSE), -- arroz
(1, 2, 150, FALSE), -- feijão
(2, 3, 200, FALSE), -- frango
(3, 4, 100, FALSE), -- ovo
(4, 6, 40, FALSE),  -- aveia
(4, 7, 100, FALSE), -- banana
(4, 5, 200, TRUE);  -- leite (opcional)
