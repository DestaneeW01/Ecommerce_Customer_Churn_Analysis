USE EcommerceAnalytics;
GO

/*-------------------------------------------------
  Drop tables if they already exist
--------------------------------------------------*/
IF OBJECT_ID('dbo.CustomerData', 'U') IS NOT NULL
    DROP TABLE dbo.CustomerData;

IF OBJECT_ID('dbo.CustomerData_Stage', 'U') IS NOT NULL
    DROP TABLE dbo.CustomerData_Stage;
GO

/*-------------------------------------------------
  Final table (typed, clean schema)
--------------------------------------------------*/
CREATE TABLE dbo.CustomerData
(
    Age FLOAT,
    Gender NVARCHAR(20),
    Country NVARCHAR(50),
    City NVARCHAR(100),
    Membership_Years FLOAT,
    Login_Frequency INT,
    Session_Duration_Avg FLOAT,
    Pages_Per_Session FLOAT,
    Cart_Abandonment_Rate FLOAT,
    Wishlist_Items FLOAT,
    Total_Purchases FLOAT,
    Average_Order_Value FLOAT,
    Days_Since_Last_Purchase FLOAT,
    Discount_Usage_Rate FLOAT,
    Returns_Rate FLOAT,
    Email_Open_Rate FLOAT,
    Customer_Service_Calls FLOAT,
    Product_Reviews_Written FLOAT,
    Social_Media_Engagement_Score FLOAT,
    Mobile_App_Usage FLOAT,
    Payment_Method_Diversity FLOAT,
    Lifetime_Value FLOAT,
    Credit_Balance FLOAT,
    Churned INT,
    Signup_Quarter NVARCHAR(5),
    Wishlist_Items_Missing_Flag INT,
    Returns_Rate_Missing_Flag INT,
    Product_Reviews_Written_Missing_Flag INT,
    Social_Media_Engagement_Score_Missing_Flag INT,
    Mobile_App_Usage_Missing_Flag INT
);
GO

/*-------------------------------------------------
  Staging table (ALL text, very forgiving)
--------------------------------------------------*/
CREATE TABLE dbo.CustomerData_Stage
(
    Age NVARCHAR(100),
    Gender NVARCHAR(100),
    Country NVARCHAR(100),
    City NVARCHAR(100),
    Membership_Years NVARCHAR(100),
    Login_Frequency NVARCHAR(100),
    Session_Duration_Avg NVARCHAR(100),
    Pages_Per_Session NVARCHAR(100),
    Cart_Abandonment_Rate NVARCHAR(100),
    Wishlist_Items NVARCHAR(100),
    Total_Purchases NVARCHAR(100),
    Average_Order_Value NVARCHAR(100),
    Days_Since_Last_Purchase NVARCHAR(100),
    Discount_Usage_Rate NVARCHAR(100),
    Returns_Rate NVARCHAR(100),
    Email_Open_Rate NVARCHAR(100),
    Customer_Service_Calls NVARCHAR(100),
    Product_Reviews_Written NVARCHAR(100),
    Social_Media_Engagement_Score NVARCHAR(100),
    Mobile_App_Usage NVARCHAR(100),
    Payment_Method_Diversity NVARCHAR(100),
    Lifetime_Value NVARCHAR(100),
    Credit_Balance NVARCHAR(100),
    Churned NVARCHAR(100),
    Signup_Quarter NVARCHAR(100),
    Wishlist_Items_Missing_Flag NVARCHAR(100),
    Returns_Rate_Missing_Flag NVARCHAR(100),
    Product_Reviews_Written_Missing_Flag NVARCHAR(100),
    Social_Media_Engagement_Score_Missing_Flag NVARCHAR(100),
    Mobile_App_Usage_Missing_Flag NVARCHAR(100)
);
GO

/*-------------------------------------------------
  BULK INSERT using CSV parser
--------------------------------------------------*/
BULK INSERT dbo.CustomerData_Stage
FROM 'C:\Imports\ecommerce_customer_churn_clean.csv'  -- <<< CHANGE THIS PATH
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    KEEPNULLS,
    TABLOCK
);
GO

/*-------------------------------------------------
  Insert into final table with safe conversions
--------------------------------------------------*/
INSERT INTO dbo.CustomerData
SELECT
    TRY_CONVERT(FLOAT, Age),
    Gender,
    Country,
    City,
    TRY_CONVERT(FLOAT, Membership_Years),
    TRY_CONVERT(INT, Login_Frequency),
    TRY_CONVERT(FLOAT, Session_Duration_Avg),
    TRY_CONVERT(FLOAT, Pages_Per_Session),
    TRY_CONVERT(FLOAT, Cart_Abandonment_Rate),
    TRY_CONVERT(FLOAT, Wishlist_Items),
    TRY_CONVERT(FLOAT, Total_Purchases),
    TRY_CONVERT(FLOAT, Average_Order_Value),
    TRY_CONVERT(FLOAT, Days_Since_Last_Purchase),
    TRY_CONVERT(FLOAT, Discount_Usage_Rate),
    TRY_CONVERT(FLOAT, Returns_Rate),
    TRY_CONVERT(FLOAT, Email_Open_Rate),
    TRY_CONVERT(FLOAT, Customer_Service_Calls),
    TRY_CONVERT(FLOAT, Product_Reviews_Written),
    TRY_CONVERT(FLOAT, Social_Media_Engagement_Score),
    TRY_CONVERT(FLOAT, Mobile_App_Usage),
    TRY_CONVERT(FLOAT, Payment_Method_Diversity),
    TRY_CONVERT(FLOAT, Lifetime_Value),
    TRY_CONVERT(FLOAT, Credit_Balance),
    TRY_CONVERT(INT, Churned),
    Signup_Quarter,
    TRY_CONVERT(INT, Wishlist_Items_Missing_Flag),
    TRY_CONVERT(INT, Returns_Rate_Missing_Flag),
    TRY_CONVERT(INT, Product_Reviews_Written_Missing_Flag),
    TRY_CONVERT(INT, Social_Media_Engagement_Score_Missing_Flag),
    TRY_CONVERT(INT, Mobile_App_Usage_Missing_Flag)
FROM dbo.CustomerData_Stage;
GO

/*-------------------------------------------------
  Quick sanity check
--------------------------------------------------*/
SELECT COUNT(*) AS RowsLoaded FROM dbo.CustomerData;
SELECT TOP 10 * FROM dbo.CustomerData;
GO