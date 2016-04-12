"
This is the basic interface to instantiate and look for database drivers.

Database drivers subscribe themselves to a global driver manager using this class. Then, they are instantiated through it.

It also describes the minimal interface of all drivers. Its API contains the main methods to execute database queries, prepare statements and manage transactions. Also, to handle the differences between different drivers, this API provides a bunch of supports* methods to check the provided features.
"
Class {
	#name : #UDBCDatabaseDriver,
	#superclass : #Object,
	#instVars : [
		'connectionString',
		'encoding'
	],
	#classVars : [
		'DriverManager'
	],
	#category : #'UDBC-Core-Driver'
}

{ #category : #'driver management' }
UDBCDatabaseDriver class >> availableDrivers [
	<script: 'self availableDrivers inspect'>
	
	^ self driverManager availableDrivers
]

{ #category : #'instance creation' }
UDBCDatabaseDriver class >> connectToConnectionString: aConnectionString [

	| connection |
	connection := self fromConnectionString: aConnectionString.
	connection connect.
	^ connection
]

{ #category : #'driver management' }
UDBCDatabaseDriver class >> driverAt: aDriverId [
	
	^ self driverManager driverAt: aDriverId
]

{ #category : #accessing }
UDBCDatabaseDriver class >> driverId [

	^self subclassResponsibility 
]

{ #category : #'private - accessing' }
UDBCDatabaseDriver class >> driverManager [
	
	^DriverManager ifNil: [ DriverManager := UDBCDriverManager new ]
]

{ #category : #'instance creation' }
UDBCDatabaseDriver class >> fromConnectionString: string [

	| connectionString |
	connectionString := string isString
		ifTrue: [ UDBCConnectionString fromString: string ]
		ifFalse: [ string ].
	^ (self driverAt: connectionString driverId) fromConnectionString: connectionString
]

{ #category : #'driver management' }
UDBCDatabaseDriver class >> isDriverAvailable: aKey [
	
	^ self driverManager isAvailable: aKey
]

{ #category : #'driver management' }
UDBCDatabaseDriver class >> subscribeDriver [

	self driverManager subscribeDriver: self
]

{ #category : #'testing - encoding' }
UDBCDatabaseDriver class >> supportsEncoding: anEncoding [
	
	self subclassResponsibility
]

{ #category : #testing }
UDBCDatabaseDriver >> affectsOnlyChangedRows [

	"Tests if the current database driver will inform the number of effectively affected rows during a INSERT/UPDATE/DELETE query or just all that were selected by the WHERE clause"
	^ false
]

{ #category : #accessing }
UDBCDatabaseDriver >> backend [
	
	^ self subclassResponsibility
]

{ #category : #transactions }
UDBCDatabaseDriver >> beginTransaction [
	"Starts a database transaction"
	
	self subclassResponsibility
]

{ #category : #'connection open/close' }
UDBCDatabaseDriver >> close [
	"Closes the current connection"
	
	self subclassResponsibility
]

{ #category : #transactions }
UDBCDatabaseDriver >> commitTransaction [
	"Commits the current database transaction"
	
	self subclassResponsibility
]

{ #category : #'connection open/close' }
UDBCDatabaseDriver >> connect [
	"Opens the connection to the configured database"
	
	self subclassResponsibility
]

{ #category : #accessing }
UDBCDatabaseDriver >> connectionString [
	
	^ connectionString
]

{ #category : #accessing }
UDBCDatabaseDriver >> connectionString: aUDBCConnectionString [ 

	connectionString := aUDBCConnectionString
]

{ #category : #statement }
UDBCDatabaseDriver >> createStatement [
	"Creates an empty statement object"

	self subclassResponsibility
]

{ #category : #statement }
UDBCDatabaseDriver >> createStatement: aSQLString [
	"Creates a statement object from a sql query"
	
	self subclassResponsibility
]

{ #category : #transactions }
UDBCDatabaseDriver >> defaultValueAutoCommit [
	"Retrieves the expected default value of autocommit for the current driver.
	Autocommit should not be used in a general fashion: each database vendor implements it differently."

	self subclassResponsibility
]

{ #category : #accessing }
UDBCDatabaseDriver >> driverId [

	^ self class driverId
]

{ #category : #encoding }
UDBCDatabaseDriver >> encoder [
	
	| theEncoding |
	"Returns a Zn encoder corresponding to the configured encoding.
	Default: 'utf8'"
	theEncoding := (self encoding = 'utf8mb4') ifTrue: [ 'utf8' ] ifFalse: [ self encoding ].
	^ ZnCharacterEncoder newForEncoding: theEncoding
]

{ #category : #encoding }
UDBCDatabaseDriver >> encoding [
	"Returns the configured encoding for this driver instance.
	Default: 'utf8'"

	^ encoding ifNil: [ encoding := connectionString optionAt: 'encoding' ifAbsent: 'utf8' ]
]

{ #category : #encoding }
UDBCDatabaseDriver >> encoding: anEncoding [
	"Sets an encoding for the current driver instance.
	Accepted encodings are those supported by ZnCharacterEncoder"

	encoding := anEncoding
]

{ #category : #finalization }
UDBCDatabaseDriver >> execute: aQuery [

	"Executes a SQL query against the database in one roundtrip"
	self subclassResponsibility
]

{ #category : #finalization }
UDBCDatabaseDriver >> finalize [
	"Frees all associated resources of this driver instance. Do nothing by default - subclasses can override this method."
]

{ #category : #transactions }
UDBCDatabaseDriver >> hasAutoCommit [

	"Tests if the current database driver has autocommit enabled or not"
	self subclassResponsibility
]

{ #category : #testing }
UDBCDatabaseDriver >> isConnected [
	"Tests if the connection is alive and connected"

	self subclassResponsibility
]

{ #category : #finalization }
UDBCDatabaseDriver >> isRegisteredForFinalization [
	"Tests if the current driver instance is registered in the weak registry for finalization or not"

	^ WeakRegistry default includes: self
]

{ #category : #testing }
UDBCDatabaseDriver >> notBoundArgumentsFail [
	"Tests if the current database driver fails if a prepared statement contains arguments that are not bound. Some drivers such as Sqlite3 will default unbound arguments to NULL and not fail."

	^ true
]

{ #category : #accessing }
UDBCDatabaseDriver >> numberOfFetchesForSingleExecute [
	"Returns the number of roundtrips a database driver does for a single execute command"
	
	^ 1
]

{ #category : #options }
UDBCDatabaseDriver >> optionAt: aString [
	"It allows to access the configuration options of this driver"

	^ self connectionString optionAt: aString
]

{ #category : #statement }
UDBCDatabaseDriver >> prepare: aQuery [
	"Creates a statement object from a sql query and sends it for its preparation to the database server"

	self subclassResponsibility
]

{ #category : #finalization }
UDBCDatabaseDriver >> register [

	"Registers the current driver into the weak registry for automatic memory management"
	WeakRegistry default add: self
]

{ #category : #transactions }
UDBCDatabaseDriver >> rollbackTransaction [
	"Rollbacks the current database transaction"

	self subclassResponsibility
]

{ #category : #testing }
UDBCDatabaseDriver >> supportsAutomaticQueryEncoding [
	
	"Tests if the current database driver supports not-encoded strings inside a sql query.
	When true the driver will encode the full request into the configured encoding and the user does not have to manage it.
	When false the driver does not support encoding the query and thus the user has to encode manually arguments if building a query by String concatenation.
	
	Alternatively, use prepared statements when supported to avoid this issue"
	self subclassResponsibility
]

{ #category : #testing }
UDBCDatabaseDriver >> supportsCursoredFetch [

	"Tests if the current database driver supports cursored fetches. i.e., bringing database rows in batch instead of all in a row."
	^ self subclassResponsibility
]

{ #category : #encoding }
UDBCDatabaseDriver >> supportsEncoding: anEncoding [
	"Returns a boolean that indicates if the current driver supports a particular encoding"

	^ self class supportsEncoding: anEncoding
]

{ #category : #testing }
UDBCDatabaseDriver >> supportsPreparedStatements [

	"Tests if the current database driver supports prepared statements"
	^ false
]

{ #category : #testing }
UDBCDatabaseDriver >> supportsRetrievingGeneratedKeys [
	"Tests if the current database driver supports retrieving auto generated keys/ids without an extra query"

	^ false
]

{ #category : #finalization }
UDBCDatabaseDriver >> unregister [

	"Unregisters the current driver from the weak registry. Calling this means that finalization will be manual"
	WeakRegistry default remove: self ifAbsent: [  ]
]
