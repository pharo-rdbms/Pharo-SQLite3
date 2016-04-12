"
I am a driver implementation to connect with Mysql databases.
I use the binary and textual protocol of mysql, connecting to a database through a socket.
"
Class {
	#name : #UDBCMySQLDatabaseDriver,
	#superclass : #UDBCDatabaseDriver,
	#category : #'UDBC-MySQL-Core-Driver'
}

{ #category : #accessing }
UDBCMySQLDatabaseDriver class >> driverId [

	^ 'mysql'
]

{ #category : #'instance creation' }
UDBCMySQLDatabaseDriver class >> fromConnectionString: aConnectionString [
	
	| connection |
	connection := self new.
	connection connectionString: aConnectionString.
	connection host: aConnectionString host.
	connection port: aConnectionString port asInteger.
	connection database: aConnectionString database.
	connection user: aConnectionString user.
	connection password: aConnectionString password.
	^ connection
]

{ #category : #initialization }
UDBCMySQLDatabaseDriver class >> initialize [

	self subscribeDriver
]

{ #category : #'testing - encoding' }
UDBCMySQLDatabaseDriver class >> supportsEncoding: aString [ 	
	"Mysql only supports in the client encodings that are compatible with ascii.
	Cite: ucs2, utf16, and utf32 cannot be used as a client character set, which means that they do not work for SET NAMES or SET CHARACTER SET."
	
	" check 
	  https://dev.mysql.com/doc/refman/5.5/en/charset-charsets.html
	  https://dev.mysql.com/doc/refman/5.5/en/charset-connection.html"
	
	^ 'utf8' = aString
]
