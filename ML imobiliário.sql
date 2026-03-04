CREATE DATABASE imobiliaria_ml;
USE imobiliaria_ml;

Create table cidades (
id int auto_increment primary key,
nome varchar(100),
estado varchar(2)
); 

CREATE TABLE bairros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cidade_id INT,
    renda_media DECIMAL(12,2),
    indice_desenvolvimento DECIMAL(4,2),
    preco_m2_base DECIMAL(10,2),
    FOREIGN KEY (cidade_id) REFERENCES cidades(id)
);

CREATE TABLE imoveis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bairro_id INT,
    metragem INT,
    quartos INT,
    banheiros INT,
    vagas INT,
    idade_imovel INT,
    preco DECIMAL(14,2),
    data_publicacao DATE,
    vendido BOOLEAN,
    FOREIGN KEY (bairro_id) REFERENCES bairros(id)
);

CREATE TABLE historico_precos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    imovel_id INT,
    preco_anterior DECIMAL(14,2),
    preco_novo DECIMAL(14,2),
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (imovel_id) REFERENCES imoveis(id)
);



DROP PROCEDURE IF EXISTS popular_dados $$
DELIMITER $$
CREATE PROCEDURE popular_dados()
BEGIN
    DECLARE i INT DEFAULT 1;

    DECLARE v_bairro INT;
    DECLARE v_metragem INT;
    DECLARE v_quartos INT;
    DECLARE v_banheiros INT;
    DECLARE v_vagas INT;
    DECLARE v_idade INT;
    DECLARE v_preco DECIMAL(14,2);
    DECLARE v_preco_base DECIMAL(10,2);
    DECLARE v_renda DECIMAL(12,2);
    DECLARE v_fator_metragem DECIMAL(4,2);

    SET SQL_SAFE_UPDATES = 0;
    SET FOREIGN_KEY_CHECKS = 0;

    DELETE FROM historico_precos;
    DELETE FROM imoveis;
    DELETE FROM bairros;
    DELETE FROM cidades;

    SET FOREIGN_KEY_CHECKS = 1;
    SET SQL_SAFE_UPDATES = 1;

    INSERT INTO cidades (nome, estado)
    VALUES ('São Paulo', 'SP');

    INSERT INTO bairros (nome, cidade_id, renda_media, indice_desenvolvimento, preco_m2_base)
    VALUES 
    ('Moema', 1, 15000, 0.92, 12000),
    ('Tatuapé', 1, 8000, 0.85, 9000),
    ('Pinheiros', 1, 18000, 0.95, 14000),
    ('Butantã', 1, 7000, 0.80, 8000);

    WHILE i <= 600 DO

        SET v_bairro = FLOOR(1 + RAND()*4);
        SET v_metragem = FLOOR(40 + RAND()*160);
        SET v_quartos = FLOOR(1 + RAND()*4);
        SET v_banheiros = FLOOR(1 + RAND()*3);
        SET v_vagas = FLOOR(RAND()*3);
        SET v_idade = FLOOR(RAND()*30);

        SELECT preco_m2_base, renda_media
        INTO v_preco_base, v_renda
        FROM bairros
        WHERE id = v_bairro
        LIMIT 1;

        SET v_fator_metragem =
            CASE
                WHEN v_metragem < 60 THEN 1.20
                WHEN v_metragem BETWEEN 60 AND 120 THEN 1.00
                ELSE 0.88
            END;

        SET v_preco =
            (v_metragem * v_preco_base * v_fator_metragem)
            + (v_quartos * 35000)
            + (v_banheiros * 25000)
            + (v_vagas * 30000)
            - (v_idade * 1800);

        SET v_preco = v_preco * (1 + (v_renda / 100000));
        SET v_preco = v_preco * (1 + (RAND()*0.08 - 0.04));

        IF v_preco < 180000 THEN
            SET v_preco = 180000 + RAND()*50000;
        END IF;

        INSERT INTO imoveis (
            bairro_id,
            metragem,
            quartos,
            banheiros,
            vagas,
            idade_imovel,
            preco,
            data_publicacao,
            vendido
        )
        VALUES (
            v_bairro,
            v_metragem,
            v_quartos,
            v_banheiros,
            v_vagas,
            v_idade,
            v_preco,
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
            IF(RAND() > 0.3, TRUE, FALSE)
        );

        INSERT INTO historico_precos (imovel_id, preco_anterior, preco_novo)
        VALUES (LAST_INSERT_ID(), NULL, v_preco);

        SET i = i + 1;

    END WHILE;

END $$

DELIMITER ;

CALL popular_dados();


CREATE OR REPLACE VIEW vw_dataset_ml AS
SELECT
    i.id,
    c.nome AS cidade,
    b.nome AS bairro,
    b.renda_media,
    b.indice_desenvolvimento,
    b.preco_m2_base,
    i.metragem,
    i.quartos,
    i.banheiros,
    i.vagas,
    i.idade_imovel,
    i.preco,
    i.vendido,
    i.data_publicacao
FROM imoveis i
JOIN bairros b ON i.bairro_id = b.id
JOIN cidades c ON b.cidade_id = c.id;

CREATE INDEX idx_preco ON imoveis(preco);
CREATE INDEX idx_bairro ON imoveis(bairro_id);
CREATE INDEX idx_metragem ON imoveis(metragem);

select * from imoveis



    

