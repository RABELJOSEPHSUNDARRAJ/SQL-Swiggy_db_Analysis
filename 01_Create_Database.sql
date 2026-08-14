# Part 1 – Swiggy Delivery Management System

# Step 1: Create Database

-- =============================================
-- SWIGGY DELIVERY MANAGEMENT SYSTEM
-- PART 1 : DATABASE CREATION
-- MySQL 8.0
-- =============================================

DROP DATABASE IF EXISTS SwiggyDB;

CREATE DATABASE SwiggyDB;

USE SwiggyDB;

# Step 2: Customers Table

CREATE TABLE Customers
(
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    Gender ENUM('Male','Female','Other'),
    MobileNo VARCHAR(15) NOT NULL UNIQUE,
    Email VARCHAR(100) UNIQUE,
    DateOfBirth DATE,
    RegistrationDate DATE NOT NULL,
    City VARCHAR(50),
    Area VARCHAR(100)
);


# Step 3: Restaurants

CREATE TABLE Restaurants
(
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantName VARCHAR(100) NOT NULL,
    Cuisine VARCHAR(50),
    City VARCHAR(50),
    Area VARCHAR(100),
    Rating DECIMAL(2,1),
    OpeningTime TIME,
    ClosingTime TIME
);

# Step 4: Menu Categories
CREATE TABLE MenuCategories
(
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL UNIQUE
);

# Step 5: Menu Items
CREATE TABLE MenuItems
(
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    CategoryID INT,
    ItemName VARCHAR(100) NOT NULL,
    Price DECIMAL(8,2) NOT NULL,
    IsVeg BOOLEAN,
    Available BOOLEAN DEFAULT TRUE,
    FOREIGN KEY(RestaurantID)
        REFERENCES Restaurants(RestaurantID),
    FOREIGN KEY(CategoryID)
        REFERENCES MenuCategories(CategoryID)
);


# Step 6: Orders

CREATE TABLE Orders
(
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    EstimatedDelivery DATETIME,
    OrderStatus
    ENUM
    (
        'Placed',
        'Preparing',
        'Picked Up',
        'Delivered',
        'Cancelled'
    )
    DEFAULT 'Placed',
    DeliveryAddress VARCHAR(200),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY(CustomerID)
        REFERENCES Customers(CustomerID),
    FOREIGN KEY(RestaurantID)
        REFERENCES Restaurants(RestaurantID)
);

# Step 8: Delivery Partners

CREATE TABLE DeliveryPartners
(
    PartnerID INT AUTO_INCREMENT PRIMARY KEY,
    PartnerName VARCHAR(100),
	Gender ENUM('Male','Female','Other'),
    MobileNo VARCHAR(15) UNIQUE,
	city varchar(30),
    VehicleType
    ENUM
    (
        'Bike',
        'Scooter',
        'Cycle'
    ),
    JoiningDate DATE,
    Rating DECIMAL(2,1),
	PartnerStatus varchar(30)
);

# Step 9: Delivery

CREATE TABLE Delivery
(
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT UNIQUE,
    PartnerID INT,
    AssignedTime DATETIME,
    PickupTime DATETIME,
    DeliveryTime DATETIME,
    DeliveryStatus varchar(30),
    DeliveryRating int,
    FOREIGN KEY(OrderID)
        REFERENCES Orders(OrderID),
    FOREIGN KEY(PartnerID)
        REFERENCES DeliveryPartners(PartnerID)
);

# Step 10: Payments

CREATE TABLE Payments
(
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT UNIQUE,
    PaymentMethod
    ENUM
    (
        'UPI',
        'Credit Card',
        'Debit Card',
        'Cash',
        'Net Banking',
        'Cash on Delivery',
        'Wallet'
    ),
    PaymentStatus
    ENUM
    (
        'Success',
        'Failed',
        'Pending'
    ),
    PaymentDate DATETIME,
    Amount numeric(10,2),
    TransactionID varchar(10),
    FOREIGN KEY(OrderID)
        REFERENCES Orders(OrderID)
);


# Step 11: Reviews

CREATE TABLE Reviews
(
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT UNIQUE,
	CustomerID INT,
	RestaurantID INT,
	ReviewDate DATE,
    FoodRating INT CHECK(FoodRating BETWEEN 1 AND 5),
    DeliveryRating INT CHECK(DeliveryRating BETWEEN 1 AND 5),
    ReviewComment VARCHAR(300),

    FOREIGN KEY(OrderID)
        REFERENCES Orders(OrderID)
);


# Step 12: Useful Indexes

CREATE INDEX idx_customer_city
ON Customers(City);

CREATE INDEX idx_restaurant_city
ON Restaurants(City);

CREATE INDEX idx_order_date
ON Orders(OrderDate);

CREATE INDEX idx_delivery_time
ON Delivery(DeliveryTime);

