def test_ingredient_creation():
    ing = Ingredient(1, "Arroz", 130)
    assert ing.name == "Arroz"
    assert ing.is_vegan() is True