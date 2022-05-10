Extension { #name : #SQLite3Table }

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Columns [
	<inspectorPresentationOrder: 13 title: 'SQLite3 - Columns'>
	 
	^ SpTablePresenter new
		items: self columns;
		addColumn: (SpStringTableColumn title: 'Column Name' evaluated: [ :each | each name ]);	
		addColumn: (SpStringTableColumn title: 'Column Type' evaluated: [ :each | each type ]);			
		yourself
]

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Data [
	<inspectorPresentationOrder: 11 title: 'SQLite3 - Data'>
	 
	| presenter |
	presenter := SpTablePresenter new.
	presenter items: self rows.
	
	self columnNames do: [:col |
		presenter addColumn: (SpStringTableColumn title: col evaluated: [ :each | each at: col ])		 
	 ].
	^presenter
]

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Schema [
	<inspectorPresentationOrder: 10 title: 'SQLite3 - Schema'>
	 
	^ SpTextPresenter new
		text: self schema;
		yourself
]

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3TableProperties [
	<inspectorPresentationOrder: 40 title: 'SQLite3 - Table Properties'>
	 
	^ SpTablePresenter new
		items: self properties associations;
		addColumn: (SpStringTableColumn title: 'Property' evaluated: [ :assoc | assoc key ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :assoc | assoc value ]);	
		yourself
]
