import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_csv("metricas.csv")

# Adiciona uma coluna 'Execução' para o eixo x (índice original)
df['Execução'] = df.index + 1

# Derrete o dataframe para formato longo, mantendo 'Execução'
df_melt = df.melt(id_vars=['Execução'], var_name='Métrica', value_name='Valor')

# Gráfico de linha com eixo X igual para todas as métricas
sns.lineplot(x='Execução', y='Valor', hue='Métrica', data=df_melt, marker='o', palette='viridis')

plt.title("Métricas de Avaliação do Cardápio ao Longo das Execuções")
plt.xlabel("Execução")
plt.ylabel("Valor")
plt.legend(title="Métrica")
plt.show()


