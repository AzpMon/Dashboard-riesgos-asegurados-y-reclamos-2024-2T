-- Paso 1: Verificar si la tabla temporal para los nombres de archivos existe y eliminarla si es necesario
IF OBJECT_ID('TEMPDB..TEMP_FILES') IS NOT NULL 
    DROP TABLE TEMP_FILES;

-- Crear una tabla temporal para almacenar los nombres de los archivos CSV
CREATE TABLE TEMP_FILES
(
    FileName VARCHAR(MAX),
    DEPTH VARCHAR(MAX),
    [FILE] VARCHAR(MAX)
);

-- Paso 2: Obtener la lista de archivos en el directorio especificado
-- Cambia 'C:\Users\monro\OneDrive\Escritorio\Dashboard AMIS\CSVs' 
INSERT INTO TEMP_FILES
EXEC master.dbo.xp_DirTree 'C:\Users\monro\OneDrive\Escritorio\Dashboard AMIS\CSVs', 1, 1;

-- Eliminar los registros que no son archivos CSV
DELETE FROM TEMP_FILES WHERE RIGHT(FileName, 4) != '.CSV';

-- Paso 3: Crear una tabla temporal para almacenar los resultados
IF OBJECT_ID('TEMPDB..TEMP_RESULTS') IS NOT NULL 
    DROP TABLE TEMP_RESULTS;

-- Crear la tabla temporal para almacenar los resultados
CREATE TABLE TEMP_RESULTS
(
    ENTIDAD VARCHAR(MAX),
    [RIESGOS ASEGURADOS] INT,  -- Cambiar a INT según el tipo de datos esperado
    RECLAMACIONES INT,          -- Cambiar a INT según el tipo de datos esperado
    nombre_hoja VARCHAR(MAX)    -- Nueva columna para el nombre de la hoja
);

-- Paso 4: Declarar variables para el nombre del archivo y el SQL dinámico
DECLARE @FILENAME VARCHAR(MAX), @SQL VARCHAR(MAX);

-- Bucle para procesar cada archivo CSV en la carpeta
WHILE EXISTS(SELECT * FROM TEMP_FILES)
BEGIN
    -- Asignar el nombre del archivo a la variable
    SET @FILENAME = (SELECT TOP 1 FileName FROM TEMP_FILES);

    -- Crear la consulta SQL dinámica para importar los datos desde el archivo CSV
    SET @SQL = '
    BULK INSERT TEMP_RESULTS
    FROM ''C:\Users\monro\OneDrive\Escritorio\Dashboard AMIS\CSVs\' + @FILENAME + '''
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        CODEPAGE = ''65001'' -- UTF-8
    );';

    -- Imprimir la consulta para depuración (opcional)
    PRINT @SQL;

    -- Ejecutar la consulta dinámica para cargar los datos
    EXEC(@SQL);

    -- Agregar el nombre de la hoja a los registros importados
    UPDATE TEMP_RESULTS
    SET nombre_hoja = LEFT(@FILENAME, LEN(@FILENAME) - 4)  -- Remover la extensión .CSV
    WHERE nombre_hoja IS NULL;  -- Asegúrate de que no se sobrescriban datos existentes

    -- Eliminar el archivo procesado de la tabla temporal
    DELETE FROM TEMP_FILES WHERE FileName = @FILENAME;
END

-- Paso 5: (Opcional) Manejar errores durante el proceso de inserción
-- Este bloque es similar al anterior, pero incluye manejo de errores
WHILE EXISTS(SELECT * FROM TEMP_FILES)
BEGIN
    BEGIN TRY
        SET @FILENAME = (SELECT TOP 1 FileName FROM TEMP_FILES);
        SET @SQL = '
        BULK INSERT TEMP_RESULTS
        FROM ''C:\Users\monro\OneDrive\Escritorio\Dashboard AMIS\CSVs\' + @FILENAME + '''
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = '','',
            ROWTERMINATOR = ''\n'',
            CODEPAGE = ''65001''
        );';

        PRINT @SQL;
        EXEC(@SQL);

        -- Agregar el nombre de la hoja a los registros importados
        UPDATE TEMP_RESULTS
        SET nombre_hoja = LEFT(@FILENAME, LEN(@FILENAME) - 4)  -- Remover la extensión .CSV
        WHERE nombre_hoja IS NULL;

    END TRY
    BEGIN CATCH
        PRINT 'Error al procesar el archivo: ' + @FILENAME;
    END CATCH;

    DELETE FROM TEMP_FILES WHERE FileName = @FILENAME;
END

-- Al final, los datos de todos los archivos CSV estarán en la tabla temporal TEMP_RESULTS
-- Puedes realizar consultas para verificar los resultados, por ejemplo:
SELECT * FROM TEMP_RESULTS;

-- (Opcional) Si deseas guardar los resultados en una tabla permanente en la base de datos:
-- INSERT INTO TuTablaPermanente (ENTIDAD, [RIESGOS ASEGURADOS], RECLAMACIONES, nombre_hoja)
-- SELECT ENTIDAD, [RIESGOS ASEGURADOS], RECLAMACIONES, nombre_hoja
-- FROM TEMP_RESULTS;
