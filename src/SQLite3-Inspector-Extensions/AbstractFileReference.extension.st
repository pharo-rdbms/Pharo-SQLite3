Extension { #name : #AbstractFileReference }

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3 [
	<inspectorPresentationOrder: 40 title: 'SQlite3'>
	
	^ SpTablePresenter new
		addColumn: (SpStringTableColumn title: 'Table Name' evaluated: [ :assoc | assoc key ]);
		addColumn: (SpStringTableColumn title: 'Number of Rows' evaluated: [ :assoc | assoc value ]);	
		yourself
]

{ #category : #'*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3Context: aContext [

	
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
