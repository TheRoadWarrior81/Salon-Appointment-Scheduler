-- Drop tables if they exist (for resets)
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS services;

-- Create services table
CREATE TABLE services (
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL
);

-- Create customers table
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(15) UNIQUE NOT NULL,
  name VARCHAR(100) NOT NULL
);

-- Create appointments table
CREATE TABLE appointments (
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id),
  time VARCHAR(50) NOT NULL
);

-- Insert initial services
INSERT INTO services(name) VALUES
('Haircut'),
('Hair Coloring'),
('Scalp Treatment');
