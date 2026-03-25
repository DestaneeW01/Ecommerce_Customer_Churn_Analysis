USE EcommerceAnalytics;
GO

-- Churn by Recency
SELECT
    CASE 
        WHEN Days_Since_Last_Purchase <= 10 THEN '0-10 Days'
        WHEN Days_Since_Last_Purchase <= 30 THEN '11-30 Days'
        WHEN Days_Since_Last_Purchase <= 60 THEN '31-60 Days'
        ELSE '60+ Days'
    END AS Recency_Group,

    COUNT(*) AS Total_Customers,
    AVG(CAST(Churned AS FLOAT)) AS Churn_Rate

FROM dbo.CustomerData
GROUP BY 
    CASE 
        WHEN Days_Since_Last_Purchase <= 10 THEN '0-10 Days'
        WHEN Days_Since_Last_Purchase <= 30 THEN '11-30 Days'
        WHEN Days_Since_Last_Purchase <= 60 THEN '31-60 Days'
        ELSE '60+ Days'
    END
ORDER BY Churn_Rate DESC;


-- Engagement vs Lifetime Value
SELECT
    CASE 
        WHEN Pages_Per_Session >= 12 THEN 'High Engagement'
        WHEN Pages_Per_Session >= 6 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END AS Engagement_Level,

    AVG(Lifetime_Value) AS Avg_LTV,
    COUNT(*) AS Customers

FROM dbo.CustomerData
GROUP BY 
    CASE 
        WHEN Pages_Per_Session >= 12 THEN 'High Engagement'
        WHEN Pages_Per_Session >= 6 THEN 'Medium Engagement'
        ELSE 'Low Engagement'
    END
ORDER BY Avg_LTV DESC;


-- Cart Abandonment vs Purchase
SELECT
    CASE 
        WHEN Cart_Abandonment_Rate >= 70 THEN 'High'
        WHEN Cart_Abandonment_Rate >= 40 THEN 'Medium'
        ELSE 'Low'
    END AS Abandonment_Group,

    AVG(Total_Purchases) AS Avg_Purchases,
    AVG(Lifetime_Value) AS Avg_LTV

FROM dbo.CustomerData
GROUP BY 
    CASE 
        WHEN Cart_Abandonment_Rate >= 70 THEN 'High'
        WHEN Cart_Abandonment_Rate >= 40 THEN 'Medium'
        ELSE 'Low'
    END
ORDER BY Avg_Purchases;


-- Churn by Engagement
SELECT
    CASE 
        WHEN Login_Frequency >= 20 THEN 'High Activity'
        WHEN Login_Frequency >= 10 THEN 'Medium Activity'
        ELSE 'Low Activity'
    END AS Activity_Level,

    AVG(CAST(Churned AS FLOAT)) AS Churn_Rate,
    COUNT(*) AS Customers

FROM dbo.CustomerData
GROUP BY 
    CASE 
        WHEN Login_Frequency >= 20 THEN 'High Activity'
        WHEN Login_Frequency >= 10 THEN 'Medium Activity'
        ELSE 'Low Activity'
    END
ORDER BY Churn_Rate DESC;


-- At-Risk Customers
SELECT *
FROM dbo.CustomerData
WHERE 
    Days_Since_Last_Purchase > 30
    AND Login_Frequency < 10
    AND Cart_Abandonment_Rate > 60;


-- Missing Data vs Churn
SELECT
    Wishlist_Items_Missing_Flag,
    AVG(CAST(Churned AS FLOAT)) AS Churn_Rate,
    COUNT(*) AS Customers

FROM dbo.CustomerData
GROUP BY Wishlist_Items_Missing_Flag;


SELECT * 
FROM dbo.CustomerData;
