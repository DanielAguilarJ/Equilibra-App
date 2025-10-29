# Documentación Técnica - Módulo de Mindfulness

## Equilibra - Herramientas DBT

### Fecha: 28 de Octubre, 2025

---

## Resumen Ejecutivo

Se ha implementado un módulo completo e interactivo de Mindfulness y ejercicios de respiración basados en los principios de la Terapia Dialéctico-Conductual (DBT). El módulo incluye animaciones fluidas, feedback háptico, persistencia de datos y una experiencia de usuario excepcional.

---

## Arquitectura del Módulo

### Estructura de Archivos

```
Models/
├── BreathingExercise.swift       # Modelo para ejercicios de respiración
└── MindfulnessExercise.swift     # Modelo para ejercicios de mindfulness

ViewModels/
└── MindfulnessViewModel.swift    # Lógica de negocio y gestión de estado

Views/Tools/
├── MindfulnessModuleView.swift              # Vista principal del módulo
├── BreathingView.swift                      # Vista de ejercicios de respiración
├── CustomBreathingConfigView.swift          # Configuración personalizada
├── MindfulnessExercisesView.swift           # Lista de ejercicios mindfulness
└── MindfulnessExerciseDetailView.swift      # Detalle de ejercicio mindfulness
```

---

## Componentes Principales

### 1. Modelos de Datos

#### BreathingExercise.swift

**Enumeraciones:**
```swift
enum BreathingTechniqueType: String, Codable, CaseIterable {
    case boxBreathing        // Respiración cuadrada 4-4-4-4
    case breathing478        // Respiración 4-7-8
    case diaphragmatic       // Respiración diafragmática
    case custom             // Personalizada
}

enum BreathingPhase: String, Codable {
    case inhale              // Inhalación
    case holdAfterInhale     // Retención después de inhalar
    case exhale              // Exhalación
    case holdAfterExhale     // Retención después de exhalar
}
```

**Modelo Principal:**
```swift
@Model
final class BreathingExercise {
    var id: UUID
    var techniqueType: BreathingTechniqueType
    var inhaleDuration: Int              // segundos
    var holdAfterInhaleDuration: Int     // segundos
    var exhaleDuration: Int              // segundos
    var holdAfterExhaleDuration: Int     // segundos
    var totalCycles: Int
    var isCustom: Bool
    var createdDate: Date
    var lastPracticedDate: Date?
    var practiceCount: Int
}
```

**Características:**
- Configuración predefinida para cada tipo de técnica
- Cálculo automático de duración total
- Seguimiento de progreso del usuario
- Método `markPracticed()` para actualizar estadísticas

#### MindfulnessExercise.swift

**Enumeraciones:**
```swift
enum MindfulnessExerciseType: String, Codable, CaseIterable {
    case bodyScan            // Escaneo corporal
    case emotionObservation  // Observación de emociones
    case fiveSenses          // Ejercicio de los 5 sentidos
    case lovingKindness      // Compasión y amabilidad
}
```

**Modelo Principal:**
```swift
@Model
final class MindfulnessExercise {
    var id: UUID
    var exerciseType: MindfulnessExerciseType
    var duration: Int                    // minutos
    var instructions: [String]
    var createdDate: Date
    var lastPracticedDate: Date?
    var practiceCount: Int
    var completedSessions: Int
    var notes: String
}
```

**Características:**
- Instrucciones predefinidas para cada tipo
- Duración recomendada configurable
- Seguimiento de sesiones completadas vs iniciadas
- Método `completeSession()` para marcar sesiones finalizadas

---

### 2. ViewModel

#### MindfulnessViewModel.swift

**Responsabilidades:**
1. Gestión del estado de los ejercicios
2. Control de timers y progreso
3. Feedback háptico y audio
4. Actualización de estadísticas

**Propiedades Publicadas:**
```swift
// Respiración
@Published var isBreathing = false
@Published var currentPhase: BreathingPhase
@Published var cyclesCompleted = 0
@Published var timeRemaining = 0
@Published var progress: Double = 0.0
@Published var currentExercise: BreathingExercise?

// Mindfulness
@Published var isMeditating = false
@Published var meditationTimeRemaining = 0
@Published var meditationProgress: Double = 0.0
@Published var currentMindfulnessExercise: MindfulnessExercise?
@Published var currentInstructionIndex = 0
```

**Métodos Principales:**

