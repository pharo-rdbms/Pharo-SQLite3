Extension { #name : 'AbstractFileReference' }

{ #category : '*SQLite3-Inspector-Extensions' }
AbstractFileReference >> databaseSize [
	|s|
	s := self size.
	s / 1024 > 1024 ifTrue: [ ^ ((s / 1024 / 1024) roundDownTo: 0.01) asString, ' MB' ].
	^ ((s / 1024) roundDownTo: 0.01) asString, ' KB'
]

{ #category : '*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3Info: aBuilder [

	<inspectorPresentationOrder: -2 title: 'SQLite3 - Info'>
	| fileLabel sizeLabel |
	fileLabel := (aBuilder instantiate: SpLabeledPresenter)
		             label: 'Database file:';
		             input: (aBuilder newTextInput
				              text: self fullName;
				              yourself);
		             yourself.
	sizeLabel := (aBuilder instantiate: SpLabeledPresenter)
		             label: 'Database size:';
		             input: (aBuilder newTextInput
				              text: self databaseSize;
				              yourself);
		             yourself.
	^ aBuilder newPresenter
		  layout: (aBuilder newBoxLayoutTopToBottom
				   add: fileLabel;
				   add: sizeLabel;
				   yourself);
		  yourself
]

{ #category : '*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3InfoContext: aContext [

	^ aContext active: self isSQlite3Database
]

{ #category : '*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3Tables: aBuilder [

	<inspectorPresentationOrder: -1 title: 'SQLite3 - Tables'>
	^ (SQLite3Database openOn: self fullName) inspectionSQLite3Tables:
		  aBuilder
]

{ #category : '*SQLite3-Inspector-Extensions' }
AbstractFileReference >> inspectionSQLite3TablesContext: aContext [

	^ aContext active: self isSQlite3Database
]

{ #category : '*SQLite3-Inspector-Extensions' }
AbstractFileReference >> isSQlite3Database [
	"Return true if the reference is an SQLite3 database file"

	^ self isFile and: [
		  self extension = 'db' and: [
			  (self readStreamDo: [ :s | s next: 16 ])
			  = ('SQLite format 3' , Character null asString) ] ]
]
