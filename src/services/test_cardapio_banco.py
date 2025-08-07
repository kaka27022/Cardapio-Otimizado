import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # raiz do projeto

from src.services.gerador_cardapio import gerar_cardapio
from src.db.receitas import buscar_receitas  # ou o nome correto do seu módulo

# Ingredientes disponíveis (pode adaptar)
ingredientes_disponiveis = ["Arroz", "Feijão"]

# Restrições do usuário
restricoes_usuario = ["vegano", "sem_lactose"]

def main():
    # Busca as receitas reais do banco
    receitas = buscar_receitas()

    # Gera o cardápio
    cardapio = gerar_cardapio(receitas, ingredientes_disponiveis, restricoes_usuario)

    # Imprime resultados
    print("Cardápio gerado com dados reais do banco:")
    for receita in cardapio:
        print(f"- {receita.nome} (ingredientes: {', '.join(receita.ingredientes)}, restrições: {', '.join(receita.restricoes)})")

if __name__ == "__main__":
    main()
