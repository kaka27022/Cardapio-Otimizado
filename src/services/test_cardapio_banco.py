import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # raiz do projeto

from src.services.gerador_cardapio import gerar_cardapio
from src.db.receitas import buscar_receitas

# Ingredientes disponíveis (pode adaptar)
ingredientes_disponiveis = ["Arroz", "Feijão", "Frango", "Ovo", "Tofu", "Pão Integral", "Cenoura"] 

# Restrições do usuário
restricoes_usuario = ["sem_lactose"]

def main():
    # Busca as receitas reais do banco
    receitas = buscar_receitas()

    # Gera o cardápio
    cardapio = gerar_cardapio(receitas, ingredientes_disponiveis, restricoes_usuario)

    # Imprime resultados por refeição
    print("=== Cardápio gerado com dados reais do banco ===")
    for tipo_refeicao, lista_receitas in cardapio.items():
        print(f"\n{tipo_refeicao.replace('_', ' ').title()}:")
        if lista_receitas:
            for receita in lista_receitas:
                print(f"- {receita.nome} "
                      f"(ingredientes: {', '.join(receita.ingredientes)}, "
                      f"restrições: {', '.join(receita.restricoes)}), "
                      f"tempo preparo: {receita.tempo_preparo} min, "
                      f"dificuldade: {receita.dificuldade}")
        else:
            print("Nenhuma receita disponível para esta refeição.\n")

if __name__ == "__main__":
    main()
