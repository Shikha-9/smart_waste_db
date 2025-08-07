CREATE DATABASE smart_waste_db;
USE smart_waste_db;
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(15),
  address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO users (name, email, phone, address)
VALUES
('Aarav Sharma', 'aarav@example.com', '9876543210', 'New Delhi, India'),
('Meera Singh', 'meera@example.com', '9123456789', 'Bangalore, India'),
('Rahul Das', 'rahul@example.com', '9988776655', 'Kolkata, India');
SELECT * FROM users;
CREATE TABLE pickup_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  pickup_address TEXT,
  pickup_date DATE,
  waste_type VARCHAR(50),
  status VARCHAR(20) DEFAULT 'Pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO users (name, email, phone, address)
VALUES
  ('Amit Sharma', 'amit@example.com', '9876543210', 'Bhubaneswar, Odisha'),
  ('Riya Sen', 'riya@example.com', '9123456780', 'Patna, Bihar');
  INSERT INTO pickup_requests (user_id, waste_type, status, pickup_time)
VALUES
  (1, 'Plastic', 'Pending', '2025-08-08 10:00:00'),
  (2, 'Organic', 'Completed', '2025-08-06 08:30:00');
ALTER TABLE pickup_requests
ADD COLUMN pickup_time DATETIME;
INSERT INTO pickup_requests (user_id, waste_type, status, pickup_time)
VALUES
  (1, 'Plastic', 'Pending', '2025-08-08 10:00:00'),
  (2, 'Organic', 'Completed', '2025-08-06 08:30:00');
  CREATE TABLE feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  rating INT,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO feedback (user_id, rating, comment)
VALUES
  (1, 5, 'Great service!'),
  (2, 3, 'Pickup was late.');
  CREATE TABLE rewards (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  points INT,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO rewards (user_id, points, description)
VALUES
  (1, 50, 'First pickup completed'),
  (2, 30, 'Feedback submitted'),
  (1, 20, 'Second pickup completed');
  CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  message TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO notifications (user_id, message, is_read)
VALUES
  (1, 'Your pickup request is scheduled for tomorrow.', FALSE),
  (2, 'Thank you for your feedback!', TRUE),
  (1, 'Pickup completed successfully.', TRUE);
  Select * From notifications;
  CREATE TABLE complaints (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  complaint_text TEXT,
  status VARCHAR(50) DEFAULT 'Open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
INSERT INTO complaints (user_id, complaint_text, status)
VALUES
  (1, 'Garbage was not picked up on time.', 'Open'),
  (2, 'The pickup guy was rude.', 'Resolved'),
  (1, 'Plastic waste still lying outside.', 'In Progress');
  CREATE TABLE feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  rating INT CHECK (rating >= 1 AND rating <= 5),
  comments TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE waste_categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL UNIQUE
);
INSERT INTO waste_categories (category_name)
VALUES 
  ('Plastic'),
  ('Organic'),
  ('E-Waste'),
  ('Glass'),
  ('Metal'),
  ('Paper');
  DROP TABLE IF EXISTS pickup_requests;

CREATE TABLE pickup_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  waste_category_id INT,
  status VARCHAR(50),
  pickup_time DATETIME,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (waste_category_id) REFERENCES waste_categories(id)
);
INSERT INTO pickup_requests (user_id, waste_category_id, status, pickup_time)
VALUES
  (1, 1, 'Pending', '2025-08-08 10:00:00'),  -- 1 = Plastic
  (2, 2, 'Completed', '2025-08-06 08:30:00'); -- 2 = Organic

CREATE TABLE pickup_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pickup_request_id INT,
  status VARCHAR(50),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pickup_request_id) REFERENCES pickup_requests(id)
);
INSERT INTO pickup_logs (pickup_request_id, status) 
VALUES
  (1, 'Requested'),
  (1, 'Scheduled'),
  (2, 'Requested'),
  (2, 'Completed');
CREATE TABLE recycling_centers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  location TEXT,
  contact_info VARCHAR(100)
);
INSERT INTO recycling_centers (name, location, contact_info)
VALUES
  ('Green Earth Center', 'Sector 21, Bhubaneswar', 'greenearth@example.com'),
  ('Eco Recycle Hub', 'Zone 3, Patia', 'eco.recycle@example.com'),
  ('Urban Renew Facility', 'Block A, Infocity', 'urbanrenew@example.com');
CREATE TABLE center_assignments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT,
  center_id INT,
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (request_id) REFERENCES pickup_requests(id),
  FOREIGN KEY (center_id) REFERENCES recycling_centers(id)
);
INSERT INTO center_assignments (request_id, center_id)
VALUES
  (1, 1),
  (2, 2);
SELECT
  pr.id AS request_id,
  u.name AS user_name,
  u.phone,
  u.address,
  pr.waste_type,
  pr.status,
  pr.pickup_time,
  rc.name AS center_name,
  rc.location AS center_location
FROM
  pickup_requests pr
JOIN users u ON pr.user_id = u.id
LEFT JOIN center_assignments ca ON pr.id = ca.request_id
LEFT JOIN recycling_centers rc ON ca.center_id = rc.id;
DESCRIBE pickup_requests;
ALTER TABLE pickup_requests
ADD COLUMN waste_type VARCHAR(50);
SELECT
  pr.id AS request_id,
  u.name AS user_name,
  u.phone,
  u.address,
  pr.waste_type,
  pr.status,
  pr.pickup_time,
  rc.name AS center_name,
  rc.location AS center_location
