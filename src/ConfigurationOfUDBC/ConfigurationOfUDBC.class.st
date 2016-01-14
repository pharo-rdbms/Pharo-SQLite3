"
Configuration for UDBC - Universal database connectivity
"
Class {
	#name : #ConfigurationOfUDBC,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfUDBC
}

{ #category : #'development support' }
ConfigurationOfUDBC class >> DevelopmentSupport [

"See the methods in the 'development support' category on the class-side of MetacelloBaseConfiguration. Decide what development support methods you would like to use and copy them the the class-side of your configuration."
	<apiDocumentation>
]

{ #category : #private }
ConfigurationOfUDBC class >> baseConfigurationClassIfAbsent: aBlock [

	^Smalltalk
		at: #'ConfigurationOf'
		ifAbsent: [ 
			self ensureMetacelloBaseConfiguration.
			Smalltalk at: #'ConfigurationOf' ifAbsent: aBlock ].
]

{ #category : #catalog }
ConfigurationOfUDBC class >> catalogChangeLog [
	"Returns a paragraph describing the most important changes in the configuration class."
	^ ''
]

{ #category : #catalog }
ConfigurationOfUDBC class >> catalogContactInfo [
	"Returns a paragraph describing contact information such as email, mailing lists and website."
	^ 'Contact the authors on the pharo mailinglist'
]

{ #category : #catalog }
ConfigurationOfUDBC class >> catalogDescription [
	"Returns a paragraph describing the project"
	^ 'UDBC - Universal Database connectivity for Pharo'
]

{ #category : #catalog }
ConfigurationOfUDBC class >> catalogKeyClassesAndExample [
	"Returns a paragraph or more describing the key classes of your project. You can use Pillar/Pier syntax to layout out the text i.e., ==Code== and - for bullet."
	^ ' '
]

{ #category : #catalog }
ConfigurationOfUDBC class >> catalogKeywords [
	"Returns an array of symbols"
	^ #(database rdbms) 
]

{ #category : #private }
ConfigurationOfUDBC class >> ensureMetacello [

	(self baseConfigurationClassIfAbsent: []) ensureMetacello
]

{ #category : #private }
ConfigurationOfUDBC class >> ensureMetacelloBaseConfiguration [
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
ConfigurationOfUDBC class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #loading }
ConfigurationOfUDBC class >> load [
	"Load the #stable version defined for this platform. The #stable version is the version that is recommended to be used on this platform."

	"self load"

	<apiDocumentation>
	^(self project version: #stable) load
]

{ #category : #loading }
ConfigurationOfUDBC class >> loadBleedingEdge [
	"Load the latest versions of the mcz files defined for this project. It is not likely that the #bleedingEdge has been tested."

	"self loadBleedingEdge"

	<apiDocumentation>
	^(self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfUDBC class >> loadDevelopment [
	"Load the #development version defined for this platform. The #development version will change over time and is not expected to be stable."

	"self loadDevelopment"

	<apiDocumentation>
	^(self project version: #development) load
]

{ #category : #accessing }
ConfigurationOfUDBC class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfUDBC class >> validate [
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
ConfigurationOfUDBC >> baseline01: spec [
	<version: '0.1-baseline'>

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
			package: #'UDBC-Tests-SQLite-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-SQLite-Core' ). ];
			package: #'UDBC-PostgreSQL-Core';
			package: #'UDBC-Tests-PostgreSQL-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-PostgreSQL-Core' ). ];
			package: #'UDBC-MySQL-Core';
			package: #'UDBC-Tests-MySQL-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-MySQL-Core' ). ];
			package: #'UDBC-OpenDBX-Base';
			package: #'UDBC-OpenDBX-Core' with: [
				spec requires: #(#'UDBC-OpenDBX-Base' ). ];
			package: #'UDBC-Tests-OpenDBX-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-OpenDBX-Core' ). ].
		spec 
			group: 'Core' with: #(#'UDBC-Core' );
			group: 'SQLite' with: #(#'UDBC-Tests-SQLite-Core' );
			group: 'MySQL' with: #(#'UDBC-Tests-MySQL-Core' );
			group: 'OpenDBX' with: #(#'UDBC-Tests-OpenDBX-Core' );
			group: 'PostgreSQL' with: #(#'UDBC-Tests-PostgreSQL-Core' );
			group: 'Tests' with: #('SQLite' 'MySQL' 'OpenDBX' 'PostgreSQL' );
			group: 'default' with: #('all' );
			group: 'all' with: #('Tests' ). ].

]

{ #category : #accessing }
ConfigurationOfUDBC >> customProjectAttributes [
    "Edit to return a collection of any custom attributes e.g. for conditional loading: Array with: #'Condition1' with: #'Condition2.
	For more information see: http://code.google.com/p/metacello/wiki/CustomProjectAttrributes "

    ^ #()
]

{ #category : #'symbolic versions' }
ConfigurationOfUDBC >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '0.1-baseline'.

]

{ #category : #accessing }
ConfigurationOfUDBC >> project [
    ^ project
        ifNil: [ 
            "Bootstrap Metacello if it is not already loaded"
            self class ensureMetacello.
            project := MetacelloMCProject new projectAttributes: self customProjectAttributes.	"Create the Metacello project"
            (Smalltalk at: #'MetacelloVersionConstructor') on: self project: project.	"Construct the project"
            project loadType: #'linear'.	"change to #atomic if desired"
            project ]
]
