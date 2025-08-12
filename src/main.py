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

def obter_limite(msg):
    entrada = input(msg).strip()
    if not entrada:
        return None
    try:
        valor = float(entrada)
        if valor < 0:
            print("Por favor, insira um valor positivo ou deixe em branco.")
            return obter_limite(msg)
        return valor
    except ValueError:
        print("Valor inválido. Insira um número ou deixe em branco.")
        return obter_limite(msg)

def obter_minimo(msg):
    entrada = input(msg).strip()
    if not entrada:
        return None
    try:
        valor = float(entrada)
        if valor < 0:
            print("Por favor, insira um valor positivo ou deixe em branco.")
            return obter_minimo(msg)
        return valor
    except ValueError:
        print("Valor inválido. Insira um número ou deixe em branco.")
        return obter_minimo(msg)

def main():
    print("=== Gerador de Cardápio Otimizado ===\n")

    ingredientes_disponiveis = obter_lista_usuario("Digite os ingredientes disponíveis (separados por vírgula): ")
    restricoes_usuario = obter_lista_usuario("Digite suas restrições alimentares (ex: sem_lactose, vegano, etc): ")

    print("\nOpcional: Defina limites para o cardápio (deixe em branco para pular)")
    limite_calorias = obter_limite("Limite máximo de calorias (total): ")
    minimo_proteinas = obter_minimo("Mínimo de proteínas desejadas (total): ")
    limite_gorduras = obter_limite("Limite máximo de gorduras (total): ")
    limite_tempo_preparo = obter_limite("Limite máximo de tempo de preparo por receita (min): ")

    receitas = buscar_receitas()
    cardapio = gerar_cardapio(receitas, ingredientes_disponiveis, restricoes_usuario)

    total_calorias = 0
    total_proteinas = 0
    total_gorduras = 0

    cardapio_filtrado = {k: [] for k in cardapio.keys()}

    def cabe_no_limite(r):
        if limite_tempo_preparo is not None and r.tempo_preparo is not None:
            if r.tempo_preparo > limite_tempo_preparo:
                return False

        c = total_calorias + (r.calorias or 0)
        g = total_gorduras + (r.gorduras or 0)

        if limite_calorias is not None and c > limite_calorias:
            return False
        if limite_gorduras is not None and g > limite_gorduras:
            return False

        return True

    for tipo_refeicao, lista_receitas in cardapio.items():
        for receita in lista_receitas:
            if cabe_no_limite(receita):
                cardapio_filtrado[tipo_refeicao].append(receita)
                total_calorias += receita.calorias or 0
                total_proteinas += receita.proteinas or 0
                total_gorduras += receita.gorduras or 0

    print("\n=== Cardápio Gerado Respeitando Limites ===")
    for refeicao, lista in cardapio_filtrado.items():
        print(f"\n{refeicao.replace('_', ' ').title()}:")
        if lista:
            for receita in lista:
                print(f"- {receita.nome}")
                print(f"  Ingredientes: {', '.join(receita.ingredientes)}")
                print(f"  Restrições: {', '.join(receita.restricoes) if receita.restricoes else 'Nenhuma'}")
                print(f"  Tempo de Preparo: {receita.tempo_preparo if receita.tempo_preparo is not None else 'Não informado'} min")
                print(f"  Dificuldade: {receita.dificuldade if receita.dificuldade is not None else 'Não informado'}")
                print(f"  Calorias: {receita.calorias if receita.calorias is not None else 'Não informado'}")
                print(f"  Proteínas: {receita.proteinas if receita.proteinas is not None else 'Não informado'}")
                print(f"  Gorduras: {receita.gorduras if receita.gorduras is not None else 'Não informado'}\n")
        else:
            print("Nenhuma receita disponível para esta refeição.")

    print("=== Resumo Total Nutricional do Cardápio ===")
    print(f"Calorias totais: {total_calorias}")
    print(f"Proteínas totais: {total_proteinas}")
    print(f"Gorduras totais: {total_gorduras}")

    if minimo_proteinas is not None and total_proteinas < minimo_proteinas:
        print("\n⚠ AVISO: O cardápio gerado não atingiu o mínimo de proteínas desejado.")
        print("Sugestão: aumente a porção ou adicione mais receitas com maior teor proteico.")
        # Encontrar receita mais proteica
        mais_proteica = max(
            (r for lista in cardapio_filtrado.values() for r in lista),
            key=lambda r: r.proteinas or 0,
            default=None
        )
        if mais_proteica:
            print(f"Exemplo: aumentar a porção de '{mais_proteica.nome}' ({mais_proteica.proteinas}g de proteína).")

if __name__ == "__main__":
    main()

