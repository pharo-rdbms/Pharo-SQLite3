Extension { #name : #SQLite3Library }

{ #category : #'*SQLite3-Pharo8' }
SQLite3Library >> stringFrom: aStatement at: aColumn [
	^ self utf8StringToPharo: (self apiColumnText: aStatement atColumn: aColumn)
]

{ #category : #'*SQLite3-Pharo8' }
SQLite3Library >> utf8StringToPharo: anUTF8String [
	"Converts from SQLite UTF-8 to Pharo Multibyte Characters"
	
	^ (ZnCharacterReadStream on: anUTF8String asByteArray readStream) upToEnd
]
