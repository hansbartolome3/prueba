CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(15),
    CreatedDate DATETIME DEFAULT GETDATE()
);
CREATE TABLE MenuItems (
    MenuItemID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255),
    Price DECIMAL(10, 2) CHECK (Price > 0),
    Available BIT DEFAULT 1
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Cancelled')),
    TotalAmount DECIMAL(10, 2) CHECK (TotalAmount >= 0),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    MenuItemID INT NOT NULL,
    Quantity INT CHECK (Quantity > 0),
    Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (MenuItemID) REFERENCES MenuItems(MenuItemID)
);
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL,
    Salary DECIMAL(10, 2) CHECK (Salary >= 0),
    Phone NVARCHAR(15)
);
-- Poblar la tabla Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES 
('John', 'Doe', 'john.doe@example.com', '1234567890'),
('Jane', 'Smith', 'jane.smith@example.com', '2345678901'),
('Michael', 'Johnson', 'michael.johnson@example.com', '3456789012'),
('Emily', 'Davis', 'emily.davis@example.com', '4567890123'),
('Sarah', 'Brown', 'sarah.brown@example.com', '5678901234');

-- Poblar la tabla MenuItems
INSERT INTO MenuItems (Name, Description, Price)
VALUES 
('Cheeseburger', 'A delicious cheeseburger with all the toppings', 8.99),
('Margherita Pizza', 'Classic pizza with tomato, mozzarella, and basil', 12.50),
('Caesar Salad', 'Crisp romaine lettuce with Caesar dressing', 7.00),
('Spaghetti Carbonara', 'Pasta with creamy sauce, pancetta, and parmesan', 14.25),
('Chocolate Cake', 'Rich chocolate cake with a molten center', 6.50);

-- Poblar la tabla Orders
INSERT INTO Orders (CustomerID, Status, TotalAmount)
VALUES 
(1, 'Completed', 25.48),
(2, 'Pending', 7.00),
(3, 'Completed', 12.50),
(4, 'Cancelled', 0.00),
(5, 'Completed', 20.75);

-- Poblar la tabla OrderDetails
INSERT INTO OrderDetails (OrderID, MenuItemID, Quantity, Price)
VALUES 
(1, 1, 2, 8.99),
(1, 5, 1, 6.50),
(2, 3, 1, 7.00),
(3, 2, 1, 12.50),
(5, 4, 1, 14.25);

-- Poblar la tabla Employees
INSERT INTO Employees (FirstName, LastName, Position, HireDate, Salary, Phone)
VALUES 
('Alice', 'Taylor', 'Manager', '2022-01-15', 50000.00, '6789012345'),
('Bob', 'Miller', 'Chef', '2023-03-10', 40000.00, '7890123456'),
('Charlie', 'Wilson', 'Waiter', '2023-06-01', 25000.00, '8901234567'),
('Daisy', 'Moore', 'Waiter', '2023-07-20', 25000.00, '9012345678'),
('Ethan', 'White', 'Dishwasher', '2023-08-05', 20000.00, '0123456789');
--Consulta: Obtener los detalles de todos los pedidos completados
SELECT o.OrderID, c.FirstName, c.LastName, o.TotalAmount 
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.Status = 'Completed';
--Consulta: Calcular el total de ingresos generados por cada ítem del menú.
SELECT m.Name, SUM(od.Quantity * od.Price) AS TotalRevenue 
FROM OrderDetails od
JOIN MenuItems m ON od.MenuItemID = m.MenuItemID
GROUP BY m.Name;
