from typing import List, Dict
from src.models.receita import Receita

def gerar_cardapio(
    receitas: List[Receita],
    ingredientes_disponiveis: List[str],
    restricoes_usuario: List[str]
) -> Dict[str, List[Receita]]:
    """
    Gera um cardápio separado por tipo de refeição.
    """

    # Mapa para converter valores do banco para as chaves usadas no cardápio
    mapa_tipos = {
        "café": "cafe_da_manha",
        "cafe": "cafe_da_manha",
        "café da manhã": "cafe_da_manha",
        "almoço": "almoco",
        "almoco": "almoco",
        "jantar": "jantar",
        "lanche": "lanche"
    }

    cardapio = {
        "cafe_da_manha": [],
        "almoco": [],
        "jantar": [],
        "lanche": []
    }

    for receita in receitas:
        # Normaliza o tipo de refeição
        tipo_norm = mapa_tipos.get(receita.tipo_refeicao.lower())

        if not tipo_norm:
            continue  # ignora apenas se não estiver no mapa

        # Verifica ingredientes
        if all(ing.lower() in map(str.lower, ingredientes_disponiveis) for ing in receita.ingredientes):
            # Verifica restrições
            if all(r.lower() in map(str.lower, receita.restricoes) for r in restricoes_usuario):
                cardapio[tipo_norm].append(receita)

    return cardapio




