"
I am a connection string url parser. I parse a url with the form:

[scheme]://[host][:port]/[database]?[query]

I do no validations on the url such as validating if the scheme, host or port are valid. I return all strings. In such way, I support many different connection strings.
"
Class {
	#name : #UDBCConnectionStringURL,
	#superclass : #Object,
	#instVars : [
		'schema',
		'host',
		'port',
		'path',
		'query'
	],
	#category : #'UDBC-Core-Utilities'
}

{ #category : #'instance creation' }
UDBCConnectionStringURL class >> fromString: aString [

	^(self new)
		initializeFromString: aString;
		yourself
]

{ #category : #accessing }
UDBCConnectionStringURL >> host [
	^ host
]

{ #category : #'private - initialization' }
UDBCConnectionStringURL >> initializeFromString: aString [

	self parse: aString
]

{ #category : #'private - parsing' }
UDBCConnectionStringURL >> parse: aString [
	
	| schemaStart schemaEnd authorityEnd hostEnd queryStart pathEnd |
	schemaStart := (aString indexOfSubCollection: '://') - 1.
	schemaEnd := schemaStart + 3.
	
	schema := (aString copyFrom: 1 to: schemaStart) asLowercase.
	
	queryStart := aString indexOf: $?.
	
	authorityEnd := (aString indexOf: $/ startingAt: schemaEnd + 1).
	authorityEnd <= 0 ifTrue: [
		queryStart > 0 ifTrue: [
			authorityEnd := queryStart.
		] ifFalse: [ authorityEnd := aString size + 1. ]
	].
	hostEnd := aString indexOf: $: startingAt: schemaEnd + 1.
	(hostEnd > authorityEnd or: [hostEnd = 0]) ifTrue: [
		hostEnd := authorityEnd.
	].

	host := (aString copyFrom: schemaEnd + 1 to: hostEnd - 1).
	((hostEnd + 1) < (authorityEnd - 1))
		ifTrue:[ port := (aString copyFrom: hostEnd + 1 to: authorityEnd - 1) ]
		ifFalse: [ port := '' ].
	
	queryStart = 0
		ifTrue: [ pathEnd := aString size ]
		ifFalse:[ pathEnd := queryStart -1].
	authorityEnd + 1 > pathEnd
		ifTrue:  [ path := '' ]
		ifFalse: [ path := (aString copyFrom: authorityEnd + 1 to: pathEnd)].
	
	queryStart > 0 ifTrue: [
		query := (ZnResourceMetaUtils parseQueryFrom: (ReadStream on: aString from: queryStart + 1 to: aString size)) asDictionary].
]

{ #category : #accessing }
UDBCConnectionStringURL >> path [
	^ path
]

{ #category : #accessing }
UDBCConnectionStringURL >> port [
	^ port
]

{ #category : #accessing }
UDBCConnectionStringURL >> query [
	^ query
]

{ #category : #accessing }
UDBCConnectionStringURL >> scheme [
	^ schema
]
