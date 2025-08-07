import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # adiciona a raiz do projeto

from src.models.receita import Receita
from src.services.gerador_cardapio import gerar_cardapio

# Simulação de receitas
receitas_mock = [
    Receita(
        id=1,
        nome="Salada Vegana",
        ingredientes=["alface", "tomate", "azeite"],
        restricoes=["vegano", "sem_lactose"]
    ),
    Receita(
        id=2,
        nome="Omelete",
        ingredientes=["ovo", "queijo", "cebola"],
        restricoes=["vegetariano"]
    ),
    Receita(
        id=3,
        nome="Arroz com tofu",
        ingredientes=["arroz", "tofu", "alho"],
        restricoes=["vegano", "sem_lactose", "sem_gluten"]
    ),
]

# Ingredientes disponíveis no momento
ingredientes_disponiveis = ["arroz", "tofu", "alho", "alface", "tomate", "azeite"]

# Restrições do usuário
restricoes_usuario = ["vegano", "sem_lactose"]

# Chamar a função
cardapio = gerar_cardapio(receitas_mock, ingredientes_disponiveis, restricoes_usuario)

# Mostrar resultados
print("Cardápio gerado:")
for receita in cardapio:
    print(f"- {receita.nome}")
