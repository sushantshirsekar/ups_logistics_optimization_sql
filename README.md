# Logistics Optimization for Delivery Routes – UPS (SQL Project)

## Project Overview

UPS (United Parcel Service) operates a large-scale global logistics network involving warehouses, transportation routes, shipment tracking systems, and delivery agents. With high daily shipment volumes, maintaining delivery efficiency and minimizing delays is critical for operational success and customer satisfaction.

This project develops a complete SQL-based Logistics Intelligence System to analyze delivery performance, route efficiency, warehouse bottlenecks, agent productivity, and overall shipment KPIs.

---

## Business Objectives

- Reduce delivery delays across routes  
- Improve route efficiency and transportation planning  
- Identify warehouse bottlenecks  
- Monitor delivery agent performance  
- Enhance on-time delivery percentage  
- Enable data-driven operational decision-making  

---

## Datasets Used

### 1. Orders Dataset  
Contains order-level delivery details.

Key fields:  
Order_ID, Order_Date, Expected_Delivery_Date, Actual_Delivery_Date, Route_ID, Warehouse_ID, Delivery_Status, Payment_Type  

### 2. Routes Dataset  
Includes route-level transportation information.

Key fields:  
Route_ID, Start_Location, End_Location, Distance_KM, Average_Travel_Time_Min, Traffic_Delay_Min  

### 3. Warehouses Dataset  
Provides warehouse-level operational data.

Key fields:  
Warehouse_ID, Location, Country, Processing_Time  

### 4. Delivery Agents Dataset  
Contains agent-level performance information.

Key fields:  
Agent_ID, Agent_Name, Route_ID, Experience_Years, Customer_Rating  

### 5. Shipment Tracking Dataset  
Includes shipment checkpoint and delay information.

Key fields:  
Order_ID, Checkpoint, Checkpoint_Time, Delay_Minutes, Delay_Reason  

---

## Tools & Technologies Used

- SQL  
- Window Functions  
- CTEs (Common Table Expressions)  
- Subqueries  
- Aggregations & Joins  
- Analytical Query Techniques  

---

## Key Tasks Performed

### 1. Data Cleaning & Preparation

- Removed duplicate Order_ID records  
- Replaced NULL traffic delays with route-level averages  
- Standardized date formats to YYYY-MM-DD  
- Flagged inconsistent delivery records where Actual_Delivery_Date < Order_Date  

---

### 2. Delivery Delay Analysis

- Calculated delivery delay (in days) for each order  
- Identified Top 10 delayed routes based on average delay  
- Ranked orders by delay within each warehouse using window functions  

---

### 3. Route Optimization Insights

- Calculated average delivery time per route  
- Measured average traffic delay  
- Computed Distance-to-Time Efficiency Ratio  
- Identified 3 least efficient routes  
- Detected routes with more than 20 percent delayed shipments  

---

### 4. Warehouse Performance Analysis

- Identified top 3 warehouses with highest average processing time  
- Calculated total vs delayed shipments per warehouse  
- Used CTEs to identify bottleneck warehouses  
- Ranked warehouses based on on-time delivery percentage  

---

### 5. Delivery Agent Performance

- Ranked agents per route by on-time delivery percentage  
- Identified agents with on-time performance below 80 percent  
- Compared performance between top 5 and bottom 5 agents  

---

### 6. Shipment Tracking Analytics

- Retrieved last checkpoint and timestamp for each order  
- Identified most common delay reasons  
- Detected orders with more than 2 delayed checkpoints  

---

### 7. Advanced KPI Reporting

Calculated key operational KPIs:

- Average Delivery Delay per Region  
- On-Time Delivery Percentage  
- Average Traffic Delay per Route  

---

## Key Insights

- Certain routes consistently showed high delay rates and low efficiency ratios.  
- A small number of warehouses significantly impacted overall processing time.  
- Delivery agent performance varied notably across routes.  
- Traffic delay played a major role in shipment performance variability.  

---

## Business Recommendations

- Optimize high-delay routes using data-driven planning.  
- Improve warehouse processing workflows at bottleneck locations.  
- Implement continuous agent performance monitoring.  
- Adjust route scheduling based on traffic delay trends.  
- Track KPIs regularly to ensure operational efficiency.  

---

## Project Outcome

This SQL-driven logistics analytics solution enables UPS to:

- Identify inefficiencies in routes and warehouses  
- Improve on-time delivery performance  
- Optimize operational workflows  
- Make data-backed strategic logistics decisions  

---

## Author

Sushant  
Data Analyst | SQL | Power BI | Excel  
