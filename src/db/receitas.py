import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(__file__))))  # adiciona a raiz do projeto

from .connect import get_connection
from src.models.receita import Receita

def buscar_receitas():
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT r.id_receita, r.nome,
               ARRAY(
                   SELECT i.nome FROM ingredientes i
                   JOIN receita_ingredientes ri ON ri.id_ingrediente = i.id_ingrediente
                   WHERE ri.id_receita = r.id_receita
               ),
               ARRAY[
                   CASE WHEN r.gluten_free THEN 'sem_gluten' ELSE NULL END,
                   CASE WHEN r.lactose_free THEN 'sem_lactose' ELSE NULL END,
                   CASE WHEN r.vegano THEN 'vegano' ELSE NULL END,
                   CASE WHEN r.vegetariano THEN 'vegetariano' ELSE NULL END,
                   CASE WHEN r.low_carb THEN 'low_carb' ELSE NULL END,
                   CASE WHEN r.high_protein THEN 'high_protein' ELSE NULL END
               ]
        FROM receitas r
        WHERE r.ativo = TRUE;
    """)

    receitas = []
    for row in cursor.fetchall():
        id_receita, nome, ingredientes, restricoes_raw = row
        restricoes = list(filter(None, restricoes_raw))  # remove Nones
        receitas.append(Receita(id_receita, nome, ingredientes, restricoes))

    cursor.close()
    conn.close()
    return receitas

