from sklearn.model_selection import cross_val_score
from sklearn.metrics import mean_absolute_error
from train_model import modelo, X, y, pred, y_test

scores = cross_val_score(
    modelo, X, y,
    cv=5,
    scoring="r2"
)

print("R2 médio (CV):", scores.mean())



print("MAE:", mean_absolute_error(y_test, pred))