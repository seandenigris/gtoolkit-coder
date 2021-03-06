Class {
	#name : #GtCoderExpanderWithoutShadowLook,
	#superclass : #BrExpanderLook,
	#instVars : [
		'sidebar',
		'toggle',
		'container',
		'borderWidth',
		'expandedBorderWidth',
		'borderPaint',
		'borderFocusedPaint',
		'cornerRadius',
		'styleLook',
		'padding'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderFocusedPaint [
	^ borderFocusedPaint
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderFocusedPaint: aPaintOrColor [
	borderFocusedPaint := aPaintOrColor.
	styleLook requestStates
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderPaint [
	^ borderPaint
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderPaint: aPaintOrColor [
	borderPaint := aPaintOrColor.
	styleLook requestStates
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderWidth [
	^ borderWidth
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderWidth: anInteger [
	borderWidth := anInteger.
	styleLook requestStates
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> cornerRadius [
	^ cornerRadius
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> cornerRadius: aNumber [
	cornerRadius := aNumber.
	styleLook requestStates
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowLook >> defaultBorderPaint [
	^ BrGlamorousColors lightBorderColor
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowLook >> defaultFocusedBorderPaint [
	^ (BrGlamorousColors primaryBorderColor alpha: 0.4) gtOpaqueColorOnWhite
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> expandedBorderWidth [
	<return: #Number>

	^ expandedBorderWidth
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> expandedBorderWidth: aNumber [
	expandedBorderWidth := aNumber
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowLook >> initialize [
	| aTriangle |
	super initialize.

	borderWidth := 0.
	expandedBorderWidth := 0.
	cornerRadius := 3.
	padding := BlInsets all: 4.

	borderPaint := self defaultBorderPaint.
	borderFocusedPaint := self defaultFocusedBorderPaint.

	aTriangle := self newTriangle.
	toggle := self newToggle.
	toggle addChild: aTriangle.
			
	sidebar := self newSidebar.
	sidebar addChild: toggle.

	container := BlElement new
		padding: self padding;
		layout: BlLinearLayout vertical.

	self add: (styleLook := BrInteractiveCommonLook new
			default: [ :aWidget | 
				sidebar background: self borderPaint.
				aWidget border: (BlBorder paint: self borderPaint width: self borderWidth) ];
			collapsed: [ :aWidget | 
				aTriangle geometry: self newCollapsedTriangleGeometry.
				aWidget background: Color transparent.
				aWidget border: (aWidget border copyWithWidth: self borderWidth) ];
			expanded: [ :aWidget | 
				aTriangle geometry: self newExpandedTriangleGeometry.
				aWidget background: Color white.
				aWidget border: (aWidget border copyWithWidth: self expandedBorderWidth) ];
			focused: [ :aWidget |
				sidebar background: self borderFocusedPaint.
				aWidget border: (aWidget border copyWithPaint: self borderFocusedPaint) ]).

	self addChangeAddChildAs: #(sidebar) with: [ sidebar ].
	self addChangeAddChildAs: #(content) with: [ container ].
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal ].
	self
		addChangeProperty: #(widget geometry)
		with: [ BlRoundedRectangleGeometry cornerRadius: self cornerRadius ]
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowLook >> newCollapsedTriangleGeometry [
	^ BlPolygon vertices: {
		(0 @ 0).
		(8 @ 4).
		(0 @ 8)
	}
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowLook >> newExpandedTriangleGeometry [
	^ BlPolygon vertices: {
		(0 @ 0).
		(8 @ 0).
		(4 @ 8)
	}
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowLook >> newSidebar [
	^ BlElement new
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		background: Color veryVeryLightGray
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowLook >> newToggle [
	^ BlElement new
		layout: BlLinearLayout horizontal;
		padding: (BlInsets all: 4);
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical matchParent ];
		background: Color transparent;
		when: BlClickEvent
			do: [ :anEvent |
				anEvent consumed: true.
				self dispatchEvent: BrExpansionToggleWish new ]
]

{ #category : #'private - instance creation' }
GtCoderExpanderWithoutShadowLook >> newTriangle [
	^ BlElement new
		size: 8 @ 8;
		background: (Color white alpha: 0.9);
		constraintsDo: [ :c | c linear vertical alignTop ]
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> padding [
	^ padding
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> padding: aBlInsets [
	padding := aBlInsets.
	container padding: aBlInsets
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> resizableElementsDo: aBlock [
	super resizableElementsDo: aBlock.
	aBlock value: container
]
