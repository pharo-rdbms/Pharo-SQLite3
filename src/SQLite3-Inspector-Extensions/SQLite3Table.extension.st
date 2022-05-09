Extension { #name : #SQLite3Table }

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3Columns [
	<inspectorPresentationOrder: 11 title: 'SQLite3 - Columns'>
	 
	^ SpTablePresenter new
		items: self columnNames;
		addColumn: (SpStringTableColumn title: 'Column Name' evaluated: [ :each | each asString ]);		 
		yourself
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

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> schema [

	^ self properties at: #sql ifAbsent: ''
]
