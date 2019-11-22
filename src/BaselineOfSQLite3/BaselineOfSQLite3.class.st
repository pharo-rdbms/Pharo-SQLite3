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
		for: #common
		do: [ 
			spec blessing: #baseline.
								
			"Packages"
			spec 
				package: 'SQLite3-Core';
				package: 'SQLite3-Core-Benchmarks' with: [ spec requires: #('SQLite3-Core') ];
				package: 'SQLite3-Core-Tests' with: [ spec requires: #('SQLite3-Core') ].				
						
			"Groups"
			spec
				group: 'Core' with: #('SQLite3-Core');		
				group: 'Tests' with: #('SQLite3-Core-Tests'); 	
				group: 'Benchmarks' with: #('SQLite3-Core-Tests'); 				
				group: 'all' with: #('Core' 'Tests' 'Benchmarks');
				group: 'default' with: #('all') ].
]
