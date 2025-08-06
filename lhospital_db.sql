-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Aug 06, 2025 at 10:40 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `lhospital_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `admissions`
--

CREATE TABLE `admissions` (
  `admission_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `room_id` int(11) DEFAULT NULL,
  `admission_date` datetime NOT NULL,
  `discharge_date` datetime DEFAULT NULL,
  `admission_type` enum('emergency','scheduled','transfer') NOT NULL,
  `reason` text NOT NULL,
  `discharge_summary` text DEFAULT NULL,
  `status` enum('admitted','discharged','transferred') DEFAULT 'admitted',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `appointment_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `duration_minutes` int(11) DEFAULT 30,
  `status` enum('scheduled','confirmed','in_progress','completed','cancelled','no_show') DEFAULT 'scheduled',
  `type` enum('consultation','follow_up','emergency','surgery') DEFAULT 'consultation',
  `symptoms` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `cancellation_reason` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `table_name` varchar(100) NOT NULL,
  `record_id` int(11) NOT NULL,
  `action` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `old_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_values`)),
  `new_values` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_values`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `bill_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `consultation_id` int(11) DEFAULT NULL,
  `bill_date` date NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) DEFAULT 0.00,
  `balance_amount` decimal(10,2) GENERATED ALWAYS AS (`total_amount` - `paid_amount`) STORED,
  `status` enum('pending','partial','paid','overdue','cancelled') DEFAULT 'pending',
  `due_date` date DEFAULT NULL,
  `payment_method` enum('cash','card','bank_transfer','insurance','online') DEFAULT NULL,
  `insurance_claim_number` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bill_items`
--

