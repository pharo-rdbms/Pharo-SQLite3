Extension { #name : #SQLite3Table }

{ #category : #'*SQLite3-Inspector-Extensions' }
SQLite3Table >> inspectionSQLite3TableProperties [
	<inspectorPresentationOrder: 40 title: 'Table Properties'>
	 
	^ SpTablePresenter new
		items: self properties associations;
		addColumn: (SpStringTableColumn title: 'Property' evaluated: [ :assoc | assoc key ]);
		addColumn: (SpStringTableColumn title: 'Value' evaluated: [ :assoc | assoc value ]);	
		yourself
]
