-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema vidly
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema vidly
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vidly` DEFAULT CHARACTER SET latin1 ;
USE `vidly` ;

-- -----------------------------------------------------
-- Table `vidly`.`coupons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vidly`.`coupons` (
  `coupon_code` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `value` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`coupon_code`))
ENGINE = InnoDB
AUTO_INCREMENT = 5
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `vidly`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vidly`.`customers` (
  `customer_id` SMALLINT(6) NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `phone_number` VARCHAR(20) NOT NULL,
  `email` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB
AUTO_INCREMENT = 3
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `vidly`.`movies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vidly`.`movies` (
  `bar_code` INT NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `stock` TINYINT(4) NOT NULL,
  `daily_rental_rate` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`bar_code`))
ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `vidly`.`return_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vidly`.`return_status` (
  `return_status_code` TINYINT(4) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`return_status_code`))
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `vidly`.`rents`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `vidly`.`rents` (
  `rent_id` INT(11) NOT NULL AUTO_INCREMENT,
  `customer_id` SMALLINT(6) NOT NULL,
  `bar_code` INT NOT NULL,
  `coupon_code` TINYINT(4) NULL DEFAULT NULL,
  `return_status_code` TINYINT(4) NOT NULL,
  `issue_date` DATETIME NOT NULL,
  `return_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`rent_id`),
  INDEX `fk_rents_customers_idx` (`customer_id` ASC),
  INDEX `fk_rents_coupons1_idx` (`coupon_code` ASC),
  INDEX `fk_rents_return_status1_idx` (`return_status_code` ASC),
  INDEX `fk_rents_movies1_idx` (`bar_code` ASC),
  CONSTRAINT `fk_rents_coupons`
    FOREIGN KEY (`coupon_code`)
    REFERENCES `vidly`.`coupons` (`coupon_code`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rents_customers`
    FOREIGN KEY (`customer_id`)
    REFERENCES `vidly`.`customers` (`customer_id`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rents_return_status`
    FOREIGN KEY (`return_status_code`)
    REFERENCES `vidly`.`return_status` (`return_status_code`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_rents_movies1`
    FOREIGN KEY (`bar_code`)
    REFERENCES `vidly`.`movies` (`bar_code`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

USE `vidly` ;

-- -----------------------------------------------------
-- procedure proc_movies
-- -----------------------------------------------------

DELIMITER $$
USE `vidly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_movies`(
	role_id tinyint
)
begin
	if role_id = 1 then
		select * from vidly.movies;
    end if;
	
end$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure return_daily_rental_rate
-- -----------------------------------------------------

DELIMITER $$
USE `vidly`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `return_daily_rental_rate`(
	bar_code int
    )
begin
		select daily_rental_rate
        from movies 
        where movie_id = (
		select movie_id
        from items i
        where i.bar_code = bar_code);
    end$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
USE `vidly`;

DELIMITER $$
USE `vidly`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `vidly`.`trigg_lost_item`
AFTER UPDATE ON `vidly`.`rents`
FOR EACH ROW
begin
	if new.return_status_code = 3 then
		delete from items where bar_code = new.bar_code;        
	end if;
end$$


DELIMITER ;
