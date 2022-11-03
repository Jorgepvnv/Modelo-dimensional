CREATE OR REPLACE PROCEDURE CARGA_CLIENTE
AS 

TRUNCADO VARCHAR2(1000);
BEGIN 

TRUNCADO:='TRUNCATE TABLE DIM_CLIENTE';
EXECUTE IMMEDIATE TRUNCADO;

INSERT INTO DIM_CLIENTE
    SELECT 
    C.DNI,
    C.CUENTA,
    C.NOMBRE,
    C.APELLIDO1,
    C.APELLIDO2,
    D.ID_PROV,
    C.DIR,
    SYSTIMESTAMP
    FROM CLIENTE C LEFT OUTER JOIN DIM_PROV D ON C.CIUDAD = UPPER(D.DES_NOM_PROV);  
END;