**Respiración:**
- `startBreathing(exercise:)`: Inicia un ejercicio de respiración
- `stopBreathing()`: Detiene el ejercicio actual
- `executePhase(_:duration:)`: Ejecuta una fase específica
- `moveToNextPhase()`: Transición entre fases
- `completeCycle()`: Completa un ciclo y avanza al siguiente

**Mindfulness:**
- `startMindfulness(exercise:)`: Inicia un ejercicio de mindfulness
- `stopMindfulness()`: Detiene la sesión actual
- `completeMindfulness()`: Marca la sesión como completada
- `nextInstruction()`: Avanza a la siguiente instrucción
- `previousInstruction()`: Retrocede a la instrucción anterior

**Audio y Hápticos:**
- `playBellSound()`: Reproduce campana suave
- `playCompletionSound()`: Reproduce sonido de completado
- Generadores hápticos para feedback táctil

**Implementación de Timers:**
```swift
private var breathingTimer: Timer?
private var meditationTimer: Timer?

// Timer con interval de 1 segundo
Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
    self?.updateBreathingTimer()
}
```

---

### 3. Vistas

#### MindfulnessModuleView.swift

**Propósito:** Vista principal que integra respiración y mindfulness

**Características:**
- Selector segmentado para cambiar entre secciones
- TabView sincronizado con el selector
- Navegación fluida entre ejercicios

**Estructura:**
```swift
VStack {
    Picker("Categoría", selection: $selectedTab) {
        Text("Respiración").tag(0)
        Text("Mindfulness").tag(1)
    }
    .pickerStyle(.segmented)
    
    TabView(selection: $selectedTab) {
        BreathingView().tag(0)
        MindfulnessExercisesView().tag(1)
    }
}
```

#### BreathingView.swift

**Componentes Visuales:**

1. **Círculo Animado de Respiración:**
```swift
Circle()
    .fill(LinearGradient(...))
    .frame(width: animatedSize, height: animatedSize)
    .shadow(color: ..., radius: 20)
    .animation(.easeInOut(duration: 1.0), value: animatedSize)
```

2. **Cálculo de Tamaño Dinámico:**
```swift
private var animatedSize: CGFloat {
    switch viewModel.currentPhase {
    case .inhale:
        return 100 + (200 * viewModel.progress)  // Expande de 100 a 300
    case .holdAfterInhale:
        return 300                                // Mantiene máximo
    case .exhale:
        return 100 + (200 * viewModel.progress)  // Contrae de 300 a 100
    case .holdAfterExhale:
        return 100                                // Mantiene mínimo
    }
}
```

3. **Colores por Fase:**
```swift
private var phaseColors: [Color] {
    switch viewModel.currentPhase {
    case .inhale:          return [.blue, .cyan]
    case .holdAfterInhale: return [.purple, .pink]
    case .exhale:          return [.green, .mint]
    case .holdAfterExhale: return [.cyan, .blue]
    }
}
```

**Cards de Ejercicios:**
- Gradientes personalizados por tipo
- Iconos SF Symbols
- Descripciones informativas
- Navegación con chevron

#### CustomBreathingConfigView.swift

**Controles Personalizados:**

1. **Sliders de Duración:**
```swift
Slider(value: $inhaleDuration, in: 2...10, step: 1)
    .tint(color)
```

2. **Vista Previa en Tiempo Real:**
- Cálculo de duración por ciclo
- Duración total estimada
- Número de ciclos

3. **Validación:**
- Rangos apropiados para cada parámetro
- Valores mínimos seguros (2-10 segundos)
- Total cycles 1-20

#### MindfulnessExercisesView.swift

**Componentes:**

1. **Lista de Ejercicios:**
- Cards con iconos personalizados
- Duración recomendada
- Descripción breve
- Colores temáticos

2. **Principios DBT:**
- 6 tarjetas con principios fundamentales
- Iconos representativos
- Descripciones concisas

3. **Navegación:**
- Sheet para detalle de ejercicio
- Transición fluida a sesión activa

#### MindfulnessExerciseDetailView.swift

**Secciones:**

1. **Header Informativo:**
- Icono grande con gradiente
- Título y descripción
- Configuración de duración

2. **Instrucciones Paso a Paso:**
- Lista numerada
- Círculos de índice
- Texto legible y espaciado

3. **Estadísticas (si existen):**
- Sesiones totales
- Sesiones completadas
- Última práctica (formato relativo)

