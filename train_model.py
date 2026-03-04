from connection import conn
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import r2_score, mean_squared_error



query = "SELECT * FROM vw_dataset_ml"
df = pd.read_sql(query, conn)

X = df[[
    "metragem",
    "quartos",
    "banheiros",
    "vagas",
    "idade_imovel",
    "renda_media",
    "indice_desenvolvimento",
    "preco_m2_base"
]]

y = df["preco"]

x_train, x_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

modelo = RandomForestRegressor(n_estimators=200)
modelo.fit(x_train, y_train)

pred = modelo.predict(x_test)

print("R2:", r2_score(y_test, pred))
rmse = np.sqrt(mean_squared_error(y_test, pred))
print("RMSE:", rmse)

