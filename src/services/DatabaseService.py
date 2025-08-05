import mysql.connector

class DatabaseService:
    def __init__(self, config):
        self.connection = mysql.connector.connect(**config)
    
    def get_recipes_by_ingredients(self, ingredient_ids: list) -> list:
        cursor = self.connection.cursor(dictionary=True)
        query = """SELECT ..."""
        cursor.execute(query, (ingredient_ids,))
        return cursor.fetchall()