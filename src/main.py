import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(__file__)))


from src.db.receitas import buscar_receitas
from src.services.gerador_cardapio import gerar_cardapio

def main():
    print("Bem-vindo ao Otimizador de Cardápios!")
    
    ingredientes_input = input("Digite os ingredientes disponíveis (separados por vírgula): ")
    restricoes_input = input("Digite suas restrições alimentares (ex: vegano, sem_lactose): ")

    ingredientes = [i.strip().lower() for i in ingredientes_input.split(",")]
    restricoes = [r.strip().lower() for r in restricoes_input.split(",")]

    receitas = buscar_receitas()
    cardapio = gerar_cardapio(receitas, ingredientes, restricoes)

    print("\nReceitas recomendadas:")
    for r in cardapio:
        print(f"- {r.nome} (ingredientes: {', '.join(r.ingredientes)})")

if __name__ == "__main__":
    main()
