"
I am a fixture setting up and tearing down the database and tables needed for running tests.

Each of my concrete subclasses implement the particular details of a database vendor. That is, for each driver flavor, one of me should be available.

For insight into my usage, look at the setup and teardown methods in UDBCDatabaseDriverTest
"
Class {
	#name : #UDBCDatabaseDriverTestFixture,
	#superclass : #Object,
	#instVars : [
		'connection',
		'connectionString',
		'setupConnectionString',
		'options',
		'setupConnection'
	],
	#category : #'UDBC-Tests-Core-Fixtures'
}

{ #category : #accessing }
UDBCDatabaseDriverTestFixture >> connection [
	
	^ connection ifNil:[ connection := self newConnection ]
]

{ #category : #accessing }
UDBCDatabaseDriverTestFixture >> connectionString [

	^ connectionString
]

{ #category : #accessing }
UDBCDatabaseDriverTestFixture >> connectionString: aConnectionString [

	connectionString := aConnectionString
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverTestFixture >> createDatabase [

	self subclassResponsibility
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverTestFixture >> createSetupConnection [

	setupConnection := UDBCDatabaseDriver connectToConnectionString: 
		((UDBCConnectionString fromString: setupConnectionString) addOptions: options).
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverTestFixture >> createTables [

	self subclassResponsibility
]

{ #category : #accessing }
UDBCDatabaseDriverTestFixture >> driver [
	
	^ UDBCDatabaseDriver driverAt: (UDBCConnectionString fromString: setupConnectionString) driverId
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverTestFixture >> dropDatabase [

	self subclassResponsibility
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverTestFixture >> dropTables [

	self subclassResponsibility
]

{ #category : #'setting up - database' }
UDBCDatabaseDriverTestFixture >> newConnection [

	^ UDBCDatabaseDriver connectToConnectionString: 
		((UDBCConnectionString fromString: connectionString) addOptions: options).
]

{ #category : #'setting up' }
UDBCDatabaseDriverTestFixture >> setUp [
	"We create the connection that will create the database. The other one will be created lazily"

	self setUp: Dictionary new
]

{ #category : #'setting up' }
UDBCDatabaseDriverTestFixture >> setUp: someOptions [

	"We create the connection that will create the database. The other one will be created lazily"
	options := someOptions.
	connection := setupConnection := nil.
	self createSetupConnection.
	self dropDatabase.
	self createDatabase.
	self createTables.
]

{ #category : #accessing }
UDBCDatabaseDriverTestFixture >> setupConnectionString: aConnectionString [

	setupConnectionString := aConnectionString
]

{ #category : #'setting up' }
UDBCDatabaseDriverTestFixture >> tearDown [

	options := nil.
	[connection ifNotNil: [ 
		connection close.
		connection := nil. ].]
		ensure: [
		[self dropDatabase.]
			ensure: [
			setupConnection ifNotNil: [
			setupConnection close.
			setupConnection := nil ]]]
]
