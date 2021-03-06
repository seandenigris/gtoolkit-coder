Class {
	#name : #GtExpandableCoderElementExamples,
	#superclass : #Object,
	#category : #'GToolkit-Coder-Examples-UI'
}

{ #category : #'as yet unclassified' }
GtExpandableCoderElementExamples >> forCollapsedMethodCoder [
	<gtExample>
	| anElement aCoder |
	
	aCoder := GtMethodCoder forMethod: (GtMethodCoderExamples >> #example).
	self assert: aCoder expanded not.
	
	anElement := GtExpandableCoderElement new.
	anElement coder: aCoder.
	
	self assert: anElement isExpanded not.
	
	^ anElement
]
