/*PART C – JOIN Queries (Questions 61–90)

61.Display customer name, order ID, order date, and total amount. */
select 
	concat(FirstName, LastName) as Customer_Name,
	o.OrderID,
	o.OrderDate,
	o.TotalAmount
from Customers c
inner join orders o on o.CustomerID = c.CustomerID;

/* 62.Display order ID, restaurant name, order date, and order amount. */
select 
	o.OrderID, 
	r.RestaurantName,
	o.OrderDate,
	o.TotalAmount
from orders o
inner join restaurants r on r.RestaurantID = o.RestaurantID;

/* 63.Display menu item name, category name, and price. */
select 
	m.ItemName, 
	c.CategoryName,
	m.Price
from menuitems m
inner join menucategories c on m.CategoryID = c.CategoryID;       

/* 64.Display order ID, payment amount, payment method, and payment status. */
select 
	o.OrderID,
	o.TotalAmount,
	p.PaymentMethod,
	p.PaymentStatus
from orders o
inner join payments p on o.OrderID = p.OrderID;

/* 65.Display order ID, delivery partner name, and delivery status. */
select 
	d.OrderID,
	l.PartnerName,
	d.DeliveryStatus 
from delivery d
inner join deliverypartners l on l.PartnerID = d.PartnerID;
        
/* 66.Display customer name, review rating, and review comment. */
select 
	concat(FirstName, LastName) as CustomerName,
	r.FoodRating,
    r.ReviewComment
from customers c
inner join reviews r on r.CustomerID = c.CustomerID;
    
/* 67.Display restaurant name, review rating, and review comment. */
select 
	RestaurantName,
    r.FoodRating,
    r.ReviewComment
from restaurants e
inner join reviews r on r.RestaurantID = e.RestaurantID;

/* 68.Display restaurant name, menu item, and menu price. */
select 
	RestaurantName,
    m.ItemName,
    m.Price
from restaurants e
inner join menuitems m on m.RestaurantID = e.RestaurantID;
	
/* 69.Display all customers along with their orders, including customers who have not placed any orders. */
select
	concat(FirstName, LastName) as Customer_Name,
    o.OrderID
from customers c
left join orders o on o.CustomerID = c.CustomerID;

/* 70.Display all restaurants along with their menu items. */
select
	r.RestaurantName,
    m.ItemName
from restaurants r
left join menuitems m on m.RestaurantID = r.RestaurantID;

/* 71.Display all orders with their payment details, including unpaid orders. */
select
	o.OrderID,
    p.PaymentStatus
from orders o
left join payments p on p.OrderID = o.OrderID;

/* 72.Display all orders with delivery information, including undelivered orders. */
select
	o.OrderID,
    d.DeliveryStatus
from orders o
left join delivery d on d.OrderID = o.OrderID;

/* 73.Display all restaurants along with their customer reviews. */
select
	r.RestaurantName,
    f.FoodRating
from restaurants r
left join reviews f on f.RestaurantID = r.RestaurantID;

/* 74.Display all menu categories along with their menu items. */
select 
	CategoryName,
    m.ItemName
from menucategories c
left join menuitems m on m.CategoryID = c.CategoryID;

/* 75.Display all payment records with their corresponding orders. */
select
	o.orderID,
    p.paymentStatus
from payments p
right join orders o on o.OrderID = p.OrderID;

/* 76.Display all reviews with restaurant details. */
select
	r.RestaurantName,
    f.ReviewComment
from restaurants r
right join reviews f on f.RestaurantID = r.RestaurantID;

/* 77.Display all delivery records with delivery partner details. */
select 
	d.OrderID,
    dp.PartnerName,
    d.DeliveryStatus
from delivery d
right join deliverypartners dp on dp.PartnerID = d.PartnerID;

/* 78.Display customer name, restaurant name, order amount, and payment status. */
select
	concat(FirstName, LastName) as CustomerName,
    r.RestaurantName,
    o.TotalAmount,
    p.PaymentStatus
from orders o
right join  customers c on c.CustomerID = o.CustomerID
right join restaurants r on r.RestaurantID = o.RestaurantID
right join payments p on p.OrderID = o.OrderID;

