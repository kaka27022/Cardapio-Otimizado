def test_recipe_search():
    db = DatabaseService(test_config)
    recipes = db.get_recipes_by_ingredients([1, 2])
    assert len(recipes) > 0