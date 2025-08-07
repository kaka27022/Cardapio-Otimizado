import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # adiciona a raiz do projeto

from src.models.receita import Receita
from typing import List

def gerar_cardapio(
    receitas: List[Receita],
    ingredientes_disponiveis: List[str],
    restricoes_usuario: List[str]
) -> List[Receita]:
    """
    Gera um cardápio filtrando receitas com:
    - apenas ingredientes disponíveis
    - que respeitam TODAS as restrições do usuário

    Args:
        receitas: lista de objetos Receita
        ingredientes_disponiveis: lista de strings
        restricoes_usuario: lista de strings como 'sem_lactose', 'vegano', etc

    Returns:
        Lista de receitas compatíveis
    """
    cardapio = []

    for receita in receitas:
        # Checa se todos os ingredientes da receita estão disponíveis
        if all(ing.lower() in map(str.lower, ingredientes_disponiveis) for ing in receita.ingredientes):
            # Checa se todas as restrições do usuário estão incluídas nas da receita
            if all(r.lower() in map(str.lower, receita.restricoes) for r in restricoes_usuario):
                cardapio.append(receita)

    return cardapio




