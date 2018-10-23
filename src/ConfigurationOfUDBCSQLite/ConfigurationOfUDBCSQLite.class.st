"
Configuration for UDBC - Universal database connectivity - that loads only SQLite.
"
Class {
	#name : #ConfigurationOfUDBCSQLite,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfUDBCSQLite
}

{ #category : #'development support' }
ConfigurationOfUDBCSQLite class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>
]

{ #category : #private }
ConfigurationOfUDBCSQLite class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #'ConfigurationOf'
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #'ConfigurationOf' ifAbsent: aBlock ].
]

{ #category : #private }
ConfigurationOfUDBCSQLite class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfUDBCSQLite class >> ensureMetacelloBaseConfiguration [
  Smalltalk
    at: #'ConfigurationOf'
    ifAbsent: [ 
      | repository version |
      repository := MCHttpRepository
        location: 'http://smalltalkhub.com/mc/dkh/metacello/main'
        user: ''
        password: ''.
      repository
        versionReaderForFileNamed: 'Metacello-Base-dkh.107'
        do: [ :reader | 
          version := reader version.
          version load.
          version workingCopy repositoryGroup addRepository: repository ] ]
]

{ #category : #'metacello tool support' }
ConfigurationOfUDBCSQLite class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfUDBCSQLite class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfUDBCSQLite class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfUDBCSQLite class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfUDBCSQLite class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfUDBCSQLite class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."

	"self validate"

	<apiDocumentation>
	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #baselines }
ConfigurationOfUDBCSQLite >> baseline01: spec [
	<version: '0.1-baseline'>
	"This is ConfigOfUDBC>>baseline01 minus all non-SQLite stuff."
	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/TorstenBergmann/UDBC/main/'.
		spec 
			package: #'UDBC-Core';
			package: #'UDBC-Tests-Core' with: [
				spec requires: #(#'UDBC-Core' ). ];
			package: #'UDBC-SQLite-Base';
			package: #'UDBC-SQLite-Core' with: [
				spec requires: #(#'UDBC-SQLite-Base' ). ];
			package: #'UDBC-Tests-SQLite-Base' with: [
				spec requires: #(#'UDBC-SQLite-Base' ). ];
			package: #'UDBC-Tests-SQLite-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-Tests-SQLite-Base' #'UDBC-SQLite-Core' ). ].
		
		spec 
			group: 'SQLite' with: #(#'UDBC-Tests-SQLite-Core' );
			group: 'Tests' with: #('SQLite');
			group: 'all' with: #('Tests' );
			group: 'Core' with: #(#'UDBC-Core' );
			group: 'default' with: #('all' );
			group: 'Base' with: #(). ]

]

{ #category : #baselines }
ConfigurationOfUDBCSQLite >> baseline02: spec [
	<version: '0.2-baseline'>
	"This is baseline01 with specific UDBC-SQLite versions."
	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/TorstenBergmann/UDBC/main/'.
		spec 
			package: #'UDBC-Core';
			package: #'UDBC-Tests-Core' with: [
				spec requires: #(#'UDBC-Core' ). ];
			package: #'UDBC-SQLite-Base' with: 'UDBC-SQLite-Base-PierceNg.51';
			package: #'UDBC-SQLite-Core' with: [
				spec requires: #(#'UDBC-SQLite-Base' ). ];
			package: #'UDBC-Tests-SQLite-Base' with: 'UDBC-Tests-SQLite-Base-PierceNg.22';
			package: #'UDBC-Tests-SQLite-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-Tests-SQLite-Base' #'UDBC-SQLite-Core' ). ].
		
		spec 
			group: 'SQLite' with: #(#'UDBC-Tests-SQLite-Core' );
			group: 'Tests' with: #('SQLite');
			group: 'all' with: #('Tests' );
			group: 'Core' with: #(#'UDBC-Core' );
			group: 'default' with: #('all' );
			group: 'Base' with: #(). ]

]

{ #category : #accessing }
ConfigurationOfUDBCSQLite >> customProjectAttributes [
    "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes "

    ^ #()
]

{ #category : #accessing }
ConfigurationOfUDBCSQLite >> project [
    ^ project
        ifNil: [ 
            "Bootstrap Metacello if it is not already loaded"
            self class ensureMetacello.
            project := MetacelloMCProject new projectAttributes: self customProjectAttributes.	"Create the Metacello project"
            (Smalltalk at: #'MetacelloVersionConstructor') on: self project: project.	"Construct the project"
            project loadType: #'linear'.	"change to #atomic if desired"
            project ]
]

{ #category : #'symbolic versions' }
ConfigurationOfUDBCSQLite >> stable: spec [
	<symbolicVersion: #'stable'>
	
	spec for: #'common' version: '0.1-baseline'
]

{ #category : #'symbolic versions' }
ConfigurationOfUDBCSQLite >> stableNoBooleanMagic: spec [
	<symbolicVersion: #'stableNoBooleanMagic'>
	
	spec for: #'common' version: '0.2-baseline'
]
