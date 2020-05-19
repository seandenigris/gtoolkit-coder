Class {
	#name : #GtCoderTool,
	#superclass : #GtPhlowTool,
	#category : #'GToolkit-Coder-Adaptors'
}

{ #category : #converting }
GtCoderTool >> asElementDo: aOneArgBlock [
	"Create a tool element and execute the block."

	aOneArgBlock cull: self newCoder asPagerPageElement
]

{ #category : #converting }
GtCoderTool >> newCoder [
	^ self subclassResponsibility
]