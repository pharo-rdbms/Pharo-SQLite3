Extension { #name : #UDBCDatabaseDriver }

{ #category : #'*UDBC-Tests-Core-tests' }
UDBCDatabaseDriver class >> newFixture [

	^ self subclassResponsibility
]

{ #category : #'*UDBC-Tests-Core-tests' }
UDBCDatabaseDriver class >> newFixtureForConnectionString: aConnectionString [

	^ self newFixture
]
