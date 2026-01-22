# Card Component - Reusable UI Component dengan Props
# Mendemonstrasikan:
# - Component dengan props
# - Inline styling
# - State lokal (hover effect)
# - Event handling

tag Card
	# Props yang bisa diterima dari parent
	prop title = "Card Title"
	prop description = "Default description"
	prop color = "#4f46e5"
	prop icon = "📊"
	
	# State lokal untuk hover effect
	prop isHovered = false
	
	# Method untuk handle events
	def handleMouseEnter
		isHovered = true
	
	def handleMouseLeave
		isHovered = false
	
	# CSS styling dalam Imba menggunakan object syntax
	css self
		background: white
		border-radius: 12px
		padding: 24px
		margin: 12px
		min-width: 250px
		box-shadow: 0 2px 8px rgba(0,0,0,0.1)
		transition: all 0.3s ease
		cursor: pointer
		border-left: 4px solid
		
		&.hovered
			transform: translateY(-4px)
			box-shadow: 0 8px 16px rgba(0,0,0,0.15)
	
	css .card-icon
		font-size: 2.5rem
		margin-bottom: 12px
	
	css .card-title
		font-size: 1.5rem
		font-weight: 700
		margin: 8px 0
		color: #1f2937
	
	css .card-description
		font-size: 0.95rem
		color: #6b7280
		line-height: 1.5
	
	css .card-footer
		margin-top: 16px
		padding-top: 16px
		border-top: 1px solid #e5e7eb
		font-size: 0.85rem
		color: #9ca3af
	
	# Render method - Imba menggunakan tag syntax
	<self
		.hovered=isHovered
		[border-left-color: color]
		@mouseenter=handleMouseEnter
		@mouseleave=handleMouseLeave
	>
		<div.card-icon> icon
		<h3.card-title> title
		<p.card-description> description
		<div.card-footer> "Hover untuk melihat efek"