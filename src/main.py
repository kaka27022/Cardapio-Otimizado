import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # raiz do projeto

from db.receitas import buscar_receitas
from services.gerador_cardapio import gerar_cardapio

def obter_lista_usuario(msg):
    """
    Recebe uma string de entrada do usuário e transforma em lista.
    Exemplo: "arroz, tomate, cebola" → ["arroz", "tomate", "cebola"]
    """
    entrada = input(msg)
    return [item.strip().lower() for item in entrada.split(",") if item.strip()]

def main():
    print("=== Gerador de Cardápio Otimizado ===\n")

    # 1. Obter entradas do usuário
    ingredientes_disponiveis = obter_lista_usuario("Digite os ingredientes disponíveis (separados por vírgula): ")
    restricoes_usuario = obter_lista_usuario("Digite suas restrições alimentares (ex: sem_lactose, vegano, etc): ")

    # 2. Buscar receitas do banco
    receitas = buscar_receitas()

    # 3. Gerar cardápio
    cardapio = gerar_cardapio(receitas, ingredientes_disponiveis, restricoes_usuario)

    # 4. Mostrar resultado
    print("\n=== Cardápio Gerado ===")
    if cardapio:
        for receita in cardapio:
            print(f"- {receita.nome}")
    else:
        print("Nenhuma receita encontrada com os ingredientes e restrições fornecidos.")

if __name__ == "__main__":
    main()
