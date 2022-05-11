Extension { #name : #SQLite3Database }

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Database >> inspectionSQLite3Tables [
	<inspectorPresentationOrder: 10 title: 'Sqlite3 - Tables'>
	 
	^ SpTablePresenter new
		items: self tables;
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :assoc | assoc name ]);
		addColumn: (SpStringTableColumn title: 'Number of rows' evaluated: [ :assoc | assoc numberOfRows ]);		
		yourself
]
