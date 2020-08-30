-- ************** Conectado como usuário dw **************

-- Carga de Dados

INSERT INTO TB_DIM_TEMPO
SELECT 
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'YYYYMMDD') AS SK_DATA,
 TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day') AS Full_Date,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'YYYY') AS NR_ANO,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'MM') AS NR_MES,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'Month') AS NM_MES,
 TO_CHAR(TO_DATE('31/12/2012','DD/MM/YYYY') + NUMTODSINTERVAL(n,'day'),'DD') AS NR_DIA
FROM (
 SELECT LEVEL n
 FROM dual
 CONNECT BY LEVEL <= 2000
);
COMMIT;



-- Exemplo para a dimensão completa 

INSERT INTO DIM_TEMPO
SELECT
		TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'YYYYMMDD') AS SK_DATA,
        TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'DD/MM/YYYY') AS FULL_DATE_FORMATADA,
		TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day') AS FULL_DATE,
        TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'DDD') AS NR_DIA_ANO,
		TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'YYYY') AS NR_ANO,
		TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') AS NR_MES,
        TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'DD') AS NR_DIA_MES,
		
        CASE 
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '01'  THEN 'JANEIRO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '02'  THEN 'FEVEREIRO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '03'  THEN 'MARÇO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '04'  THEN 'ABRIL'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '05'  THEN 'MAIO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '06'  THEN 'JUNHO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '07'  THEN 'JULHO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '08'  THEN 'AGOSTO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '09'  THEN 'SETEMBRO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '10'  THEN 'OUTUBRO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '11'  THEN 'NOVEMBRO'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MM') = '12'  THEN 'DEZEMBRO'
        ELSE '** ERRO **'
        END AS NM_MES,
        
        TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'D') AS NR_DIA_SEMANA,
        TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'DAY') AS NM_DIA_SEMANA,
        TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'Q') AS NR_TRIMESTRE,
        'TRIMESTRE-' || TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'Q') AS NM_TRIMESTRE,
        'T' || TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'Q') AS NM_TRIMESTRE_ABREVIADO,
        
        CASE 
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'D') IN (1,7) THEN 'FIM DE SEMANA' 
        ELSE 'DIA DE SEMANA' 
        END AS FLAG_FIM_SEMANA,
        
        CASE 
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') 
            IN (0101, 0212, 0213, 0330, 0421, 0501, 0531, 0907, 1012, 1102, 1115, 1225) THEN  'FERIADO'
        ELSE 'NÃO FERIADO'
        END AS FLAG_FERIADO_BRASIL,
        
        CASE
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') BETWEEN '0601' AND '0831' THEN 'TEMPORADA DE INVERNO'
		    WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') BETWEEN '1115' AND '1225' THEN 'TEMPORADA DE NATAL'
            WHEN TO_CHAR(TO_DATE('31/12/2012', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') <= '0106' THEN 'TEMPORADA DE VERÃO'
        ELSE 'NORMAL' 
        END	AS PERIODO_NEGOCIO
        
	FROM 
        (
          SELECT LEVEL n
          FROM DUAL
          CONNECT BY LEVEL <= 3287
        )
    ORDER BY SK_DATA DESC;