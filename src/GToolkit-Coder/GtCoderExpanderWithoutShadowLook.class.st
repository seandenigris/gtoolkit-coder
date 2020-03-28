Class {
	#name : #GtCoderExpanderWithoutShadowLook,
	#superclass : #BrExpanderLook,
	#instVars : [
		'sidebar',
		'toggle',
		'container',
		'borderWidth'
	],
	#category : #'GToolkit-Coder-Looks'
}

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderWidth [
	^ borderWidth
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> borderWidth: anInteger [
	borderWidth := anInteger
]

{ #category : #initialization }
GtCoderExpanderWithoutShadowLook >> initialize [
	| aTriangle |
	super initialize.

	borderWidth := 0.

	aTriangle := self newTriangle.
	toggle := self newToggle.
	toggle addChild: aTriangle.
			
	sidebar := self newSidebar.
	sidebar addChild: toggle.

	container := BlElement new
		padding: (BlInsets all: 4);
		layout: BlLinearLayout vertical.

	self add: (BrInteractiveCommonLook new
			default: [ :aWidget | 
				sidebar background: Color veryVeryLightGray.
				aWidget border: (BlBorder paint: Color veryVeryLightGray width: self borderWidth) ];
			collapsed: [ :aWidget | 
				aTriangle geometry: self newCollapsedTriangleGeometry.
				aWidget background: Color transparent ];
			expanded: [ :aWidget | 
				aTriangle geometry: self newExpandedTriangleGeometry.
				aWidget background: Color white ];
			unfocused: [ :aWidget | sidebar background: Color veryVeryLightGray ];
			focused: [ :aWidget | sidebar background: (BrGlamorousColors primaryBorderColor alpha: 0.4) ]).

	self addChangeAddChildAs: #(sidebar) with: [ sidebar ].
	self addChangeAddChildAs: #(content) with: [ container ].
	self
		addChangeProperty: #(widget layout)
		with: [ BlLinearLayout horizontal ].
	self
		addChangeProperty: #(widget geometry)
		with: [ BlRectangle cornerRadius: 3 ]
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
GtCoderExpanderWithoutShadowLook >> padding: anInsets [
	container padding: anInsets
]

{ #category : #accessing }
GtCoderExpanderWithoutShadowLook >> resizableElementsDo: aBlock [
	super resizableElementsDo: aBlock.
	aBlock value: container
]