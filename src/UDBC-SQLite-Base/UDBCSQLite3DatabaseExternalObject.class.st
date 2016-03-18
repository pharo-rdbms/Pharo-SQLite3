"
I represent the SQLite API 'sqlite3' C-level type.
"
Class {
	#name : #UDBCSQLite3DatabaseExternalObject,
	#superclass : #FFIOpaqueObject,
	#category : #'UDBC-SQLite-Base-UFFI-Support'
}

{ #category : #'instance finalization' }
UDBCSQLite3DatabaseExternalObject class >> finalizeResourceData: resourceData [
	UDBCSQLite3Library current 
		ffiCall: #(int sqlite3_close (ExternalAddress resourceData))
		module: UDBCSQLite3Library current library
]
