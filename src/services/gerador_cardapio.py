from src.models.receita import Receita
from typing import List

def gerar_cardapio(receitas: List[Receita], ingredientes_disponiveis: List[str], restricoes_usuario: List[str]) -> List[Receita]:
    cardapio = []

    for receita in receitas:
        if not set(receita.ingredientes).issubset(set(ingredientes_disponiveis)):
            continue  # pula se faltar ingrediente

        if not set(restricoes_usuario).issubset(set(receita.restricoes)):
            continue  # pula se não atender às restrições

        cardapio.append(receita)

    return cardapio

