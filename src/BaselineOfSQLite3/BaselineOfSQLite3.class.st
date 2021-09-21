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
			"Pharo version compatibility"
			SystemVersion current major >= 9 
				ifTrue: [ spec package: 'SQLite3-Pharo9' with: [ spec requires: #('SQLite3-Core') ] ]
				ifFalse: [ spec package: 'SQLite3-Pharo8' with: [ spec requires: #('SQLite3-Core') ] ].
			"Groups"
			spec
				group: 'Core' with: #('SQLite3-Core');
				group: 'Tests' with: #('SQLite3-Core-Tests');
				group: 'Benchmarks' with: #('SQLite3-Core-Benchmarks');
				group: 'glorp' with: 'SQLite3-Glorp';
				group: 'CI' with: #('SQLite3-Glorp-Tests' 'Tests');
				group: 'all' with: #('Core' 'Tests' 'Benchmarks');
				group: 'default' with: #('all')
			]
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
