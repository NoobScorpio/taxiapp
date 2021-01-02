-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 11, 2020 at 04:05 PM
-- Server version: 10.3.27-MariaDB
-- PHP Version: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shareuri_taxiApp`
--

-- --------------------------------------------------------

--
-- Table structure for table `driver`
--

CREATE TABLE `driver` (
  `idDriver` int(11) NOT NULL,
  `FullName` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `CarMake` varchar(45) NOT NULL,
  `RegistrationNo` varchar(45) NOT NULL,
  `City` varchar(45) NOT NULL,
  `Postal` varchar(45) NOT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL,
  `Phone` varchar(45) NOT NULL,
  `Status` varchar(45) NOT NULL DEFAULT 'Free',
  `Membership` varchar(45) NOT NULL DEFAULT 'Not Valid',
  `ActivationDate` date NOT NULL,
  `Balance` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `driver`
--

INSERT INTO `driver` (`idDriver`, `FullName`, `Email`, `Password`, `CarMake`, `RegistrationNo`, `City`, `Postal`, `Latitude`, `Longitude`, `Phone`, `Status`, `Membership`, `ActivationDate`, `Balance`) VALUES
(1, 'Salman', 'salman@gmail.com', 'salman1', 'Toyota', 'ABC12', 'Karachi', '32345', 24.8606499, 67.0660625, '6382573', 'Busy', 'Valid', '2020-11-02', 0),
(2, 'Salman', 'salman2@gmail.com', 'salman', 'Toyota', 'ABC123', 'Karachi', '32345', 35, 6, '', 'Busy', 'Not Valid', '2020-10-01', 0),
(3, 'Salman', 'salman3@gmail.com', 'salman', 'Toyota', 'ABC123', 'Karachi', '32345', 35, 36, '456456', 'Free', 'Not Valid', '0000-00-00', 0),
(8, 'Saylu', 'driver12@gmail.com', 'abc123', 'Toyota', 'BAC123', 'Hyd', '23r35', 35, 36, '3534345', 'Free', 'Not Valid', '0000-00-00', 0),
(10, 'Saylu', 'driver123@gmail.com', 'abc123', 'Toyota', 'BAC123', 'Hyd', '23r35', 35, 36, '3534345', 'Free', 'Not Valid', '0000-00-00', 0),
(11, 'Saylu', 'driver1@gmail.com', 'abc123', 'Toyota', 'BAC123', 'Hyd', '23r35', 35, 36, '3534345', 'Free', 'Not Valid', '0000-00-00', 0),
(12, 'Saylu', 'driver21@gmail.com', 'abc123', 'Toyota', 'BAC123', 'Hyd', '23r35', 35, 36, '3534345', 'Free', 'Not Valid', '0000-00-00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `idOrder` int(11) NOT NULL,
  `CustomerName` varchar(45) NOT NULL,
  `CustomerPhone` varchar(45) NOT NULL,
  `DestAddress` varchar(100) NOT NULL,
  `Status` varchar(45) NOT NULL DEFAULT 'Not Accepted',
  `Timestamp` datetime NOT NULL DEFAULT current_timestamp(),
  `idDriver` int(11) DEFAULT NULL,
  `idRest` int(11) NOT NULL,
  `orderValue` float NOT NULL DEFAULT 0,
  `time` varchar(45) NOT NULL,
  `postcode` int(11) NOT NULL,
  `price` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`idOrder`, `CustomerName`, `CustomerPhone`, `DestAddress`, `Status`, `Timestamp`, `idDriver`, `idRest`, `orderValue`, `time`, `postcode`, `price`) VALUES
(1, 'Salman', '936203469', 'Gulistan-e-Johar', 'In Progress', '2020-10-01 22:49:32', 2, 2, 0, '', 0, 0),
(2, 'Hussain', '967356', 'Nipa', 'Complete', '2020-10-01 22:54:37', 1, 1, 0, '5', 0, 0),
(3, 'Shibli', '96733456', 'Johar', 'Complete', '2020-10-01 22:57:37', 1, 1, 0, '20', 0, 0),
(4, 'Shibli', '96733456', 'Johar', 'Complete', '2020-10-01 23:06:27', 1, 1, 0, '25', 0, 0),
(5, 'Shibli', '96733456', 'Johar', 'Complete', '2020-10-01 23:08:31', 1, 1, 0, '5', 0, 0),
(6, 'Alishan', '96733456', 'Johar', 'Complete', '2020-10-03 01:40:52', 1, 1, 0, '25', 0, 0),
(7, 'Alishan', '96733456', 'Johar', 'Complete', '2020-10-03 01:41:26', 1, 2, 0, '15', 0, 0),
(10, 'Alishah', '96733456', 'Johar', 'Complete', '2020-10-03 01:42:21', 1, 1, 0, '15', 0, 0),
(14, 'Alishah', '96733456', 'Johar', 'Complete', '2020-10-03 01:47:34', 1, 2, 0, '55', 0, 0),
(15, 'salman', '032197834864', 'gulistane johr', 'Accepted', '2020-10-06 02:50:48', 1, 1, 1000, '20', 258, 0),
(16, 'hhs', '6464', 'h', 'Complete', '2020-10-07 00:31:33', 1, 1, 74, '2', 44, 0),
(18, 'jsk', '649', 's', 'Complete', '2020-10-07 00:53:56', 1, 1, 7, '5', 55, 0),
(19, 'ALISHAN M. Amin', '0642138468764', 'Hyderabad', 'Complete', '2020-10-12 02:28:02', 1, 1, 500, '15', 3, 0),
(20, 'Salman Shaikh', '03232374975', 'Block 10 Gulshan-e-Iqbal, Karachi, Karachi City, Sindh, Pakistan', 'Complete', '2020-10-18 04:45:46', 1, 1, 500, '20', 85200, 40),
(21, 'Ehsan', '8464062845', 'Liaquatabad Town, Karachi, Karachi City, Sindh, Pakistan', 'Complete', '2020-10-20 03:26:33', 1, 1, 900, '355', 85500, 50),
(22, 'Ahsan', '2548215', 'johar', 'Complete', '2020-10-20 09:20:35', 1, 1, 600, '55', 85400, 20),
(23, 'Salman shaikh', '03232374975', 'Liaquatabad Town, Karachi, Karachi City, Sindh, Pakistan', 'Complete', '2020-10-26 18:12:18', 1, 1, 1000, '55', 85500, 50),
(24, 'Salman', '8234073045', 'Liaquatabad Town, Karachi, Karachi City, Sindh, Pakistan', 'Complete', '2020-10-27 15:48:33', 1, 1, 500, '55', 85400, 20),
(25, 'salman', '032187642', 'Liaquatabad Town, Karachi, Karachi City, Sindh, Pakistan', 'Complete', '2020-10-30 07:30:49', 1, 1, 100, '5', 85400, 20);

-- --------------------------------------------------------

--
-- Table structure for table `postcodeprice`
--

CREATE TABLE `postcodeprice` (
  `idRest` int(11) NOT NULL,
  `postcode` int(11) NOT NULL,
  `price` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `postcodeprice`
--

INSERT INTO `postcodeprice` (`idRest`, `postcode`, `price`) VALUES
(1, 82000, 5),
(1, 85400, 20),
(1, 85500, 50);

-- --------------------------------------------------------

--
-- Table structure for table `restaurant`
--

CREATE TABLE `restaurant` (
  `idRestaurant` int(11) NOT NULL,
  `FullName` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Password` varchar(45) NOT NULL,
  `RestaurantName` varchar(45) NOT NULL,
  `Address` varchar(45) NOT NULL,
  `City` varchar(45) NOT NULL,
  `Postal` varchar(45) NOT NULL,
  `Phone` varchar(45) NOT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL,
  `Status` varchar(45) NOT NULL DEFAULT 'Not Activated',
  `Balance` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`idRestaurant`, `FullName`, `Email`, `Password`, `RestaurantName`, `Address`, `City`, `Postal`, `Phone`, `Latitude`, `Longitude`, `Status`, `Balance`) VALUES
