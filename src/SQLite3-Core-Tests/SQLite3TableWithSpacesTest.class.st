Class {
	#name : #SQLite3TableWithSpacesTest,
	#superclass : #SQLite3TableBasedTest,
	#category : #'SQLite3-Core-Tests-Base'
}

{ #category : #accessing }
SQLite3TableWithSpacesTest >> tableCreationScript [

	^'CREATE TABLE "ANOTHER TABLE"
(
    [ID] INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    [SOME NAME] NVARCHAR(120)
)'
]

{ #category : #tests }
SQLite3TableWithSpacesTest >> testColumnNameHasSpace [

	self assert: table columnNames size equals: 2.
	self assert: table columnNames second equals: 'SOME NAME'
]

{ #category : #tests }
SQLite3TableWithSpacesTest >> testPrintStringHasTableNameWithSpace [

	self assert: table printString equals: 'a SQLite3Table("ANOTHER TABLE")'
]
