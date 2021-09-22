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
		do: [ spec blessing: #baseline.
			self setUpDependencies: spec.
			"Packages"
			spec
				package: 'SQLite3-Core';
				package: 'SQLite3-Core-Benchmarks' with: [ spec requires: #('SQLite3-Core') ];
				package: 'SQLite3-Core-Tests' with: [ spec requires: #('SQLite3-Core') ];
				package: 'SQLite3-Glorp' with: [ spec requires: #('SQLite3-Core' 'Glorp-Core') ];
				package: 'SQLite3-Glorp-Tests' with: [ spec requires: #('SQLite3-Glorp' 'Glorp-Tests') ].
			"Groups"
			spec
				group: 'Core' with: #('SQLite3-Core');
				group: 'Tests' with: #('SQLite3-Core-Tests');
				group: 'Benchmarks' with: #('SQLite3-Core-Benchmarks');
				group: 'glorp' with: 'SQLite3-Glorp';
				group: 'CI' with: #('SQLite3-Glorp-Tests' 'Tests');
				group: 'all' with: #('Core' 'Tests' 'Benchmarks');
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
		baseline: 'Glorp' with: [ spec repository: 'github://pharo-rdbms/glorp:master/' ];
		project: 'Glorp-Core' copyFrom: 'Glorp' with: [ spec loads: 'Core' ];
		project: 'Glorp-Tests' copyFrom: 'Glorp' with: [ spec loads: 'Tests' ]
]

{ #category : #baselines }
BaselineOfSQLite3 >> versionSpecificBaseline: spec [
	"Add version specific packages to the spec"

	spec
		for: #'pharo7.x'
		do: 
			[ spec 
				package: 'SQLite3-Pharo8';
				group: 'Core' with: 'SQLite3-Pharo8';
				group: 'glorp' with: 'SQLite3-Pharo8' ].

	spec
		for: #'pharo8.x'
		do: 
			[ spec 
				package: 'SQLite3-Pharo8';
				group: 'Core' with: 'SQLite3-Pharo8';
				group: 'glorp' with: 'SQLite3-Pharo8' ].

	spec
		for: #'pharo9.x'
		do: 
			[ spec 
				package: 'SQLite3-Pharo9';
				group: 'Core' with: 'SQLite3-Pharo9';
				group: 'glorp' with: 'SQLite3-Pharo9' ].

]
