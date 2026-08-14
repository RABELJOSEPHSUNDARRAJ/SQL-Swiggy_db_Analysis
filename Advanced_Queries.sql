/* PART E – Advanced SQL (Questions 121–150)

121.Display all customers with a row number based on their total spending. */
select
	concat(c.FirstName, c.LastName) as Customer_Name,
    sum(p.Amount) as Spend_Amount,
	row_number() over(
		order by sum(p.Amount) desc
    ) as 'Row_number'
from orders o
inner join customers c on o.CustomerID = c.CustomerID
inner join payments p on p.OrderID = o.OrderID
group by c.CustomerID;

/* 122.Rank restaurants according to total revenue. */
select 
    r.RestaurantName,
    sum(o.TotalAmount) as Total_Revenue,
    rank() over(
		order by sum(o.TotalAmount) desc
    ) as Count_Rank
from orders o
inner join restaurants r on r.RestaurantID = o.RestaurantID
group by r.RestaurantID;
    
/* 123.Assign a dense rank to customers based on lifetime spending. */
select
	concat(c.FirstName, c.LastName) as Customer_Name,
    sum(p.Amount) as Spend_Amount,
	dense_rank() over(
		order by sum(p.Amount) desc
    ) as 'Rank_Dense'
from orders o
inner join customers c on o.CustomerID = c.CustomerID
inner join payments p on p.OrderID = o.OrderID
group by c.CustomerID;
 
/* 124.Divide customers into four spending groups using NTILE(). */
select
    concat(c.FirstName, c.LastName) as Customer_Name,
    sum(p.Amount) as Spend_Amount,
	NTILE(4) over(
		order by sum(p.Amount) desc
        ) as 'Tile_Group'
from orders o
inner join customers c on c.CustomerID = o.CustomerID
inner join payments p on p.OrderID = o.OrderID
group by c.CustomerID;

/* 125.Display each payment along with the previous payment amount. */
select
	paymentDate,
    Amount,
    lag(Amount) over(
		order by paymentID
    ) as Previous_Payment
from payments;
    
/* 126.Display each payment along with the next payment amount. */
select
	paymentDate,
    
    Amount,
    lead(Amount) over(
		order by paymentDate
    ) as Next_Payment
from payments;

/* 127.Calculate the running total of completed payments. */
select
	paymentDate,
    Amount,
    sum(Amount) over(
		order by paymentDate
    ) as Total_Payment
from payments
where PaymentStatus = 'Success';

/* 128.Calculate the moving average of payment amounts. */
select
	paymentDate,
    Amount,
    avg(Amount) over(
		order by paymentDate
    ) as Average_Payment
from payments
where PaymentStatus = 'Success';

/* 129.Using a Common Table Expression (CTE), display restaurants with revenue greater than ₹20,000. */
with CTE_Restaurant as(
	select
		r.RestaurantID,
        r.RestaurantName,
        sum(o.TotalAmount) as Total_Revenue
        from orders o
		inner join restaurants r on r.RestaurantID = o.RestaurantID
        group by r.RestaurantID
	)
select *
from CTE_Restaurant
where Total_Revenue > 19000;

/* 130.Using a Common Table Expression (CTE), display customer-wise total spending. */
with CTE_Customers as (
		select
			c.CustomerID,
            concat(c.FirstName, c.LastName) as Customer_Name,
            sum(p.Amount) as Total_spending
            from orders o
            inner join customers c on c.CustomerID = o.CustomerID
            inner join payments p on p.OrderID = o.OrderID
            group by c.CustomerID
    )
    select *
    from CTE_Customers;


/* 131.Display customers whose total spending is greater than the average customer spending. */
select 
	c.CustomerID,
	concat(c.FirstName, c.LastName) as Customer_Name,
	sum(p.Amount) as Total_spending
	from orders o
	inner join customers c on c.CustomerID = o.CustomerID
	inner join payments p on p.OrderID = o.OrderID
    group by c.CustomerID
	having Total_spending >
(
	select avg(Amount)
    from payments
);

/* 132.Display orders whose value is greater than the average order value of the same restaurant. */
with CTE_Order_Value as (
	select
	r.RestaurantID,
    r.RestaurantName,
    o.TotalAmount,
    avg(o.TotalAmount) over(
		partition by r.RestaurantID 
    ) as Average_Amount
	from orders o
	inner join restaurants r on  r.RestaurantID = o.RestaurantID
 )
