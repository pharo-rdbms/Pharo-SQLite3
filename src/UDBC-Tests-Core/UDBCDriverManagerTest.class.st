"
Unit tests for UDBCDriverManager
"
Class {
	#name : #UDBCDriverManagerTest,
	#superclass : #TestCase,
	#instVars : [
		'manager'
	],
	#category : #'UDBC-Tests-Core-Driver-Management'
}

{ #category : #'private - utilities' }
UDBCDriverManagerTest >> newMockDriver [

	^UDBCMockDatabaseDriver new
]

{ #category : #running }
UDBCDriverManagerTest >> setUp [

	super setUp.
	manager := UDBCDriverManager new.
]

{ #category : #running }
UDBCDriverManagerTest >> tearDown [

	manager := nil.
	super tearDown.
	
]

{ #category : #tests }
UDBCDriverManagerTest >> testAccessingAvailableDriversYieldsDriver [

	| driver |
	driver := self newMockDriver.
	manager subscribeDriver: driver.
	
	self assert: (manager driverAt: driver driverId) equals: driver
]

{ #category : #tests }
UDBCDriverManagerTest >> testAccessingUnavailableDriversRaisesError [

	self should: [manager driverAt: 1 ] raise: Error
]

{ #category : #tests }
UDBCDriverManagerTest >> testAvailableDriversDoNotListCollectedDrivers [
	
	manager subscribeDriver: self newMockDriver.
	Smalltalk garbageCollect.
	self assert: manager availableDrivers equals: #()
]

{ #category : #tests }
UDBCDriverManagerTest >> testAvailableDriversListsSubscribedDrivers [
	| driver id |
	driver := self newMockDriver.
	id := driver driverId.
	manager subscribeDriver: driver.
	self assert: manager availableDrivers equals: {id}
]

{ #category : #tests }
UDBCDriverManagerTest >> testDriverManagerIsInitiallyEmpty [
 
	self assert: manager availableDrivers equals: #()
]

{ #category : #tests }
UDBCDriverManagerTest >> testSubscribeDriver [

	| driver |
	driver := self newMockDriver.
	manager subscribeDriver: driver.
	
	self assert: (manager isAvailable: driver driverId)
]

{ #category : #tests }
UDBCDriverManagerTest >> testSubscribeIsWeak [

	|   driver id |
	driver := self newMockDriver.
	id := driver driverId.
	manager subscribeDriver: driver.
	
	driver := nil.
	Smalltalk garbageCollect.
	self assert: (manager isAvailable: id) not
]

{ #category : #tests }
UDBCDriverManagerTest >> testSubscribeTwiceReplaces [
	| driver |
	driver := self newMockDriver.
	manager subscribeDriver: driver.
	manager subscribeDriver: driver.
	self assert: manager availableDrivers equals: {driver driverId}
]
