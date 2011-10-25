SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `mydb`;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`user` (
  `uid` INT NOT NULL ,
  `email` VARCHAR(45) NULL ,
  `company` VARCHAR(45) NULL ,
  `phone` VARCHAR(45) NULL ,
  `firstname` VARCHAR(45) NULL ,
  `lastname` VARCHAR(45) NULL ,
  `password` VARCHAR(45) NULL ,
  `status` VARCHAR(45) NULL ,
  PRIMARY KEY (`uid`) )
ENGINE = MyISAM
COMMENT = '用户表 存放用户数据';


-- -----------------------------------------------------
-- Table `mydb`.`app_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`app_list` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`app_list` (
  `appid` INT NOT NULL ,
  `platform_id` INT NOT NULL ,
  `user_uid` INT NOT NULL ,
  `appname` VARCHAR(45) NOT NULL COMMENT 'Name of your application' ,
  `url` VARCHAR(200) NOT NULL COMMENT 'URL to your application (not including any tracking URLs)' ,
  `category_id` INT NOT NULL ,
  PRIMARY KEY (`appid`) ,
  CONSTRAINT `fk_app_list_user`
    FOREIGN KEY (`user_uid` )
    REFERENCES `mydb`.`user` (`uid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = '应用列表';

CREATE INDEX `fk_app_list_user` ON `mydb`.`app_list` (`user_uid` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`advertisement`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`advertisement` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`advertisement` (
  `adid` INT NOT NULL AUTO_INCREMENT ,
  `app_list_appid` INT NOT NULL ,
  `bannerurl` VARCHAR(200) NOT NULL ,
  `islive` INT NOT NULL DEFAULT 1 ,
  `enabled` INT NOT NULL DEFAULT 1 ,
  `ratio` DECIMAL(2) NOT NULL DEFAULT 1.00 ,
  `clicks` INT NOT NULL DEFAULT 0 ,
  `impressions` INT NOT NULL DEFAULT 0 ,
  `type` INT NOT NULL DEFAULT 0 COMMENT 'house promot\ncross promot' ,
  `efficiency` INT NOT NULL DEFAULT 0 ,
  `url` VARCHAR(45) NOT NULL ,
  `banner_tag` VARCHAR(100) NULL ,
  `popupdesc` VARCHAR(150) NULL ,
  `preference` INT NOT NULL DEFAULT 0 COMMENT '0,1' ,
  PRIMARY KEY (`adid`) ,
  CONSTRAINT `fk_advertisement_app_list1`
    FOREIGN KEY (`app_list_appid` )
    REFERENCES `mydb`.`app_list` (`appid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = MyISAM
COMMENT = '广告列表';

CREATE INDEX `fk_advertisement_app_list1` ON `mydb`.`advertisement` (`app_list_appid` ASC) ;


-- -----------------------------------------------------
-- Table `mydb`.`statistics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`statistics` ;

CREATE  TABLE IF NOT EXISTS `mydb`.`statistics` (
  `statistics_id` INT NOT NULL ,
  PRIMARY KEY (`statistics_id`) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
