🧱 Arquitetura do Projeto
1️⃣ Modelagem de Banco de Dados (MySQL)

Criação de schema relacional

Tabelas normalizadas:

cidades

bairros

imoveis

historico_precos

Índices estratégicos para otimização

Stored procedure para geração automática de 500+ registros

View analítica (vw_dataset_ml) para consumo do modelo

2️⃣ Pipeline Analítico (Python)

Conexão com MySQL

Extração via view analítica

Feature engineering

Separação treino/teste

Validação cruzada (5-fold)

Treinamento com Random Forest Regressor

Avaliação com múltiplas métricas

🤖 Modelo Utilizado

RandomForestRegressor

Comparação com regressão linear (quando aplicável)

Seleção de variáveis numéricas relevantes

Avaliação estatística robusta

📈 Resultados

R² (holdout): ~0.98

R² médio (validação cruzada 5-fold): ~0.95

RMSE: ~63.000

MAE: ~52.000

Os resultados indicam boa capacidade de generalização e consistência preditiva.

🛠 Tecnologias Utilizadas

MySQL

Python

Pandas

Scikit-learn

Matplotlib

📂 Estrutura do Repositório
ML_Imobiliario/
│
├── database/
│   ├── schema.sql
│   ├── procedure.sql
│   └── view.sql
│
├── train_model.py
├── requirements.txt
└── README.md
🧠 Principais Aprendizados

Modelagem relacional aplicada a projetos de Data Science

Criação de pipeline estruturado (SQL → Python → ML)

Engenharia de atributos

Validação cruzada e análise de generalização

Interpretação de métricas de regressão


📌 Conclusão

O projeto demonstra a construção de um pipeline completo de dados até modelagem preditiva, aplicando técnicas de Machine Learning a um problema real de precificação imobiliária.

<img width="640" height="480" alt="Figure_1" src="https://github.com/user-attachments/assets/be6043b0-f250-481d-bdf8-18bfd8d33afc" />

