# src/tests/test_queries.py

from services.RecipeService import RecipeService

def test_filtragem_receitas_vegana_sem_lactose():
    ingredientes = ['banana', 'aveia', 'amendoim']
    restricoes = ['vegana', 'sem_lactose']
    categorias = ['café', 'almoço']

    service = RecipeService()
    result = service.get_receitas_filtradas(ingredientes, restricoes, categorias)

    assert 'café' in result
    for receita in result['café']:
        assert receita.vegano is True
        assert receita.sem_lactose is True
