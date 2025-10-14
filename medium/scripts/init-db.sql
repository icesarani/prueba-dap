IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'SqlPracticeDB')
BEGIN
    CREATE DATABASE SqlPracticeDB;
END
GO

USE SqlPracticeDB;
GO

IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
IF OBJECT_ID('dbo.Employees', 'U') IS NOT NULL DROP TABLE dbo.Employees;
IF OBJECT_ID('dbo.Departments', 'U') IS NOT NULL DROP TABLE dbo.Departments;
IF OBJECT_ID('dbo.Enrollments', 'U') IS NOT NULL DROP TABLE dbo.Enrollments;
IF OBJECT_ID('dbo.Students', 'U') IS NOT NULL DROP TABLE dbo.Students;
IF OBJECT_ID('dbo.Courses', 'U') IS NOT NULL DROP TABLE dbo.Courses;
GO

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100),
    Country NVARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50),
    Price DECIMAL(10, 2),
    Stock INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    Status NVARCHAR(20)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10, 2)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL,
    Budget DECIMAL(12, 2)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(100) NOT NULL,
    DepartmentID INT FOREIGN KEY REFERENCES Departments(DepartmentID),
    Salary DECIMAL(10, 2),
    HireDate DATE,
    ManagerID INT NULL
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY,
    CourseName NVARCHAR(100) NOT NULL,
    Credits INT,
    Capacity INT
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    StudentName NVARCHAR(100) NOT NULL,
    Major NVARCHAR(50),
    EnrollmentYear INT
);

CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Grade DECIMAL(3, 2),
    Semester NVARCHAR(20)
);

INSERT INTO Customers (CustomerID, CustomerName, Email, Country) VALUES
(1, 'John Smith', 'john@email.com', 'USA'),
(2, 'Maria Garcia', 'maria@email.com', 'Spain'),
(3, 'Li Wang', 'li@email.com', 'China'),
(4, 'Emma Brown', 'emma@email.com', 'UK'),
(5, 'Carlos Rodriguez', 'carlos@email.com', 'Mexico');

INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 999.99, 50),
(2, 'Mouse', 'Electronics', 29.99, 200),
(3, 'Keyboard', 'Electronics', 79.99, 150),
(4, 'Monitor', 'Electronics', 299.99, 75),
(5, 'Desk Chair', 'Furniture', 199.99, 30);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, Status) VALUES
(1, 1, '2024-01-15', 'Completed'),
(2, 2, '2024-01-16', 'Completed'),
(3, 3, '2024-01-17', 'Pending'),
(4, 1, '2024-01-18', 'Completed'),
(5, 4, '2024-01-19', 'Cancelled');

INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 1, 999.99),
(2, 1, 2, 2, 29.99),
(3, 2, 3, 1, 79.99),
(4, 2, 4, 1, 299.99),
(5, 3, 1, 2, 999.99),
(6, 4, 2, 5, 29.99),
(7, 4, 3, 2, 79.99);

INSERT INTO Departments (DepartmentID, DepartmentName, Budget) VALUES
(1, 'Engineering', 500000),
(2, 'Sales', 300000),
(3, 'Marketing', 200000),
(4, 'HR', 150000);

INSERT INTO Employees (EmployeeID, EmployeeName, DepartmentID, Salary, HireDate, ManagerID) VALUES
(1, 'Alice Johnson', 1, 95000, '2020-01-15', NULL),
(2, 'Bob Williams', 1, 85000, '2020-03-20', 1),
(3, 'Charlie Davis', 1, 75000, '2021-06-10', 1),
(4, 'Diana Miller', 2, 70000, '2019-11-05', NULL),
(5, 'Eve Wilson', 2, 65000, '2021-02-14', 4),
(6, 'Frank Moore', 3, 60000, '2022-01-20', NULL),
(7, 'Grace Taylor', 3, 55000, '2022-05-15', 6),
(8, 'Henry Anderson', 4, 58000, '2020-08-10', NULL);

INSERT INTO Courses (CourseID, CourseName, Credits, Capacity) VALUES
(1, 'Database Systems', 4, 30),
(2, 'Data Structures', 4, 35),
(3, 'Web Development', 3, 40),
(4, 'Machine Learning', 4, 25),
(5, 'Software Engineering', 3, 30);

INSERT INTO Students (StudentID, StudentName, Major, EnrollmentYear) VALUES
(1, 'Sarah Connor', 'Computer Science', 2022),
(2, 'Kyle Reese', 'Computer Science', 2023),
(3, 'John Connor', 'Information Systems', 2022),
(4, 'Kate Brewster', 'Data Science', 2023),
(5, 'Marcus Wright', 'Computer Science', 2021);

INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade, Semester) VALUES
(1, 1, 1, 3.8, 'Fall 2023'),
(2, 1, 2, 4.0, 'Fall 2023'),
(3, 2, 1, 3.5, 'Fall 2023'),
(4, 2, 3, 3.7, 'Fall 2023'),
(5, 3, 1, 3.2, 'Fall 2023'),
(6, 3, 3, 3.9, 'Fall 2023'),
(7, 4, 2, 3.6, 'Fall 2023'),
(8, 4, 4, 4.0, 'Fall 2023'),
(9, 5, 1, 3.9, 'Fall 2023'),
(10, 5, 2, 3.8, 'Fall 2023'),
(11, 5, 4, 3.7, 'Fall 2023');

GO
