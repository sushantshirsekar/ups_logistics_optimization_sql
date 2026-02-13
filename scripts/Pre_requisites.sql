-- Script Title -> Pre-Requisites
-- Script Purpose -> 
--	1. Created Project Database.
--	2. Created Schema for the Data Tables.
--	3. Imported Data by right clicking on the 
--		Databse -> Tasks -> Import Flat File
--	4. Added all the Data Tables -> 
--		Delivery_Agents, Orders, Routes, Shipment_Tracking and Warehouses.
--	5. Updated On_Time_Percentage Field of Delivery_Agents,
--		Formatting Decimal places to 2 decimal places.
--	6. Created Relationships between Data Tables.

-- =======================================================
-- Database & Schema Intialization
-- =======================================================
CREATE DATABASE UPS_Analytics;

USE UPS_Analytics;

CREATE SCHEMA UPS;

-- =======================================================
-- Formatting Data
-- =======================================================

-- Converting On_Time_Percentage field to consistent 
--	2 decimal places in Delivery_Agents table. 

ALTER TABLE UPS.Delivery_Agents
ALTER COLUMN On_Time_Percentage DECIMAL(5,2);


-- Converting Distance_KM in Routes table to consistent
-- 2 decimal places in Delivery_Agents table.

ALTER TABLE UPS.[Routes ]
ALTER COLUMN Distance_KM DECIMAL(5,2);


-- Converting String time format to time format in Warehouse Table

UPDATE UPS.[Warehouses ]
SET Dispatch_Time = REPLACE(Dispatch_Time, '.', ':');

ALTER TABLE UPS.[Warehouses ]
	ALTER COLUMN Dispatch_Time TIME;


-- =======================================================
-- Connecting Data Tables
-- =======================================================

-- Establishing Relationship between Orders and Routes using key : Route_ID
-- Constraint Check
SELECT Route_ID
FROM UPS.[Orders ]
WHERE Route_ID NOT IN (SELECT Route_ID FROM UPS.[Routes ]);

ALTER TABLE UPS.[Orders ]
ADD CONSTRAINT FK_Orders_Routes
FOREIGN KEY (Route_ID)
REFERENCES UPS.[Routes ](Route_ID);


-- Establishing Relationship between Orders and Warehouses using key : Warehouse_ID
-- Constraint Check
SELECT Warehouse_ID
FROM UPS.[Orders ]
WHERE Warehouse_ID NOT IN (SELECT Warehouse_ID FROM UPS.[Warehouses ]);

ALTER TABLE UPS.[Orders ]
ADD CONSTRAINT FK_Orders_Warehouses
FOREIGN KEY (Route_ID)
REFERENCES UPS.[Routes ](Route_ID);


-- Establishing Relationship between Routes and Delivery Agents using key : Route_ID
-- Constraint Check
SELECT Route_ID
FROM UPS.Delivery_Agents
WHERE Route_ID NOT IN (SELECT Route_ID FROM UPS.[Routes ]);

ALTER TABLE UPS.Delivery_Agents
ADD CONSTRAINT FK_Agents_Routes
FOREIGN KEY (Route_ID)
REFERENCES UPS.[Routes ](Route_ID);

-- Establishing Relationship between Shipment Tracking and Orders using key : Order_ID
-- Constraint Check
SELECT Order_ID
FROM UPS.Shipment_Tracking
WHERE Order_ID NOT IN (SELECT Order_ID FROM UPS.[Orders ]);

ALTER TABLE UPS.Shipment_Tracking
ADD CONSTRAINT FK_ShipmentTracking_Orders
FOREIGN KEY (Order_ID)
REFERENCES UPS.[Orders ](Order_ID);