# Vista Previa Visual - Herramientas de Regulación Emocional

## 📱 Flujo de Navegación

```
Home (TabView)
│
├─ Botón "Regulación Emocional" (acceso rápido)
│  └─> EmotionRegulationToolsView (Sheet)
│      │
│      ├─ Card "PLEASE" 
│      │  └─> PLEASEToolView (Sheet)
│      │      ├─ Header con descripción
│      │      ├─ Barra de progreso
│      │      ├─ 5 Secciones colapsables:
│      │      │  ├─ Physical Illness (rojo)
│      │      │  ├─ Eating (naranja)
│      │      │  ├─ Avoid Substances (púrpura)
│      │      │  ├─ Sleep (índigo)
│      │      │  └─ Exercise (cyan)
│      │      ├─ Notas adicionales
│      │      ├─ Registros recientes (últimos 3)
│      │      └─ Botón "Guardar"
│      │
│      ├─ Card "Check the Facts"
│      │  └─> CheckTheFactsView (Sheet)
│      │      ├─ Barra de progreso (4 pasos)
│      │      ├─ Paso 1: Identificar emoción + slider
│      │      ├─ Paso 2: Describir situación
│      │      ├─ Paso 3: 8 Preguntas socráticas
│      │      ├─ Paso 4: Revisión y comparación
│      │      ├─ Navegación Anterior/Siguiente
│      │      └─ Modal de completado
│      │
│      ├─ Card "Opposite Action"
│      │  └─> OppositeActionView (Sheet)
│      │      ├─ Barra de progreso (4 pasos)
│      │      ├─ Paso 1: Seleccionar emoción (5 opciones)
│      │      ├─ Paso 2: Identificar impulso
│      │      ├─ Paso 3: Ver acción opuesta + ejemplos
│      │      ├─ Paso 4: Evaluación resultados
│      │      ├─ Navegación Anterior/Siguiente
│      │      └─ Alert de completado
│      │
│      ├─ Sesiones Recientes (últimas 3)
│      │  └─ SessionCard para cada una
│      │
│      ├─ Resumen estadístico
│      │  ├─ Total sesiones
│      │  └─ Sesiones esta semana
│      │
│      └─ Botón de estadísticas (toolbar)
│         └─> EmotionRegulationStatsView (Sheet)
│             ├─ Resumen general (4 stats)
│             ├─ Gráfico de barras (uso por herramienta)
│             ├─ Efectividad por herramienta
│             ├─ Top 5 emociones trabajadas
│             └─ Gráfico de líneas (cambios intensidad)
│
└─ Módulos (TabView)
   └─ Regulación Emocional
      └─ Botón "Herramientas Interactivas"
         └─> EmotionRegulationToolsView (Sheet)
```

## 🎨 Paleta de Colores por Vista

### EmotionRegulationToolsView
- **Background:** systemGroupedBackground
- **Cards:** white con sombra sutil
- **Acento:** Azul
- **Icons:**
  - PLEASE: Verde
  - Check the Facts: Azul
  - Opposite Action: Púrpura

