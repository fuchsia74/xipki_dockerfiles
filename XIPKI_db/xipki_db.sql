-- MySQL dump 10.18  Distrib 10.3.27-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: ca
-- ------------------------------------------------------
-- Server version	10.6.0-MariaDB-1:10.6.0+maria~focal

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `ca`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ca` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ca`;

--
-- Table structure for table `CA`
--

DROP TABLE IF EXISTS `CA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CA` (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) DEFAULT NULL COMMENT 'duplication is not permitted',
  `SN_SIZE` smallint(6) DEFAULT NULL COMMENT 'number of octets of the serial number',
  `NEXT_CRLNO` bigint(20) DEFAULT NULL,
  `STATUS` varchar(10) NOT NULL COMMENT 'valid values: active, inactive',
  `SUBJECT` varchar(350) NOT NULL,
  `CA_URIS` varchar(2000) DEFAULT NULL,
  `MAX_VALIDITY` varchar(45) NOT NULL,
  `CRL_CONTROL` varchar(1000) DEFAULT NULL,
  `CMP_CONTROL` varchar(1000) DEFAULT NULL,
  `SCEP_CONTROL` varchar(500) DEFAULT NULL,
  `CTLOG_CONTROL` varchar(1000) DEFAULT NULL COMMENT 'Certificate Transparency Log Control',
  `REVOKE_SUSPENDED_CONTROL` varchar(500) DEFAULT NULL,
  `CRL_SIGNER_NAME` varchar(45) DEFAULT NULL,
  `CMP_RESPONDER_NAME` varchar(45) DEFAULT NULL,
  `SCEP_RESPONDER_NAME` varchar(45) DEFAULT NULL,
  `PROTOCOL_SUPPORT` varchar(200) NOT NULL DEFAULT '0' COMMENT 'Whether REST API is supported, default is false (0)',
  `SAVE_REQ` smallint(6) NOT NULL DEFAULT 0 COMMENT 'Whether requests should be saved, default is false (0)',
  `VALIDITY_MODE` varchar(100) DEFAULT NULL,
  `PERMISSION` int(11) NOT NULL,
  `NUM_CRLS` smallint(6) NOT NULL DEFAULT 30,
  `EXPIRATION_PERIOD` smallint(6) DEFAULT 365,
  `REV_INFO` varchar(200) DEFAULT NULL COMMENT 'CA revocation information',
  `SIGNER_TYPE` varchar(100) NOT NULL,
  `KEEP_EXPIRED_CERT_DAYS` smallint(6) DEFAULT -1 COMMENT 'How long in days should certificates be kept after the expiration. Negative value for kept-for-ever',
  `CERT` varchar(6000) NOT NULL,
  `DHPOC_CONTROL` longtext DEFAULT NULL COMMENT 'Diffie-Hellman Key Agreement PoC Control',
  `EXTRA_CONTROL` longtext DEFAULT NULL COMMENT 'extra control',
  `CERTCHAIN` longtext DEFAULT NULL COMMENT 'Certificate chain without CA''s certificate',
  `SIGNER_CONF` longtext NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_CA_NAME` (`NAME`),
  KEY `FK_CA_CRL_SIGNER1` (`CRL_SIGNER_NAME`),
  KEY `FK_CA_CMP_SIGNER1` (`CMP_RESPONDER_NAME`),
  KEY `FK_CA_SCEP_SIGNER1` (`SCEP_RESPONDER_NAME`),
  CONSTRAINT `FK_CA_CMP_SIGNER1` FOREIGN KEY (`CMP_RESPONDER_NAME`) REFERENCES `SIGNER` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_CRL_SIGNER1` FOREIGN KEY (`CRL_SIGNER_NAME`) REFERENCES `SIGNER` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_SCEP_SIGNER1` FOREIGN KEY (`SCEP_RESPONDER_NAME`) REFERENCES `SIGNER` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CA`
--