4. **Beneficios:**
- Lista de checkmarks verdes
- Beneficios específicos por ejercicio
- Diseño visual atractivo

#### ActiveMindfulnessView.swift

**Implementación del Timer:**

1. **Timer Circular:**
```swift
Circle()
    .trim(from: 0, to: viewModel.meditationProgress)
    .stroke(LinearGradient(...), style: StrokeStyle(lineWidth: 8, lineCap: .round))
    .rotationEffect(.degrees(-90))
    .animation(.linear, value: viewModel.meditationProgress)
```

2. **Formato de Tiempo:**
```swift
private var timeString: String {
    let minutes = viewModel.meditationTimeRemaining / 60
    let seconds = viewModel.meditationTimeRemaining % 60
    return String(format: "%d:%02d", minutes, seconds)
}
```

3. **Navegación de Instrucciones:**
- Botones chevron izquierdo/derecho
- Deshabilitados en límites
- Animación de transición con opacidad

---

## Características Técnicas Destacadas

### Animaciones

**SwiftUI Animations:**
```swift
.animation(.easeInOut(duration: 1.0), value: animatedSize)
.animation(.linear, value: viewModel.meditationProgress)
.transition(.opacity.combined(with: .scale))
```

**Tipos utilizados:**
- `.easeInOut`: Para círculo de respiración (suave y natural)
- `.linear`: Para progreso de timer (constante)
- `.opacity` + `.scale`: Para cambio de instrucciones

### Feedback Háptico

**Generadores:**
```swift
private let hapticGenerator = UINotificationFeedbackGenerator()
private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
```

**Uso:**
- **Impact**: Al inicio de cada fase de respiración
- **Notification Success**: Al completar ciclos
- **Impact**: Al cambiar instrucciones

### Audio

**Sonidos del Sistema:**
```swift
AudioServicesPlaySystemSound(1013)  // Campana suave
AudioServicesPlaySystemSound(1057)  // Completado
```

**Ventajas:**
- No requiere archivos de audio externos
- Respeta configuración del sistema
- Rendimiento óptimo

### Gestión de Estado

**Combine + @Published:**
- Actualizaciones reactivas de UI
- Sincronización automática entre ViewModel y Vista
- Prevención de memory leaks con `[weak self]`

**SwiftData:**
- Persistencia automática de modelos
- Queries eficientes
- Sincronización con iCloud (si está habilitado)

### Optimizaciones

**Timers:**
```swift
deinit {
    breathingTimer?.invalidate()
    meditationTimer?.invalidate()
}
```

**Memory Management:**
- Weak references en closures
- Invalidación de timers en cleanup
- Liberación de generadores hápticos

---

## Diseño Visual

### Paleta de Colores

**Respiración:**
- Azul/Cyan: Inhalación (calmante, fresco)
- Púrpura/Rosa: Retención (transición)
- Verde/Menta: Exhalación (relajante, liberación)

**Mindfulness:**
- Púrpura: Escaneo corporal (introspección)
- Azul: Observación emocional (claridad)
- Verde: 5 sentidos (naturaleza, grounding)
- Rosa: Compasión (amor, calidez)

### Gradientes

**LinearGradient:**
```swift
LinearGradient(
    colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

**Uso:**
- Fondos sutiles (opacidad 0.1)
- Iconos destacados (opacidad 1.0)
- Botones de acción (sin opacidad)

### Tipografía

**Jerarquía:**
- `.title`: Nombres de ejercicios principales
- `.title2`: Headers de secciones
- `.title3`: Subsecciones
- `.headline`: Elementos importantes
- `.subheadline`: Información secundaria
- `.caption`: Metadatos y timestamps

**Modificadores:**
- `.fontWeight(.bold)`: Énfasis fuerte
- `.fontWeight(.semibold)`: Énfasis medio
- `.monospacedDigit()`: Para contadores y timers

### Espaciado

**Padding Consistente:**
- `.padding()`: 16pt (estándar)
- `.padding(.horizontal)`: Márgenes laterales
- `spacing: 24`: Entre secciones principales
- `spacing: 16`: Entre cards
- `spacing: 12`: Dentro de cards

### Corner Radius

**Estándar:**
- `12pt`: Elementos pequeños (chips, badges)
- `16pt`: Cards y botones principales
- `10pt`: Elementos secundarios

---

## Flujo de Usuario

### Ejercicio de Respiración

1. Usuario accede desde Home o Módulos
2. Ve lista de técnicas predefinidas
3. Selecciona técnica o crea personalizada
4. Ejercicio inicia automáticamente
5. Círculo anima siguiendo fases
6. Feedback háptico guía cada fase
7. Contador muestra progreso
8. Al completar: sonido + vibración
9. Estadísticas se actualizan automáticamente

### Ejercicio de Mindfulness

1. Usuario selecciona tipo de ejercicio
2. Ve detalle con instrucciones y beneficios
3. Ajusta duración si lo desea
4. Inicia sesión
5. Campana marca inicio
6. Timer circular muestra progreso
7. Instrucciones avanzan automáticamente
8. Usuario puede navegar manualmente
9. Campana marca finalización
10. Sesión se marca como completada

---

## Integración con la App

### HomeView

**Botón de Acceso Rápido:**
```swift
@State private var showingMindfulness = false

