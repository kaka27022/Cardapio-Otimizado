# 🍽️ Otimização de Cardápios Personalizados

Sistema inteligente para geração de cardápios personalizados com base em **Programação por Satisfação de Restrições (PSR)**, integrando banco de dados relacional e cálculos nutricionais automáticos.

## 📌 Contextualização
A demanda por alimentação personalizada está aumentando, seja por questões **de saúde, ética ou estética**. Planejar uma dieta equilibrada manualmente exige tempo, conhecimento e atenção às restrições alimentares.

Este projeto implementa um sistema capaz de criar cardápios otimizados que:
- Respeitam restrições alimentares.
- Balanceiam nutrientes.
- Minimiza esforço humano no planejamento.

---

## 🎯 Objetivo
Utilizar **PSR** para resolver problemas comuns no planejamento de cardápios:
- Dificuldade em balancear nutrientes.
- Conflitos entre restrições e alimentos comuns.
- Falta de conhecimento técnico.
- Tempo e esforço no planejamento manual.

---

## 🧠 Programação por Satisfação de Restrições (PSR)
PSR é um paradigma de resolução de problemas no qual:
- **Entrada:** Variáveis + Domínios + Restrições.
- **Processo:** Algoritmo de busca/verificação para encontrar atribuições válidas.
- **Saída:** Uma ou mais soluções que obedecem a todas as restrições.

Vantagens:
- Flexibilidade.
- Capacidade de lidar com problemas complexos.
- Possibilidade de múltiplas soluções.

---

## ⚙️ Implementação

### 1. Associação com o problema de PSR
- **Variáveis:** calorias, tempo de preparo, restrições e ingredientes.
- **Domínios:** valores possíveis para cada variável.
- **Restrições:** filtros SQL e *triggers* no banco, retornando apenas receitas compatíveis.

### 2. Banco de Dados
- **PostgreSQL** para armazenar e gerenciar dados.
- **Ingredientes:** dados nutricionais por porção (100g).
- **Receitas:** informações gerais e valores nutricionais calculados.
- **Restrições:** dieta, objetivos, limites nutricionais, refeições.

### 3. Código em Python
- **`receitas.py`**: intermediário entre aplicação e banco.
- Função principal: `buscar_receitas()` → retorna lista de objetos `Receita`.

### 4. Processamento
- Filtragem inicial no banco.
- Verificação de ingredientes disponíveis.
- Geração de combinações (CSP / backtracking).
- Cálculo de métricas nutricionais.

---

## 🧪 Testes e Resultados

**Entradas solicitadas:**
- Ingredientes disponíveis.
- Restrições alimentares.
- Metas nutricionais (opcional).
- Configuração de refeições.

**Saída:**
- Lista de receitas por refeição.
- Totais nutricionais.
- Indicação de metas atingidas ou não.
- Sugestões de ajustes.

**Exemplo:**
- Calorias: `664 kcal` (dentro do limite de 1500 kcal).
- Gordura: `20.2 g` (dentro do limite de 40 g).
- Proteína: `29 g` de 60 g (meta não atingida) → sugestão de aumento de porções ou inclusão de alimentos ricos em proteína.

---

## 📊 Comparação com ChatGPT
O ChatGPT pode sugerir receitas, mas:
- ❌ Não calcula nutrientes com precisão.
- ❌ Não usa banco de dados real de nutrientes.
- ❌ Não otimiza por PSR.

O sistema desenvolvido:
- ✅ Precisão nutricional.
- ✅ Restrições automatizadas.
- ✅ Otimização por PSR.
- ✅ Integração com dados reais.

---

## ✅ Conclusão
O sistema combina:
- **PSR** para otimização.
- **PostgreSQL** para armazenamento estruturado.
- **Python** para processamento e integração.

**Principais pontos fortes:**
- Alta precisão e consistência.
- Triggers para integridade automática.
- Redução de ajustes manuais.

**Próximos passos:**
- Novos parâmetros de otimização.
- Integração com APIs externas.
- Interface mais intuitiva.

---

## 👥 Autores
- Augusto Luna *(DECOM)* 
- Luiz Victor Silva *(DECOM)*
- [Maria Clara Perpetuo](https://github.com/kaka27022)

