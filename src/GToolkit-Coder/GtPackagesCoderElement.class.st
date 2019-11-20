Class {
	#name : #GtPackagesCoderElement,
	#superclass : #BlElement,
	#instVars : [
		'packagesCoder',
		'contentPane',
		'navigationElement',
		'selectedCoder'
	],
	#category : #'GToolkit-Coder-UI'
}

{ #category : #'building ui' }
GtPackagesCoderElement >> buildAddClassButton [
	| look |
	^ BrButton new
		label: 'Add class';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						handle: [ BrButton new
								look:
									BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
										- BrGlamorousButtonExteriorLook;
								icon: BrGlamorousIcons add asElement;
								yourself ]
						content: [ | coder |
							coder := GtClassDefinitionCoder new
								expanded: true;
								source:
									'Object subclass: #NameOfSubclass
	instanceVariableNames: ''''
	classVariableNames: ''''
	package: ''''';
								yourself.
							coder announcer
								when: GtCoderEvaluationAnnouncement
								do: [ :e | 
									look hide.
									self updateSelection: (packagesCoder coderForClass: e value) ].
							coder asElement
								hFitContent;
								vFitContent;
								margin: (BlInsets all: 10);
								yourself ]);
		icon: BrGlamorousIcons add asElement;
		yourself
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildContentPane [
	contentPane := BlElement new.
	contentPane layout: BlLinearLayout horizontal.
	contentPane padding: (BlInsets all: 5).
	contentPane
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	^ contentPane
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildPackageCards [
	| element |
	element := BlElement new.
	element layout: BlFlowLayout new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element
		addChildren:
			((packagesCoder coders asSortedCollection: [ :a :b | a name < b name ])
				collect: [ :each | 
					BlLazyElement new
						elementBuilder: [ each asCardElement ];
						margin: (BlInsets all: 10);
						background: Color white;
						look: BrShadowLook;
						width: 200;
						height: 65 ]).
	^ element asScrollableElement
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildPackagesElement [
	| element |
	element := BlElement new.
	element layout: BlLinearLayout vertical.
	element padding: (BlInsets all: 5).
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: (BrGlamorousLabelLook new bold glamorousCodeFontAndSize fontSize: 20);
				text: packagesCoder name).
	element
		addChild:
			(BrLabel new
				margin: (BlInsets left: 10);
				look: BrGlamorousLabelLook new glamorousCodeFontAndSize;
				text: packagesCoder coders size printString , ' Packages').
	element addChild: self buildPackageCards.
	^ element
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildPackagesTreeButton [
	^ BrToggle new
		label: 'Show Package Tree';
		look: BrGlamorousButtonWithIconLook + BrGlamorousToggleBackgroundLook;
		icon: BrGlamorousIcons tree asElement;
		when: BrToggleActivatedEvent
			do: [ contentPane addChildFirst: self navigationElement ];
		when: BrToggleDeactivatedEvent
			do: [ self navigationElement removeFromParent ];
		yourself
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildSpotterButton [
	| look |
	^ BrButton new
		label: 'Search';
		look:
			BrGlamorousButtonWithIconLook
				+
					(look := BrGlamorousWithDropdownLook
						stencil: [ | model |
							model := GtSpotter new initializeWith: GtCoderSpotterStart new.
							model announcer
								when: GtSpotterActOn
								do: [ :e | 
									| item |
									item := e element.
									e actedUpon: true.
									self flag: 'FIXME candidates may be wrapped for some reason'.
									[ (item isKindOf: GtSpotterCandidate)
										and: [ item item ~~ item ] ]
										whileTrue: [ item := item item ].
									((#(singleClick doubleClick keyPressed) includes: e eventType)
										and: [ {RPackage.
											ClassDescription.
											CompiledMethod} anySatisfy: [ :f | item isKindOf: f ] ])
										ifTrue: [ look hide.
											(item isKindOf: RPackage)
												ifTrue: [ self updateSelection: (packagesCoder coderForPackage: item) ].
											(item isKindOf: ClassDescription)
												ifTrue: [ self updateSelection: (packagesCoder coderForClass: item) ].
											(item isKindOf: CompiledMethod)
												ifTrue: [ | classCoder |
													classCoder := packagesCoder
														coderForClass: item methodClass.
													self updateSelection: classCoder.
													classCoder withSelectedMethod: item ] ] ].
							BlElement new
								look:
									(BrGlamorousDropdownLook new
										handle:
											(BrButton new
												look:
													BrGlamorousButtonWithIconLook - BrGlamorousWithLabelTooltipLook
														- BrGlamorousButtonExteriorLook;
												icon: BrGlamorousIcons search asElement;
												yourself);
										content:
											(GtSpotterElement new
												spotterModel: model;
												constraintsDo: [ :c | 
													c horizontal exact: 600.
													c vertical exact: 400 ];
												margin: (BlInsets all: 1);
												geometry: (BlRectangle cornerRadius: 4);
												in: [ :e | 
													self
														flag: 'FIXME need to remove original listener to avoid phlow inspect'.
													model announcer subscriptions subscriptions
														detect: [ :g | 
															g announcementClass == GtSpotterSelectedCandidateChanged
																and: [ g action isMessageSend
																		and: [ g action selector = #onCandidateSelected:
																				and: [ g action receiver == e ] ] ] ]
														ifFound: [ :g | g announcer subscriptions remove: g ] ];
												yourself);
										yourself);
								background: BrGlamorousColors secondaryHeaderBackgroundColor;
								yourself ]);
		icon: BrGlamorousIcons search asElement;
		yourself
]

{ #category : #'building ui' }
GtPackagesCoderElement >> buildToolbar [
	^ BrToolbar new
		look: BrGlamorousToolbarLook new;
		padding:
			(BlInsets
				top: 10
				left: 0
				bottom: 0
				right: 5);
		constraintsDo: [ :c | 
			c ignoreByLayout.
			c ignored horizontal alignRight.
			c ignored vertical alignTop ];
		addItem: self buildSpotterButton;
		addItem: self buildPackagesTreeButton;
		addItem: self buildAddClassButton;
		yourself
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> coders: aPackagesCoder [
	packagesCoder := aPackagesCoder.
	self updateSelection: packagesCoder
]

{ #category : #'initialize-release' }
GtPackagesCoderElement >> initialize [
	super initialize.
	self
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ].
	self addChild: self buildContentPane.
	self addChild: self buildToolbar
]

{ #category : #'building ui' }
GtPackagesCoderElement >> navigationElement [
	^ navigationElement
		ifNil: [ navigationElement := BrSimpleTree new.
			navigationElement constraintsDo: [ :c | c linear weight: 0.7 ].
			navigationElement
				items: {packagesCoder}
				children: [ :anObject | 
					anObject packageTreeCoders
						asSortedCollection: [ :a :b | a name < b name ] ].
			navigationElement
				stencil:
					(BrSimpleTreeRowStencilBuilder new
						text: [ :anObject | anObject name asRopedText glamorousRegularFontAndSize ]).
			navigationElement
				when: BrSelectionChanged
				do: [ :anEvent | 
					navigationElement
						selectedNodeDo: [ :aNode | 
							selectedCoder := aNode value.
							self updateCoder ] ].
			self selectAndScrollTree.
			navigationElement ]
]

{ #category : #private }
GtPackagesCoderElement >> selectAndScrollTree [
	navigationElement isNil
		ifTrue: [ ^ self ].
	navigationElement viewModel root
		allChildrenNodesBreadthFirstDo: [ :treeNode | 
			| selectedNode |
			treeNode ensureChildNodesComputed.
			selectedCoder = treeNode value
				ifTrue: [ selectedNode := treeNode.
					treeNode withAllParentNodesDo: [ :node | node expand ].
					navigationElement selectOne: treeNode globalIndexInTree.
					(navigationElement childNamed: #tree)
						scrollToPosition: treeNode globalIndexInTree ] ]
]

{ #category : #events }
GtPackagesCoderElement >> updateCoder [
	| coderElement |
	contentPane
		childNamed: #coder
		ifFound: [ :element | element removeFromParent ]
		ifNone: [  ].
	coderElement := selectedCoder == packagesCoder
		ifTrue: [ self buildPackagesElement ]
		ifFalse: [ selectedCoder asElement ].
	contentPane addChild: coderElement as: #coder
]

{ #category : #events }
GtPackagesCoderElement >> updateSelection: aCoder [
	selectedCoder := aCoder.
	self updateCoder.
	self selectAndScrollTree
]