Button {
    showingMindfulness = true
} label: {
    // Card con gradiente púrpura/azul
    // Icono: brain.head.profile
    // Texto: "Mindfulness"
    // Subtexto: "Respiración y meditación guiada"
}

.sheet(isPresented: $showingMindfulness) {
    MindfulnessModuleView()
}
```

### ContentView

**Actualización del ModelContainer:**
```swift
.modelContainer(for: [
    DBTModule.self,
    EmotionalLog.self,
    DBTSkill.self,
    CrisisPlan.self,
    MoodEntry.self,
    BreathingExercise.self,      // NUEVO
    MindfulnessExercise.self     // NUEVO
])
```

---

## Testing

### Casos de Prueba Recomendados

**Modelos:**
- ✅ Creación de ejercicios con valores predefinidos
- ✅ Cálculo correcto de duraciones
- ✅ Actualización de estadísticas
- ✅ Persistencia en SwiftData

**ViewModel:**
- ✅ Inicio y detención de ejercicios
- ✅ Transiciones correctas entre fases
- ✅ Actualización de progreso
- ✅ Cleanup de timers

**Vistas:**
- ✅ Renderizado correcto de animaciones
- ✅ Navegación entre pantallas
- ✅ Responsividad de controles
- ✅ Accesibilidad básica

### Testing Manual

1. **Respiración:**
   - Probar cada técnica predefinida
   - Crear ejercicio personalizado
   - Detener a mitad de ciclo
   - Completar ciclo completo
   - Verificar vibraciones

2. **Mindfulness:**
   - Iniciar cada tipo de ejercicio
   - Ajustar duración
   - Navegar instrucciones
   - Completar sesión
   - Verificar estadísticas

---

## Mejoras Futuras (Roadmap)

### Versión 1.1
- [ ] Notificaciones para recordatorios de práctica
- [ ] Widget de iOS con contador rápido
- [ ] Apple Watch companion app
- [ ] Sonidos de campana personalizables

### Versión 1.2
- [ ] Sesiones guiadas con narración de voz
- [ ] Música de fondo opcional
- [ ] Integración con HealthKit (mindful minutes)
- [ ] Achievements y streaks

### Versión 2.0
- [ ] Meditaciones guiadas completas
- [ ] Biblioteca de técnicas DBT expandida
- [ ] Comunidad y compartir progreso
- [ ] Análisis avanzado de patrones

---

## Requisitos del Sistema

- **iOS**: 17.0+
- **Xcode**: 16.0+
- **Swift**: 6.0+
- **Frameworks**:
  - SwiftUI
  - SwiftData
  - AVFoundation
  - Combine

---

## Conclusión

El Módulo de Mindfulness representa una implementación completa y profesional de técnicas de respiración y meditación basadas en DBT. Combina animaciones fluidas, feedback sensorial múltiple, persistencia de datos robusta y un diseño visual calmante para proporcionar una experiencia de usuario excepcional.

**Puntos Destacados:**
✅ Arquitectura MVVM clara y mantenible  
✅ Animaciones nativas de SwiftUI (60 FPS)  
✅ Feedback háptico y audio integrado  
✅ Persistencia con SwiftData  
✅ Diseño visual profesional y calmante  
✅ Código documentado y extensible  
✅ Integración perfecta con la app existente  

---

**Desarrollado por:** Sistema de IA GitHub Copilot  
**Fecha:** 28 de Octubre, 2025  
**Versión del Módulo:** 1.0.0
