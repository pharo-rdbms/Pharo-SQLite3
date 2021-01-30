Extension { #name : #FFIExternalReference }

{ #category : #'*SQLite3-Core' }
FFIExternalReference >> manualRelease [
	FFIExternalResourceManager uniqueInstance removeResource: self
]
