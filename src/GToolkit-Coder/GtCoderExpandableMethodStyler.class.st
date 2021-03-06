Class {
	#name : #GtCoderExpandableMethodStyler,
	#superclass : #GtASTStyler,
	#category : #'GToolkit-Coder-Styler/Highlighter'
}

{ #category : #visiting }
GtCoderExpandableMethodStyler >> visitMessageNode: aMessageNode [
	| aMethodClass type |
	super visitMessageNode: aMessageNode.
	aMethodClass := self
		typeOf: aMessageNode receiver
		in: aMessageNode methodNode methodClass.
	aMethodClass isNil
		ifTrue: [ ^ self ].
	(aMethodClass canUnderstand: aMessageNode selector)
		ifFalse: [ ^ self ].
	self
		styleFrom: aMessageNode keywordsIntervals last last
		to: aMessageNode keywordsIntervals last last
		with:
			{(GtMethodExpanderAttribute
				forClass: aMethodClass
				andSelector: aMessageNode selector)}
]
