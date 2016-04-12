"
A connection info 
"
Class {
	#name : #UDBCPostgreSQLConnectInfo,
	#superclass : #Object,
	#instVars : [
		'host',
		'port',
		'database',
		'user',
		'password',
		'debugTTY',
		'extraArguments',
		'clientEncoding'
	],
	#category : #'UDBC-PostgreSQL-Base-Connections'
}

{ #category : #examples }
UDBCPostgreSQLConnectInfo class >> example [

	^self host: 'localhost' port: 5432 database: 'simple' user: '' password: ''
]

{ #category : #'instance creation' }
UDBCPostgreSQLConnectInfo class >> host: host port: port database: database user: user password: pwd [
	^(self new)
		host: host;
		port: port;
		database: database;
		user: user;
		password: pwd;
		yourself
]

{ #category : #'instance creation' }
UDBCPostgreSQLConnectInfo class >> host: host port: port database: database user: user password: pwd extraArguments: extra debugTTY: debug [
	^(self new)
		host: host;
		port: port;
		database: database;
		user: user;
		password: pwd;
		extraArguments: extra;
		debugTTY: debug;
		yourself
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> clientEncoding [
	clientEncoding ifNil: [ clientEncoding := #utf8 ].
	^clientEncoding 
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> clientEncoding: anObject [
	clientEncoding := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> database [
	^ database
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> database: anObject [
	database := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> debugTTY [
	^ debugTTY
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> debugTTY: anObject [
	debugTTY := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> extraArguments [
	^ extraArguments
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> extraArguments: anObject [
	extraArguments := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> host [
	^ host
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> host: anObject [
	host := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> password [
	^ password
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> password: anObject [
	password := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> port [
	^ port
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> port: anObject [
	port := anObject
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> user [
	^ user
]

{ #category : #accessing }
UDBCPostgreSQLConnectInfo >> user: anObject [
	user := anObject
]
