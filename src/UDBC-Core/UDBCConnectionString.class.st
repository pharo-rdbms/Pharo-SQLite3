"
I am a database connection string for url-like connections. For example:

mysql://localhost:5432/sodbxtest?&user=sodbxtest&password=sodbxtest

More generally, a connection string is written as:

driver://host:port/database?key=value&key2=value2

Internally, I use ZnUrl to parse and access the data inside a connection string.
"
Class {
	#name : #UDBCConnectionString,
	#superclass : #Object,
	#instVars : [
		'connectionStringURL',
		'options'
	],
	#category : #'UDBC-Core-Connections'
}

{ #category : #examples }
UDBCConnectionString class >> exampleMySQL [	
	^ self
		fromString:
			'mysql://localhost:5432/sodbxtest?&user=sodbxtest&password=sodbxtest'
]

{ #category : #'instance creation' }
UDBCConnectionString class >> fromString: aString [

	^(self new)
		initializeFromString: aString;
		yourself
]

{ #category : #private }
UDBCConnectionString >> addOptions: aDictionaryOfOptions [

	self options addAll: aDictionaryOfOptions
]

{ #category : #'accessing - server' }
UDBCConnectionString >> database [
	
	^ connectionStringURL path
]

{ #category : #accessing }
UDBCConnectionString >> driverId [
	
	^ connectionStringURL scheme
]

{ #category : #'accessing - server' }
UDBCConnectionString >> host [
	
	^ connectionStringURL host
]

{ #category : #initialization }
UDBCConnectionString >> initializeFromString: aString [ 

	connectionStringURL:= UDBCConnectionStringURL fromString: aString
	 
]

{ #category : #'accessing - options' }
UDBCConnectionString >> optionAt: aString [ 
	
	^ self options at: aString ifAbsent: ''
]

{ #category : #'accessing - options' }
UDBCConnectionString >> optionAt: aString ifAbsent: aBlockClosure [ 
	
	^ self options at: aString ifAbsent: aBlockClosure
]

{ #category : #private }
UDBCConnectionString >> options [
	^ options
		ifNotNil:
			[ options := connectionStringURL query
				ifNil: [ Dictionary new ]
				ifNotNil: #asDictionary ]
]

{ #category : #accessing }
UDBCConnectionString >> password [
	
	^ self optionAt: 'password'
]

{ #category : #'accessing - server' }
UDBCConnectionString >> port [
	
	^ connectionStringURL port
]

{ #category : #accessing }
UDBCConnectionString >> user [
	
	^ self optionAt: 'user'
]
