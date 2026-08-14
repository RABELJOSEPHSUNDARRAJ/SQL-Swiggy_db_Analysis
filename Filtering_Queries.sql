/*
PART A – Beginner SQL (Questions 1–40)
Basic SQL Statements

1. Display all customer details. */
select * 
from customers;

/* 2.Display Customer ID, Customer Name, and City. */
select CustomerID, concat(FirstName, LastName), City
from customers;

/* 3.Display customers from Chennai. */
select * 
from customers
where City = 'Chennai';

/* 4.Display customers from Coimbatore. */
select * 
from customers
where City = 'Coimbatore';

/* 5.Display the list of unique customer cities. */
select distinct City
from customers;

/* 6.Display customers in alphabetical order. */
select * 
from customers
order by FirstName;

/* 7.Display customers in reverse alphabetical order. */
select * 
from customers
order by FirstName desc;

/* 8.Display the first 10 customer records. */
select * 
from customers
limit 10;

/* 9.Display the first five restaurants. */
select *
from restaurants
limit 5;

/* 10.Display restaurants located in Bengaluru. */
select * 
from restaurants
where City = 'Bengaluru';

/* Filtering Records
11.Display all menu items. */
select * 
from menuitems;

/* 12.Display only vegetarian menu items. */
select * 
from menuitems
where Isveg = True;

/* 13.Display only non-vegetarian menu items. */
select *
from menuitems
where IsVeg = 0;

/* 14.Display menu items costing more than ₹300. */
select * 
from menuitems 
where Price > 300;

/* 15.Display menu items costing less than ₹200. */
select * 
from menuitems 
where Price < 200;

/* 16.Display menu items priced between ₹200 and ₹400. */
select * 
from menuitems 
where Price between 200 and 400;

/* 17.Display the ten most expensive menu items. */
select *
from menuitems
order by Price desc
limit 10;

/* 18.Display the ten least expensive menu items. */
select *
from menuitems
order by Price 
limit 10;

/* 19.Display customers whose names begin with the letter 'A'. */
select *
from customers
where FirstName like 'A%';

/* 20.Display customers whose names end with "Kumar". */
select * 
from customers 
where LastName like '%Kumar';

/* Pattern Matching & Conditions
21.Display menu items containing the word "Chicken". */
select ItemName
from menuitems 
where ItemName like '%Chicken%';

/* 22.Display customers from Chennai, Coimbatore, and Madurai. */
select concat(FirstName, LastName), City 
from customers
where City in ('Chennai', 'Coimbatore', 'Madurai');

/* 23.Display customers who are not from Chennai. */
select concat(FirstName, LastName), City 
from customers
where City not in ('Chennai');

/* 24.Display deliveries where the delivery rating is not available. */
select * 
from delivery
where DeliveryRating is null;

/* 25.Display deliveries that have received ratings. */
select * 
from delivery
where DeliveryRating is not null;

/* Orders, Payments & Reviews
 26.Display all orders. */
 select *
 from orders;
 
/* 27.Display delivered orders. */
select *
from orders
where OrderStatus = 'Delivered';

/* 28.Display cancelled orders. */
select *
from orders
where OrderStatus = 'Cancelled';

/* 29.Display pending orders. */
select *
from orders
where OrderStatus not in ('Delivered', 'Cancelled');

/* 30.Display completed payments. */
select * 
from payments
where PaymentStatus = 'Success';

/* 31.Display failed payments. */
select * 
from payments
where PaymentStatus = 'Failed';

/* 32.Display refunded payments. */
select *
from payments
where PaymentStatus = 'Refund';

/* 33.Display the ten highest payment amounts. */
select TotalAmount
from orders
order by TotalAmount desc
limit 10;

/* 34.Display the ten lowest payment amounts. */
select TotalAmount
from orders
order by TotalAmount
limit 10;

/* 35.Display all five-star reviews. */
select *
from reviews
where FoodRating = 5 and DeliveryRating = 5;

/* 36.Display reviews with ratings less than three. */
select *
from reviews
where FoodRating < 3 and DeliveryRating < 3;

/* 37.Display customer names using the alias "Customer". */
select concat(FirstName, LastName) as CustomerName
from customers;

/* 38.Display menu item names using the alias "Food Item". */
select Itemname as Food_Item
from menuitems;

/* 39.Display menu prices after adding a 5% service charge. */
select ItemName, Price, Price * 1.05 as Price_with_servicecharge
from menuitems;

/* 40.Display the latest ten registered customers. */
select *
from customers
order by RegistrationDate desc
limit 10;