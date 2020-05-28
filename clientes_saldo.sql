-- INSERT INTO clientes_saldos
SELECT CONSULTA.CODIGO 						AS CODIGO
		,CONSULTA.cliente						AS cliente
		,CONSULTA.TELEFONO						AS TELEFONO
		,CONSULTA.ult_fact  					AS ult_fact
		,MAX(CONSULTA.ult_pag_dev)       			AS utl_pag_dev
		,CONSULTA.MONEDA						AS MONEDA
		,SUM(CONSULTA.VENTAS)                   AS VENTAS
		,SUM(CONSULTA.PAGOS)                    AS PAGOS
		,SUM(CONSULTA.VENTAS-CONSULTA.PAGOS) 	AS SALDO
	FROM
	(
		SELECT tercero.TER_Codigo     	AS CODIGO
			,tercero.TER_Nombre     	AS cliente
			,tercero.TER_Telefono	  	AS TELEFONO
			,MAX(operacion.OPR_Fecha)   AS ult_fact
			,DATE(20130101)             AS ult_pag_dev
			,moneda.MON_Simbolo		  	AS MONEDA
			,SUM(operacion.OPR_Monto)  	AS VENTAS
			,0							AS PAGOS
			,tercero.TER_Id				AS ID
			,operacion.OPR_MON_Id		AS MONEDA_ID
		FROM operacion
			INNER JOIN comprobante ON comprobante.COM_Id = operacion.OPR_COM_Id
			INNER JOIN moneda      ON moneda.MON_Id      = operacion.OPR_MON_Id
			INNER JOIN tercero     ON tercero.TER_Id     = operacion.OPR_TER_Id
		WHERE  tercero.TER_Tipo   			= 'CL'
			AND comprobante.COM_TIP_Codigo 	= 2
			AND OPR_Monto > 0 
		GROUP BY tercero.TER_Id,operacion.OPR_MON_Id
		UNION ALL
		SELECT tercero.TER_Codigo     	AS CODIGO
			,tercero.TER_Nombre      	AS cliente
			,tercero.TER_Telefono	  	AS TELEFONO
			,DATE(20130101)             AS ult_fact
			,MAX(operacion.OPR_Fecha)   AS ult_pag_dev
			,moneda.MON_Simbolo		  	AS MONEDA
			,0	  						AS VENTAS
			,SUM(operacion.OPR_Monto)	AS PAGOS
			,tercero.TER_Id				AS ID
			,operacion.OPR_MON_Id		AS MONEDA_ID
		FROM operacion
			INNER JOIN comprobante ON comprobante.COM_Id = operacion.OPR_COM_Id
			INNER JOIN moneda      ON moneda.MON_Id      = operacion.OPR_MON_Id
			INNER JOIN tercero     ON tercero.TER_Id     = operacion.OPR_TER_Id
		WHERE  tercero.TER_Tipo   			= 'CL'
			AND comprobante.COM_TIP_Codigo IN (4,5)
			AND OPR_Monto > 0 
		GROUP BY tercero.TER_Id,operacion.OPR_MON_Id
	) AS CONSULTA
	GROUP BY CONSULTA.ID,CONSULTA.MONEDA_ID
	ORDER BY CONSULTA.CODIGO ASC
