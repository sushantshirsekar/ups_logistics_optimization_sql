-- ===========================================================================
-- Script Title -> Task 2: Delivery Delay Analysis
-- ===========================================================================
-- Script Purpose -> 
--	1. Calculated delivery delay (in days) for each order in Orders Table.
--	2. Identified Top 10 delayed routes based on average delay days in Orders Table.
--	3. Used window functions to rank all Orders by delay within each Warehouse in Orders Table.
-- ===========================================================================


-- Calculated Delivery Delay in days for each Order using Orders table.

SELECT 
	Order_ID,
	Order_Date,
	Expected_Delivery_Date,
	Actual_Delivery_Date,
	Delivery_Status,
	DATEDIFF(DAY, Expected_Delivery_Date, Actual_Delivery_Date) Delay_In_Days
FROM  UPS.[Orders ];


-- Top 10 delayed routes based on average delay days

SELECT TOP 10
	r.Route_ID,
	r.Start_Location,
	r.End_Location,
	r.Distance_KM,
	r.Average_Travel_Time_Min,
	r.Traffic_Delay_Min,
	ROUND(AVG(CAST(DATEDIFF(DAY, o.Expected_Delivery_Date, o.Actual_Delivery_Date) AS FLOAT) ),2) Avg_Delay_In_Days
FROM UPS.[Orders ] o
	JOIN UPS.[Routes ] r 
	ON o.Route_ID = r.Route_ID
GROUP BY r.Route_ID,
	r.Start_Location,
	r.End_Location,
	r.Distance_KM,
	r.Average_Travel_Time_Min,
	r.Traffic_Delay_Min
ORDER BY Avg_Delay_In_Days DESC, r.Route_ID;


-- Used window functions to rank all orders by delay within each warehouse.

SELECT 
	Warehouse_ID,
	Order_ID,
	Order_Date,
	Expected_Delivery_Date,
	Actual_Delivery_Date,
	Delivery_Status,
	DATEDIFF(DAY, Expected_Delivery_Date, Actual_Delivery_Date) Delay_In_Days,
	DENSE_RANK() OVER (
        PARTITION BY Warehouse_ID
        ORDER BY DATEDIFF(DAY, Expected_Delivery_Date, Actual_Delivery_Date) DESC
    ) AS Rank_Per_Order_By_Warehouse
FROM UPS.[Orders ];