# Cardapio-Otimizado

1. Banco de Dados Geral (read-only):
   - Tabela Ingredientes (informações nutricionais e flags de restrição)
   - Tabela Receitas (composição e informações)

2. Input do Usuário:
   - Lista de ingredientes disponíveis
   - Restrições alimentares (gluten-free, vegetariano, etc.)

3. Processamento:
   - Match entre ingredientes disponíveis e receitas possíveis
   - Filtragem por restrições
   - Ordenação por critérios (menos calorias, mais proteína, etc.)

4. Output:
   - Cardápio com receitas viáveis\

# Estrutura do Projeto
cardapio_otimizado/
│
├── database/
│   ├── ingredients.db (SQLite)
│   └── recipes.db (SQLite)
│
├── data/
│   ├── sample_ingredients.csv
│   └── sample_recipes.csv
│
├── src/
│   ├── database.py
│   ├── menu_optimizer.py
│   └── main.py
│
└── requirements.txt