FROM
  pickup_requests pr
JOIN users u ON pr.user_id = u.id
LEFT JOIN center_assignments ca ON pr.id = ca.request_id
LEFT JOIN recycling_centers rc ON ca.center_id = rc.id
LIMIT 0, 1000;
SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_requests FROM pickup_requests;
SELECT status, COUNT(*) AS count
FROM pickup_requests
GROUP BY status;

SELECT waste_type, COUNT(*) AS count
FROM pickup_requests
GROUP BY waste_type
ORDER BY count DESC;
SELECT 
  DATE(pickup_time) AS pickup_date,
  COUNT(*) AS total_requests
FROM 
  pickup_requests
GROUP BY 
  pickup_date
ORDER BY 
  pickup_date;
  
SELECT 
  DATE_FORMAT(pickup_time, '%Y-%m') AS pickup_month,
  COUNT(*) AS total_requests
FROM 
  pickup_requests
GROUP BY 
  pickup_month
ORDER BY 
  pickup_month;
  SELECT 
    rc.name AS center_name, COUNT(pr.id) AS total_requests
FROM
    center_assignments ca
        JOIN
    recycling_centers rc ON ca.center_id = rc.id
        JOIN
    pickup_requests pr ON ca.request_id = pr.id
GROUP BY rc.name
ORDER BY total_requests DESC;
  SELECT 
  status,
  COUNT(*) AS count
FROM 
  pickup_requests
GROUP BY 
  status;
  SELECT 
  waste_type,
  COUNT(*) AS count
FROM 
  pickup_requests
GROUP BY 
  waste_type
ORDER BY 
  count DESC;
  SELECT 
  ROUND(COUNT(*) / COUNT(DISTINCT user_id), 2) AS avg_requests_per_user
FROM 
  pickup_requests;
  SELECT 
  u.name, u.email
FROM 
  users u
JOIN 
  pickup_requests pr ON u.id = pr.user_id
GROUP BY 
  u.id
HAVING 
  COUNT(pr.id) = 1;
SELECT 
  DATE(pickup_time) AS request_date,
  COUNT(*) AS total_requests
FROM 
  pickup_requests
GROUP BY 
  request_date
ORDER BY 
  request_date DESC;
  SELECT 
  rc.name AS center_name,
  COUNT(pr.id) AS pending_requests
FROM 
  recycling_centers rc
JOIN 
  center_assignments ca ON rc.id = ca.center_id
JOIN 
  pickup_requests pr ON pr.id = ca.request_id
WHERE 
  pr.status = 'Pending'
GROUP BY 
  rc.name
ORDER BY 
  pending_requests DESC;
  SELECT 
  status,
  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pickup_requests) AS percentage
FROM 
  pickup_requests
GROUP BY 
  status;
  SELECT 
  pr.id,
  u.name AS user_name,
  pr.pickup_time,
  TIMESTAMPDIFF(DAY, pr.pickup_time, NOW()) AS days_waiting
FROM 
  pickup_requests pr
JOIN 
  users u ON pr.user_id = u.id
WHERE 
  pr.status = 'Pending'
  AND pickup_time < NOW() - INTERVAL 2 DAY;
  CREATE VIEW pickup_request_summary AS
SELECT
  pr.id AS request_id,
  u.name AS user_name,
  u.phone,
  u.address,
  pr.waste_type,
  pr.status,
  pr.pickup_time,
  rc.name AS center_name,
  rc.location AS center_location
FROM
  pickup_requests pr
JOIN users u ON pr.user_id = u.id
LEFT JOIN center_assignments ca ON pr.id = ca.request_id
LEFT JOIN recycling_centers rc ON ca.center_id = rc.id;
CREATE VIEW daily_request_counts AS
SELECT 
  DATE(pickup_time) AS request_date,
  COUNT(*) AS total_requests
FROM 
  pickup_requests
GROUP BY 
  request_date;
  CREATE VIEW center_pending_load AS
SELECT 
  rc.name AS center_name,
  COUNT(pr.id) AS pending_requests
FROM 
  recycling_centers rc
JOIN 
  center_assignments ca ON rc.id = ca.center_id
JOIN 
  pickup_requests pr ON pr.id = ca.request_id
WHERE 
  pr.status = 'Pending'
GROUP BY 
  rc.name;
  CREATE VIEW request_status_percentage AS
SELECT 
  status,
  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM pickup_requests) AS percentage
FROM 
  pickup_requests
GROUP BY 
  status;
  CREATE VIEW delayed_pending_requests AS
SELECT 
  pr.id,
  u.name AS user_name,
  pr.pickup_time,
  TIMESTAMPDIFF(DAY, pr.pickup_time, NOW()) AS days_waiting
FROM 
  pickup_requests pr
JOIN 
  users u ON pr.user_id = u.id
WHERE 
  pr.status = 'Pending'
  AND pickup_time < NOW() - INTERVAL 2 DAY;
  CREATE TABLE feedback (
  id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT,
  user_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (request_id) REFERENCES pickup_requests(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);






























