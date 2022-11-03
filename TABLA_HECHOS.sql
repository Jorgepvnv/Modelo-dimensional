CREATE OR REPLACE PROCEDURE CARGA_HECHOS2
AS TRUNCADO VARCHAR2(1000);
BEGIN 
TRUNCADO:='TRUNCATE TABLE HEC_TRANSAC';
EXECUTE IMMEDIATE TRUNCADO;
INSERT INTO HEC_TRANSAC      
SELECT 
TO_DATE(TO_CHAR(FECHAS.ID_FECHA,'DD/MM/YYYY')) AS ID_FECHA, --FROM DIM_FECHA FECHAS,
COALESCE(CLI_ORI.ID_DNI, -1) AS ID_DNI_CLI_ORIGEN, 
COALESCE(CLI_DES.ID_DNI, -1) AS ID_DNI_CLI_DESTINO,-- EL COALESCE ES PARA ESTABLECER EL VALOR POR DEFECTO DE -1, EN LUGAR DE METERLO EN LA CREACIÓN DE LAS TABLAS.
--COALESCE(PROVINCIAS.ID_PROV,-1) AS ID_PROV,
--1 AS ID_PROV,
--ESTA DUDO CÓMO HACERLA.
COALESCE(CLI_ORI.ID_PROV,-1) AS ID_PROV_CLI_ORIGEN,
COALESCE(CLI_DES.ID_PROV,-1) AS ID_PROV_CLI_DESTINO,
COALESCE(ORIGEN.IMPORTE,-1) AS IMP_IMPORTE, 
COALESCE(ORIGEN.COMISION,-1) AS IMP_COMISION,
COALESCE(ORIGEN.IMPORTE + ORIGEN.COMISION,ORIGEN.IMPORTE) AS IMP_TOTAL,
SYSTIMESTAMP AS FEC_AUDIT

FROM TRANSACCIONES ORIGEN 
LEFT OUTER JOIN DIM_FECHA FECHAS
ON TO_DATE(TO_CHAR(ORIGEN.FECHA,'DD/MM/YYYY'))=FECHAS.ID_FECHA
LEFT OUTER JOIN DIM_CLIENTE CLI_ORI
ON ORIGEN.CTA_ORIGEN = CLI_ORI.COD_CUENTA
LEFT OUTER JOIN DIM_CLIENTE CLI_DES
ON ORIGEN.CTA_DESTINO = CLI_DES.COD_CUENTA;

END;

EXECUTE CARGA_HECHOS2;

SELECT *FROM hec_transac;