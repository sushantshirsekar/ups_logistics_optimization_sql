-- ===================================================================================================
-- Script Title ->  Views Layer for Power BI Visualizations
-- ===================================================================================================
-- Script Purpose ->
--	1. vw_Orders – Calculated delivery delay in days and ranks orders by delay within each warehouse.
--	2. vw_Routes – Provides route KPIs like average delay, efficiency ratio, total orders, 
--		and delayed order percentage.
--	3. vw_Warehouses – Summarizes warehouse performance with order volumes, on-time %, 
--		and processing time comparison to global average.
--	4. vw_Delivery_Agents – Ranks agents per route by on-time delivery % 
--		and flags underperforming agents.
--	5. vw_Shipment_Tracking – Supplies checkpoint-level tracking and delay reason data 
--		for shipment monitoring.
-- ===================================================================================================


-- View Table On Orders

CREATE VIEW UPS.vw_Orders AS
	SELECT 
		*, 
		DATEDIFF(DAY, Expected_Delivery_Date, Actual_Delivery_Date) Delay_In_Days,
		DENSE_RANK() OVER (
			PARTITION BY Warehouse_ID
			ORDER BY DATEDIFF(DAY, Expected_Delivery_Date, Actual_Delivery_Date) DESC
		) AS Delay_In_Days_Per_Warehouse
	FROM  UPS.[Orders ];


-- View Table on Routes 

CREATE VIEW UPS.vw_Routes AS
	SELECT 
		Route_ID,
		Start_Location,
		End_Location,
		Distance_KM,
		Average_Travel_Time_Min,
		Traffic_Delay_Min,
		Avg_Delay_Days,
		Efficiency_Ratio,
		CAST(100 * Delayed_Orders_Per_Route / Total_Orders_Per_Route AS DECIMAL(5,2) ) Delayed_Orders_Percentage
	FROM
		(SELECT 
			r.Route_ID AS Route_ID,
			r.Start_Location AS Start_Location,
			r.End_Location AS End_Location,
			r.Distance_KM AS Distance_KM,
			r.Average_Travel_Time_Min AS Average_Travel_Time_Min,
			r.Traffic_Delay_Min AS Traffic_delay_Min,
			AVG(
				CASE 
					WHEN o.Delivery_Status = 'Delayed'
					THEN DATEDIFF(DAY, o.Expected_Delivery_Date, o.Actual_Delivery_Date)
				END
			) AS Avg_Delay_Days,
			CAST(ROUND(Distance_KM * 1.0 / Average_Travel_Time_Min, 2) AS DECIMAL(10,2)) AS Efficiency_Ratio,
			COUNT(*) Total_Orders_Per_Route,
			SUM(CASE
				WHEN Delivery_Status = 'Delayed' THEN 1
				ELSE 0
			END) AS Delayed_Orders_Per_Route
		FROM UPS.[Orders ] o
		JOIN UPS.[Routes ] r 
		ON o.Route_ID = r.Route_ID
		GROUP BY r.Route_ID,
			r.Start_Location,
			r.End_Location,
			r.Distance_KM,
			r.Average_Travel_Time_Min,
			r.Traffic_Delay_Min) t;


-- View Table on Warehouses 

CREATE VIEW UPS.vw_Warehouses AS

	WITH Global_Average_Processing_Time AS (
		SELECT AVG(Processing_Time_Min) AS Global_Avg_Time
		FROM UPS.[Warehouses ]
	)

	SELECT
		w.Warehouse_ID,
		w.Location,
		w.Processing_Time_Min,
		w.Dispatch_Time,

		COUNT(o.Order_ID) AS Total_Orders_Per_Warehouse,

		SUM(CASE
			WHEN o.Delivery_Status = 'On Time' THEN 1
			ELSE 0
		END) AS Ontime_Orders_Per_Warehouse,

		CAST(
			100.0 * SUM(CASE
				WHEN o.Delivery_Status = 'On Time' THEN 1
				ELSE 0
			END) / COUNT(o.Order_ID)
		AS DECIMAL(5,2)) AS Ontime_Orders_Percent_Per_Warehouse,

		CASE
			WHEN w.Processing_Time_Min > ga.Global_Avg_Time THEN 'Above Global Average'
			WHEN w.Processing_Time_Min = ga.Global_Avg_Time THEN 'Global Average'
			ELSE 'Below Global Average'
		END AS Processing_Level

	FROM UPS.[Warehouses ] w
	JOIN UPS.[Orders ] o
		ON w.Warehouse_ID = o.Warehouse_ID
	CROSS JOIN Global_Average_Processing_Time ga

	GROUP BY 
		w.Warehouse_ID,
		w.Location,
		w.Processing_Time_Min,
		w.Dispatch_Time,
		ga.Global_Avg_Time;


-- View Table on Delivery Agents 

CREATE VIEW UPS.vw_Delivery_Agents AS
	SELECT
		Agent_ID,
		Route_ID,
		Shift_Hours,
		Avg_Speed_KM_HR,
		On_Time_Percentage,
		CASE
			WHEN On_Time_Percentage >= 80 THEN 'Yes'
			ELSE 'No'
		END Performer_Flag,
		DENSE_RANK() OVER(PARTITION BY Route_ID ORDER BY On_Time_Percentage DESC) Agent_Rank_Per_Route
	FROM UPS.Delivery_Agents;


-- View Table on Shipment Trackings

CREATE VIEW UPS.vw_Shipment_Tracking AS
	SELECT 
		Shipment_ID,
		Order_ID,
		[Checkpoint ],
		Checkpoint_Time,
		Delay_Reason
	FROM UPS.Shipment_Tracking;

SELECT 
    s.name AS Schema_Name,
    v.name AS View_Name
FROM sys.views v
JOIN sys.schemas s ON v.schema_id = s.schema_id
WHERE v.name = 'vw_Delivery_Agents';