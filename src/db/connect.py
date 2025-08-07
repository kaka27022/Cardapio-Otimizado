import psycopg2

def get_connection():
   
    conn = psycopg2.connect(
        host="localhost",
        port=5433,
        database="cardapio_dev",
        user="postgres",
        password="sua_senha_forte"  # coloque sua senha se tiver
    )

    return conn
