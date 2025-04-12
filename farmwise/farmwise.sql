-- Create database
-- CREATE DATABASE farmwise CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

DROP DATABASE IF EXISTS farmwise;
CREATE DATABASE farmwise
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;



USE farmwise;

-- Users table with encrypted passwords
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    language VARCHAR(5) DEFAULT 'en',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Password reset tokens
CREATE TABLE password_resets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL,
    expires_at DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Pest detections
CREATE TABLE pest_detections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    pest_name VARCHAR(100) NOT NULL,
    pest_name_original VARCHAR(100) NOT NULL, -- Original name in detected language
    confidence DECIMAL(5,2) NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    detection_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- SMS notifications
CREATE TABLE sms_notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    message TEXT NOT NULL,
    message_language VARCHAR(5) NOT NULL,
    status ENUM('queued', 'sent', 'failed') DEFAULT 'queued',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sent_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Language translations cache
CREATE TABLE translations_cache (
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_text TEXT NOT NULL,
    source_lang VARCHAR(5) NOT NULL,
    target_lang VARCHAR(5) NOT NULL,
    translated_text TEXT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY (source_text(255), source_lang, target_lang)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
-- Insert sample users with bcrypt encrypted passwords
INSERT INTO users (username, password_hash, email, phone, language) VALUES
('farmer1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'farmer1@example.com', '919876543210', 'mr'),
('farmer2', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'farmer2@example.com', '919876543211', 'kn'),
('farmer3', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'farmer3@example.com', '919876543212', 'ta');

-- Sample pest detections
INSERT INTO pest_detections (user_id, pest_name, pest_name_original, confidence, image_path) VALUES
(1, 'Aphid', 'एफिड', 0.85, 'uploads/detections/aphid1.jpg'),
(2, 'Whitefly', 'ಸ್ಫಟಿಕದ ಹುಳು', 0.92, 'uploads/detections/whitefly1.jpg'),
(3, 'Caterpillar', 'புழு', 0.78, 'uploads/detections/caterpillar1.jpg');