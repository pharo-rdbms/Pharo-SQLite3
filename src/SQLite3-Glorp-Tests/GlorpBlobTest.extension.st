Extension { #name : #GlorpBlobTest }

{ #category : #'*SQLite3-Glorp-Tests' }
GlorpBlobTest >> expectedFailures [

	"testBlob is working with version 3.32.3 of SQLite"

	^ ( IceSemanticVersion
		fromArray: ( ( SQLite3Library current apiLibVersion splitOn: '.' ) collect: #asNumber ) )
		< ( IceSemanticVersion major: 3 minor: 32 patch: 3 )
		ifTrue: [ super expectedFailures , #(testBlob) ]
		ifFalse: [ super expectedFailures ]
]
