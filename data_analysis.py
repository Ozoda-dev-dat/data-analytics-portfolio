import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


df = pd.read_csv("data/uzbekistan_economy.csv")
print(df.info())  
print(df.describe())  
df.dropna(inplace=True)

yearly_salary = df.groupby("year")["avg_salary"].mean()

plt.figure(figsize=(8,5))
sns.lineplot(data=yearly_salary, marker="o", color="b")
plt.title("O‘zbekistonda O‘rtacha Ish Haqi (yillar bo‘yicha)")
plt.xlabel("Yil")
plt.ylabel("O‘rtacha Ish Haqi (USD)")
plt.grid()
plt.show()

plt.figure(figsize=(8,5))
sns.scatterplot(data=df, x="unemployment_rate", y="avg_salary", hue="year", palette="viridis")
plt.title("Ishsizlik darajasi va O‘rtacha Ish Haqi")
plt.xlabel("Ishsizlik darajasi (%)")
plt.ylabel("O‘rtacha Ish Haqi (USD)")
plt.grid()
plt.show()