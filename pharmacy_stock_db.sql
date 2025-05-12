-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 11, 2025 at 11:23 PM
-- Server version: 8.2.0
-- PHP Version: 8.2.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pharmacy_stock_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `icon` varchar(50) NOT NULL,
  `color` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `icon`, `color`) VALUES
(1, 'Antibiotiques', 'medical_services', 'pinkAccent'),
(2, 'Antalgiques', 'healing', 'lightGreen'),
(3, 'Vitamines', 'local_florist', 'redAccent'),
(4, 'Sirop', 'liquor', 'yellow'),
(5, 'Antiseptiques', 'sanitizer', 'cyan'),
(6, 'Allergies', 'cloud', 'deepPurpleAccent'),
(7, 'Vaccins', 'vaccines', 'teal'),
(8, 'Cardiologie', 'medical_information', 'indigo'),
(9, 'Hygiène', 'health_and_safety', 'amber'),
(10, 'Dermatologie', 'science', 'brown'),
(11, 'Antiviraux', 'biotech', 'deepOrange'),
(12, 'Respiratoire', 'air', 'lime'),
(13, 'Diurétiques', 'water_drop', 'blueGrey'),
(14, 'Psychotropes', 'coronavirus', 'purple');

-- --------------------------------------------------------

--
-- Table structure for table `medicines`
--

DROP TABLE IF EXISTS `medicines`;
CREATE TABLE IF NOT EXISTS `medicines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `category_id` int NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT 'assets/images/pills.png',
  `provider_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  KEY `provider_id` (`provider_id`)
) ENGINE=MyISAM AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `medicines`
--

INSERT INTO `medicines` (`id`, `name`, `category_id`, `stock`, `price`, `image`, `provider_id`) VALUES
(1, 'Amoxicilline', 1, 120, 34.50, 'assets/images/pills.png', 1),
(2, 'Paracétamol', 2, 1, 15.00, 'assets/images/pills.png', 2),
(3, 'Vitamine C', 3, 150, 22.75, 'assets/images/pills.png', 3),
(4, 'Sirop pour la toux', 4, 80, 19.90, 'assets/images/pills.png', 1),
(5, 'Bétadine Solution', 5, 99, 27.30, 'assets/images/pills.png', 2),
(6, 'Loratadine', 6, 99, 16.00, 'assets/images/pills.png', 3),
(7, 'Ibuprofène', 2, 85, 18.50, 'assets/images/pills.png', 4),
(8, 'Vitamine D3', 3, 200, 29.90, 'assets/images/pills.png', 5),
(9, 'Doliprane', 2, 150, 12.75, 'assets/images/pills.png', 6),
(10, 'Vaccin Grippe', 7, 50, 89.00, 'assets/images/pills.png', 4),
(11, 'Atorvastatine', 8, 75, 45.25, 'assets/images/pills.png', 5),
(12, 'Crème Hydratante', 10, 120, 32.50, 'assets/images/pills.png', 6),
(13, 'Zyrtec', 6, 90, 24.80, 'assets/images/pills.png', 4),
(14, 'Oméprazole', 11, 110, 38.60, 'assets/images/pills.png', 5),
(15, 'Ventoline', 12, 60, 52.40, 'assets/images/pills.png', 6),
(16, 'Furosémide', 13, 40, 28.90, 'assets/images/pills.png', 4),
(17, 'Diazepam', 14, 30, 41.75, 'assets/images/pills.png', 5),
(18, 'Gel Hydroalcoolique', 9, 200, 15.20, 'assets/images/pills.png', 6),
(19, 'Azithromycine', 1, 95, 42.80, 'assets/images/pills.png', 1),
(20, 'Aspirine', 2, 180, 10.50, 'assets/images/pills.png', 2),
(21, 'Vitamine B12', 3, 110, 35.20, 'assets/images/pills.png', 3),
(22, 'Sirop Expectorant', 4, 70, 25.60, 'assets/images/pills.png', 1),
(23, 'Chlorhexidine', 5, 120, 18.90, 'assets/images/pills.png', 2),
(24, 'Cetirizine', 6, 85, 20.40, 'assets/images/pills.png', 3),
(25, 'Naproxène', 2, 65, 23.75, 'assets/images/pills.png', 4),
(26, 'Vitamine K', 3, 90, 40.00, 'assets/images/pills.png', 5),
(27, 'Efferalgan', 2, 140, 14.80, 'assets/images/pills.png', 6),
(28, 'Vaccin Hépatite B', 7, 45, 120.00, 'assets/images/pills.png', 4),
(29, 'Simvastatine', 8, 60, 50.30, 'assets/images/pills.png', 5),
(30, 'Crème Solaire SPF50', 10, 100, 28.90, 'assets/images/pills.png', 6),
(31, 'Claritin', 6, 75, 22.50, 'assets/images/pills.png', 4),
(32, 'Lansoprazole', 11, 95, 36.70, 'assets/images/pills.png', 5),
(33, 'Salbutamol', 12, 55, 48.20, 'assets/images/pills.png', 6),
(34, 'Hydrochlorothiazide', 13, 50, 31.40, 'assets/images/pills.png', 4),
(35, 'Alprazolam', 14, 25, 45.90, 'assets/images/pills.png', 5),
(36, 'Savon Antiseptique', 9, 150, 12.30, 'assets/images/pills.png', 6),
(37, 'Ciprofloxacine', 1, 80, 39.60, 'assets/images/pills.png', 1),
(38, 'Tramadol', 2, 40, 55.00, 'assets/images/pills.png', 2);

-- --------------------------------------------------------

--
-- Table structure for table `providers`
--

DROP TABLE IF EXISTS `providers`;
CREATE TABLE IF NOT EXISTS `providers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `city` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `providers`
--

INSERT INTO `providers` (`id`, `name`, `email`, `phone`, `city`) VALUES
(1, 'PharmaPlus', 'contact@pharmaplus.com', '0111113124', 'Rabat'),
(2, 'MediPharm', 'info@medipharm.com', '0111113948', 'Kénitra'),
(4, 'PharmaCare', 'contact@pharmacare.ma', '0522887766', 'Casablanca'),
(3, 'BioHealth', 'biohealth@info.com', '0112233445', 'Rabat'),
(5, 'SantéPlus', 'info@santeplus.ma', '0533665544', 'Marrakech'),
(6, 'MediCare', 'support@medicare.ma', '0522334455', 'Tanger');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(50) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `city` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(10) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `username`, `email`, `phone`, `city`, `password`, `role`, `created_at`) VALUES
(1, 'Claire Jackson', 'admin', 'admin@pharmacy.com', '0777777777', 'Agadir', 'admin', 'admin', '2025-05-06 18:57:41'),
(2, 'Pharmacien Assistant', 'pharmassist', 'assistant@pharmacy.com', '0666666666', 'Rabat', 'assistant123', 'user', '2025-05-12 07:00:00'),
(3, 'Responsable Stock', 'stockmanager', 'stock@pharmacy.com', '0655555555', 'Casablanca', 'stock2025', 'user', '2025-05-12 08:30:00');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
