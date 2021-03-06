Class {
	#name : #GtPoolDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'name'
	],
	#category : #'GToolkit-Coder-Behavior - Definitions'
}

{ #category : #'instance creation' }
GtPoolDefinition class >> fromPool: aSharedPoolClass [
	^ self new fromPool: aSharedPoolClass
]

{ #category : #converting }
GtPoolDefinition >> asDefinitionString [
	^ self name
]

{ #category : #'api - pool' }
GtPoolDefinition >> browseFrom: anEvent [
	self class environment
		at: self name
		ifPresent: [ :aPool | anEvent currentTarget phlow spawnTool: (GtClassCoderTool observedClass: aPool) ]
]

{ #category : #testing }
GtPoolDefinition >> exists [
	^ Smalltalk globals includesKey: self name asSymbol
]

{ #category : #'instance creation' }
GtPoolDefinition >> fromPool: aSharedPoolClass [
	name := aSharedPoolClass name
]

{ #category : #accessing }
GtPoolDefinition >> name [
	^ name
]

{ #category : #accessing }
GtPoolDefinition >> name: aSymbol [
	name := aSymbol asSymbol
]

{ #category : #printing }
GtPoolDefinition >> printOn: aStream [
	aStream print: self name
]
