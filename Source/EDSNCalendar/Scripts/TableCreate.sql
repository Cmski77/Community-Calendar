/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  gotoel
 * Created: Nov 4, 2016
 */

CREATE TABLE IF NOT EXISTS `events` (
    `id` int(11) NOT NULL auto_increment,
    `start_date` date,
    `start_time` time,
    `end_date` date,
    `end_time` time,
    `summary` varchar(50) collate latin1_general_ci NOT NULL,
    `description` varchar(50) collate latin1_general_ci NOT NULL,
    `location` varchar(50) collate latin1_general_ci NOT NULL,
    `colorId` varchar(50) collate latin1_general_ci NOT NULL,
    `isPublished` boolean collate latin1_general_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=4 ;