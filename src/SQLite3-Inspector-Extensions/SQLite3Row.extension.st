Extension { #name : 'SQLite3Row' }

{ #category : '*SQLite3-Inspector-Extensions' }
SQLite3Row >> inspectionSQLite3Row: aBuilder [

	<inspectorPresentationOrder: 10 title: 'SQlite3 - Contents'>
	^ aBuilder newTable
		  items: self associations;
		  beResizable;
		  alternateRowsColor;
		  addColumn: (SpIndexTableColumn new
				   title: '#';
				   beNotExpandable;
				   yourself);
		  addColumn: (SpStringTableColumn
				   title: 'Column Name'
				   evaluated: [ :assoc | assoc key ]);
		  addColumn: (SpStringTableColumn
				   title: 'Value'
				   evaluated: [ :assoc | assoc value ]);
		  yourself
]
