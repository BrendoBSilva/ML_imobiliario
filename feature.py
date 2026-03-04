import matplotlib.pyplot as plt
import pandas as pd
from train_model import modelo, X

importancias = pd.Series(modelo.feature_importances_, index=X.columns)
importancias = importancias.sort_values()

plt.figure()
importancias.plot(kind="barh")
plt.title("Importância das Features")
plt.show()