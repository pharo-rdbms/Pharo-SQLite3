Extension { #name : #FFIExternalResourceManager }

{ #category : #'*SQLite3-Core' }
FFIExternalResourceManager >> removeResource: anObject [
	registry remove: anObject ifAbsent: [  ]
]
