class Receita:
    def __init__(self, id, nome, ingredientes, restricoes, tipo_refeicao, tempo_preparo, dificuldade,
                 calorias=None, proteinas=None, gorduras=None):
        self.id = id
        self.nome = nome
        self.ingredientes = ingredientes  # lista de strings
        self.restricoes = restricoes      # lista de strings (ex: ["sem_lactose"])
        self.tipo_refeicao = tipo_refeicao.lower()
        self.tempo_preparo = tempo_preparo
        self.dificuldade = dificuldade
        self.calorias = calorias
        self.proteinas = proteinas
        self.gorduras = gorduras

    def __repr__(self):
        return f"<Receita {self.nome}>"
