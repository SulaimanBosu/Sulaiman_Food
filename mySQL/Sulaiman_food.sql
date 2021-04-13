-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 13, 2021 at 11:47 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 8.0.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Sulaiman_food`
--

-- --------------------------------------------------------

--
-- Table structure for table `userTABLE`
--

CREATE TABLE `userTABLE` (
  `id` int(11) NOT NULL,
  `ChooseType` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `Name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `User` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `Password` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `userTABLE`
--

INSERT INTO `userTABLE` (`id`, `ChooseType`, `Name`, `User`, `Password`) VALUES
(3, 'Shop', 'test1', 'test', '1234'),
(4, 'chooseType', 'name', 'user322', 'password'),
(5, 'Rider', '1111', '2222', '3333'),
(6, 'Shop', '22222', '2222', '3333'),
(7, 'User', '6666', '5555', '4444'),
(8, 'User', 'test', 'test', '12345'),
(9, 'Rider', '4444', '4444', '44444'),
(10, 'Shop', 'สุไลมาน บอซู', 'Sulaiman', '12345'),
(11, 'Shop', 'name2', 'user2', '12345'),
(12, 'User', 'tttt', 'test6', '12345'),
(13, 'User', '1111111', '222222', '222222'),
(14, 'User', 'name2', 'user2', '12345'),
(15, 'User', '11', '121', '111'),
(16, 'Rider', 'สมชาย พักดี', 'rider', '12345'),
(17, 'Shop', 'สมปอง ใจกล้า', 'shop', '12345'),
(18, 'User', 'คำปอง ทองดี', 'user', '12345');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `userTABLE`
--
ALTER TABLE `userTABLE`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `userTABLE`
--
ALTER TABLE `userTABLE`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
