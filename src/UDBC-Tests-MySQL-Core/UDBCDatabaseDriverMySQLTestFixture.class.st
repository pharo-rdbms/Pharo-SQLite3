"
Test fixture for MySQL
"
Class {
	#name : #UDBCDatabaseDriverMySQLTestFixture,
	#superclass : #UDBCDatabaseDriverTestFixture,
	#category : #'UDBC-Tests-MySQL-Core-Fixtures'
}

{ #category : #'setting up - database' }
UDBCDatabaseDriverMySQLTestFixture >> createDatabase [

	setupConnection execute: 'CREATE DATABASE sodbxtest
	CHARACTER SET utf8mb4'.
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverMySQLTestFixture >> createTables [

	self connection execute: 'CREATE TABLE IF NOT EXISTS student(
	   id INTEGER AUTO_INCREMENT,
	   username VARCHAR(10),
	   pass VARCHAR(50),
	   mail VARCHAR(50),
	   name_surname VARCHAR(30),	   
	   regular BOOLEAN,
	   age SMALLINT,	   
	   average_grade DECIMAL(9,3),
	   sex CHARACTER(3),
	   description VARCHAR(200),
	   starting_hour TIME,
	   sign_up_date DATETIME,
	   born_date DATE,
	   nullable_field VARCHAR(64) NULL,
	  CONSTRAINT pk_students_id PRIMARY KEY (id)
	) ENGINE = InnoDB ;
'.
"The InnoDB engine is in order to have transaction in this table"
	
	self connection execute: 'CREATE TABLE IF NOT EXISTS signature(
	code INTEGER, 
	id_student INTEGER,
	name CHAR(100),
	observations VARCHAR(255),
	course_grade INTEGER,
	final_grade INTEGER,
	CONSTRAINT pk_signatures_code PRIMARY KEY (id_student, code)
) ENGINE = InnoDB '.
"The InnoDB engine is in order to have transaction in this table"

	self connection execute: 'CREATE TABLE IF NOT EXISTS course(
	id_course INTEGER,
	id_student INTEGER,
	signature_code INTEGER,
	starting_date DATE,
	CONSTRAINT pk_courses_id_course PRIMARY KEY (id_student, signature_code)
) ENGINE = InnoDB '.
"The InnoDB engine is in order to have transaction in this table"

	self connection execute: 'ALTER TABLE signature
	ADD CONSTRAINT se_st_fk FOREIGN KEY (id_student) REFERENCES student(id)'.
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverMySQLTestFixture >> dropDatabase [

	setupConnection ifNil: [ ^ self ].
	setupConnection execute: 'drop database if exists sodbxtest'.
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverMySQLTestFixture >> dropTables [

	self connection execute: 'ALTER TABLE signature
	DROP FOREIGN KEY se_st_fk'.
	self connection execute: 'DROP TABLE IF EXISTS course CASCADE'.
	self connection execute: 'DROP TABLE IF EXISTS signature CASCADE'. 
	self connection execute: 'DROP TABLE IF EXISTS student CASCADE'.
]
