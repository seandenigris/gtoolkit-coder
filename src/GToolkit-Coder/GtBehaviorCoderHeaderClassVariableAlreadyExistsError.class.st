Class {
	#name : #GtBehaviorCoderHeaderClassVariableAlreadyExistsError,
	#superclass : #GtBehaviorCoderHeaderClassVariableError,
	#category : #'GToolkit-Coder-Behavior - Errors'
}

{ #category : #accessing }
GtBehaviorCoderHeaderClassVariableAlreadyExistsError >> description [
	^ 'Class variable named {1} already exists in the definition' format: { self variableName }
]
