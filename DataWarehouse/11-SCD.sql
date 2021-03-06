-- ************* Conectado como usuário dw *************

ALTER TABLE TB_DIM_CLIENTE ADD (DATA_INICIO DATE);
ALTER TABLE TB_DIM_CLIENTE ADD (DATA_FIM DATE);
ALTER TABLE TB_DIM_CLIENTE ADD (FLAG_ATIVO CHAR(1));

ALTER TABLE TB_DIM_PRODUTO ADD (DATA_INICIO DATE);
ALTER TABLE TB_DIM_PRODUTO ADD (DATA_FIM DATE);
ALTER TABLE TB_DIM_PRODUTO ADD (FLAG_ATIVO CHAR(1));

ALTER TABLE TB_DIM_LOCALIDADE ADD (DATA_INICIO DATE);
ALTER TABLE TB_DIM_LOCALIDADE ADD (DATA_FIM DATE);
ALTER TABLE TB_DIM_LOCALIDADE ADD (FLAG_ATIVO CHAR(1));

UPDATE TB_DIM_CLIENTE SET FLAG_ATIVO = 1;
COMMIT;

UPDATE TB_DIM_PRODUTO SET FLAG_ATIVO = 1;
COMMIT;

UPDATE TB_DIM_LOCALIDADE SET FLAG_ATIVO = 1;
COMMIT;

UPDATE TB_DIM_CLIENTE SET DATA_INICIO = CURRENT_DATE;
COMMIT;

UPDATE TB_DIM_PRODUTO SET DATA_INICIO = CURRENT_DATE;
COMMIT;

UPDATE TB_DIM_LOCALIDADE SET DATA_INICIO = CURRENT_DATE;
COMMIT;