LOCK TABLES `CA` WRITE;
/*!40000 ALTER TABLE `CA` DISABLE KEYS */;
/*!40000 ALTER TABLE `CA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CAALIAS`
--

DROP TABLE IF EXISTS `CAALIAS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CAALIAS` (
  `NAME` varchar(45) NOT NULL,
  `CA_ID` smallint(6) NOT NULL,
  PRIMARY KEY (`NAME`),
  KEY `FK_CAALIAS_CA1` (`CA_ID`),
  CONSTRAINT `FK_CAALIAS_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CAALIAS`
--

LOCK TABLES `CAALIAS` WRITE;
/*!40000 ALTER TABLE `CAALIAS` DISABLE KEYS */;
/*!40000 ALTER TABLE `CAALIAS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CA_HAS_PROFILE`
--

DROP TABLE IF EXISTS `CA_HAS_PROFILE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CA_HAS_PROFILE` (
  `PROFILES` varchar(200) DEFAULT NULL,
  `CA_ID` smallint(6) NOT NULL,
  `PROFILE_ID` smallint(6) NOT NULL,
  PRIMARY KEY (`CA_ID`,`PROFILE_ID`),
  KEY `FK_CA_HAS_PROFILE_PROFILE1` (`PROFILE_ID`),
  CONSTRAINT `FK_CA_HAS_PROFILE_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_PROFILE_PROFILE1` FOREIGN KEY (`PROFILE_ID`) REFERENCES `PROFILE` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CA_HAS_PROFILE`
--

LOCK TABLES `CA_HAS_PROFILE` WRITE;
/*!40000 ALTER TABLE `CA_HAS_PROFILE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CA_HAS_PROFILE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CA_HAS_PUBLISHER`
--

DROP TABLE IF EXISTS `CA_HAS_PUBLISHER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CA_HAS_PUBLISHER` (
  `CA_ID` smallint(6) NOT NULL,
  `PUBLISHER_ID` smallint(6) NOT NULL,
  PRIMARY KEY (`CA_ID`,`PUBLISHER_ID`),
  KEY `FK_CA_HAS_PUBLISHER_PUBLISHER1` (`PUBLISHER_ID`),
  CONSTRAINT `FK_CA_HAS_PUBLISHER_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_PUBLISHER_PUBLISHER1` FOREIGN KEY (`PUBLISHER_ID`) REFERENCES `PUBLISHER` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CA_HAS_PUBLISHER`
--

LOCK TABLES `CA_HAS_PUBLISHER` WRITE;
/*!40000 ALTER TABLE `CA_HAS_PUBLISHER` DISABLE KEYS */;
/*!40000 ALTER TABLE `CA_HAS_PUBLISHER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CA_HAS_REQUESTOR`
--

DROP TABLE IF EXISTS `CA_HAS_REQUESTOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CA_HAS_REQUESTOR` (
  `CA_ID` smallint(6) NOT NULL,
  `REQUESTOR_ID` smallint(6) NOT NULL,
  `RA` smallint(6) NOT NULL,
  `PERMISSION` int(11) DEFAULT NULL,
  `PROFILES` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`CA_ID`,`REQUESTOR_ID`),
  KEY `FK_CA_HAS_REQUESTOR_REQUESTOR1` (`REQUESTOR_ID`),
  CONSTRAINT `FK_CA_HAS_REQUESTOR_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_REQUESTOR_REQUESTOR1` FOREIGN KEY (`REQUESTOR_ID`) REFERENCES `REQUESTOR` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CA_HAS_REQUESTOR`
--

LOCK TABLES `CA_HAS_REQUESTOR` WRITE;
/*!40000 ALTER TABLE `CA_HAS_REQUESTOR` DISABLE KEYS */;
/*!40000 ALTER TABLE `CA_HAS_REQUESTOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CA_HAS_USER`
--

DROP TABLE IF EXISTS `CA_HAS_USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CA_HAS_USER` (
  `ID` bigint(20) NOT NULL,
  `CA_ID` smallint(6) NOT NULL,
  `USER_ID` int(11) NOT NULL,
  `PERMISSION` int(11) NOT NULL,
  `PROFILES` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_CA_USER` (`CA_ID`,`USER_ID`),
  KEY `FK_CA_HAS_USER_USER1` (`USER_ID`),
  CONSTRAINT `FK_CA_HAS_USER_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CA_HAS_USER_USER1` FOREIGN KEY (`USER_ID`) REFERENCES `TUSER` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CA_HAS_USER`
--

LOCK TABLES `CA_HAS_USER` WRITE;
/*!40000 ALTER TABLE `CA_HAS_USER` DISABLE KEYS */;
/*!40000 ALTER TABLE `CA_HAS_USER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CERT`
--

DROP TABLE IF EXISTS `CERT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CERT` (
  `ID` bigint(20) NOT NULL,
  `CA_ID` smallint(6) NOT NULL COMMENT 'Issuer (CA) id',
  `SN` varchar(40) NOT NULL COMMENT 'serial number',
  `PID` smallint(6) NOT NULL COMMENT 'certificate profile id',
  `RID` smallint(6) DEFAULT NULL COMMENT 'requestor id',
  `FP_S` bigint(20) NOT NULL COMMENT 'first 8 bytes of the SHA1 sum of the subject',
  `FP_RS` bigint(20) DEFAULT NULL COMMENT 'first 8 bytes of the SHA1 sum of the requested subject',
  `LUPDATE` bigint(20) NOT NULL COMMENT 'last update, seconds since January 1, 1970, 00:00:00 GMT',
  `NBEFORE` bigint(20) NOT NULL COMMENT 'notBefore, seconds since January 1, 1970, 00:00:00 GMT',
  `NAFTER` bigint(20) NOT NULL COMMENT 'notAfter, seconds since January 1, 1970, 00:00:00 GMT',
  `REV` smallint(6) NOT NULL COMMENT 'whether the certificate is revoked',
  `RR` smallint(6) DEFAULT NULL COMMENT 'revocation reason',
  `RT` bigint(20) DEFAULT NULL COMMENT 'revocation time, seconds since January 1, 1970, 00:00:00 GMT',
  `RIT` bigint(20) DEFAULT NULL COMMENT 'revocation invalidity time, seconds since January 1, 1970, 00:00:00 GMT',
  `EE` smallint(6) NOT NULL COMMENT 'whether it is an end entity cert',
  `UID` int(11) DEFAULT NULL COMMENT 'user id',
  `RTYPE` smallint(6) NOT NULL COMMENT 'request type, 1 for direct via CA command, 2 for CMP, 3 for SCEP, 4 for REST',
  `SUBJECT` varchar(350) NOT NULL,
  `TID` varchar(43) DEFAULT NULL COMMENT 'base64 encoded transactionId, maximal 256 bit',
  `CRL_SCOPE` smallint(6) NOT NULL COMMENT 'CRL scope, reserved for future use',
  `SHA1` char(28) NOT NULL COMMENT 'base64 encoded SHA1 fingerprint of the certificate',
  `REQ_SUBJECT` varchar(350) DEFAULT NULL,
  `CERT` varchar(6000) NOT NULL COMMENT 'Base64 encoded certificate',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_CA_SN` (`CA_ID`,`SN`),
  KEY `IDX_CA_FPS` (`CA_ID`,`FP_S`),
  KEY `IDX_CA_FPRS` (`CA_ID`,`FP_RS`),
  KEY `FK_CERT_REQUESTOR1` (`RID`),
  KEY `FK_CERT_USER1` (`UID`),
  KEY `FK_CERT_PROFILE1` (`PID`),
  CONSTRAINT `FK_CERT_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CERT_PROFILE1` FOREIGN KEY (`PID`) REFERENCES `PROFILE` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CERT_REQUESTOR1` FOREIGN KEY (`RID`) REFERENCES `REQUESTOR` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CERT_USER1` FOREIGN KEY (`UID`) REFERENCES `TUSER` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CERT`
--

LOCK TABLES `CERT` WRITE;
/*!40000 ALTER TABLE `CERT` DISABLE KEYS */;
/*!40000 ALTER TABLE `CERT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CRL`
--

DROP TABLE IF EXISTS `CRL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CRL` (
  `ID` int(11) NOT NULL,
  `CA_ID` smallint(6) NOT NULL,
  `CRL_SCOPE` smallint(6) NOT NULL COMMENT 'CRL scope, reserved for future use',
  `CRL_NO` bigint(20) NOT NULL,
  `THISUPDATE` bigint(20) NOT NULL,
  `NEXTUPDATE` bigint(20) DEFAULT NULL,
  `DELTACRL` smallint(6) NOT NULL,
  `BASECRL_NO` bigint(20) DEFAULT NULL,
  `CRL` longtext NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_CA_CRLNO` (`CA_ID`,`CRL_NO`),
  CONSTRAINT `FK_CRL_CA1` FOREIGN KEY (`CA_ID`) REFERENCES `CA` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CRL`
--

LOCK TABLES `CRL` WRITE;
/*!40000 ALTER TABLE `CRL` DISABLE KEYS */;
/*!40000 ALTER TABLE `CRL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DBSCHEMA`
--

DROP TABLE IF EXISTS `DBSCHEMA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DBSCHEMA` (
  `NAME` varchar(45) NOT NULL,
  `VALUE2` varchar(100) NOT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='database schema information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DBSCHEMA`
--

LOCK TABLES `DBSCHEMA` WRITE;
/*!40000 ALTER TABLE `DBSCHEMA` DISABLE KEYS */;
INSERT INTO `DBSCHEMA` VALUES ('VERSION','6'),('X500NAME_MAXLEN','350');
/*!40000 ALTER TABLE `DBSCHEMA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PROFILE`
--

DROP TABLE IF EXISTS `PROFILE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PROFILE` (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) DEFAULT NULL COMMENT 'duplication is not permitted',
  `TYPE` varchar(100) NOT NULL,
  `CONF` longtext DEFAULT NULL COMMENT 'profile data, depends on the type',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_PROFILE_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PROFILE`
--

LOCK TABLES `PROFILE` WRITE;
/*!40000 ALTER TABLE `PROFILE` DISABLE KEYS */;
/*!40000 ALTER TABLE `PROFILE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUBLISHER`
--

DROP TABLE IF EXISTS `PUBLISHER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PUBLISHER` (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) DEFAULT NULL COMMENT 'duplication is not permitted',
  `TYPE` varchar(100) NOT NULL,
  `CONF` longtext DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_PUBLISHER_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUBLISHER`
--

LOCK TABLES `PUBLISHER` WRITE;
/*!40000 ALTER TABLE `PUBLISHER` DISABLE KEYS */;
/*!40000 ALTER TABLE `PUBLISHER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PUBLISHQUEUE`
--

DROP TABLE IF EXISTS `PUBLISHQUEUE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `PUBLISHQUEUE` (
  `CID` bigint(20) NOT NULL,
  `PID` smallint(6) NOT NULL,
  `CA_ID` smallint(6) NOT NULL,
  KEY `FK_PUBLISHQUEUE_PUBLISHER1` (`PID`),
  KEY `FK_PUBLISHQUEUE_CERT1` (`CID`),
  CONSTRAINT `FK_PUBLISHQUEUE_CERT1` FOREIGN KEY (`CID`) REFERENCES `CERT` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_PUBLISHQUEUE_PUBLISHER1` FOREIGN KEY (`PID`) REFERENCES `PUBLISHER` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PUBLISHQUEUE`
--

LOCK TABLES `PUBLISHQUEUE` WRITE;
/*!40000 ALTER TABLE `PUBLISHQUEUE` DISABLE KEYS */;
/*!40000 ALTER TABLE `PUBLISHQUEUE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQCERT`
--

DROP TABLE IF EXISTS `REQCERT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `REQCERT` (
  `ID` bigint(20) NOT NULL,
  `RID` bigint(20) NOT NULL COMMENT 'request id',
  `CID` bigint(20) NOT NULL COMMENT 'cert id',
  PRIMARY KEY (`ID`),
  KEY `FK_REQCERT_REQ1` (`RID`),
  KEY `FK_REQCERT_CERT1` (`CID`),
  CONSTRAINT `FK_REQCERT_CERT1` FOREIGN KEY (`CID`) REFERENCES `CERT` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `FK_REQCERT_REQ1` FOREIGN KEY (`RID`) REFERENCES `REQUEST` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQCERT`
--

LOCK TABLES `REQCERT` WRITE;
/*!40000 ALTER TABLE `REQCERT` DISABLE KEYS */;
/*!40000 ALTER TABLE `REQCERT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQUEST`
--

DROP TABLE IF EXISTS `REQUEST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `REQUEST` (
  `ID` bigint(20) NOT NULL,
  `LUPDATE` bigint(20) NOT NULL COMMENT 'time at which the request is added to database, seconds since January 1, 1970, 00:00:00 GMT',
  `DATA` longtext DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQUEST`
--

LOCK TABLES `REQUEST` WRITE;
/*!40000 ALTER TABLE `REQUEST` DISABLE KEYS */;
/*!40000 ALTER TABLE `REQUEST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `REQUESTOR`
--

DROP TABLE IF EXISTS `REQUESTOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `REQUESTOR` (
  `ID` smallint(6) NOT NULL,
  `NAME` varchar(45) DEFAULT NULL COMMENT 'duplication is not permitted',
  `TYPE` varchar(100) NOT NULL,
  `CONF` longtext DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_REQUESTOR_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `REQUESTOR`
--

LOCK TABLES `REQUESTOR` WRITE;
/*!40000 ALTER TABLE `REQUESTOR` DISABLE KEYS */;
/*!40000 ALTER TABLE `REQUESTOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SIGNER`
--

DROP TABLE IF EXISTS `SIGNER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SIGNER` (
  `NAME` varchar(45) NOT NULL,
  `TYPE` varchar(100) NOT NULL,
  `CERT` varchar(6000) DEFAULT NULL,
  `CONF` longtext DEFAULT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SIGNER`
--

LOCK TABLES `SIGNER` WRITE;
/*!40000 ALTER TABLE `SIGNER` DISABLE KEYS */;
/*!40000 ALTER TABLE `SIGNER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SYSTEM_EVENT`
--

DROP TABLE IF EXISTS `SYSTEM_EVENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SYSTEM_EVENT` (
  `NAME` varchar(45) NOT NULL,
  `EVENT_TIME` bigint(20) NOT NULL COMMENT 'seconds since January 1, 1970, 00:00:00 GMT',
  `EVENT_TIME2` timestamp NULL DEFAULT NULL,
  `EVENT_OWNER` varchar(255) NOT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SYSTEM_EVENT`
--

LOCK TABLES `SYSTEM_EVENT` WRITE;
/*!40000 ALTER TABLE `SYSTEM_EVENT` DISABLE KEYS */;
/*!40000 ALTER TABLE `SYSTEM_EVENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TUSER`
--

DROP TABLE IF EXISTS `TUSER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TUSER` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `ACTIVE` smallint(6) NOT NULL COMMENT 'whether the user is activated',
  `PASSWORD` varchar(150) NOT NULL COMMENT 'salted hashed password in hex',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_USER_NAME` (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TUSER`
--

LOCK TABLES `TUSER` WRITE;
/*!40000 ALTER TABLE `TUSER` DISABLE KEYS */;
/*!40000 ALTER TABLE `TUSER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `ocsp`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ocsp` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ocsp`;

--
-- Current Database: `ocspcache`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ocspcache` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ocspcache`;

--
-- Table structure for table `ISSUER`
--

DROP TABLE IF EXISTS `ISSUER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ISSUER` (
  `ID` int(11) NOT NULL,
  `S1C` char(28) NOT NULL COMMENT 'base64 enoded SHA1 sum of the certificate',
  `CERT` varchar(6000) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ISSUER`
--

LOCK TABLES `ISSUER` WRITE;
/*!40000 ALTER TABLE `ISSUER` DISABLE KEYS */;
/*!40000 ALTER TABLE `ISSUER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OCSP`
--

DROP TABLE IF EXISTS `OCSP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `OCSP` (
  `ID` bigint(20) NOT NULL,
  `IID` int(11) NOT NULL COMMENT 'issuer id',
  `IDENT` varchar(48) NOT NULL COMMENT 'Identifier consists of hex(SIG_ALG) | hex(CERTHASH_ALG) | hex(serial number)',
  `GENERATED_AT` bigint(20) NOT NULL COMMENT 'generatedAt, seconds since January 1, 1970, 00:00:00 GMT',
  `NEXT_UPDATE` bigint(20) NOT NULL COMMENT 'next update, seconds since January 1, 1970, 00:00:00 GMT',
  `RESP` varchar(4000) NOT NULL COMMENT 'Base64 DER-encoded OCSP response',
  PRIMARY KEY (`ID`),
  KEY `FK_OCSP_ISSUER1` (`IID`),
  CONSTRAINT `FK_OCSP_ISSUER1` FOREIGN KEY (`IID`) REFERENCES `ISSUER` (`ID`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Only OCSP response without nonce is cached here';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OCSP`
--

LOCK TABLES `OCSP` WRITE;
/*!40000 ALTER TABLE `OCSP` DISABLE KEYS */;
/*!40000 ALTER TABLE `OCSP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `ocspcrl`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `ocspcrl` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `ocspcrl`;

--
-- Table structure for table `CERT`
--

DROP TABLE IF EXISTS `CERT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CERT` (
  `ID` bigint(20) NOT NULL,
  `IID` smallint(6) NOT NULL COMMENT 'issuer id',
  `SN` varchar(40) NOT NULL COMMENT 'serial number',
  `CRL_ID` int(11) DEFAULT NULL COMMENT 'CRL ID, only present for entry imported from CRL',
  `LUPDATE` bigint(20) NOT NULL COMMENT 'last update of the this database entry, seconds since January 1, 1970, 00:00:00 GMT',
  `NBEFORE` bigint(20) DEFAULT NULL COMMENT 'notBefore of certificate, seconds since January 1, 1970, 00:00:00 GMT',
  `NAFTER` bigint(20) DEFAULT NULL COMMENT 'notAfter of certificate, seconds since January 1, 1970, 00:00:00 GMT',
  `REV` smallint(6) NOT NULL COMMENT 'whether the certificate is revoked',
  `RR` smallint(6) DEFAULT NULL COMMENT 'revocation reason',
  `RT` bigint(20) DEFAULT NULL COMMENT 'revocation time, seconds since January 1, 1970, 00:00:00 GMT',
  `RIT` bigint(20) DEFAULT NULL COMMENT 'revocation invalidity time, seconds since January 1, 1970, 00:00:00 GMT',
  `HASH` char(86) DEFAULT NULL COMMENT 'base64 enoded hash value of the DER encoded certificate. Algorithm is defined by CERTHASH_ALGO in table DBSchema',
  `SUBJECT` varchar(350) DEFAULT NULL COMMENT 'subject of the certificate',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `CONST_ISSUER_SN` (`IID`,`SN`),
  KEY `FK_CERT_CRL1` (`CRL_ID`),
  CONSTRAINT `FK_CERT_CRL1` FOREIGN KEY (`CRL_ID`) REFERENCES `CRL_INFO` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_CERT_ISSUER1` FOREIGN KEY (`IID`) REFERENCES `ISSUER` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='certificate information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CERT`
--

LOCK TABLES `CERT` WRITE;
/*!40000 ALTER TABLE `CERT` DISABLE KEYS */;
/*!40000 ALTER TABLE `CERT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CRL_INFO`
--

DROP TABLE IF EXISTS `CRL_INFO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `CRL_INFO` (
  `ID` int(11) NOT NULL,
  `NAME` varchar(100) NOT NULL,
  `INFO` varchar(1000) NOT NULL COMMENT 'CRL information',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CRL_INFO`
--

LOCK TABLES `CRL_INFO` WRITE;
/*!40000 ALTER TABLE `CRL_INFO` DISABLE KEYS */;
/*!40000 ALTER TABLE `CRL_INFO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DBSCHEMA`
--

DROP TABLE IF EXISTS `DBSCHEMA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `DBSCHEMA` (
  `NAME` varchar(45) NOT NULL,
  `VALUE2` varchar(100) NOT NULL,
  PRIMARY KEY (`NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='database schema information';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DBSCHEMA`
--

LOCK TABLES `DBSCHEMA` WRITE;
/*!40000 ALTER TABLE `DBSCHEMA` DISABLE KEYS */;
INSERT INTO `DBSCHEMA` VALUES ('CERTHASH_ALGO','SHA256'),('VERSION','4'),('X500NAME_MAXLEN','350');
/*!40000 ALTER TABLE `DBSCHEMA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ISSUER`
--

DROP TABLE IF EXISTS `ISSUER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ISSUER` (
  `ID` smallint(6) NOT NULL,
  `SUBJECT` varchar(350) NOT NULL,
  `NBEFORE` bigint(20) NOT NULL COMMENT 'notBefore of certificate, seconds since January 1, 1970, 00:00:00 GMT',
  `NAFTER` bigint(20) NOT NULL COMMENT 'notAfter of certificate, seconds since January 1, 1970, 00:00:00 GMT',
  `S1C` char(28) NOT NULL COMMENT 'base64 enoded SHA1 sum of the certificate',
  `REV_INFO` varchar(200) DEFAULT NULL COMMENT 'CA revocation information',
  `CERT` varchar(6000) NOT NULL,
  `CRL_ID` int(11) DEFAULT NULL COMMENT 'CRL ID, only present for entry imported from CRL, and only if exactly one CRL is available for this CA',
  PRIMARY KEY (`ID`),
  KEY `FK_ISSUER_CRL1` (`CRL_ID`),
  CONSTRAINT `FK_ISSUER_CRL1` FOREIGN KEY (`CRL_ID`) REFERENCES `CRL_INFO` (`ID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ISSUER`
--

LOCK TABLES `ISSUER` WRITE;
/*!40000 ALTER TABLE `ISSUER` DISABLE KEYS */;
/*!40000 ALTER TABLE `ISSUER` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-01  7:33:50