select *
from CTE_order_Value
where TotalAmount > Average_Amount;

/* 133.Categorize orders as Low, Medium, or High value using the CASE statement. */
select 
	CustomerID,
    OrderID,
	TotalAmount,
    case
		when TotalAmount < 300 then 'LOW'
        when TotalAmount < 600 then 'MEDIUM'
        else 'HIGH'
	end as Categorize_Orders
from orders;

/* 134.Display the total number of completed, pending, failed, and refunded payments using conditional aggregation. */
/* method 1 */
select PaymentStatus, count(PaymentStatus) as Total_Numbers
from payments
group by PaymentStatus;

/* method 2 */
select 
	distinct PaymentStatus,
    count(PaymentStatus) over(
     partition by PaymentStatus
    ) as Total_Numbers
from payments;

/* method 3 */
select 
    sum(case when PaymentStatus = 'Success' then 1 end) AS Completed_payment,
    sum(case when PaymentStatus = 'Pending' then 1 end) AS Pending_payment,
	sum(case when PaymentStatus = 'Failed' then 1 end) AS Failed_payment
from Payments;

/* 135.Display customers who have placed at least one order. */
/* method 1 */
select
	c.CustomerID,
	concat(c.FirstName, c.LastName) as Customer_Name,
    count(o.OrderID) as No_of_orders
from orders o
inner join customers c on c.CustomerID = o.CustomerID
group by c.CustomerID
having No_of_orders >= 1;

/* method 2 */
with CTE_Placed_orders as(
	select
		distinct c.CustomerID,
		concat(c.FirstName, c.LastName) as Customer_Name,
        count(o.OrderID) over(
			partition by c.CustomerID 
        ) as No_of_Orders
	from Orders o
	inner join customers c on c.CustomerID = o.CustomerID
)
select *
from CTE_Placed_orders
where No_of_Orders >= 1;

/* 136.Display customers who have never placed any order. */
/* Method 1 */
select
	concat(c.FirstName, c.LastName) as Customer_Name,
    count(o.OrderID) as No_of_orders
from orders o
inner join customers c on c.CustomerID = o.CustomerID
group by c.CustomerID
having No_of_orders is null;

/* Method 2 */
with CTE_Order_Placed as (
	select 
		distinct c.CustomerID,
        concat(c.FirstName, c.LastName) as Customer_Name,
        count(o.OrderID) over(
			partition by c.CustomerID
        ) as No_of_orders
	from Orders o
	inner join customers c on c.CustomerID = o.CustomerID 
)
select *
from CTE_Order_Placed
where No_of_orders is null;

    
/* 137.Display the top five restaurants based on revenue. */
select 
	r.RestaurantName,
    sum(o.TotalAmount) as Total_Amount,
    rank() over(
		order by sum(o.TotalAmount) desc
    ) as Count_Rank
from orders o
inner join restaurants r on r.RestaurantID = o.RestaurantID
group by r.RestaurantID
limit 5;

/* 138.Display the top ten customers based on lifetime spending. */
select 
	concat(c.FirstName, c.LastName) as Customer_Name,
    sum(P.Amount) as LifeTime_Spending,
    rank() over(
		order by sum(P.Amount) desc
    ) as Count_Rank
from orders o
inner join payments p on p.OrderID = o.OrderID
inner join customers c on c.CustomerID = o.CustomerID
group by c.CustomerID
limit 10;

/* 139.Display restaurants having an average customer rating greater than 4.5. */
select 
	RestaurantID,
	RestaurantName,
    avg(Rating) over(
		partition by RestaurantID
    )as Average_Rating
from restaurants
where Rating > 4.5;


/* 140.Calculate the Customer Lifetime Value (CLV) for every customer. */
select 
	concat(c.FirstName, c.LastName) as Customer_Name,
    count(o.orderID) as No_of_Orders,
    sum(p.Amount) as CLV
from orders o
inner join customers c on c.CustomerID = o.CustomerID
inner join payments p on p.OrderID = o.OrderID
where PaymentStatus = 'Success'
group by c.CustomerID
order by CLV desc;


/* 141.Display monthly revenue generated through completed payments. */
/* Method 1 */
select 
	monthname(OrderDate) as Month_Name,
    sum(p.Amount) as Total_Revenue
