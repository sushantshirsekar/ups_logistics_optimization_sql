-- ====================================================================================
-- Script Title -> Task 3: Route Optimization Insights
-- ====================================================================================
-- Script Purpose ->  For each route, calculated:
--						Average delivery time (in days) in Orders Table.
--						Average traffic delay in Routes Table.
--						Distance-to-time efficiency ratio: 
--								Distance_KM / Average_Travel_Time_Min in Routes Table.
--	Identified 3 routes with the Worst efficiency ratio in Routes Table.
--	Find routes with >20% delayed shipments.
--	Recommend potential routes for optimization.
-- ====================================================================================


-- Calculated Average delivery time (in days) per Route

SELECT 
	Route_ID,
	ROUND(AVG(CAST(DATEDIFF(day, Order_Date, Actual_Delivery_Date) AS FLOAT)),2) Delivery_Time_Days
FROM UPS.[Orders ]
GROUP BY Route_ID
ORDER BY Delivery_Time_Days DESC, Route_ID;


-- Calculated Average traffic delay

SELECT 
	Route_ID,
	AVG(Traffic_Delay_Min) OVER(PARTITION BY Route_ID) as Avg_Traffic_Delay
FROM UPS.[Routes ]
ORDER BY Avg_Traffic_Delay DESC, Route_ID;


-- Calculated Distance-to-time efficiency ratio: Distance_KM / Average_Travel_Time_Min.

SELECT 
	Route_ID,
	CAST(ROUND(Distance_KM * 1.0 / Average_Travel_Time_Min, 2) AS DECIMAL(10,2)) as Efficiency_Ratio
FROM UPS.[Routes ]
ORDER BY Efficiency_Ratio DESC;


-- Identified Top 3 routes with the worst efficiency ratio.

SELECT TOP 3
	Route_ID,
	ROUND(CAST(Distance_KM * 1.0 / Average_Travel_Time_Min AS FLOAT) ,2) as Efficiency_Ratio
FROM UPS.[Routes ]
ORDER BY Efficiency_Ratio, Route_ID;


-- Identified Routes with >20% delayed shipments.

SELECT 
	Route_ID,
	Delayed_Orders_Per_Route,
	Total_Orders_Per_Route,
	CAST(100 * Delayed_Orders_Per_Route / Total_Orders_Per_Route AS DECIMAL(5,2) ) Delayed_Percentage
FROM
	(SELECT 
		Route_ID,
		COUNT(*) Total_Orders_Per_Route,
		SUM(CASE
			WHEN Delivery_Status = 'Delayed' THEN 1
			ELSE 0
		END) AS Delayed_Orders_Per_Route
	
	FROM UPS.[Orders ]
	GROUP BY Route_ID ) t
ORDER BY Delayed_Percentage DESC, Route_ID;
