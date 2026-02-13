-- =====================================================================================
-- Script Title -> Task 4: Warehouse Performance 
-- =====================================================================================
-- Script Purpose ->
--		Identified Top 3 Warehouses with the highest Average Processing Time 
--			using Warehouses Table.
--		Calculated Total vs. Delayed shipments for each Warehouse using Orders Table.
--		Used CTEs to find bottleneck Warehouses where Processing Time > Global Average
--			using Warehouses Table.
--		Ranked Warehouses based on on-time delivery percentage using Orders Table.
-- =====================================================================================


-- Top 3 Warehouses with the highest average processing time.

SELECT TOP 3
	Warehouse_ID,
	AVG(Processing_Time_Min) AS Top_3_avg_processing_time
FROM UPS.[Warehouses ]
GROUP BY Warehouse_ID
ORDER BY AVG(Processing_Time_Min) DESC, Warehouse_ID;


-- Total shipments vs Delayed Shipments

SELECT 
	Warehouse_ID,
	COUNT(*) Total_Orders_Per_Warehouse,
	SUM(CASE
		WHEN Delivery_Status = 'Delayed' THEN 1
		ELSE 0
	END) Delayed_Orders_Per_Warehouse
FROM UPS.[Orders ]
GROUP BY Warehouse_ID;


-- Use CTEs to find bottleneck warehouses where processing time > global average.

WITH Global_Average_Processing_Time AS (
	SELECT 
		AVG(Processing_Time_Min) AS Global_Avg_Time
	FROM UPS.[Warehouses ]
)
SELECT 
	w.Warehouse_ID,
	w.Processing_Time_Min,
	ga.Global_Avg_Time
FROM UPS.[Warehouses ] AS w, Global_Average_Processing_Time AS ga
WHERE w.Processing_Time_Min > ga.Global_Avg_Time;


-- Rank warehouses based on on-time delivery percentage.

SELECT 
	Warehouse_ID,
	COUNT(*) Total_Orders_Per_Warehouse,
	SUM(CASE
		WHEN Delivery_Status = 'On Time' THEN 1
		ELSE 0
	END) Ontime_Orders_Per_Warehouse,
	CAST(100 * SUM(CASE
		WHEN Delivery_Status = 'On Time' THEN 1
		ELSE 0
	END) / COUNT(*) AS decimal(5,2)) Ontime_Orders_Percent,
	DENSE_RANK() OVER(ORDER BY 
		CAST(100 * SUM(CASE
			WHEN Delivery_Status = 'On Time' THEN 1
			ELSE 0 
		END) / COUNT(*) AS decimal(5,2)) DESC) Warehouse_Rank
FROM UPS.[Orders ]
GROUP BY Warehouse_ID;