/* 79.Display customer name, restaurant name, delivery partner name, and delivery status. */
select
	concat(c.FirstName, c.LastName) as CustomerName,
    r.RestaurantName,
    dp.PartnerName,
    d.DeliveryStatus
from customers c
right join orders as o on c.CustomerID = o.CustomerID
right join restaurants r on o.RestaurantID = r.RestaurantID
right join delivery d on o.OrderID = d.OrderID
right join deliverypartners dp on d.PartnerID = dp.PartnerID;

/* 80.Display customer name, restaurant name, payment amount, payment method, and review rating. */
select	
	concat(c.FirstName, c.LastName) as CustomerName,
    r.RestaurantName,
    p.Amount,
	p.PaymentMethod,
    rv.FoodRating
from orders o
right join customers c on c.CustomerID = o.CustomerID
right join restaurants r on r.RestaurantID = o.RestaurantID
right join payments p on p.OrderID = o.OrderID
right join reviews rv on rv.OrderID = o.OrderID;

/* 81.Display each customer's total number of orders. */
select 
	c.CustomerID,
	concat(c.FirstName, c.LastName) as CustomerName, 
    count(o.OrderID) as No_of_orders
from orders o
right join customers c on c.CustomerID = o.CustomerID
group by c.CustomerID;

/* 82.Display each restaurant's total number of orders received. */ 
select
	r.RestaurantName,
    count(o.OrderID) as No_of_orders
from orders o
right join restaurants r on r.RestaurantID = o.RestaurantID
group by r.RestaurantName;

/* 83.Display the total revenue generated by each restaurant. */
select 
	r.restaurantName,
    sum(o.TotalAmount) as Total_Revenue
from orders o
right join restaurants r on r.RestaurantID = o.RestaurantID
group by r.restaurantName;

/* 84.Display the average customer rating for each restaurant. */
select 
	r.RestaurantName,
    round(avg(rv.FoodRating), 2) as Average_Rating
from restaurants r
right join reviews rv on rv.RestaurantID = r.RestaurantID
group by r.RestaurantName;

/* 85.Display the total number of deliveries handled by each delivery partner. */
select 
	dp.PartnerName,
    count(d.DeliveryID) as No_of_Delivery
from delivery d
right join deliverypartners dp on dp.PartnerID = d.PartnerID
group by dp.PartnerName;
 
/* 86.Display the total payment collected through each payment method. */
select 
	PaymentMethod,
    sum(Amount) as Payment_Collected
from payments
where PaymentStatus = 'Success'
group by PaymentMethod;

/* 87.Display customers along with the restaurants they reviewed. */
select 
	concat(c.FirstName, c.LastName) as CustomerName,
    r.RestaurantName,
    rv.ReviewComment
from reviews rv
right join customers c on c.CustomerID = rv.CustomerID
right join restaurants r on r.RestaurantID = rv.RestaurantID;

/* 88.Display restaurant name, city, and average menu price. */
select
	r.RestaurantName,
    r.City,
    round(avg(m.Price), 2) as Average_Menu_price
from restaurants r
right join menuitems m on m.RestaurantID = r.RestaurantID
group by r.RestaurantName, r.City;

/* 89.Display each food category with the number of menu items. */
select
	mc.CategoryName,
    count(m.ItemID) as No_of_Menuitem
from menuitems m
right join menucategories mc on mc.CategoryID = m.CategoryID
group by mc.CategoryName;

/* 90.Prepare a consolidated order report containing customer, restaurant, payment, and delivery details. */
select
	o.OrderID,
	concat(c.FirstName, c.LastName) as CustomerName,
    r.RestaurantName,
	m.ItemName,
    m.Price,
    d.DeliveryID,
    d.DeliveryStatus,
    d.DeliveryRating,
    dp.PartnerName,
    dp.Rating as Partner_Rating
from orders o
right join customers c on c.CustomerID = o.CustomerID
right join restaurants r on r.RestaurantID = o.RestaurantID
right join menuitems m on m.RestaurantID = o.RestaurantID
right join payments p on p.OrderID = o.OrderID
right join delivery d on d.OrderID = o.OrderID
right join deliverypartners dp on dp.PartnerID = d.PartnerID;