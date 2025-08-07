class Receita:
    def __init__(self, id, nome, ingredientes, restricoes):
        self.id = id
        self.nome = nome
        self.ingredientes = ingredientes  # lista de strings
        self.restricoes = restricoes      # lista de strings (ex: ["sem_lactose"])