CREATE TABLE `bill_items` (
  `item_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `service_name` varchar(200) NOT NULL,
  `service_type` enum('consultation','test','procedure','medication','room_charge','other') NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) GENERATED ALWAYS AS (`quantity` * `unit_price`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `consultations`
--

CREATE TABLE `consultations` (
  `consultation_id` int(11) NOT NULL,
  `appointment_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `visit_date` date NOT NULL,
  `chief_complaint` text DEFAULT NULL,
  `symptoms` text DEFAULT NULL,
  `diagnosis` text DEFAULT NULL,
  `treatment_plan` text DEFAULT NULL,
  `prescription` text DEFAULT NULL,
  `follow_up_instructions` text DEFAULT NULL,
  `next_visit_date` date DEFAULT NULL,
  `vital_signs` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`vital_signs`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `doctor_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `specialty_id` int(11) NOT NULL,
  `license_number` varchar(50) DEFAULT NULL,
  `qualifications` text DEFAULT NULL,
  `experience_years` int(11) DEFAULT 0,
  `consultation_fee` decimal(10,2) DEFAULT 0.00,
  `bio` text DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `rating` decimal(3,2) DEFAULT 0.00,
  `total_reviews` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`doctor_id`, `user_id`, `first_name`, `last_name`, `phone`, `specialty_id`, `license_number`, `qualifications`, `experience_years`, `consultation_fee`, `bio`, `profile_image`, `is_available`, `rating`, `total_reviews`, `created_at`, `updated_at`) VALUES
(1, 2, 'Dr. Mosharrof', 'Hossain', '01712345678', 3, 'BMDC-NEU-001', 'MBBS, MD (Neurology)', 15, 1500.00, 'Experienced neurologist with expertise in brain and nervous system disorders.', NULL, 1, 0.00, 0, '2025-08-06 20:39:55', '2025-08-06 20:39:55'),
(2, 3, 'Mrs. Sabrina', 'Sultana', '01712345679', 7, 'BMDC-GYN-002', 'MBBS, FCPS (Gynecology)', 12, 1200.00, 'Specialized in women\'s health and reproductive medicine.', NULL, 1, 0.00, 0, '2025-08-06 20:39:55', '2025-08-06 20:39:55'),
(3, 4, 'Dr. Md. Dildar', 'Sarwar', '01712345680', 5, 'BMDC-DEN-003', 'BDS, MDS (Oral Surgery)', 10, 800.00, 'Expert in dental care and oral surgery procedures.', NULL, 1, 0.00, 0, '2025-08-06 20:39:55', '2025-08-06 20:39:55'),
(4, 5, 'Dr. Ishtiaque', 'Sharker', '01712345681', 1, 'BMDC-CAR-004', 'MBBS, MD (Cardiology)', 18, 2000.00, 'Leading cardiologist specializing in heart disease treatment.', NULL, 1, 0.00, 0, '2025-08-06 20:39:55', '2025-08-06 20:39:55');

-- --------------------------------------------------------

--
-- Stand-in structure for view `doctor_availability_view`
-- (See below for the actual view)
--
CREATE TABLE `doctor_availability_view` (
`doctor_id` int(11)
,`first_name` varchar(100)
,`last_name` varchar(100)
,`specialty` varchar(100)
,`consultation_fee` decimal(10,2)
,`rating` decimal(3,2)
,`total_reviews` int(11)
,`day_of_week` tinyint(4)
,`start_time` time
,`end_time` time
,`is_available` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `doctor_schedules`
--

CREATE TABLE `doctor_schedules` (
  `schedule_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `day_of_week` tinyint(4) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctor_schedules`
--

INSERT INTO `doctor_schedules` (`schedule_id`, `doctor_id`, `day_of_week`, `start_time`, `end_time`, `is_available`, `created_at`) VALUES
(1, 1, 1, '09:00:00', '17:00:00', 1, '2025-08-06 20:39:55'),
(2, 1, 2, '09:00:00', '17:00:00', 1, '2025-08-06 20:39:55'),
(3, 1, 3, '09:00:00', '17:00:00', 1, '2025-08-06 20:39:55'),
(4, 1, 4, '09:00:00', '17:00:00', 1, '2025-08-06 20:39:55'),
(5, 1, 5, '09:00:00', '17:00:00', 1, '2025-08-06 20:39:55'),
(6, 2, 1, '10:00:00', '18:00:00', 1, '2025-08-06 20:39:55'),
(7, 2, 2, '10:00:00', '18:00:00', 1, '2025-08-06 20:39:55'),
(8, 2, 4, '10:00:00', '18:00:00', 1, '2025-08-06 20:39:55'),
(9, 2, 5, '10:00:00', '18:00:00', 1, '2025-08-06 20:39:55'),
(10, 2, 6, '09:00:00', '13:00:00', 1, '2025-08-06 20:39:55'),
(11, 3, 0, '08:00:00', '16:00:00', 1, '2025-08-06 20:39:55'),
(12, 3, 1, '08:00:00', '16:00:00', 1, '2025-08-06 20:39:55'),
(13, 3, 2, '08:00:00', '16:00:00', 1, '2025-08-06 20:39:55'),
(14, 3, 3, '08:00:00', '16:00:00', 1, '2025-08-06 20:39:55'),
(15, 3, 4, '08:00:00', '16:00:00', 1, '2025-08-06 20:39:55'),
(16, 4, 1, '08:00:00', '20:00:00', 1, '2025-08-06 20:39:55'),
(17, 4, 2, '08:00:00', '20:00:00', 1, '2025-08-06 20:39:55'),
(18, 4, 3, '08:00:00', '20:00:00', 1, '2025-08-06 20:39:55'),
(19, 4, 4, '08:00:00', '20:00:00', 1, '2025-08-06 20:39:55'),
(20, 4, 5, '08:00:00', '20:00:00', 1, '2025-08-06 20:39:55');

-- --------------------------------------------------------

--
-- Table structure for table `hospital_settings`
--

CREATE TABLE `hospital_settings` (
  `setting_id` int(11) NOT NULL,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text NOT NULL,
  `setting_type` enum('string','number','boolean','json') DEFAULT 'string',
  `description` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hospital_settings`
--

INSERT INTO `hospital_settings` (`setting_id`, `setting_key`, `setting_value`, `setting_type`, `description`, `updated_at`) VALUES
(1, 'hospital_name', 'L\'Hospital', 'string', 'Hospital name', '2025-08-06 20:39:54'),
(2, 'hospital_address', 'Mirpur-10, Dhaka, Bangladesh', 'string', 'Hospital address', '2025-08-06 20:39:54'),
(3, 'hospital_phone', '01901901901', 'string', 'Hospital phone number', '2025-08-06 20:39:54'),
(4, 'hospital_email', 'lhospital@gmail.com', 'string', 'Hospital email', '2025-08-06 20:39:54'),
(5, 'appointment_duration', '30', 'number', 'Default appointment duration in minutes', '2025-08-06 20:39:54'),
(6, 'advance_booking_days', '30', 'number', 'How many days in advance patients can book', '2025-08-06 20:39:54'),
(7, 'working_hours_start', '08:00', 'string', 'Hospital working hours start time', '2025-08-06 20:39:54'),
(8, 'working_hours_end', '22:00', 'string', 'Hospital working hours end time', '2025-08-06 20:39:54'),
(9, 'emergency_available', 'true', 'boolean', 'Is emergency service available 24/7', '2025-08-06 20:39:54'),
(10, 'consultation_fee_default', '1000', 'number', 'Default consultation fee in BDT', '2025-08-06 20:39:54');

-- --------------------------------------------------------

--
-- Table structure for table `lab_tests`
--

CREATE TABLE `lab_tests` (
  `test_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `consultation_id` int(11) DEFAULT NULL,
  `test_name` varchar(200) NOT NULL,
  `test_type` enum('blood','urine','imaging','biopsy','other') NOT NULL,
  `test_date` date NOT NULL,
  `results` text DEFAULT NULL,
  `normal_range` varchar(100) DEFAULT NULL,
  `status` enum('ordered','in_progress','completed','cancelled') DEFAULT 'ordered',
  `technician_notes` text DEFAULT NULL,
  `result_file_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `patient_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `gender` enum('male','female','other') NOT NULL,
  `blood_group` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') DEFAULT NULL,
  `address` text DEFAULT NULL,
  `emergency_contact_name` varchar(100) DEFAULT NULL,
  `emergency_contact_phone` varchar(20) DEFAULT NULL,
  `medical_history` text DEFAULT NULL,
  `allergies` text DEFAULT NULL,
  `current_medications` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `patient_appointments_view`
-- (See below for the actual view)
--
CREATE TABLE `patient_appointments_view` (
`appointment_id` int(11)
,`appointment_date` date
,`appointment_time` time
,`status` enum('scheduled','confirmed','in_progress','completed','cancelled','no_show')
,`type` enum('consultation','follow_up','emergency','surgery')
,`symptoms` text
,`patient_first_name` varchar(100)
,`patient_last_name` varchar(100)
,`patient_phone` varchar(20)
,`doctor_first_name` varchar(100)
,`doctor_last_name` varchar(100)
,`specialty_name` varchar(100)
,`consultation_fee` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `patient_medical_history_view`
-- (See below for the actual view)
--
CREATE TABLE `patient_medical_history_view` (
`patient_id` int(11)
,`first_name` varchar(100)
,`last_name` varchar(100)
,`consultation_id` int(11)
,`visit_date` date
,`chief_complaint` text
,`diagnosis` text
,`treatment_plan` text
,`doctor_first_name` varchar(100)
,`doctor_last_name` varchar(100)
,`specialty` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `bill_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method` enum('cash','card','bank_transfer','insurance','online') NOT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `payment_status` enum('pending','completed','failed','refunded') DEFAULT 'completed',
  `reference_number` varchar(100) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prescriptions`
--

CREATE TABLE `prescriptions` (
  `prescription_id` int(11) NOT NULL,
  `consultation_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `medication_name` varchar(200) NOT NULL,
  `dosage` varchar(100) NOT NULL,
  `frequency` varchar(100) NOT NULL,
  `duration` varchar(100) DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `patient_id` int(11) NOT NULL,
  `doctor_id` int(11) NOT NULL,
  `appointment_id` int(11) DEFAULT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 1 and 5),
  `review_text` text DEFAULT NULL,
  `is_anonymous` tinyint(1) DEFAULT 0,
  `is_approved` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `reviews`
--
DELIMITER $$
CREATE TRIGGER `update_doctor_rating_after_review_delete` AFTER DELETE ON `reviews` FOR EACH ROW BEGIN
    UPDATE doctors 
    SET rating = COALESCE((
        SELECT AVG(rating) 
        FROM reviews 
        WHERE doctor_id = OLD.doctor_id AND is_approved = TRUE
    ), 0),
    total_reviews = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE doctor_id = OLD.doctor_id AND is_approved = TRUE
    )
    WHERE doctor_id = OLD.doctor_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_doctor_rating_after_review_insert` AFTER INSERT ON `reviews` FOR EACH ROW BEGIN
    UPDATE doctors 
    SET rating = (
        SELECT AVG(rating) 
        FROM reviews 
        WHERE doctor_id = NEW.doctor_id AND is_approved = TRUE
    ),
    total_reviews = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE doctor_id = NEW.doctor_id AND is_approved = TRUE
    )
    WHERE doctor_id = NEW.doctor_id;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_doctor_rating_after_review_update` AFTER UPDATE ON `reviews` FOR EACH ROW BEGIN
    UPDATE doctors 
    SET rating = (
        SELECT AVG(rating) 
        FROM reviews 
        WHERE doctor_id = NEW.doctor_id AND is_approved = TRUE
    ),
    total_reviews = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE doctor_id = NEW.doctor_id AND is_approved = TRUE
    )
    WHERE doctor_id = NEW.doctor_id;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_number` varchar(10) NOT NULL,
  `room_type` enum('general','private','semi_private','icu','emergency','surgery') NOT NULL,
  `floor` int(11) NOT NULL,
  `capacity` int(11) DEFAULT 1,
  `daily_rate` decimal(10,2) DEFAULT 0.00,
  `amenities` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`amenities`)),
  `is_available` tinyint(1) DEFAULT 1,
  `last_cleaned` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_number`, `room_type`, `floor`, `capacity`, `daily_rate`, `amenities`, `is_available`, `last_cleaned`, `created_at`) VALUES
(1, '101', 'general', 1, 4, 500.00, NULL, 1, NULL, '2025-08-06 20:39:55'),
(2, '102', 'general', 1, 4, 500.00, NULL, 1, NULL, '2025-08-06 20:39:55'),
(3, '201', 'private', 2, 1, 1500.00, NULL, 1, NULL, '2025-08-06 20:39:55'),
(4, '202', 'private', 2, 1, 1500.00, NULL, 1, NULL, '2025-08-06 20:39:55'),
(5, '301', 'icu', 3, 1, 3000.00, NULL, 1, NULL, '2025-08-06 20:39:55'),
(6, '302', 'icu', 3, 1, 3000.00, NULL, 1, NULL, '2025-08-06 20:39:55'),
(7, '401', 'surgery', 4, 1, 2000.00, NULL, 1, NULL, '2025-08-06 20:39:55');

-- --------------------------------------------------------

--
-- Table structure for table `specialties`
--

CREATE TABLE `specialties` (
  `specialty_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon_class` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `specialties`
--

INSERT INTO `specialties` (`specialty_id`, `name`, `description`, `icon_class`, `is_active`, `created_at`) VALUES
(1, 'Cardiology', 'Treating heart diseases and promoting cardiovascular health.', 'fa-heartbeat', 1, '2025-08-06 20:39:50'),
(2, 'Tumor and Cancer', 'Abnormal tissue growth that may be benign or malignant.', 'fa-x-ray', 1, '2025-08-06 20:39:50'),
(3, 'Neurology', 'Diagnosing and managing disorders of the brain, nerves, and spinal cord.', 'fa-brain', 1, '2025-08-06 20:39:50'),
(4, 'Orthopedics', 'Care for bones, joints, muscles, and related injuries.', 'fa-wheelchair', 1, '2025-08-06 20:39:50'),
(5, 'Dental', 'Comprehensive care for teeth, gums, and oral health.', 'fa-tooth', 1, '2025-08-06 20:39:50'),
(6, 'Laboratory', 'Advancing medical science through research and clinical studies.', 'fa-vials', 1, '2025-08-06 20:39:50'),
(7, 'Gynecology', 'Women\'s reproductive health and pregnancy care.', 'fa-female', 1, '2025-08-06 20:39:50'),
(8, 'Pediatrics', 'Medical care for infants, children, and adolescents.', 'fa-baby', 1, '2025-08-06 20:39:50'),
(9, 'Emergency Medicine', '24/7 emergency and critical care services.', 'fa-ambulance', 1, '2025-08-06 20:39:50'),
(10, 'Radiology', 'Medical imaging and diagnostic services.', 'fa-x-ray', 1, '2025-08-06 20:39:50');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `user_type` enum('patient','doctor','admin','staff') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `email_verified` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `email`, `password_hash`, `user_type`, `is_active`, `email_verified`, `created_at`, `updated_at`, `last_login`) VALUES
(1, 'admin@lhospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1, 1, '2025-08-06 20:39:54', '2025-08-06 20:39:54', NULL),
(2, 'mosharrof@lhospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'doctor', 1, 1, '2025-08-06 20:39:55', '2025-08-06 20:39:55', NULL),
(3, 'sabrina@lhospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'doctor', 1, 1, '2025-08-06 20:39:55', '2025-08-06 20:39:55', NULL),
(4, 'dildar@lhospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'doctor', 1, 1, '2025-08-06 20:39:55', '2025-08-06 20:39:55', NULL),
(5, 'ishtiaque@lhospital.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'doctor', 1, 1, '2025-08-06 20:39:55', '2025-08-06 20:39:55', NULL);

-- --------------------------------------------------------

--
-- Structure for view `doctor_availability_view`
--
DROP TABLE IF EXISTS `doctor_availability_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `doctor_availability_view`  AS SELECT `d`.`doctor_id` AS `doctor_id`, `d`.`first_name` AS `first_name`, `d`.`last_name` AS `last_name`, `s`.`name` AS `specialty`, `d`.`consultation_fee` AS `consultation_fee`, `d`.`rating` AS `rating`, `d`.`total_reviews` AS `total_reviews`, `ds`.`day_of_week` AS `day_of_week`, `ds`.`start_time` AS `start_time`, `ds`.`end_time` AS `end_time`, `ds`.`is_available` AS `is_available` FROM ((`doctors` `d` join `specialties` `s` on(`d`.`specialty_id` = `s`.`specialty_id`)) left join `doctor_schedules` `ds` on(`d`.`doctor_id` = `ds`.`doctor_id`)) WHERE `d`.`is_available` = 1 ;

