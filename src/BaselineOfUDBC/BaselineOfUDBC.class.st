"
Baseline for UDBC
"
Class {
	#name : #BaselineOfUDBC,
	#superclass : #BaselineOf,
	#category : #BaselineOfUDBC
}

{ #category : #baselines }
BaselineOfUDBC >> baseline: spec [
	<baseline>
	
	spec for: #'common' do: [	 
		spec 
			package: #'UDBC-Core';
			package: #'UDBC-Tests-Core' with: [
				spec requires: #(#'UDBC-Core' ). ];
			
			"SQLite"
			package: #'UDBC-SQLite-Base';
			package: #'UDBC-SQLite-Core' with: [
				spec requires: #(#'UDBC-SQLite-Base' ). ];
			package: #'UDBC-Tests-SQLite-Base' with: [
				spec requires: #(#'UDBC-SQLite-Base' ). ];
			package: #'UDBC-Tests-SQLite-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-Tests-SQLite-Base' #'UDBC-SQLite-Core' ). ];

			"PostgreSQL"
			package: #'UDBC-PostgreSQL-Base';
			package: #'UDBC-PostgreSQL-Core' with: [
				spec requires: #(#'UDBC-PostgreSQL-Base' ). ];
			package: #'UDBC-Tests-PostgreSQL-Base' with: [
				spec requires: #(#'UDBC-PostgreSQL-Base' ). ];
			package: #'UDBC-Tests-PostgreSQL-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-Tests-PostgreSQL-Base'  #'UDBC-PostgreSQL-Core' ). ];

			"MySQL"
			package: #'UDBC-MySQL-Core';
			package: #'UDBC-Tests-MySQL-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-MySQL-Core' ). ];

			"ODBC"
			package: #'UDBC-ODBC-Base';
			package: #'UDBC-ODBC-Core' with: [
				spec requires: #(#'UDBC-ODBC-Base' ). ];
			package: #'UDBC-Tests-ODBC-Base' with: [
				spec requires: #(#'UDBC-ODBC-Base' ). ];
			package: #'UDBC-Tests-ODBC-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-Tests-ODBC-Base' #'UDBC-ODBC-Core' ). ];

			"X"
			package: #'UDBC-OpenDBX-Base';
			package: #'UDBC-OpenDBX-Core' with: [
				spec requires: #(#'UDBC-OpenDBX-Base' ). ];
			package: #'UDBC-Tests-OpenDBX-Core' with: [
				spec requires: #(#'UDBC-Tests-Core' #'UDBC-OpenDBX-Core' ). ].

		spec 
			group: 'MySQL' with: #(#'UDBC-Tests-MySQL-Core' );
			group: 'PostgreSQL' with: #(#'UDBC-Tests-PostgreSQL-Core' );
			group: 'OpenDBX' with: #(#'UDBC-Tests-OpenDBX-Core' );
			group: 'SQLite' with: #(#'UDBC-Tests-SQLite-Core' );
			group: 'ODBC' with: #(#'UDBC-Tests-ODBC-Core' );
			group: 'Tests' with: #('SQLite' 'MySQL' 'OpenDBX' 'PostgreSQL' 'ODBC');
			
			group: 'all' with: #('Tests' );
			group: 'Core' with: #(#'UDBC-Core' );
			group: 'default' with: #('all' );
			group: 'Base' with: #(). ].
]
