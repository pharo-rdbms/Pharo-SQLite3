Extension { #name : #GlorpBooleanTest }

{ #category : #'*SQLite3-Glorp' }
GlorpBooleanTest >> expectedFailures [

	"testBoolean is working with version 3.32.3 of SQLite"

	^ ( IceSemanticVersion
		fromArray: ( ( SQLite3Library current apiLibVersion splitOn: '.' ) collect: #asNumber ) )
		< ( IceSemanticVersion major: 3 minor: 32 patch: 3 )
		ifTrue: [ super expectedFailures , #(testBoolean) ]
		ifFalse: [ super expectedFailures ]
]
