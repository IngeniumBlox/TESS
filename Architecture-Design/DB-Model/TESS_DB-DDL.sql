-- MySQL Script generated by MySQL Workbench
-- Tue Nov 28 23:54:12 2017
-- Model: TESS Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema tessdb
-- -----------------------------------------------------
-- tess db with all tables behind
DROP SCHEMA IF EXISTS `tessdb` ;

-- -----------------------------------------------------
-- Schema tessdb
--
-- tess db with all tables behind
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `tessdb` DEFAULT CHARACTER SET utf8 ;
USE `tessdb` ;

-- -----------------------------------------------------
-- Table `tessdb`.`Business_Type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Business_Type` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Business_Type` (
  `business_type_id` INT NOT NULL,
  `business_type` VARCHAR(10) NULL COMMENT 'Business Type can take values like:\nCorporation\nLLC\nOther',
  PRIMARY KEY (`business_type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Countries`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Countries` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Countries` (
  `country_id` INT NOT NULL AUTO_INCREMENT,
  `country_name` VARCHAR(45) NULL COMMENT 'The names of all the countries',
  `country_phone_prefix` VARCHAR(45) NULL COMMENT 'The phone prefix of the country',
  PRIMARY KEY (`country_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Country_States`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Country_States` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Country_States` (
  `state_id` INT NOT NULL AUTO_INCREMENT,
  `country_id` INT NOT NULL,
  `state_name` VARCHAR(30) NULL,
  PRIMARY KEY (`state_id`, `country_id`),
  CONSTRAINT `fk_Country_States_Countries1`
    FOREIGN KEY (`country_id`)
    REFERENCES `tessdb`.`Countries` (`country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Country_States_Countries1_idx` ON `tessdb`.`Country_States` (`country_id` ASC);


-- -----------------------------------------------------
-- Table `tessdb`.`Address`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Address` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `address_line1` VARCHAR(45) NULL,
  `address_line2` VARCHAR(45) NULL,
  `city` VARCHAR(45) NULL,
  `state_id` INT NOT NULL,
  `country_id` INT NOT NULL,
  `zip_postal_code` VARCHAR(10) NULL,
  PRIMARY KEY (`address_id`),
  CONSTRAINT `fk_Address_Country_States1`
    FOREIGN KEY (`state_id` , `country_id`)
    REFERENCES `tessdb`.`Country_States` (`state_id` , `country_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Address_Country_States1_idx` ON `tessdb`.`Address` (`state_id` ASC, `country_id` ASC);


-- -----------------------------------------------------
-- Table `tessdb`.`Participant_Type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Participant_Type` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Participant_Type` (
  `participant_id` INT NOT NULL,
  `participant_type` VARCHAR(10) NULL COMMENT 'Values for this field:\nCarrier\nFunder',
  PRIMARY KEY (`participant_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Payment_Method`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Payment_Method` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Payment_Method` (
  `payment_method_id` INT NOT NULL AUTO_INCREMENT,
  `payment_method_name` VARCHAR(45) NULL,
  PRIMARY KEY (`payment_method_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Currencies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Currencies` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Currencies` (
  `currency_id` INT NOT NULL,
  `currency_name` VARCHAR(10) NULL COMMENT 'For POC:\n',
  PRIMARY KEY (`currency_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Bank_Account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Bank_Account` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Bank_Account` (
  `bank_account_id` INT NOT NULL AUTO_INCREMENT,
  `payment_method_id` INT NOT NULL COMMENT 'values:\nWire Transfer\nCheque',
  `currency_id` INT NOT NULL,
  `bank_name` VARCHAR(45) NULL,
  `bank_address` VARCHAR(120) NULL,
  `account_name` VARCHAR(45) NULL,
  `account_address` VARCHAR(45) NULL,
  `account_number` VARCHAR(45) NULL,
  `aba_ach` VARCHAR(45) NULL,
  `swift` VARCHAR(10) NULL,
  PRIMARY KEY (`bank_account_id`),
  CONSTRAINT `fk_Bank_Account_Payment_Method1`
    FOREIGN KEY (`payment_method_id`)
    REFERENCES `tessdb`.`Payment_Method` (`payment_method_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bank_Account_Currencies1`
    FOREIGN KEY (`currency_id`)
    REFERENCES `tessdb`.`Currencies` (`currency_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Bank_Account_Payment_Method1_idx` ON `tessdb`.`Bank_Account` (`payment_method_id` ASC);

CREATE INDEX `fk_Bank_Account_Currencies1_idx` ON `tessdb`.`Bank_Account` (`currency_id` ASC);


-- -----------------------------------------------------
-- Table `tessdb`.`Voip_Protocols`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Voip_Protocols` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Voip_Protocols` (
  `voip_protocol_id` INT NOT NULL,
  `voip_protocol_name` VARCHAR(20) NULL,
  PRIMARY KEY (`voip_protocol_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Codecs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Codecs` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Codecs` (
  `codex_id` INT NOT NULL AUTO_INCREMENT,
  `codex_name` VARCHAR(20) NULL,
  PRIMARY KEY (`codex_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `tessdb`.`Hardware`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Hardware` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Hardware` (
  `hardware_id` INT NOT NULL,
  `voip_protocol_id` INT NOT NULL,
  `codex_id` INT NOT NULL,
  `manufacturer` VARCHAR(45) NULL,
  `model` VARCHAR(30) NULL,
  `software_version` VARCHAR(20) NULL,
  `primary_ip_address` VARCHAR(30) NULL,
  `media_ip_address` VARCHAR(30) NULL,
  `dial_string_format` VARCHAR(45) NULL,
  PRIMARY KEY (`hardware_id`),
  CONSTRAINT `fk_Hardware_Voip_Protocols1`
    FOREIGN KEY (`voip_protocol_id`)
    REFERENCES `tessdb`.`Voip_Protocols` (`voip_protocol_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hardware_Codecs1`
    FOREIGN KEY (`codex_id`)
    REFERENCES `tessdb`.`Codecs` (`codex_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Hardware_Voip_Protocols1_idx` ON `tessdb`.`Hardware` (`voip_protocol_id` ASC);

CREATE INDEX `fk_Hardware_Codecs1_idx` ON `tessdb`.`Hardware` (`codex_id` ASC);


-- -----------------------------------------------------
-- Table `tessdb`.`Participant`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `tessdb`.`Participant` ;

CREATE TABLE IF NOT EXISTS `tessdb`.`Participant` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `business_type_id` INT NOT NULL,
  `address_id` INT NOT NULL,
  `participant_type_id` INT NOT NULL,
  `bank_account_id` INT NOT NULL,
  `participant_name` VARCHAR(50) NULL,
  `contact_person` VARCHAR(45) NULL,
  `tax_id` VARCHAR(45) NULL,
  `phone_number` VARCHAR(10) NULL,
  `fax_number` VARCHAR(10) NULL,
  `email` VARCHAR(45) NULL,
  `user_name` VARCHAR(20) NULL,
  `password` VARCHAR(20) NULL,
  `hardware_id` INT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_Participant_Business_Type`
    FOREIGN KEY (`business_type_id`)
    REFERENCES `tessdb`.`Business_Type` (`business_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Participant_Address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `tessdb`.`Address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Participant_Participant_Type1`
    FOREIGN KEY (`participant_type_id`)
    REFERENCES `tessdb`.`Participant_Type` (`participant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Participant_Bank_Account1`
    FOREIGN KEY (`bank_account_id`)
    REFERENCES `tessdb`.`Bank_Account` (`bank_account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Participant_Hardware1`
    FOREIGN KEY (`hardware_id`)
    REFERENCES `tessdb`.`Hardware` (`hardware_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_Participant_Business_Type_idx` ON `tessdb`.`Participant` (`business_type_id` ASC);

CREATE INDEX `fk_Participant_Address1_idx` ON `tessdb`.`Participant` (`address_id` ASC);

CREATE INDEX `fk_Participant_Participant_Type1_idx` ON `tessdb`.`Participant` (`participant_type_id` ASC);

CREATE INDEX `fk_Participant_Bank_Account1_idx` ON `tessdb`.`Participant` (`bank_account_id` ASC);

CREATE INDEX `fk_Participant_Hardware1_idx` ON `tessdb`.`Participant` (`hardware_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
