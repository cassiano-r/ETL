-- ************** Conectado como usuário dw **************

-- Carga de Dados

INSERT INTO TB_DIM_CLIENTE
SELECT dim_cliente_id_seq.NEXTVAL, NK_ID_CLIENTE, NM_CLIENTE, NM_CIDADE_CLIENTE, FLAG_ACEITA_CAMPANHA, DESC_CEP
FROM STAREA.ST_DIM_CLIENTE;
COMMIT;

INSERT INTO TB_DIM_PRODUTO
SELECT dim_produto_id_seq.NEXTVAL, NK_ID_PRODUTO, DESC_SKU, NM_PRODUTO, NM_CATEGORIA_PRODUTO, NM_MARCA_PRODUTO
FROM STAREA.ST_DIM_PRODUTO;
COMMIT;

INSERT INTO TB_DIM_LOCALIDADE
SELECT dim_localidade_id_seq.NEXTVAL, NK_ID_LOCALIDADE, NM_LOCALIDADE, NM_CIDADE_LOCALIDADE, NM_REGIAO_LOCALIDADE
FROM STAREA.ST_DIM_LOCALIDADE;
COMMIT;
