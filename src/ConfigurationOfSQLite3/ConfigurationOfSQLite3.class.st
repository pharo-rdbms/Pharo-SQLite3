"
Configuration for SQLite 3
"
Class {
	#name : #ConfigurationOfSQLite3,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfSQLite3
}

{ #category : #private }
ConfigurationOfSQLite3 class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #private }
ConfigurationOfSQLite3 class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), bootstrap ConfigurationOfMetacello (using old Gofer API), then load the latest 
	version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [
		Smalltalk at: #Gofer ifAbsent: [
			"Current version of Gofer from which to bootstrap - as of 1.0-beta.15"
			self bootstrapPackage: 'Gofer-lr.83' from: 'http://seaside.gemstone.com/ss/metacello' ].
		Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
			gofer := goferClass new
				url: 'http://seaside.gemstone.com/ss/metacello';
				yourself.
			[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
			gofer load ].
		"load 'default' group of Metacello"
		(Smalltalk at: #ConfigurationOfMetacello) perform: #load ]
]

{ #category : #'metacello tool support' }
ConfigurationOfSQLite3 class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfSQLite3 class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #loading }
ConfigurationOfSQLite3 class >> load [
	"self load"

	^self project latestVersion load
]

{ #category : #'metacello tool support' }
ConfigurationOfSQLite3 class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfSQLite3 class >> project [

	^self new project
]

{ #category : #'outdated - baselines' }
ConfigurationOfSQLite3 >> baseline10: spec [
    <version: '1.0-baseline'>
    
    spec for: #common do: [
        spec 
			blessing: #baseline;
			description: '1.0 baseline for SQLite 3';
			repository: 'http://smalltalkhub.com/mc/TorstenBergmann/SQLite/main'.     
			 
        spec package: 'SQLite3-Core' with: [ spec requires: #('FFI' ) ].
		 spec package: 'SQLite3-Tests' with: [ spec requires: #('SQLite3-Core' ) ].		
				
		 spec
			group: 'default' with: #('SQLite3-Core' );
			group: 'Tests' with: #('SQLite3-Tests' ).
							
	  spec
			project: 'FFI' with: [
				spec
					className: 'ConfigurationOfFFI';
					file: 'ConfigurationOfFFI';
					version: '1.0-baseline';
					repository: 'http://www.squeaksource.com/MetacelloRepository' ].
    ]
      
        

]

{ #category : #'symbolic versions' }
ConfigurationOfSQLite3 >> dev: spec [
	<version: #'dev'>

	spec for: #'common' do: [ 
		spec
			baseline: 'SQLite3' with: [ 
				spec 
					className: 'BaselineOfSQLite3';
					repository: 'github://pharo-rdbms/Pharo-SQLite3:master/src' ]]
]

{ #category : #'symbolic versions' }
ConfigurationOfSQLite3 >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: 'dev'
]

{ #category : #accessing }
ConfigurationOfSQLite3 >> project [

	^ project ifNil: [ | constructor |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		constructor := (Smalltalk at: #MetacelloVersionConstructor) on: self.
		project := constructor project.
		project loadType: #linear.
		project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfSQLite3 >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '1.5.0'.

]

{ #category : #'outdated - versions' }
ConfigurationOfSQLite3 >> version10: spec [
	<version: '1.0' imports: #('1.0-baseline')>
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'first release'. 
		spec author: 'Torsten Bergmann'.
		spec timestamp: '1/25/2010 8:49'.
		spec 
			project: 'FFI' with: '1.0'.	 
		spec package: 'SQLite3-Core' with: 'SQLite3-Core-tbn.1'.
		spec package: 'SQLite3-Tests' with: 'SQLite3-Tests-tbn.1'.		
	]
]

{ #category : #'outdated - versions' }
ConfigurationOfSQLite3 >> version11: spec [
	<version: '1.1' imports: #('1.0-baseline')>
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'release with newer FFI'. 
		spec author: 'Torsten Bergmann'.
		spec timestamp: '2/18/2010 0:10'.
		spec 
			project: 'FFI' with: '1.2'.	 
		spec package: 'SQLite3-Core' with: 'SQLite3-Core-tbn.1'.
		spec package: 'SQLite3-Tests' with: 'SQLite3-Tests-tbn.1'.		
	]
]

{ #category : #'outdated - versions' }
ConfigurationOfSQLite3 >> version12: spec [
	<version: '1.2' imports: #('1.0-baseline')>
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'release with working on Mac too'. 
		spec author: 'Torsten Bergmann'.
		spec timestamp: '5/19/2010 0:10'.
		spec 
			project: 'FFI' with: '1.2'.	 
		spec package: 'SQLite3-Core' with: 'SQLite3-Core-tbn.5'.
		spec package: 'SQLite3-Tests' with: 'SQLite3-Tests-spd.2'.		
	]
]

{ #category : #'outdated - versions' }
ConfigurationOfSQLite3 >> version13: spec [
	<version: '1.3' imports: #('1.0-baseline')>
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'adopt to new file system API'. 
		spec author: 'Torsten Bergmann'.
		spec timestamp: '3/13/2013 0:10'.
		spec 
			project: 'FFI' with: '1.7'.	 
		spec package: 'SQLite3-Core' with: 'SQLite3-Core-ar.8'.
		spec package: 'SQLite3-Tests' with: 'SQLite3-Tests-tbn.5'.		
	]
]

{ #category : #'outdated - versions' }
ConfigurationOfSQLite3 >> version14: spec [
	<version: '1.4' imports: #('1.0-baseline')>
	
	spec for: #common do: [
		spec blessing: #release.
		spec description: 'Pharo 3.0 with newer FFI'. 
		spec author: 'Torsten Bergmann'.
		spec timestamp: '3/13/2013 0:10'.
		spec 
			project: 'FFI' with: '1.8'.	 
		spec package: 'SQLite3-Core' with: 'SQLite3-Core-ar.8'.
		spec package: 'SQLite3-Tests' with: 'SQLite3-Tests-TorstenBergmann.5'.		
	]
]

{ #category : #versions }
ConfigurationOfSQLite3 >> version150: spec [
	<version: '1.5.0'>

	spec for: #'common' do: [ 
		spec
			baseline: 'SQLite3' with: [ 
				spec 
					className: 'BaselineOfSQLite3';
					repository: 'github://pharo-rdbms/Pharo-SQLite3:1.5.0/src' ]]
]