from orders o
inner join payments p on p.OrderID = o.OrderID
where p.PaymentStatus = 'Success'
group by Month_Name;

/* Method 2 */
select 
	distinct monthname(OrderDate) as Month_Name,
    sum(p.Amount) over(
      partition by monthname(OrderDate)
    ) as Total_Revenue
from orders o
inner join payments p on p.OrderID = o.OrderID
where p.PaymentStatus = 'Success';


/* 142.Display the total number of orders placed during each hour of the day. */
select 
	extract(hour from OrderDate) as Each_Hour,
    count(orderID) as No_of_Orders
from orders
group by Each_Hour;
    

/* 143.Display the average delivery time for each delivery partner. */
select
    dp.PartnerName,
    round(avg(timestampdiff(minute,d.PickupTime, d.DeliveryTime))) as Average_Delivery_Time
from deliverypartners dp
inner join delivery d on d.PartnerID = dp.PartnerID
group by dp.PartnerID;


/* 144.Identify the delivery partner with the lowest average delivery time. */
select
    dp.PartnerName,
    round(avg(timestampdiff(minute,d.PickupTime, d.DeliveryTime))) as Average_Delivery_Time
from deliverypartners dp
inner join delivery d on d.PartnerID = dp.PartnerID
group by dp.PartnerID
order by Average_Delivery_Time
limit 1;

/* 145.Rank payment methods based on completed transactions. */
select 
	PaymentMethod,
    sum(Amount) as Total_Amount,
    rank() over(
			order by sum(Amount) desc
	) as Count_Rank
from payments
where PaymentStatus = 'Success'
group by PaymentMethod;
    

/* 146.Display each restaurant's revenue along with its percentage contribution to total revenue. */
select 
	r.RestaurantName,
    sum(o.TotalAmount) as total_Revenue,
    round(sum(o.TotalAmount) * 100 / sum(sum(o.TotalAmount)) over(), 2) as Percentage
from orders o
inner join restaurants r on r.RestaurantID = o.RestaurantID
group by r.RestaurantID
order by total_Revenue desc;


/* 147.Display customers who have placed more than five orders. */
/* method 1 */
select 
	concat(c.FirstName, c.LastName) as Customer_Name,
	count(o.OrderID) as No_of_orders
from orders o 
inner join customers c on o.CustomerID = c.CustomerID 
group by c.CustomerID 
having No_of_orders > 5;
	

/* method 2 */
with CTE_Order_Placed as(
	select 
		distinct concat(c.FirstName, c.LastName) as Customer_Name,
		count(o.OrderID) over(
			partition by c.CustomerID
		) as No_of_orders
	from orders o 
	inner join customers c on o.CustomerID = c.CustomerID
)
select *
from CTE_Order_Placed
where No_of_orders > 5;

/* 148.Display customers who have ordered from more than one restaurant. */
select 
	concat(c.FirstName, c.LastName) as Customer_Name,
	count(distinct r.RestaurantID) as No_of_Restaurant
from orders o 
inner join customers c on o.CustomerID = c.CustomerID 
inner join restaurants r on r.RestaurantID = o.RestaurantID
group by c.CustomerID
having No_of_Restaurant > 1;

/* 149.Prepare a KPI dashboard showing total customers, restaurants, orders, completed payments, and reviews. */
select 
	count(CustomerID) as No_of_Customers,
	count(distinct RestaurantID) as No_of_Restaurant,
    
    (select count(OrderID) 
    from orders)  as No_of_Orders,
    
    (select count(*) from payments 
    where PaymentStatus = 'Success')  as Completed_Payments,
    
    count(ReviewID) as No_of_Reviews
from reviews;


/* 150.Prepare an executive business report showing restaurant name, total orders, total revenue, average customer rating, and average delivery time.*/
select
	r.RestaurantName,
    count(o.OrderID) as No_of_Orders,
    sum(o.TotalAmount) as Total_Revenue,
    avg(rv.FoodRating) as Average_Customer_Rating,
    round(avg(timestampdiff(minute,d.PickupTime, d.DeliveryTime)), 2) as Average_Delivery_Time
from orders o
inner join restaurants r on r.RestaurantID = o.RestaurantID
inner join reviews rv on rv.OrderID = o.OrderID
inner join delivery d on d.OrderID = o.OrderID
group by r.RestaurantID;