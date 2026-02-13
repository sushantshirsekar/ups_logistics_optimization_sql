-- ===========================================================
-- Script Title -> Task 6: Shipment Tracking Analytics
-- ===========================================================
-- Script Purpose -> 
--	For each Order, listed the last Checkpoint and Time
--		using Shipment_Tracking Table.
--	Identified the most common Delay Reasons (excluding None)
--		using Shipment_Tracking Table.
--	Identified Orders with >2 delayed Checkpoints
--		using Shipment_Tracking Table.
-- ===========================================================


-- For each order, listed the last Checkpoint and Time.

SELECT 
	Order_ID,
	[Checkpoint ],
	Checkpoint_Time
FROM
(SELECT
	Order_ID,
	[Checkpoint ],
	Checkpoint_Time,
	Row_Number() OVER(PARTITION BY Order_ID ORDER BY Checkpoint_Time DESC, [Checkpoint ] DESC) rn
FROM UPS.Shipment_Tracking) t
WHERE rn = 1;


--	Identified the most Common Delay Reasons (excluding None).

SELECT
	Delay_Reason,
	COUNT(*) Frequency_Of_Delay_Reasons
FROM UPS.Shipment_Tracking
WHERE Delay_Reason <> 'None'
GROUP BY Delay_Reason
ORDER BY COUNT(*) DESC;


--	Identified orders with >2 Delayed Checkpoints

SELECT 
	Order_ID,
	COUNT(*) No_Of_Checkpoints
FROM UPS.Shipment_Tracking
WHERE Delay_Reason <> 'None'
AND Delay_Reason IS NOT NULL
GROUP BY Order_ID
HAVING COUNT(*) > 2
ORDER BY No_Of_Checkpoints DESC, Order_ID;