### PLEASEToolView
- **Header:** Verde con opacity 0.1
- **Progress bar:** Verde
- **Secciones:**
  - Physical: Rojo (#FF3B30)
  - Eating: Naranja (#FF9500)
  - Avoid: Púrpura (#AF52DE)
  - Sleep: Índigo (#5856D6)
  - Exercise: Cyan (#32ADE6)
- **Checkmarks:** Verde
- **Guardado:** Verde gradient

### CheckTheFactsView
- **Header:** Azul con opacity 0.1
- **Progress bar:** Azul
- **Intensidad:**
  - 1-3: Verde
  - 4-6: Naranja
  - 7-10: Rojo
- **Preguntas:** Numeradas con círculos azules
- **Navegación:** Azul gradient

### OppositeActionView
- **Header:** Púrpura con opacity 0.1
- **Progress bar:** Púrpura
- **Emociones:** Cards seleccionables
- **Comparación:**
  - Antes: Rojo opacity 0.1
  - Después: Verde opacity 0.1
- **Navegación:** Púrpura gradient

### EmotionRegulationStatsView
- **Gráficos:**
  - PLEASE: Verde
  - Check Facts: Azul
  - Opposite: Púrpura
- **Stats boxes:** Iconos con colores temáticos
- **Líneas:**
  - Antes: Rojo
  - Después: Verde

## 📐 Componentes Reutilizables

### ToolCard
```
┌─────────────────────────────────────┐
│ ○ [Icono]  Título                   │
│            Descripción breve        │
│            (2 líneas max)           │
│                              >      │
└─────────────────────────────────────┘
```
- Padding: 16pt
- Corner radius: 16pt
- Shadow: 0.05 opacity

### SessionCard
```
┌─────────────────────────────────────┐
│ [Icono] Herramienta    hace 2 horas │
│ 😐 Emoción    8 → 4    👍          │
└─────────────────────────────────────┘
```
- Padding: 12pt
- Corner radius: 12pt
- Background: systemBackground

### PLEASECard (Colapsable)
```
┌─────────────────────────────────────┐
│ [Icono] Título              ∨/∧     │
│         Subtítulo                   │
├─────────────────────────────────────┤ (si expandido)
│ Contenido de la sección...         │
│ [Controles interactivos]           │
│ 💡 Tip: ...                        │
└─────────────────────────────────────┘
```
- Animación: spring(response: 0.3)
- Transition: opacity + move

### StepCard
```
┌─────────────────────────────────────┐
│ [Icono] Título del Paso            │
│                                     │
│ Contenido del paso...              │
│ [Controles específicos]            │
│                                     │
└─────────────────────────────────────┘
```
- Padding: 16pt
- Corner radius: 16pt
- Background: systemBackground

### QuestionCard (Expandible)
```
┌─────────────────────────────────────┐
│ ① Pregunta completa aquí?    ∨/∧   │
├─────────────────────────────────────┤ (si expandido)
│ [TextEditor para respuesta]        │
│                                     │
└─────────────────────────────────────┘
```
- Número en círculo azul
- Height del editor: 80pt
- Animation: spring(response: 0.3)

### StatCard/StatBox
```
┌──────────────────┐
│ [Icono]          │
│ 25               │ (valor grande)
│ Total Sesiones   │ (caption)
└──────────────────┘
```
- Usado en grids
- Corner radius: 12pt

## 🔄 Animaciones Implementadas

### Progressive Disclosure
- **Tipo:** Spring animation
- **Response:** 0.3 segundos
- **Usado en:**
  - Expansión/colapso de PLEASECard
  - Expansión de QuestionCard
  - Transiciones entre pasos

### Progress Bars
- **Tipo:** Linear
- **Tint:** Color de la herramienta
- **Used in:**
  - PLEASE completion
  - Step progress (Check Facts, Opposite Action)

### Sheet Presentations
- **Tipo:** Default SwiftUI
- **Dismiss gesture:** Habilitado
- **Used for:**
  - Todas las herramientas principales
  - Vista de estadísticas
  - Pantalla de completado

## 📏 Espaciado y Tipografía

### Espaciado Estándar
- **Padding externo:** 16-20pt
- **Padding interno cards:** 12-16pt
- **Spacing vertical:** 20-24pt
- **Spacing horizontal:** 12-16pt

### Jerarquía Tipográfica
1. **Títulos principales:** .title2, bold
2. **Subtítulos sección:** .headline
3. **Cuerpo:** .subheadline o .body
4. **Captions:** .caption o .caption2
5. **Valores grandes:** .title o .title2, bold

### Iconografía (SF Symbols)
- **Tamaño pequeño:** .caption
- **Tamaño medio:** .title3 o .title2
- **Tamaño grande:** .title o .largeTitle
- **Estilo:** .fill para estados activos

## 🎯 Estados Visuales

### Botones
- **Default:** systemGray6 background
- **Selected:** Color temático con opacity
- **Disabled:** systemGray5 con opacidad
- **Activo:** Gradient del color temático

### Inputs
- **TextEditor:** systemGray6 background, 8pt corner
- **TextField:** .roundedBorder style
- **Slider:** Tint dinámico según valor
- **Toggle:** .green tint
- **Picker:** .segmented style

### Feedback
- **Éxito:** Verde con checkmark
- **Mejora:** Flecha hacia abajo verde
- **Útil:** Thumbs up verde
- **No útil:** Thumbs down naranja

## 📊 Charts (Swift Charts)

### BarMark (Uso de herramientas)
- **X:** Nombre de herramienta
- **Y:** Cantidad de usos
- **Color:** Por herramienta (scale)
- **Annotations:** Valores en la parte superior

### LineMark (Cambios de intensidad)
- **Series 1:** Antes (rojo, círculos)
- **Series 2:** Después (verde, cuadrados)
- **Y-Scale:** 0-10
- **X:** Índice de sesión
- **Leyenda:** En la parte inferior

## 🎭 Accesibilidad

### Contraste
- ✅ Todos los textos cumplen WCAG AA
- ✅ Iconos con labels descriptivos
- ✅ Estados activos claramente diferenciados

### VoiceOver Ready
- Labels en todos los botones
- Hints en controles complejos
- Grupos lógicos de elementos

### Dynamic Type
- ✅ Todas las vistas responden a cambios de tamaño de fuente
- ✅ Layouts flexibles con VStack/HStack

## 🖼️ Layout Responsivo

### iPhone (Compacto)
- Scrollviews para contenido largo
- Grids de 2 columnas para stats
- Cards de ancho completo

### iPad (Regular) - Futuro
- Grids de 3-4 columnas
- Sidebars potenciales
- Layouts más anchos

## 🎨 Gradientes Usados

### Home - Regulación Emocional
```swift
LinearGradient(
    colors: [.blue.opacity(0.1), .cyan.opacity(0.1)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Botones de Acción
```swift
// Verde (PLEASE)
.green.gradient

// Azul (Check Facts)
.blue.gradient

// Púrpura (Opposite)
.purple.gradient
```

---

## 🎬 Experiencia del Usuario

### Primer Uso
1. Usuario ve botón destacado en Home
2. Toca y ve menú claro de 3 herramientas
3. Cards explican qué hace cada una
4. Elige herramienta y es guiado paso a paso
5. Recibe feedback positivo al completar
6. Ve su progreso en estadísticas

### Uso Recurrente
1. Acceso rápido desde Home conocido
2. Historial muestra sesiones previas
3. Estadísticas muestran tendencias
4. Puede elegir herramienta según necesidad

### Progressive Learning
- **Día 1-7:** Exploración, PLEASE diario
- **Día 8-14:** Dominio PLEASE, introducción Check Facts
- **Día 15+:** Uso confortable de las 3 herramientas según necesidad

---

Esta estructura visual garantiza:
- ✅ Consistencia en toda la app
- ✅ Jerarquía visual clara
- ✅ Feedback inmediato
- ✅ Navegación intuitiva
- ✅ Accesibilidad
- ✅ Diseño profesional y pulido
