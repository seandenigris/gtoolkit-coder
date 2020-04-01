Class {
	#name : #GtBehaviorDefinition,
	#superclass : #GtCodeDefinition,
	#instVars : [
		'ringDefinition',
		'originalName'
	],
	#category : #'GToolkit-Coder-Behavior - Model'
}

{ #category : #accessing }
GtBehaviorDefinition >> name [
	<return: #Symbol>

	^ ringDefinition name
]

{ #category : #accessing }
GtBehaviorDefinition >> name: aSymbol [
	ringDefinition name: aSymbol asSymbol
]

{ #category : #accessing }
GtBehaviorDefinition >> originalName [
	^ originalName
]

{ #category : #accessing }
GtBehaviorDefinition >> originalName: anObject [
	originalName := anObject
]

{ #category : #printing }
GtBehaviorDefinition >> printOn: aStream [
	aStream print: self name
]