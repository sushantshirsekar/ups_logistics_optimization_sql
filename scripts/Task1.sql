-- ===========================================================================================
-- Script Title -> Task 1: Data Cleaning & Preparation
-- ===========================================================================================
-- Script Purpose -> 
--  1. Identified and deleted duplicate Order_ID records.
--  2. Replaced null Traffic_Delay_Min with the average delay for that route in Routes Table.
--  3. Converted all date columns into YYYY-MM-DD format using SQL functions in Orders Table.
--  4. Flagged Incorrect Date (Actual_Delivery_Date < Order_Date) as Invalid Date and 
--      correct as Valid Date in Orders Table.
-- ===========================================================================================


-- Identified Duplicate records (Using CTE) in Orders Table.

SELECT 
    Order_ID
FROM
    (SELECT 
        Order_ID,
        Order_Date,
        ROW_NUMBER() OVER(PARTITION BY Order_ID ORDER BY Order_Date) rn
    FROM UPS.[Orders ]) as Alias
    WHERE rn > 1;

SELECT * FROM UPS.[Orders ]

-- Deleted Duplicate Records in Orders Table.

DELETE FROM UPS.[Orders ]
WHERE Order_ID IN (
    SELECT 
        Order_ID
    FROM
        (SELECT 
            Order_ID,
            Order_Date,
            ROW_NUMBER() OVER(PARTITION BY Order_ID ORDER BY Order_Date) rn
        FROM UPS.[Orders ]) as Alias
    WHERE rn > 1
);


-- Checking Traffic_Delay_Min values to be updated.

SELECT Route_ID, Traffic_Delay_Min FROM UPS.[Routes ]
WHERE Traffic_Delay_Min IS NULL;

-- Replaced null Traffic_Delay_Min  with the average delay 
-- for that route in routes Table.

UPDATE UPS.[Routes ]
    SET Traffic_Delay_Min = (
    SELECT AVG(Traffic_Delay_Min)
    FROM UPS.[Routes ]
    WHERE Traffic_Delay_Min IS NOT NULL
)
WHERE Traffic_Delay_Min IS NULL;




-- Converting date format to YYYY-MM-DD format in Orders table.

SELECT 
   Order_ID,
   Order_Date,
   Expected_Delivery_Date,
   Actual_Delivery_Date
FROM UPS.[Orders ];


UPDATE UPS.[Orders ]
SET Order_Date = CONVERT(DATE, Order_Date, 105),
    Expected_Delivery_Date = CONVERT(DATE, Expected_Delivery_Date, 105),
    Actual_Delivery_Date = CONVERT(DATE, Actual_Delivery_Date, 105);


-- Created a Flag column in Orders table, where 
-- Actual_Delivery_Date < Order_Date is flagged as Invalid Date
-- and correct date is flagged as Valid Date

SELECT 
   Order_ID,
   Order_Date,
   Expected_Delivery_Date,
   Actual_Delivery_Date
FROM UPS.[Orders ]
WHERE Actual_Delivery_Date < Order_Date;

ALTER TABLE UPS.Orders
ADD Is_Date_Valid VARCHAR(20);

UPDATE UPS.[Orders ]
SET Is_Date_Valid =
    CASE
        WHEN Actual_Delivery_Date < Order_Date THEN 'Invalid Date'
        ELSE 'Valid Date'
    END;
