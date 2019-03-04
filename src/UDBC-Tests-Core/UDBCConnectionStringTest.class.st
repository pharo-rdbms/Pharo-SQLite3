"
Unit test for UDBCCOnnectionString
"
Class {
	#name : #UDBCConnectionStringTest,
	#superclass : #TestCase,
	#category : #'UDBC-Tests-Core-Connections'
}

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionPortInSimpleConnectionString [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111'.
	self assert: driver port equals: '1111'.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringDatabase [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111/adatabase?user=username&password=password'.
	
	self 
		assert: driver database equals: 'adatabase';
		assert: driver port equals: '1111'.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringDefaultDatabase [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111?user=username&password=password'.
	
	self assert: driver database equals: ''.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringDefaultPassword [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111'.
	
	self assert: driver password equals: ''.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringDefaultUser [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111?password=password'.
	
	self assert: driver user equals: ''.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringHost [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111/database?user=username&password=password'.
	
	self assert: driver host equals: 'Host'.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringPassword [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111?password=pa55w0rd'.
	
	self assert: driver password equals: 'pa55w0rd'.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringPort [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111/database?user=username&password=password'.
	
	self assert: driver port equals: '1111'.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringUser [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://Host:1111?user=username&password=password'.
	
	self assert: driver user equals: 'username'.
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringWithInvertedSlashHost [

	| driver |
	driver := UDBCConnectionString fromString: 'someDatabase://c:\somepath'.
	
	self 
		assert: driver host equals: 'c';
		assert: driver port equals: '\somepath'
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringWithLongHost [

	| driver |
	driver := UDBCConnectionString fromString: 'opendbx:///Users/guillermopolito/work/temp/dbxtalk/sodbxtest.db?backend=sqlite3'.

	self 
		assert: driver host equals: '';
		assert: driver database equals: 'Users/guillermopolito/work/temp/dbxtalk/sodbxtest.db'
]

{ #category : #tests }
UDBCConnectionStringTest >> testConnectionStringWithLongWindowsHost [

	| driver |
	driver := UDBCConnectionString fromString: 'opendbx://C:\Users\guillermopolito\work\temp\dbxtalk\sodbxtest.db?backend=sqlite3'.

	self 
		assert: driver host equals: 'C';
		assert: driver port equals: '\Users\guillermopolito\work\temp\dbxtalk\sodbxtest.db'
]
