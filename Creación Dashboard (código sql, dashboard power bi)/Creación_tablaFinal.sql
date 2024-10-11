USE [Amis];
WITH
	tbla_poblacion AS (
		SELECT 
			CASE	
				WHEN [Estado] = 'Ciudad de MÃ©xico' THEN 'Distrito Federal'
				ELSE [Estado] END
					AS [Estado],					
			CAST([PoblaciÃ³n] AS INT) AS poblacion, 
			CAST(LEFT([ContribuciÃ³n], LEN([ContribuciÃ³n]) - 1) AS FLOAT) AS porcentaje_poblacion
		FROM 
			[Amis].[dbo].[población]
		WHERE 
			[Estado] != 'Estados Unidos Mexicanos'
	), 
	tbla_PIB AS(	 
		SELECT 
			CASE	
				WHEN [Estado] = 'Ciudad de MÃ©xico' THEN 'Distrito Federal'
				ELSE [Estado] END
					AS [Estado],	
			CAST([PIB_MXN] AS INT) AS PIB, 
			CAST([PIB_Porcentaje] AS FLOAT) AS PIB_porcentaje
		FROM 
			[Amis].[dbo].[PIB_estados]
		WHERE 
			[Estado] != 'MÃ©xico'
	), 
	tbla_riesgos1 AS (
		SELECT 
			[nombre_hoja] AS Tipo, 
			[ENTIDAD], 
			CAST([RIESGOS ASEGURADOS] AS FLOAT) AS [RIESGOS ASEGURADOS], 
			CAST([RECLAMACIONES] AS FLOAT) AS [RECLAMACIONES], 
			PIB_porcentaje, 
			porcentaje_poblacion
		FROM 
			[Datos_Finales_Segundo_Tremestre_riesgos] dd 
				FULL JOIN tbla_PIB pib ON dd.[ENTIDAD] = pib.Estado 
				FULL JOIN tbla_poblacion pob ON pob.Estado = pib.Estado 
		WHERE
			dd.ENTIDAD != 'Total general' AND dd.ENTIDAD != 'Extranjero' AND dd.ENTIDAD != 'Total general'
	), 
	tbla_riesgos2 AS (
		SELECT 
			Tipo,
			[ENTIDAD] AS Entidad, 
			PIB_porcentaje AS [Porcentaje PIB Nacional],
			RANK() OVER(PARTITION BY Tipo ORDER BY PIB_porcentaje DESC) AS [Num. Rankin PIB], 
			porcentaje_poblacion AS [Porcentaje población Nacional],
			RANK() OVER(PARTITION BY Tipo ORDER BY porcentaje_poblacion DESC) AS [Num. Rankin población], 
			[RIESGOS ASEGURADOS], 
			ROUND(
				CAST([RIESGOS ASEGURADOS] AS FLOAT) / 
				SUM(CAST([RIESGOS ASEGURADOS] AS FLOAT)) OVER(PARTITION BY Tipo) * 100, 2
			) AS [Porcentaje del total nacional de riesgos asegurados], 
			[RECLAMACIONES], 
			ROUND(
				CAST([RECLAMACIONES] AS FLOAT) / 
				[RIESGOS ASEGURADOS] * 100, 5
			) AS [Porcentaje de riesgos asegurados reclamados]
		FROM tbla_riesgos1
	), 
	tbla_penúltima AS (
		SELECT 
			CASE 
				WHEN Tipo = 'AGRÃCOLA' THEN 'AGRÍCOLA'
				WHEN Tipo = 'AUTOMÃ“VILES' THEN 'AUTOMÓVILES'
				WHEN Tipo = 'CAUCIÃ“N' THEN 'CAUCIÓN'
				WHEN Tipo = 'CRÃ‰DITO A LA VIVIENDA' THEN 'CRÉDITO A LA VIVIENDA'
				WHEN Tipo = 'DIVERSOS MISCELÃNEOS' THEN 'DIVERSOS MISCELÁNEOS'
				WHEN Tipo = 'DIVERSOS RAMOS TÃ‰CNICOS' THEN 'DIVERSOS RAMOS TÉCNICOS'
				WHEN Tipo = 'FENÃ“MENOS HIDROMETEOROLÃ“GICOS' THEN 'FENÓMENOS HIDROMETEOROLÓGICOS'
				WHEN Tipo = 'GASTOS MÃ‰DICOS' THEN 'GASTOS MÉDICOS'
				WHEN Tipo = 'TRANSPORTES DE MERCANCÃAS' THEN 'TRANSPORTES DE MERCANCÍAS'
				ELSE TIPO END AS Tipo, 
			CASE 
				WHEN [Entidad] = 'QuerÃ©taro' THEN 'Querétaro'
				WHEN [Entidad] = 'MichoacÃ¡n' THEN 'Michoacán' 
				WHEN [Entidad] = 'Estado de MÃ©xico' THEN 'Estado de México'
				WHEN [Entidad] = 'Nuevo LeÃ³n' THEN 'Nuevo León'
				WHEN [Entidad] = 'QuerÃ©taro' THEN 'Querétaro'
				WHEN [Entidad] = 'San Luis PotosÃ­' THEN 'San Luis Potosí'
				WHEN [Entidad] = 'YucatÃ¡n' THEN 'Yucatán'
				WHEN [Entidad] = 'Distrito Federal' THEN 'DF'
				ELSE [Entidad] END AS [Entidad], 		
			[Porcentaje PIB Nacional], [Num. Rankin PIB], [Porcentaje población Nacional],
			[Num. Rankin población], [Riesgos asegurados], [Porcentaje del total nacional de riesgos asegurados], 
			RANK() OVER(PARTITION BY Tipo ORDER BY [Riesgos asegurados] DESC) AS [Num. Rankin nacional riesgos asegurados], 
			[Reclamaciones], [Porcentaje de riesgos asegurados reclamados], 
			RANK() OVER(PARTITION BY Tipo ORDER BY [Porcentaje de riesgos asegurados reclamados] DESC) AS [Num. Rankin nacional porcentaje de riesgos asegurados reclamados]
		FROM tbla_riesgos2
	) 
SELECT 
	Tipo,	
	CASE WHEN [Entidad] = 'DF' THEN 'Ciudad de México' ELSE [Entidad] END 
		AS [Entidad1],
	CASE WHEN [Entidad] = 'DF' THEN 'Ciudad de México' ELSE [Entidad] END 
		AS [Entidad2],
	[Porcentaje PIB Nacional], [Num. Rankin PIB], [Porcentaje población Nacional],
	[Num. Rankin población], [Riesgos asegurados], [Porcentaje del total nacional de riesgos asegurados], 
	[Num. Rankin nacional riesgos asegurados], [Reclamaciones], [Porcentaje de riesgos asegurados reclamados], 
	[Num. Rankin nacional porcentaje de riesgos asegurados reclamados]
FROM tbla_penúltima;



