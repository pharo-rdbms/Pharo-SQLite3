"
A generator to generate the package stub.
"
Class {
	#name : #UDBCPackageStubGenerator,
	#superclass : #Object,
	#instVars : [
		'driverName'
	],
	#classInstVars : [
		'driverName'
	],
	#category : #'UDBC-Common-Tools-Generator'
}

{ #category : #example }
UDBCPackageStubGenerator class >> example [

	| driver |
	driver := UIManager default request: 'Driver name to generate' initialAnswer: 'MySQL'.
	self generatePackagesFor: driver
]

{ #category : #generating }
UDBCPackageStubGenerator class >> generatePackagesFor: aDriverName [
	"Generate all packages for the given driver name"
	
	^(self new)
		driverName: aDriverName;
		generate
]

{ #category : #'private - utilities' }
UDBCPackageStubGenerator >> createPackageNamed: aString [

	^RPackageOrganizer default createPackageNamed: aString
]

{ #category : #accessing }
UDBCPackageStubGenerator >> driverName [
	^ driverName
]

{ #category : #accessing }
UDBCPackageStubGenerator >> driverName: anObject [
	driverName := anObject
]

{ #category : #generating }
UDBCPackageStubGenerator >> generate [
	|base core tools baseTests coreTests toolsTests |
	base := self createPackageNamed: 'UDBC-',driverName,'-Base'.
	base addClassTag: 'Connections'.

	core := self createPackageNamed: 'UDBC-',driverName,'-Core'.
	core addClassTag: 'Driver'.	

	tools 	:= self createPackageNamed: 'UDBC-',driverName,'-Tools'.
	tools addClassTag: 'UI'.	
	tools addClassTag: 'Utilities'.	
		
	baseTests := self createPackageNamed: 'UDBC-Tests-',driverName,'-Base'.
	baseTests addClassTag: 'Connections'.	

	coreTests := self createPackageNamed: 'UDBC-Tests-',driverName,'-Core'.
	coreTests addClassTag: 'Driver'.		
	coreTests addClassTag: 'Fixtures'.			

	toolsTests := self createPackageNamed: 'UDBC-Tests-',driverName,'-Tools'.
	toolsTests addClassTag: 'Utilities'.	
			
]
