-- Adiciona suporte a unidades de medida
ALTER TABLE Receita_Ingredientes
ADD COLUMN unidade VARCHAR(20) AFTER quantidade_gramas;