/* Exercises */

-- Exercise 1
-- The company wants to weekly check the stock of their products.
-- If the stock is below 15, they'd like to order more to fulfill the need.

-- (1.1) Create a QUERY that shows the ProductId, ProductName and the name of the supplier, do not forget the WHERE clause.
SELECT p.ProductID, p.ProductName, s.CompanyName
FROM Products p
JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE p.UnitsInStock < 15;
-- (1.2) Turn this SELECT statement into a VIEW called: vw_products_to_order.
CREATE VIEW vw_product_to_order
AS
SELECT p.ProductID, p.ProductName, s.CompanyName
FROM Products p
JOIN Suppliers s ON s.SupplierID = p.SupplierID
WHERE p.UnitsInStock < 15;

-- (1.3) Query the VIEW to see the results.
SELECT * FROM vw_product_to_order

-- Exercise 2
-- The company has to increase prices of certain products. 
-- To make it seem the prices are not increasing dramatically they're planning to spread the price increase over multiple years. 
-- In total they'd like a 10% price for certain products. The list of impacted products can grow over the coming years. 
-- We'd like to keep all the logic of selecting the correct products in 1 SQL View, in programming terms 'keeping it DRY'. 
-- The updating of the items is not part of the view itself.
-- The products in scope are all the products with the term 'Bröd' or 'Biscuit'.

-- (2.1) Create a simple SQL Query to get the correct resultset


-- (2.2) Turn this SELECT statement into a VIEW called: vw_price_increasing_products.


-- (2.3) Query the VIEW to see the results.


-- (2.4) Increase the price of the resultset of the VIEW: vw_price_increasing_products by 2%