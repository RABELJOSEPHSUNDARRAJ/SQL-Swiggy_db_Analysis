/* PART D – Date Functions (Questions 91–120)

 91.Display the current system date. */
 select date(now());
 
/* 92.Display the current system time. */
select time(now());

/* 93.Display the current date and time. */
select now();

/* 94.Display the system timestamp. */
select TIMESTAMP(now());

/* 95.Display today's date using the CURRENT_DATE() function. */
select current_date();

/* 96.Display the current timestamp using CURRENT_TIMESTAMP(). */
select CURRENT_TIMESTAMP();

/* 97.Display the order year for every order. */
select OrderID, OrderDate, year(OrderDate) as Order_year
from orders;

/* 98.Display the order month for every order. */
select OrderID, OrderDate, month(OrderDate) as Order_Month
from orders;

/* 99.Display the month name for every order. */
select OrderID, OrderDate, monthname(OrderDate) as Month_Name
from orders;

/* 100.Display the day of the month for every order. */
select OrderID, OrderDate, Day(OrderDate) as Order_Day
from orders;

/* 101.Display the weekday name for every order. */ 
select OrderID, OrderDate, dayname(OrderDate) as Day_Name
from Orders;

/* 102.Display the weekday number for every order. */
select OrderID, OrderDate, weekday(OrderDate) as WeekDay_no
from Orders;

/* 103.Display the week number for every order. */ 
select OrderID, OrderDate, week(OrderDate) as Week_number
from Orders;

/* 104.Display the quarter for every order. */
 select OrderDate, quarter(OrderDate) as quarter_Day
from orders;

/* 105.Display the day number within the year for every order. */
select OrderID, OrderDate, dayofyear(OrderDate) as day_of_year
from Orders;
 
/* 106.Calculate the number of days between the order date and delivery date. */
select OrderID, OrderDate, EstimatedDelivery, datediff(EstimatedDelivery, OrderDate) as Duration
from orders;

/* 107.Calculate the delivery duration in minutes. */
 select OrderID, OrderDate, EstimatedDelivery, timediff(EstimatedDelivery, OrderDate) as Duration_Minutes
from orders;

/* 108.Display the expected delivery date by adding two days to the order date. */
select OrderID, OrderDate, EstimatedDelivery, date_add(Orderdate, interval 2 day) as Expected_delivery
from orders;

/* 109.Display a reminder date three days before the order date. */
select OrderID, OrderDate, EstimatedDelivery, date_sub(OrderDate, interval 3 day) as Remainder_day
from orders;

/* 110.Add seven days to each order date. */
select OrderID, OrderDate, date_add(OrderDate, interval 7 day) as ADDING_7_days
from orders;

/* 111.Subtract five days from each order date. */
select OrderID, OrderDate, date_sub(OrderDate, interval 5 day) as Reduce_5_days
from orders;

/* 112.Display all orders placed during the last thirty days. */
select * 
from orders
where OrderDate > 
			date_sub(
				(select max(OrderDate)
                from orders),interval 30 day
			);

/* 113.Display the order date in DD-MM-YYYY format. */
select date_format(OrderDate, "%D-%M-%Y") as DD_MM_YYYY
from orders;

/* 114.Display the order month and year in "Month YYYY" format. */
select date_format(OrderDate, "%M-%Y") as Month_YYYY
from orders;

/* 115.Display monthly revenue generated from completed payments. */
 select 
	monthname(o.OrderDate) as month_Name, 
    sum(p.Amount) as revenue
 from orders o
 right join payments p on p.OrderID = o.OrderID
 where PaymentStatus = 'Success'
 group by month_Name;

/* 116.Display the daily order count. */
select 
	date(OrderDate) as per_day,
	count(*) as No_of_Orders
from orders
group by per_day;

/* 117.Display the total number of orders placed each month. */
select 
	monthname(OrderDate) as Month_Name,
	count(*) as No_of_Orders
from orders
group by Month_Name;
	

/* 118.Display the total number of orders placed on each weekday. */
select 
	dayname(Orderdate) as Week_days,
	count(*) as No_of_orders
from orders
group by Week_days;

/* 119.Display the average delivery time in minutes. */
select time_to_sec(avg(time(DeliveryTime))) / 60 as Average_Time
from delivery;

/* 120.Prepare a monthly business summary showing total orders, revenue, and average order value. */
select 
	monthname(OrderDate) as Month_Name,
	count(OrderID) as Total_Orders,
    sum(TotalAmount) as Revenue,
    round(avg(TotalAmount), 2) as Average_value
from orders
group by Month_name;