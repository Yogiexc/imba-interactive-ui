# 🚀 Getting Started: Imba Interactive Dashboard

## 📋 Prerequisites

Before you begin, ensure you have:
- **Node.js** 16.x or higher ([Download](https://nodejs.org/))
- **npm** or **yarn** package manager
- Basic understanding of JavaScript
- Code editor (VS Code recommended)

---

## 🛠️ Installation Methods

### Method 1: Quick Start (Recommended)

```bash
# 1. Install Imba globally
npm install -g imba

# 2. Verify installation
imba --version
# Should output: 2.0.0-alpha.240 (or similar)

# 3. Clone or create project directory
mkdir imba-interactive-ui
cd imba-interactive-ui

# 4. Create structure
mkdir -p src/components
```

### Method 2: Local Project Setup

```bash
# 1. Initialize npm project
npm init -y

# 2. Install Imba locally
npm install imba

# 3. Create structure
mkdir -p src/components
```

---

## 📁 File Structure Setup

Create the following files:

```
imba-interactive-ui/
├── src/
│   ├── app.imba              # Main application
│   └── components/
│       └── card.imba         # Card component
├── index.html                # HTML entry point
├── package.json              # Dependencies
└── README.md                 # Documentation
```

### Create Files:

**1. src/components/card.imba**
```bash
# Copy content dari artifact "Card Component"
```

**2. src/app.imba**
```bash
# Copy content dari artifact "Main App"
```

**3. index.html**
```bash
# Copy content dari artifact "index.html"
```

**4. package.json**
```bash
# Copy content dari artifact "package.json"
```

---

## 🏃 Running the Project

### Development Mode (Hot Reload)

**Option A: Using Global Imba**
```bash
# Navigate to project root
cd imba-interactive-ui

# Start dev server
imba serve src/app.imba

# Output:
# Server running at http://localhost:8080
# Watching for changes...
```

**Option B: Using Local Imba**
```bash
# Add to package.json scripts:
{
  "scripts": {
    "dev": "imba serve src/app.imba"
  }
}

# Run:
npm run dev
```

**Your app is now running at:** `http://localhost:8080`

---

## 🔨 Building for Production

### Compile Imba to JavaScript

```bash
# Build single file
imba build src/app.imba -o dist/app.js

# Or use package.json script
npm run build
```

### Output:
```
dist/
└── app.js    # Compiled JavaScript (ready for production)
```

### Serve Production Build

**Update index.html:**
```html
<!-- Change this line: -->
<script type="module" src="./src/app.imba"></script>

<!-- To this: -->
<script type="module" src="./dist/app.js"></script>
```

**Serve with any static server:**
```bash
# Option 1: Python
python -m http.server 8000

# Option 2: Node.js serve
npx serve .

# Option 3: VS Code Live Server
# Right-click index.html → Open with Live Server
```

---

## 🎨 VS Code Setup (Optional)

### Install Imba Extension

1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search "Imba"
4. Install "Imba Language Support"

### Features:
- Syntax highlighting
- Auto-completion
- Error detection
- Code formatting

---

## 🐛 Troubleshooting

### Issue 1: `imba: command not found`

**Solution:**
```bash
# Install globally
npm install -g imba

# Or use npx
npx imba serve src/app.imba
```

---

### Issue 2: Port 8080 already in use

**Solution:**
```bash
# Specify custom port
imba serve src/app.imba -p 3000

# Or kill process using port 8080
# Linux/Mac:
lsof -ti:8080 | xargs kill

# Windows:
netstat -ano | findstr :8080
taskkill /PID <PID> /F
```

---

### Issue 3: Module not found errors

**Solution:**
```bash
# Ensure correct import path
# In app.imba:
import './components/card'  # ✅ Correct

# NOT:
import './components/card.imba'  # ❌ Wrong
import 'card'                     # ❌ Wrong
```

---

### Issue 4: White screen / Nothing renders

**Check:**

1. **Browser console** for errors (F12)
2. **File paths** are correct
3. **Imba syntax** is valid
4. **Component mount** is called:
   ```imba
   # Should be at end of app.imba
   imba.mount <App>
   ```

---

## 📖 Learning Path

### Step 1: Understand the Code (30 mins)

Read through:
1. `card.imba` - Component basics
2. `app.imba` - State management
3. `TECHNICAL_DEEP_DIVE.md` - How it works

### Step 2: Make Changes (1 hour)

**Easy modifications:**
```imba
# In Counter component (app.imba)
# Change initial count
prop count = 10  # Instead of 0

# Change step value
prop step = 5    # Instead of 1

# Add new button
<button.btn-primary @click=(count+=10)> "+10"
```

**Medium modifications:**
```imba
# Add new card
<Card 
    title="Custom Feature"
    description="Your description here"
    color="#ff6b6b"
    icon="🎨"
>
```

**Advanced modifications:**
```imba
# Create new component
tag Timer
    prop seconds = 0
    
    def mount
        setInterval(&, 1000) do
            seconds++
    
    <self>
        <div> "Timer: {seconds}s"
```

### Step 3: Explore Imba (2-3 hours)

1. Read [Official Docs](https://imba.io/docs)
2. Try [Interactive Tutorial](https://imba.io/tutorial)
3. Join [Discord Community](https://discord.gg/imba)

---

## 🎯 Next Steps

### Extend the Dashboard:

1. **Add Data Visualization**
   ```imba
   # Install chart library
   npm install chart.js
   
   # Create chart component
   tag ChartWidget
       # ... implementation
   ```

2. **Add API Integration**
   ```imba
   tag DataFetcher
       prop data = []
       
       def mount
           let res = await window.fetch('https://api.example.com')
           data = await res.json!
   ```

3. **Add Routing**
   ```imba
   # Install imba router
   npm install imba-router
   
   # Create multi-page app
   ```

4. **Add State Management**
   ```imba
   # Create global store
   global class AppStore
       prop user = null
       prop settings = {}
   ```

---

## 📚 Additional Resources

### Official:
- [Imba Documentation](https://imba.io/docs)
- [Imba GitHub](https://github.com/imba/imba)
- [Imba Discord](https://discord.gg/imba)

### Community:
- [Imba Examples](https://github.com/imba/imba/tree/master/examples)
- [Awesome Imba](https://github.com/koolamusic/awesome-imba)

### Comparison:
- [JS Framework Benchmark](https://krausest.github.io/js-framework-benchmark/)
- [Virtual DOM vs Memoized DOM](https://imba.io/docs/performance)

---

## ✅ Checklist

Before you're done, make sure you:

- [ ] Can run the app in development mode
- [ ] Understand the Counter component state flow
- [ ] Can modify Card component props
- [ ] Know how to add new components
- [ ] Read the technical deep dive
- [ ] Tried building for production
- [ ] Explored Imba syntax differences

---

## 🎓 Key Takeaways

After completing this tutorial, you should understand:

1. **Memoized DOM** is faster than Virtual DOM for updates
2. **Compile-time analysis** enables runtime optimization
3. **Alternative syntax** can improve developer experience
4. **Trade-offs** between performance and ecosystem
5. **When to use** Imba vs mainstream frameworks

---

## 💬 Questions?

If you're stuck:
1. Check the troubleshooting section above
2. Read error messages carefully
3. Search [Imba Discord](https://discord.gg/imba)
4. Review [official docs](https://imba.io/docs)

---

**Happy Coding! 🚀**

*"The best way to learn is by building."*