-- --------------------------------------------------------

--
-- Structure for view `patient_appointments_view`
--
DROP TABLE IF EXISTS `patient_appointments_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `patient_appointments_view`  AS SELECT `a`.`appointment_id` AS `appointment_id`, `a`.`appointment_date` AS `appointment_date`, `a`.`appointment_time` AS `appointment_time`, `a`.`status` AS `status`, `a`.`type` AS `type`, `a`.`symptoms` AS `symptoms`, `p`.`first_name` AS `patient_first_name`, `p`.`last_name` AS `patient_last_name`, `p`.`phone` AS `patient_phone`, `d`.`first_name` AS `doctor_first_name`, `d`.`last_name` AS `doctor_last_name`, `s`.`name` AS `specialty_name`, `d`.`consultation_fee` AS `consultation_fee` FROM (((`appointments` `a` join `patients` `p` on(`a`.`patient_id` = `p`.`patient_id`)) join `doctors` `d` on(`a`.`doctor_id` = `d`.`doctor_id`)) join `specialties` `s` on(`d`.`specialty_id` = `s`.`specialty_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `patient_medical_history_view`
--
DROP TABLE IF EXISTS `patient_medical_history_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `patient_medical_history_view`  AS SELECT `p`.`patient_id` AS `patient_id`, `p`.`first_name` AS `first_name`, `p`.`last_name` AS `last_name`, `c`.`consultation_id` AS `consultation_id`, `c`.`visit_date` AS `visit_date`, `c`.`chief_complaint` AS `chief_complaint`, `c`.`diagnosis` AS `diagnosis`, `c`.`treatment_plan` AS `treatment_plan`, `d`.`first_name` AS `doctor_first_name`, `d`.`last_name` AS `doctor_last_name`, `s`.`name` AS `specialty` FROM (((`patients` `p` join `consultations` `c` on(`p`.`patient_id` = `c`.`patient_id`)) join `doctors` `d` on(`c`.`doctor_id` = `d`.`doctor_id`)) join `specialties` `s` on(`d`.`specialty_id` = `s`.`specialty_id`)) ORDER BY `c`.`visit_date` DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admissions`
--
ALTER TABLE `admissions`
  ADD PRIMARY KEY (`admission_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `room_id` (`room_id`),
  ADD KEY `idx_patient_admissions` (`patient_id`),
  ADD KEY `idx_admission_date` (`admission_date`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`appointment_id`),
  ADD KEY `idx_appointment_date` (`appointment_date`,`appointment_time`),
  ADD KEY `idx_patient_appointments` (`patient_id`),
  ADD KEY `idx_doctor_appointments` (`doctor_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_audit_table` (`table_name`),
  ADD KEY `idx_audit_date` (`created_at`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD KEY `appointment_id` (`appointment_id`),
  ADD KEY `consultation_id` (`consultation_id`),
  ADD KEY `idx_patient_bills` (`patient_id`),
  ADD KEY `idx_bill_status` (`status`),
  ADD KEY `idx_due_date` (`due_date`);

--
-- Indexes for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `idx_bill_items` (`bill_id`);

--
-- Indexes for table `consultations`
--
ALTER TABLE `consultations`
  ADD PRIMARY KEY (`consultation_id`),
  ADD KEY `appointment_id` (`appointment_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `idx_patient_consultations` (`patient_id`),
  ADD KEY `idx_visit_date` (`visit_date`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`doctor_id`),
  ADD UNIQUE KEY `license_number` (`license_number`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_doctor_name` (`first_name`,`last_name`),
  ADD KEY `idx_specialty` (`specialty_id`),
  ADD KEY `idx_availability` (`is_available`);

--
-- Indexes for table `doctor_schedules`
--
ALTER TABLE `doctor_schedules`
  ADD PRIMARY KEY (`schedule_id`),
  ADD UNIQUE KEY `unique_doctor_day` (`doctor_id`,`day_of_week`),
  ADD KEY `idx_doctor_schedule` (`doctor_id`,`day_of_week`);

--
-- Indexes for table `hospital_settings`
--
ALTER TABLE `hospital_settings`
  ADD PRIMARY KEY (`setting_id`),
  ADD UNIQUE KEY `setting_key` (`setting_key`);

--
-- Indexes for table `lab_tests`
--
ALTER TABLE `lab_tests`
  ADD PRIMARY KEY (`test_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `consultation_id` (`consultation_id`),
  ADD KEY `idx_patient_tests` (`patient_id`),
  ADD KEY `idx_test_date` (`test_date`),
  ADD KEY `idx_test_status` (`status`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`patient_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_patient_name` (`first_name`,`last_name`),
  ADD KEY `idx_phone` (`phone`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `bill_id` (`bill_id`),
  ADD KEY `idx_patient_payments` (`patient_id`),
  ADD KEY `idx_payment_date` (`payment_date`);

--
-- Indexes for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD PRIMARY KEY (`prescription_id`),
  ADD KEY `consultation_id` (`consultation_id`),
  ADD KEY `doctor_id` (`doctor_id`),
  ADD KEY `idx_patient_prescriptions` (`patient_id`),
  ADD KEY `idx_active_prescriptions` (`is_active`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD UNIQUE KEY `unique_patient_appointment_review` (`patient_id`,`appointment_id`),
  ADD KEY `appointment_id` (`appointment_id`),
  ADD KEY `idx_doctor_reviews` (`doctor_id`),
  ADD KEY `idx_rating` (`rating`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`),
  ADD UNIQUE KEY `room_number` (`room_number`);

--
-- Indexes for table `specialties`
--
ALTER TABLE `specialties`
  ADD PRIMARY KEY (`specialty_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_user_type` (`user_type`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admissions`
--
ALTER TABLE `admissions`
  MODIFY `admission_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `appointment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bill_items`
--
ALTER TABLE `bill_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `consultations`
--
ALTER TABLE `consultations`
  MODIFY `consultation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `doctor_schedules`
--
ALTER TABLE `doctor_schedules`
  MODIFY `schedule_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `hospital_settings`
--
ALTER TABLE `hospital_settings`
  MODIFY `setting_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `lab_tests`
--
ALTER TABLE `lab_tests`
  MODIFY `test_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `patient_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `prescriptions`
--
ALTER TABLE `prescriptions`
  MODIFY `prescription_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `specialties`
--
ALTER TABLE `specialties`
  MODIFY `specialty_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admissions`
--
ALTER TABLE `admissions`
  ADD CONSTRAINT `admissions_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `admissions_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `admissions_ibfk_3` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`);

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bills_ibfk_2` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`),
  ADD CONSTRAINT `bills_ibfk_3` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`consultation_id`);

--
-- Constraints for table `bill_items`
--
ALTER TABLE `bill_items`
  ADD CONSTRAINT `bill_items_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`) ON DELETE CASCADE;

--
-- Constraints for table `consultations`
--
ALTER TABLE `consultations`
  ADD CONSTRAINT `consultations_ibfk_1` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`),
  ADD CONSTRAINT `consultations_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `consultations_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Constraints for table `doctors`
--
ALTER TABLE `doctors`
  ADD CONSTRAINT `doctors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `doctors_ibfk_2` FOREIGN KEY (`specialty_id`) REFERENCES `specialties` (`specialty_id`);

--
-- Constraints for table `doctor_schedules`
--
ALTER TABLE `doctor_schedules`
  ADD CONSTRAINT `doctor_schedules_ibfk_1` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE;

--
-- Constraints for table `lab_tests`
--
ALTER TABLE `lab_tests`
  ADD CONSTRAINT `lab_tests_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lab_tests_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`),
  ADD CONSTRAINT `lab_tests_ibfk_3` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`consultation_id`);

--
-- Constraints for table `patients`
--
ALTER TABLE `patients`
  ADD CONSTRAINT `patients_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`bill_id`) REFERENCES `bills` (`bill_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE;

--
-- Constraints for table `prescriptions`
--
ALTER TABLE `prescriptions`
  ADD CONSTRAINT `prescriptions_ibfk_1` FOREIGN KEY (`consultation_id`) REFERENCES `consultations` (`consultation_id`),
  ADD CONSTRAINT `prescriptions_ibfk_2` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prescriptions_ibfk_3` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_3` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`appointment_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
