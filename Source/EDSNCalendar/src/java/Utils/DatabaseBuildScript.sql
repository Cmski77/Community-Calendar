-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Dec 13, 2016 at 02:46 AM
-- Server version: 5.5.49-0+deb8u1
-- PHP Version: 5.6.27-0+deb8u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `cs410`
--

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE IF NOT EXISTS `events` (
`id` int(11) NOT NULL,
  `start_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `summary` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `description` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `location` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `isPublished` tinyint(1) NOT NULL,
  `category` varchar(100) COLLATE latin1_general_ci DEFAULT NULL,
  `subName` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `subEmail` varchar(50) COLLATE latin1_general_ci NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `start_date`, `start_time`, `end_date`, `end_time`, `summary`, `description`, `location`, `isPublished`, `category`, `subName`, `subEmail`) VALUES
(27, '2016-12-13', '04:00:00', '2016-12-13', '05:00:00', 'Beers after presentation', 'Food and drinks', '1433 East St, New Britain CT, 06053', 0, 'Music', 'Tom', 'hi@reddit.com'),
(26, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Final Presentation', 'The day has come', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(28, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Example event', 'Example description', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(29, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Example event', 'Example description', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(30, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Example event', 'Example description', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(31, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Example event', 'Example description', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(32, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Example event', 'Example description', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(33, '2016-12-13', '14:00:00', '2016-12-13', '16:00:00', 'Example event', 'Example description', '1615 Stanley St, New Britain CT, 06053', 0, 'Education', 'Tom', 'myemail@email.com'),
(21, '2016-12-28', '12:00:00', '2016-12-31', '10:00:00', 'Testing (This event was modified admin-side)', 'Testing categories, email, other things', '123 Stanley St, New Britain CT 06053', 1, 'Sport', 'Chris Mazurski', 'cmski77@yahoo.com'),
(22, '2016-12-31', '12:00:00', '2016-12-31', '13:00:00', 'Chris just changed this', 'Testing categories, email, other things', '123 Stanley St, New Britain CT 06053', 1, 'Music', 'Chris Mazurski', 'cmski77@yahoo.com'),
(24, '2016-12-27', '17:30:00', '2016-12-27', '19:00:00', 'Definitive Testtest2', 'Testing categories, email, other things', '123 Stanley St, New Britain CT 06053', 0, 'Education', 'Chris Mazurski', 'cmski77@yahoo.com'),
(25, '2016-12-12', '06:30:00', '2016-12-12', '12:00:00', 'Definitive testing', 'Testing categories, email, other things', '123 Stanley St, New Britain CT 06053', 1, 'Religion', 'Chris Mazurski', 'cmski77@yahoo.com');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`id` int(11) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `access_level` tinyint(4) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `access_level`) VALUES
(1, 'admin', '21232f297a57a5a743894a0e4a801fc3', 4),
(5, 'tomek', '202cb962ac59075b964b07152d234b70', 4),
(6, 'tomek', '0192023a7bbd73250516f069df18b500', 2),
(7, 'test', 'b09c600fddc573f117449b3723f23d64', 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `events`
--
ALTER TABLE `events`
 ADD PRIMARY KEY (`id`), ADD FULLTEXT KEY `subName` (`subName`), ADD FULLTEXT KEY `subName_2` (`subName`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
