Extension { #name : #RBRenameClassRefactoring }

{ #category : #'*GToolkit-Coder' }
RBRenameClassRefactoring >> gtDescription [
	<return: #String or: #BlRopedText>
	
	^ ('Rename' asRopedText glamorousRoundedBackground)
		append: ' class ' asRopedText;
		append: className asRopedText;
		append: ' to ' asRopedText;
		append: newName asRopedText glamorousRoundedBackground
]
