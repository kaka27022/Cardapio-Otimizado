-- 1. Relações da tabela Receita_Ingredientes
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

-- 2. Relações da tabela Passos_Preparo
ALTER TABLE Passos_Preparo
ADD CONSTRAINT fk_passo_receita
FOREIGN KEY (id_receita) REFERENCES Receitas(id_receita)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 3. Relações da tabela Receita_Categorias
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

-- 4. Relações da tabela Receita_Utensilios
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

-- 5. Índices adicionais para otimização de joins
CREATE INDEX idx_receita_ingrediente_ingrediente ON Receita_Ingredientes(id_ingrediente);
CREATE INDEX idx_passo_receita ON Passos_Preparo(id_receita);
CREATE INDEX idx_rc_categoria ON Receita_Categorias(id_categoria);
CREATE INDEX idx_ru_utensilio ON Receita_Utensilios(id_utensilio);

-- 6. Restrições de verificação (CHECK constraints)
ALTER TABLE Receita_Ingredientes
ADD CONSTRAINT chk_quantidade_positiva
CHECK (quantidade > 0);

ALTER TABLE Passos_Preparo
ADD CONSTRAINT chk_ordem_positiva
CHECK (numero_ordem > 0);

ALTER TABLE Receitas
ADD CONSTRAINT chk_tempo_preparo_positivo
CHECK (tempo_preparo > 0);
