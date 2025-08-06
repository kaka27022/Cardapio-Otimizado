from src.models.Recipe import Recipe
from src.services.DatabaseService import DatabaseService

class RecipeService:

    def __init__(self):
        self.db = DatabaseService()

    def buscar_receitas_validas(self, ingredientes_disponiveis: list, restricoes: dict):
        restricoes_sql = []

        if restricoes.get("vegano"):
            restricoes_sql.append("r.vegano = TRUE")
        if restricoes.get("vegetariano"):
            restricoes_sql.append("r.vegetariano = TRUE")
        if restricoes.get("sem_lactose"):
            restricoes_sql.append("r.sem_lactose = TRUE")
        if restricoes.get("sem_gluten"):
            restricoes_sql.append("r.sem_gluten = TRUE")

        sql = f"""
            SELECT r.*
            FROM Receitas r
            JOIN Receita_Ingredientes ri ON ri.id_receita = r.id_receita
            JOIN Ingredientes i ON i.id_ingrediente = ri.id_ingrediente
            WHERE r.ativo = TRUE
              {"AND " + " AND ".join(restricoes_sql) if restricoes_sql else ""}
              AND i.nome IN %s
            GROUP BY r.id_receita
            HAVING COUNT(DISTINCT i.id_ingrediente) = (
                SELECT COUNT(*) 
                FROM Receita_Ingredientes 
                WHERE id_receita = r.id_receita AND opcional = FALSE
            )
        """

        with self.db.get_cursor() as cur:
            cur.execute(sql, (tuple(ingredientes_disponiveis),))
            rows = cur.fetchall()

        receitas = [Recipe.from_row(row) for row in rows]
        return self._agrupar_por_tipo_refeicao(receitas)

    def _agrupar_por_tipo_refeicao(self, receitas):
        agrupadas = {"café": [], "almoço": [], "jantar": []}
        for r in receitas:
            if r.tipo_refeicao in agrupadas:
                agrupadas[r.tipo_refeicao].append(r)
        return agrupadas


