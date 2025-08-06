class Recipe:
    def __init__(self, id, nome, categoria, calorias, proteinas, gorduras, vegano, sem_lactose, sem_gluten):
        self.id = id
        self.nome = nome
        self.categoria = categoria
        self.calorias = calorias
        self.proteinas = proteinas
        self.gorduras = gorduras
        self.vegano = vegano
        self.sem_lactose = sem_lactose
        self.sem_gluten = sem_gluten

    @classmethod
    def from_row(cls, row):
        return cls(
            id=row['id_receita'],
            nome=row['nome'],
            categoria=row['categoria'],
            calorias=row['calorias'],
            proteinas=row['proteinas'],
            gorduras=row['gorduras'],
            vegano=row.get('vegano', False),
            sem_lactose=row.get('sem_lactose', False),
            sem_gluten=row.get('sem_gluten', False)
        )
