"
A baseline for SQlite3 support in Pharo
"
Class {
	#name : #BaselineOfSQLite3,
	#superclass : #BaselineOf,
	#category : #BaselineOfSQLite3
}

{ #category : #baselines }
BaselineOfSQLite3 >> baseline: spec [
	<baseline>

	spec
		for: #pharo
		do: [ 
			self setUpDependencies: spec.
			spec
				package: 'SQLite3-Core';
				group: 'Core' with: 'SQLite3-Core';

				package: 'SQLite3-Core-Benchmarks' with: [ spec requires: 'SQLite3-Core' ];
				group: 'Benchmarks' with: 'SQLite3-Core-Benchmarks';
				
				package: 'SQLite3-Core-Tests' with: [ spec requires: 'Core' ];
				group: 'Tests' with: 'SQLite3-Core-Tests';
				
				package: 'SQLite3-Glorp' with: [ spec requires: #('Core' 'Glorp-Core') ];
				group: 'glorp' with: 'SQLite3-Glorp';
				
				package: 'SQLite3-Glorp-Tests' with: [ spec requires: #('SQLite3-Glorp' 'Glorp-Tests');
				group: 'Tools' with: #()	 ].

			spec
				group: 'CI' with: #('SQLite3-Glorp-Tests' 'Tests');
				group: 'all' with: #('Core' 'Tests' 'Benchmarks' 'Tools');
				group: 'default' with: #('all')
			].
	self versionSpecificBaseline: spec.
]

{ #category : #baselines }
BaselineOfSQLite3 >> projectClass [

	^ MetacelloCypressBaselineProject
]

{ #category : #baselines }
BaselineOfSQLite3 >> setUpDependencies: spec [

	spec
		baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:v9.0.4/' ];
		project: 'Glorp-Core' copyFrom: 'Glorp' with: [ spec loads: 'Core' ];
		project: 'Glorp-Tests' copyFrom: 'Glorp' with: [ spec loads: 'Glorp-Integration-Tests' ]
]

{ #category : #baselines }
BaselineOfSQLite3 >> versionSpecificBaseline: spec [

	"Add version specific packages to the spec"

	spec for: #( #'pharo7.x' #'pharo8.x' ) do: [ 
		spec
			package: 'SQLite3-Pharo8';
			group: 'Core' with: 'SQLite3-Pharo8' ].

	spec for: #( #'pharo9.x' #'pharo10.x' ) do: [ 
		spec
			package: 'SQLite3-Pharo9';
			group: 'Core' with: 'SQLite3-Pharo9' ].
	
	spec for: #'pharo10.x' do: [ 
		spec
			package: 'SQLite3-Pharo10';
			group: 'Core' with: 'SQLite3-Pharo10'.
			
		spec 
			package: 'SQLite3-Inspector-Extensions' with: [ spec requires: #('Core') ];
			group: 'Tools' with: 'SQLite3-Inspector-Extensions'	
	]
]
