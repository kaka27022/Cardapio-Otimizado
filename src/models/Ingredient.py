from dataclasses import dataclass

@dataclass
class Ingredient:
    id: int
    name: str
    calories: float
    # ... outros campos
    
    def is_vegan(self) -> bool:
        return self.vegan