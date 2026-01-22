# 🔬 Technical Deep Dive: Imba Memoized DOM

## 📚 Daftar Isi
1. [Konsep Memoized DOM](#konsep-memoized-dom)
2. [Alur State → DOM](#alur-state--dom)
3. [Compilation Process](#compilation-process)
4. [Performance Analysis](#performance-analysis)
5. [Comparison dengan Framework Lain](#comparison-dengan-framework-lain)

---

## 🧩 Konsep Memoized DOM

### Apa itu Memoization?
Memoization adalah teknik optimasi yang menyimpan hasil perhitungan dan mengembalikannya ketika input yang sama diterima lagi, tanpa perlu menghitung ulang.

### Memoized DOM di Imba
Imba menerapkan memoization pada level **DOM rendering**:

```imba
# Kode Imba
tag Counter
    prop count = 0
    
    <self>
        <div> "Count: {count}"
        <button @click=(count++)> "Increment"
```

**Yang terjadi di balik layar:**

1. **Compile Time**: Kompiler menganalisis dependency
   - `<div>` text node bergantung pada `count`
   - `<button>` tidak bergantung pada `count`

2. **Runtime**: Imba membuat "flag" memoization
   ```javascript
   // Pseudo-code hasil kompilasi
   if (this.count !== prevCount) {
       // HANYA update text node yang berubah
       divElement.textContent = "Count: " + this.count;
   }
   // Button TIDAK di-touch sama sekali
   ```

3. **Update**: Ketika `count` berubah
   - Imba langsung tahu DOM mana yang perlu di-update
   - Tidak perlu traverse seluruh tree
   - Tidak perlu diffing algorithm

---

## 🔄 Alur State → DOM

### Diagram Alur Lengkap

```
┌─────────────────────────────────────────────────────────┐
│ 1. USER INTERACTION                                      │
│    ↓                                                     │
│    User clicks button → Event triggered                 │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 2. STATE UPDATE (Imba Reactive System)                  │
│    ↓                                                     │
│    count++ → Imba detects property change               │
│           → Marks component as "dirty"                  │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 3. SCHEDULED RENDER (Microtask)                         │
│    ↓                                                     │
│    Imba schedules render via requestAnimationFrame      │
│    (batch multiple updates in same frame)               │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 4. MEMOIZED RENDER (Smart Update)                       │
│    ↓                                                     │
│    Component.render() called                            │
│    ↓                                                     │
│    Check memoization flags:                             │
│    - Has `count` changed? YES                           │
│    - Which DOM nodes depend on `count`?                 │
│      → Only the <div> text node                         │
│    ↓                                                     │
│    UPDATE ONLY THAT SPECIFIC TEXT NODE                  │
│    (Skip everything else)                               │
└─────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────┐
│ 5. DOM UPDATED                                          │
│    ↓                                                     │
│    Browser re-paints only changed regions               │
│    (Paint optimization by browser engine)               │
└─────────────────────────────────────────────────────────┘
```

### Contoh Konkret dengan Counter Component

**Kode Imba:**
```imba
tag Counter
    prop count = 0
    
    <self>
        <div.header> "Counter Dashboard"
        <div.display> "Count: {count}"
        <button @click=(count++)> "+"
        <button @click=(count--)> "-"
```

**Step-by-step saat User Click:**

1. **User klik button "+"**
   ```javascript
   // Event handler dijalankan
   this.count++ // count berubah dari 0 → 1
   ```

2. **Imba mendeteksi perubahan**
   ```javascript
   // Internal Imba mechanism
   Object.defineProperty(this, 'count', {
       set(value) {
           this._count = value;
           this.schedule(); // Mark untuk render
       }
   });
   ```

3. **Scheduled render (batched)**
   ```javascript
   // Imba batching system
   scheduleRender() {
       if (!this.renderScheduled) {
           this.renderScheduled = true;
           requestAnimationFrame(() => this.render());
       }
   }
   ```

4. **Render dengan memoization**
   ```javascript
   // Pseudo-code hasil kompilasi
   render() {
       // header TIDAK bergantung pada count → SKIP
       // display text bergantung pada count → UPDATE
       if (this.count !== this._prevCount) {
           this.displayNode.textContent = "Count: " + this.count;
           this._prevCount = this.count;
       }
       // buttons TIDAK bergantung pada count → SKIP
   }
   ```

**Total DOM operations: 1 textContent update**
- React equivalent: Bisa 5-10+ operations (create vDOM, diff, patch)

---

## ⚙️ Compilation Process

### Dari Imba ke JavaScript

**Input (Imba):**
```imba
tag SimpleCard
    prop title = "Hello"
    
    <self>
        <h1> title
        <p> "Static text"
```

**Output (Compiled JavaScript - Simplified):**
```javascript
class SimpleCard extends ImbaElement {
    constructor() {
        super();
        this.title = "Hello";
        this._prevTitle = undefined;
    }
    
    render() {
        // First render: create elements
        if (!this._initialized) {
            this.h1 = document.createElement('h1');
            this.p = document.createElement('p');
            this.p.textContent = "Static text"; // Static → set once
            this.appendChild(this.h1);
            this.appendChild(this.p);
            this._initialized = true;
        }
        
        // Subsequent renders: memoized update
        if (this.title !== this._prevTitle) {
            this.h1.textContent = this.title;
            this._prevTitle = this.title;
        }
        // p tidak pernah di-update lagi (static)
    }
}
```

### Key Optimizations dari Compiler:

1. **Static Analysis**
   - Identifikasi elemen static vs dynamic
   - Static elements di-set sekali saat mount
   - Dynamic elements di-track untuk updates

2. **Dependency Tracking**
   - Kompiler tahu: `<h1>` bergantung pada `title`
   - Kompiler tahu: `<p>` tidak bergantung pada apapun
   - Generate kode dengan minimal checks

3. **Efficient DOM APIs**
   - Gunakan `textContent` untuk text
   - Gunakan `setAttribute` hanya saat perlu
   - Cache DOM references

---

## 📊 Performance Analysis

### Benchmark: Imba vs React vs Vue

**Test Case: Update 1000 items in list**

```
Framework     | Initial Render | Update All | Update 1 | Memory
------------- | -------------- | ---------- | -------- | -------
Imba          | 12ms          | 8ms        | 0.1ms   | 1.2MB
React         | 45ms          | 78ms       | 2.5ms   | 4.8MB
Vue 3         | 38ms          | 65ms       | 1.8ms   | 3.9MB
Vanilla JS    | 10ms          | 5ms        | 0.05ms  | 0.8MB
```

**Kenapa Imba Cepat?**

1. **No Virtual DOM Overhead**
   - React: Create vDOM → Diff → Patch (3 steps)
   - Imba: Direct update (1 step)

2. **Minimal Re-renders**
   ```
   React: Component re-render → All children checked
   Imba:  Only changed nodes updated
   ```

3. **Compile-Time Optimization**
   - React: Runtime reconciliation
   - Imba: Compile-time dependency analysis

### Memory Efficiency

**React Component:**
```javascript
// Memory: Component instance + Virtual DOM tree + Fiber nodes
{
    component: ComponentInstance,
    vdom: VirtualDOMTree, // Extra memory
    fiber: FiberNode,     // Extra memory
    state: StateObject
}
```

**Imba Component:**
```javascript
// Memory: Component instance + Direct DOM references
{
    component: ComponentInstance,
    domRefs: DOMNodeReferences, // Minimal
    state: StateObject
}
```

**Imba hemat ~60-70% memory untuk complex apps**

---

## 🆚 Comparison dengan Framework Lain

### React (Virtual DOM)

**Approach:**
```
State → Create vDOM → Diff with prev vDOM → Patch real DOM
```

**Pros:**
- Declarative API yang familiar
- Huge ecosystem
- Battle-tested di production

**Cons:**
- Virtual DOM overhead
- Re-render entire subtree by default
- Butuh optimization (memo, useMemo, useCallback)

**When to use:**
- Large teams
- Complex apps dengan banyak third-party integration
- Production apps dengan long-term maintenance

---

### Vue (Virtual DOM + Template Compilation)

**Approach:**
```
State → Create vDOM (from template) → Diff → Patch
```

**Pros:**
- Template compilation optimization
- Reactive system yang bagus
- Good developer experience

**Cons:**
- Still virtual DOM overhead (walau lebih optimal dari React)
- Template syntax learning curve

**When to use:**
- Progressive enhancement
- Teams yang prefer template-based
- Good balance antara performance dan DX

---

### Svelte (Compile to Vanilla JS)

**Approach:**
```
State → Direct DOM update (via compiled code)
```

**Pros:**
- No runtime overhead
- Compiled reactive updates
- Small bundle size

**Cons:**
- Component size grows dengan complexity
- Diffing still happens untuk dynamic lists

**Similarities with Imba:**
- Compile-time optimization
- No virtual DOM
- Direct DOM manipulation

**Differences:**
- Svelte: Compiles to imperative code
- Imba: Memoization-based updates

---

### Imba (Memoized DOM)

**Approach:**
```
State → Memoized check → Direct DOM update (minimal)
```

**Pros:**
- Fastest updates (50-100x vs React)
- Smallest bundle (~10KB)
- Elegant syntax
- Built-in server-side rendering

**Cons:**
- Small ecosystem
- New syntax learning curve
- Limited libraries/tools

**When to use:**
- Performance-critical dashboards
- Real-time applications
- Internal tools
- Learning/portfolio projects

---

## 🎯 Kesimpulan Teknis

### Imba's Unique Value Proposition:

1. **Compile-Time Intelligence**
   - Dependency tracking saat compile
   - Generated code sudah optimal

2. **Runtime Efficiency**
   - Minimal checks saat render
   - Direct DOM manipulation
   - No intermediate representation (vDOM)

3. **Developer Experience**
   - Clean syntax
   - Less boilerplate
   - Fast feedback loop

### The Trade-off:

```
Performance & Bundle Size ↔ Ecosystem & Community
        (Imba wins)              (React wins)
```

### Engineering Insight:

**Imba membuktikan bahwa:**
- Virtual DOM bukan satu-satunya solusi
- Compile-time analysis bisa mengalahkan runtime optimization
- Syntax innovation bisa improve developer productivity
- Alternative paradigms matter untuk evolusi web development

**Key Lesson:**
> "Don't blindly follow mainstream. 
> Understand trade-offs, explore alternatives, 
> choose tools based on actual requirements."

---

**References:**
- [Imba Official Docs](https://imba.io/docs)
- [JS Framework Benchmark](https://krausest.github.io/js-framework-benchmark/)
- [Virtual DOM is Pure Overhead](https://svelte.dev/blog/virtual-dom-is-pure-overhead)