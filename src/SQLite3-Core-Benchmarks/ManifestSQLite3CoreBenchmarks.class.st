"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSQLite3CoreBenchmarks,
	#superclass : #PackageManifest,
	#category : #'SQLite3-Core-Benchmarks-Manifest'
}

{ #category : #'code coverage' }
ManifestSQLite3CoreBenchmarks class >> classNamesNotUnderTest [

	^ #( ManifestSQLite3CoreBenchmarks )
]

{ #category : #'code-critics' }
ManifestSQLite3CoreBenchmarks class >> ruleClassNotReferencedRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#SQLite3Benchmark)) #'2022-05-10T08:25:40.035+02:00') )
]
