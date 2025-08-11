import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # adiciona a raiz do projeto

from src.db.receitas import buscar_receitas

def testar_buscar_receitas():
    try:
        receitas = buscar_receitas()
        print(f"Receitas encontradas: {len(receitas)}\n")
        for r in receitas:
            print(f"ID: {r.id}, Nome: {r.nome}")
            print(f"  Tipo de refeição: {r.tipo_refeicao}")
            print(f"  Ingredientes: {', '.join(r.ingredientes)}")
            print(f"  Restrições: {', '.join(r.restricoes) if r.restricoes else 'Nenhuma'}")
            print(f"  Calorias: {r.calorias if hasattr(r, 'calorias') and r.calorias is not None else 'Não informado'}")
            print(f"  Proteínas: {r.proteinas if hasattr(r, 'proteinas') and r.proteinas is not None else 'Não informado'}")
            print(f"  Gorduras: {r.gorduras if hasattr(r, 'gorduras') and r.gorduras is not None else 'Não informado'}\n")
    except Exception as e:
        print(f"Erro ao buscar receitas: {e}")

if __name__ == "__main__":
    testar_buscar_receitas()


