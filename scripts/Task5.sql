-- ======================================================================
-- Script Title -> Task 5: Delivery Agent Performance
-- ======================================================================
-- Script Purpose -> 
--	Ranked agents (per route) by On-Time delivery percentage 
--      using Deliver_Agents Table.
--	Identified Agents with On-Time % < 80% using Delivery_Agents Table.
--	Compared Average Speed of Top 5 vs Bottom 5 Agents using Subqueries
--      in Delivery_Agents Table.
-- ======================================================================


SELECT * FROM UPS.Delivery_Agents;


-- Rank agents (per route) by on-time delivery percentage.

SELECT 
	Route_ID,
	Agent_ID,
	On_Time_Percentage,
	DENSE_RANK() OVER(PARTITION BY Route_ID ORDER BY On_Time_Percentage DESC) Agent_Rank
FROM UPS.Delivery_Agents;


-- Find agents with on-time % < 80%.

SELECT 
	Agent_ID,
	On_Time_Percentage
FROM UPS.Delivery_Agents
WHERE On_Time_Percentage < 80
ORDER BY On_Time_Percentage DESC;


-- Compare average speed of top 5 vs bottom 5 agents using subqueries.

SELECT 
    (SELECT AVG(Avg_Speed_KM_HR)
     FROM (
         SELECT TOP 5 Avg_Speed_KM_HR
         FROM UPS.Delivery_Agents
         ORDER BY Avg_Speed_KM_HR DESC
     ) AS Top_Delivery_Agents
    ) AS Top_5_Avg_Speed,

    (SELECT AVG(Avg_Speed_KM_HR)
     FROM (
         SELECT TOP 5 Avg_Speed_KM_HR
         FROM UPS.Delivery_Agents
         ORDER BY Avg_Speed_KM_HR ASC
     ) AS Bottom_Delivery_Agents
    ) AS Bottom_5_Avg_Speed;

SELECT * FROM UPS.[Orders ];