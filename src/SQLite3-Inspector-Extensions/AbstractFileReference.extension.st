Extension { #name : #AbstractFileReference }

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> databaseSize [
	|s|
	s := self size.
	s / 1024 > 1024 ifTrue: [ ^ ((s / 1024 / 1024) roundDownTo: 0.01) asString, ' MB' ].
	^ ((s / 1024) roundDownTo: 0.01) asString, ' KB' 	
]

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3Info [
	<inspectorPresentationOrder: 40 title: 'SQLite3 - Info'>
	
	| label1 label2 |
	label1 := SpLabeledPresenter
		          label: 'Database file:'
		          input: (SpTextInputFieldPresenter new text: self fullName).
	label2 := SpLabeledPresenter
		          label: 'Database size:'
		          input: (SpTextInputFieldPresenter new text: self databaseSize).	
	^ SpPresenter new
		  layout: (SpBoxLayout newTopToBottom
				   add: label1;
					add: label2;
				   yourself);
		  yourself
]

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3InfoContext: aContext [
	
	^ aContext active: self isSQlite3Database
]

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3Tables [
	<inspectorPresentationOrder: 40 title: 'SQLite3 - Tables'>
	
	^ SpTablePresenter new
			items: (SQLite3Database tableInfoFor: self fullName);
			addColumn: (SpStringTableColumn title: 'Table Name' evaluated: [ :assoc | assoc name ]);
			addColumn: (SpStringTableColumn title: 'Number of Rows' evaluated: [ :assoc | assoc numberOfRows ]);
			yourself
]

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3TablesContext: aContext [
	
	^ aContext active: self isSQlite3Database
]

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> isSQlite3Database [
	"Return true if the reference is an SQlite3 database file"
	
	^ self isFile and: [ 
		  self extension = 'db' and: [ 
			  (self readStreamDo: [ :s | s next: 16 ])
			  = ('SQLite format 3' , Character null asString) ] ]
]
