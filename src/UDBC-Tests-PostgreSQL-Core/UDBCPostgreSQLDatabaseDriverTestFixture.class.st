"
Test fixture for PostgreSQL
"
Class {
	#name : #UDBCPostgreSQLDatabaseDriverTestFixture,
	#superclass : #UDBCDatabaseDriverTestFixture,
	#category : #'UDBC-Tests-PostgreSQL-Core-Fixtures'
}

{ #category : #'setting up - database' }
UDBCPostgreSQLDatabaseDriverTestFixture >> createDatabase [

	setupConnection execute: 'CREATE DATABASE sodbxtest'.
]

{ #category : #'setting up - database' }
UDBCPostgreSQLDatabaseDriverTestFixture >> createTables [

	self connection execute: 'CREATE TABLE student(
   	   id SERIAL PRIMARY KEY,
	   name_surname VARCHAR,	
	   username VARCHAR(10),
         pass VARCHAR(200),
	   mail VARCHAR(50),
         regular BOOLEAN,
	   age SMALLINT,	   
	   average_grade DECIMAL(9,3),
	   sex CHARACTER(3),
	   description VARCHAR,
	   starting_hour TIME,
	   sign_up_date TIMESTAMP,
	   born_date DATE,
	   nullable_field VARCHAR(64) NULL
	)'.
"The InnoDB engine is in order to have transaction in this table"
	
	self connection execute: 'CREATE TABLE IF NOT EXISTS signature(
	code INTEGER, 
	id_student INTEGER,
	name VARCHAR(100),
	observations VARCHAR(255),
	course_grade INTEGER,
	final_grade INTEGER,
	CONSTRAINT pk_signatures_code PRIMARY KEY (id_student, code)
)'.
"The InnoDB engine is in order to have transaction in this table"

	self connection execute: 'CREATE TABLE IF NOT EXISTS course(
	id_course INTEGER,
	id_student INTEGER,
	signature_code INTEGER,
	starting_date DATE,
	CONSTRAINT pk_courses_id_course PRIMARY KEY (id_student, signature_code)
)'.
"The InnoDB engine is in order to have transaction in this table"

	self connection execute: 'ALTER TABLE signature
	ADD CONSTRAINT se_st_fk FOREIGN KEY (id_student) REFERENCES student(id)'.
]

{ #category : #'setting up - database' }
UDBCPostgreSQLDatabaseDriverTestFixture >> dropDatabase [

	setupConnection execute: 'DROP DATABASE IF EXISTS sodbxtest'.
]

{ #category : #'setting up - database' }
UDBCPostgreSQLDatabaseDriverTestFixture >> dropTables [

	self connection execute: 'DROP TABLE IF EXISTS course CASCADE'.
	self connection execute: 'DROP TABLE IF EXISTS signature CASCADE'. 
	self connection execute: 'DROP TABLE IF EXISTS student CASCADE'.
]
