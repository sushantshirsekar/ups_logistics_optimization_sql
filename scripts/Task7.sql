-- ======================================================================================
-- Script Title -> Task 7: Advanced KPI Reporting
-- ======================================================================================
-- Script Purpose -> 
--	Calculated Average Delivery Delay per Region (Start_Location) using Routes Table.
--	Calculated On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100
--		using Orders Table.
--	Calculated Average Traffic Delay per Route
--		using Routes Table.
-- ======================================================================================


--	Calculated Average Delivery Delay per Region (Start_Location).

SELECT  
	Start_Location,
	AVG(Traffic_Delay_Min) Avg_Delay_Per_Region
FROM UPS.[Routes ]
GROUP BY Start_Location;


-- Calculated On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100.

SELECT 
	CAST(100 *
	SUM(CASE
		WHEN Delivery_Status = 'On Time' THEN 1
		ELSE 0
	END) / COUNT(*)
	AS DECIMAL(5,2)) AS On_Time_Delivery_Percent
FROM UPS.[Orders ];


-- Calculated Average Traffic Delay per Route.

SELECT 
	Route_ID,
	AVG(Traffic_Delay_Min) Avg_Traffic_Delay_Per_Route
FROM UPS.[Routes ]
GROUP BY Route_ID;