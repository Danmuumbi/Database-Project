CREATE DATABASE PROJECT;
--  DROP database PROJECT;


USE PROJECT;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role ENUM('Tenant', 'Manager', 'Landlord'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE apartments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    owner_id INT,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE units (
    id INT AUTO_INCREMENT PRIMARY KEY,
    apartment_id INT NOT NULL,
    unit_number VARCHAR(50) NOT NULL,
    rent DECIMAL(10,2) NOT NULL,
    status ENUM('Vacant', 'Occupied'),
    FOREIGN KEY (apartment_id) REFERENCES apartments(id) ON DELETE CASCADE,
    UNIQUE KEY unique_unit_per_apartment (apartment_id, unit_number)
);

CREATE TABLE leases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    unit_id INT NOT NULL,
    tenant_id INT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    lease_document TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    lease_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Bank Transfer', 'Mobile Money'),
    FOREIGN KEY (tenant_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (lease_id) REFERENCES leases(id) ON DELETE CASCADE
);

CREATE TABLE debts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT NOT NULL,
    lease_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('Pending', 'Paid'),
    FOREIGN KEY (tenant_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (lease_id) REFERENCES leases(id) ON DELETE CASCADE
);

CREATE TABLE maintenance_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    apartment_id INT NOT NULL,
    description TEXT NOT NULL,
    status ENUM('Open', 'In Progress', 'Completed'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (apartment_id) REFERENCES apartments(id) ON DELETE CASCADE
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    apartment_id INT NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    FOREIGN KEY (apartment_id) REFERENCES apartments(id) ON DELETE CASCADE
);

CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    status ENUM('Sent', 'Pending'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


-- Users
INSERT INTO users (username, email, password_hash, role) VALUES
('tenant1', 'tenant1@example.com', 'hashed_pw1', 'Tenant'),
('manager1', 'manager1@example.com', 'hashed_pw2', 'Manager'),
('landlord1', 'landlord1@example.com', 'hashed_pw3', 'Landlord');

-- Apartments
INSERT INTO apartments (name, address, owner_id) VALUES
('Sunset Apartments', '123 Main St', 3),
('Greenview Residences', '456 Oak Ave', 3);

-- Units
INSERT INTO units (apartment_id, unit_number, rent, status) VALUES
(1, 'A1', 1200.00, 'Vacant'),
(1, 'A2', 1300.00, 'Occupied'),
(2, 'B1', 1100.00, 'Occupied');

-- Leases
INSERT INTO leases (unit_id, tenant_id, start_date, end_date, lease_document) VALUES
(2, 1, '2024-01-01', '2024-12-31', 'LeaseDocA2.pdf'),
(3, 1, '2024-02-01', '2025-01-31', 'LeaseDocB1.pdf');

-- Payments
INSERT INTO payments (tenant_id, lease_id, amount, payment_method) VALUES
(1, 1, 1200.00, 'Bank Transfer'),
(1, 2, 1100.00, 'Credit Card');

-- Debts
INSERT INTO debts (tenant_id, lease_id, amount, due_date, status) VALUES
(1, 1, 100.00, '2024-03-01', 'Pending'),
(1, 2, 50.00, '2024-04-01', 'Paid');

-- Maintenance Requests
INSERT INTO maintenance_requests (tenant_id, apartment_id, description, status) VALUES
(1, 1, 'Leaking faucet in A2', 'Open'),
(1, 2, 'Broken window in B1', 'In Progress');

-- Expenses
INSERT INTO expenses (apartment_id, description, amount, expense_date) VALUES
(1, 'Roof repair', 500.00, '2024-02-15'),
(2, 'Garden maintenance', 200.00, '2024-03-10');

-- Notifications
INSERT INTO notifications (user_id, message, status) VALUES
(1, 'Your rent is due soon.', 'Sent'),
(3, 'A new maintenance request has been submitted.', 'Pending');






-- listing of tenants and their apartments 
SELECT u.username, a.name AS apartment, un.unit_number
FROM users u
JOIN leases l ON u.id = l.tenant_id
JOIN units un ON l.unit_id = un.id
JOIN apartments a ON un.apartment_id = a.id
WHERE u.role = 'Tenant';


-- Show all maintenance requests for a specific apartment
SELECT mr.id, mr.description, mr.status, mr.created_at
FROM maintenance_requests mr
WHERE mr.apartment_id = 1;



-- Total payments made by a tenant
SELECT u.username, SUM(p.amount) AS total_paid
FROM users u
JOIN payments p ON u.id = p.tenant_id
WHERE u.id = 1
GROUP BY u.username;


-- Outstanding debts for all tenants
SELECT u.username, d.amount, d.due_date
FROM debts d
JOIN users u ON d.tenant_id = u.id
WHERE d.status = 'Pending';



-- Vacant units in all apartments
SELECT a.name AS apartment, u.unit_number
FROM units u
JOIN apartments a ON u.apartment_id = a.id
WHERE u.status = 'Vacant';
