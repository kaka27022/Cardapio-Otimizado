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
            print(f"  Ingredientes: {', '.join(r.ingredientes)}")
            print(f"  Restrições: {', '.join(r.restricoes) if r.restricoes else 'Nenhuma'}\n")
    except Exception as e:
        print(f"Erro ao buscar receitas: {e}")

if __name__ == "__main__":
    testar_buscar_receitas()
