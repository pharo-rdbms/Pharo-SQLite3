"
SQLite does not support a DateTime column type. Instead, it provides date and time functions which handle strings in ISO 8601 format.

I represent a date time string in ISO 8601 format. 
"
Class {
	#name : #UDBCSQLiteDateTimeString,
	#superclass : #Object,
	#category : #'UDBC-SQLite-Base-Utilities'
}