(1, 'Salman', 'salman@gmail.com', 'salman', 'Foods Inn', 'Gulshnan', 'Karachi', '34532', '98348573645', 24.86305, 67.05492, 'Not Activated', 0),
(2, 'Salman', 'kolachi@gmail.com', 'salman', 'kolachi', 'Gulshnan', 'Karachi', '34532', '98348573645', 4, 4, 'Not Activated', 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `driver`
--
ALTER TABLE `driver`
  ADD PRIMARY KEY (`idDriver`),
  ADD UNIQUE KEY `idDriver_UNIQUE` (`idDriver`),
  ADD UNIQUE KEY `Email_UNIQUE` (`Email`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`idOrder`),
  ADD UNIQUE KEY `idOrder_UNIQUE` (`idOrder`),
  ADD KEY `restFK_idx` (`idRest`),
  ADD KEY `driverFK_idx` (`idDriver`);

--
-- Indexes for table `postcodeprice`
--
ALTER TABLE `postcodeprice`
  ADD PRIMARY KEY (`idRest`,`postcode`);

--
-- Indexes for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD PRIMARY KEY (`idRestaurant`),
  ADD UNIQUE KEY `idRestaurant_UNIQUE` (`idRestaurant`),
  ADD UNIQUE KEY `Email_UNIQUE` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `driver`
--
ALTER TABLE `driver`
  MODIFY `idDriver` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `idOrder` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `restaurant`
--
ALTER TABLE `restaurant`
  MODIFY `idRestaurant` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `driverFK` FOREIGN KEY (`idDriver`) REFERENCES `driver` (`idDriver`),
  ADD CONSTRAINT `restFK` FOREIGN KEY (`idRest`) REFERENCES `restaurant` (`idRestaurant`);

--
-- Constraints for table `postcodeprice`
--
ALTER TABLE `postcodeprice`
  ADD CONSTRAINT `resauranttFK` FOREIGN KEY (`idRest`) REFERENCES `restaurant` (`idRestaurant`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
