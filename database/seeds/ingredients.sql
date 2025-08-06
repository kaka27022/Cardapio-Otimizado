-- Ingredientes
INSERT INTO Ingredientes (id_ingrediente, nome, calorias_por_100g, proteinas_por_100g, carboidratos_por_100g, gorduras_por_100g, contem_lactose, contem_gluten, vegano)
VALUES
(1, 'Arroz', 130, 2.7, 28.0, 0.3, FALSE, FALSE, TRUE),
(2, 'Feijão', 127, 8.7, 23.0, 0.5, FALSE, FALSE, TRUE),
(3, 'Frango', 165, 31.0, 0.0, 3.6, FALSE, FALSE, FALSE),
(4, 'Ovo', 143, 13.0, 1.1, 10.0, FALSE, FALSE, FALSE),
(5, 'Leite', 60, 3.2, 4.8, 3.3, TRUE, FALSE, FALSE),
(6, 'Aveia', 389, 16.9, 66.3, 6.9, FALSE, TRUE, TRUE),
(7, 'Banana', 89, 1.1, 23.0, 0.3, FALSE, FALSE, TRUE);
