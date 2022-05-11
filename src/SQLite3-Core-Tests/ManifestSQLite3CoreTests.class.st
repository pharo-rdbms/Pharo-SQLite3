"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSQLite3CoreTests,
	#superclass : #PackageManifest,
	#category : #'SQLite3-Core-Tests-Manifest'
}

{ #category : #'code coverage' }
ManifestSQLite3CoreTests class >> classNamesNotUnderTest [

	^ #( ManifestSQLite3CoreTests )
]

{ #category : #'code-critics' }
ManifestSQLite3CoreTests class >> ruleEmptyExceptionHandlerRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SQLite3ConnectionTest #tearDown #false)) #'2022-05-10T08:25:11.111+02:00') #(#(#RGMethodDefinition #(#SQLite3BaseConnectionTest #tearDown #false)) #'2022-05-10T08:27:13.419+02:00') )
]

{ #category : #'code-critics' }
ManifestSQLite3CoreTests class >> ruleLiteralArrayContainsCommaRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SQLite3BaseConnectionTest #deactivatedTestTracing #false)) #'2022-05-10T08:24:31.021+02:00') )
]

{ #category : #'code-critics' }
ManifestSQLite3CoreTests class >> ruleLiteralArrayContainsSuspiciousTrueFalseOrNilRuleV1FalsePositive [
	^ #(#(#(#RGMetaclassDefinition #(#'ManifestSQLite3CoreTests class' #ManifestSQLite3CoreTests)) #'2022-05-10T08:26:37.973+02:00') )
]
