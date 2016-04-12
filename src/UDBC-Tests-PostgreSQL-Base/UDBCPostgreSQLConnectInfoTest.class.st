"
A test for UDBCPostgreSQLConnectInfo
"
Class {
	#name : #UDBCPostgreSQLConnectInfoTest,
	#superclass : #TestCase,
	#category : #'UDBC-Tests-PostgreSQL-Base-Connections'
}

{ #category : #accessing }
UDBCPostgreSQLConnectInfoTest >> defaultTestClass [

	^UDBCPostgreSQLConnectInfo
]

{ #category : #tests }
UDBCPostgreSQLConnectInfoTest >> testDefaultClientEncoding [

	| info |
	info := self defaultTestClass new.
	self assert: info clientEncoding equals: #utf8

]

{ #category : #tests }
UDBCPostgreSQLConnectInfoTest >> testInstanceCreation [
	| info |
	info := self defaultTestClass 
				host: 'localhost'
				port: 5432
				database: 'mydb'
				user: 'pharo'
				password: 'rules'.
				
	self 
		assert: info host equals: 'localhost';
		assert: info port equals: 5432;	
		assert: info database equals: 'mydb';	
		assert: info user equals: 'pharo';	
		assert: info password equals: 'rules'
]

{ #category : #tests }
UDBCPostgreSQLConnectInfoTest >> testInstanceCreationFull [
	| info |
	info := self defaultTestClass
				host: 'localhost'
				port: 5432
				database: 'mydb'
				user: 'pharo'
				password: 'rules'
				extraArguments: #('arg1' 'arg2') 
				debugTTY: true.
				
	self 
		assert: info host equals: 'localhost';
		assert: info port equals: 5432;	
		assert: info database equals: 'mydb';	
		assert: info user equals: 'pharo';	
		assert: info password equals: 'rules';
		assert: info extraArguments equals: #('arg1' 'arg2');
		assert: info debugTTY equals: true
]
