# Main Application - Imba Interactive Dashboard
# Mendemonstrasikan:
# - State management
# - Event handling
# - Component composition
# - Reactive rendering
# - Animasi berbasis state

# Import card component
import './components/card'

# Counter Component dengan state lokal
tag Counter
	prop count = 0
	prop step = 1
	
	def increment
		count += step
	
	def decrement
		count -= step
	
	def reset
		count = 0
	
	# Inline CSS styling
	css self
		display: flex
		flex-direction: column
		align-items: center
		gap: 16px
		padding: 24px
		background: white
		border-radius: 12px
		box-shadow: 0 2px 8px rgba(0,0,0,0.1)
		min-width: 300px
	
	css .counter-display
		font-size: 3rem
		font-weight: 800
		color: #4f46e5
		transition: all 0.3s ease
		
		&.positive
			color: #10b981
		
		&.negative
			color: #ef4444
	
	css .counter-buttons
		display: flex
		gap: 12px
	
	css button
		padding: 12px 24px
		border: none
		border-radius: 8px
		font-size: 1.1rem
		font-weight: 600
		cursor: pointer
		transition: all 0.2s ease
		
		&.btn-primary
			background: #4f46e5
			color: white
			
			&:hover
				background: #4338ca
				transform: scale(1.05)
		
		&.btn-secondary
			background: #e5e7eb
			color: #1f2937
			
			&:hover
				background: #d1d5db
				transform: scale(1.05)
		
		&:active
			transform: scale(0.95)
	
	<self>
		<h2> "Interactive Counter"
		<div.counter-display 
			.positive=(count > 0)
			.negative=(count < 0)
		> count
		<div.counter-buttons>
			<button.btn-primary @click=decrement> "-"
			<button.btn-secondary @click=reset> "Reset"
			<button.btn-primary @click=increment> "+"

# Stats Component untuk menampilkan statistik
tag Stats
	prop totalClicks = 0
	prop lastUpdate = Date.new
	
	css self
		display: flex
		gap: 16px
		padding: 20px
		background: #f9fafb
		border-radius: 12px
		margin: 20px 0
	
	css .stat-item
		flex: 1
		text-align: center
		padding: 16px
		background: white
		border-radius: 8px
		box-shadow: 0 1px 3px rgba(0,0,0,0.1)
	
	css .stat-value
		font-size: 2rem
		font-weight: 700
		color: #4f46e5
	
	css .stat-label
		font-size: 0.9rem
		color: #6b7280
		margin-top: 4px
	
	<self>
		<div.stat-item>
			<div.stat-value> totalClicks
			<div.stat-label> "Total Clicks"
		<div.stat-item>
			<div.stat-value> lastUpdate.toLocaleTimeString!
			<div.stat-label> "Last Update"

# Main App Component
tag App
	prop counterValue = 0
	prop clickCount = 0
	prop lastUpdateTime = Date.new
	
	def handleCounterChange newValue
		counterValue = newValue
		clickCount++
		lastUpdateTime = Date.new
	
	# Global CSS untuk aplikasi
	css body
		margin: 0
		padding: 0
		font-family: system-ui, -apple-system, sans-serif
		background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
		min-height: 100vh
	
	css self
		max-width: 1200px
		margin: 0 auto
		padding: 40px 20px
	
	css .header
		text-align: center
		color: white
		margin-bottom: 40px
	
	css .header h1
		font-size: 3rem
		margin: 0 0 12px 0
		font-weight: 800
	
	css .header p
		font-size: 1.2rem
		opacity: 0.9
	
	css .dashboard-grid
		display: grid
		grid-template-columns: repeat(auto-fit, minmax(280px, 1fr))
		gap: 20px
		margin-top: 30px
	
	css .counter-section
		display: flex
		justify-content: center
		margin: 30px 0
	
	css .footer
		text-align: center
		color: white
		margin-top: 40px
		padding: 20px
		opacity: 0.8
		font-size: 0.9rem
	
	<self>
		<div.header>
			<h1> "🚀 Imba Interactive Dashboard"
			<p> "Exploring memoized DOM and high-performance UI"
		
		<Stats totalClicks=clickCount lastUpdate=lastUpdateTime>
		
		<div.counter-section>
			<Counter>
		
		<div.dashboard-grid>
			<Card 
				title="Performance"
				description="Memoized DOM membuat update 50-100x lebih cepat dari Virtual DOM"
				color="#10b981"
				icon="⚡"
			>
			<Card 
				title="Bundle Size"
				description="Runtime Imba hanya ~10KB, jauh lebih kecil dari React (~40KB)"
				color="#f59e0b"
				icon="📦"
			>
			<Card 
				title="Syntax"
				description="Indentation-based syntax yang clean dan ekspresif seperti Ruby"
				color="#8b5cf6"
				icon="✨"
			>
			<Card 
				title="Reactive"
				description="Setiap perubahan state otomatis memicu minimal re-render"
				color="#ec4899"
				icon="🔄"
			>
		
		<div.footer>
			<p> "Built with Imba - Alternative Frontend Language"
			<p> "Exploring memoized DOM paradigm for high-performance web apps"

# Mount aplikasi ke DOM
imba.mount <App>