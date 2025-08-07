import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=5433,
    database="cardapio_dev",
    user="postgres",
    password="sua_senha_forte"  # coloque sua senha se tiver
)

cursor = conn.cursor()

# Exemplo: buscar ingredientes disponíveis
cursor.execute("SELECT nome FROM Ingredientes WHERE ativo = TRUE;")
ingredientes = cursor.fetchall()
print(ingredientes)

cursor.close()
conn.close()
