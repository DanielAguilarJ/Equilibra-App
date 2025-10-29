# Sistema de Seguimiento Emocional Diario

## Descripción General

Sistema completo de seguimiento emocional integrado en la aplicación Equilibra - Herramientas DBT, diseñado para ayudar a los usuarios a registrar, analizar y comprender sus patrones emocionales.

## Arquitectura

### Modelos de Datos

#### MoodEntry (`Models/MoodEntry.swift`)

Modelo principal para el seguimiento emocional que incluye:

**Propiedades Principales:**
- `id`: UUID - Identificador único
- `timestamp`: Date - Fecha y hora del registro
- `emotionType`: EmotionType - Tipo de emoción (enum)
- `intensity`: Int - Intensidad emocional (1-10)
- `triggers`: [String] - Desencadenantes identificados
- `copingStrategies`: [CopingStrategy] - Estrategias utilizadas
- `notes`: String - Notas adicionales
- `wasEffective`: Bool? - Efectividad de las estrategias

**Integración HealthKit:**
- `healthKitSynced`: Bool - Estado de sincronización
- `healthKitID`: String? - ID de HealthKit

**Enums Asociados:**

**EmotionType** - 8 emociones principales:
- Alegría 😊
- Tristeza 😢
- Ira 😠
- Miedo 😰
- Ansiedad 😟
- Vacío 😶
- Calma 😌
- Emoción 🤩

**CopingStrategy** - 12 estrategias DBT:
- Respiración Profunda
- Mindfulness
- Acción Opuesta
- Distracción
- Auto-consuelo
- TIPP
- STOP
- Aceptación Radical
- Pros y Contras
- Ejercicio Físico
- Escribir/Diario
- Apoyo Social

### ViewModels

#### MoodTrackingViewModel (`ViewModels/MoodTrackingViewModel.swift`)

Gestiona toda la lógica de negocio del seguimiento emocional.

**Funcionalidades:**
- ✅ Crear y guardar entradas de mood
- ✅ Cargar y filtrar entradas por rango de fechas
- ✅ Eliminar entradas
- ✅ Análisis de datos (promedios, emociones más comunes)
- ✅ Integración con HealthKit State of Mind API
- ✅ Identificación de patrones

**Métodos Clave:**
```swift
func saveMoodEntry()
func loadMoodEntries()
func loadEntriesForDateRange(start: Date, end: Date) -> [MoodEntry]
func averageIntensityForEmotion(_ emotion: EmotionType) -> Double
func mostCommonEmotion() -> EmotionType?
func mostEffectiveStrategy() -> CopingStrategy?
```

### Vistas

#### 1. MoodTrackingView (`Views/Tools/MoodTrackingView.swift`)

Vista principal para registrar nuevas entradas emocionales.

**Secciones:**
- **Header**: Introducción visual con icono y descripción
- **Emotion Selection**: Grid de 8 emociones con emojis
- **Intensity Slider**: Control deslizante 1-10 con indicador visual
- **Triggers**: Campo de texto + lista de desencadenantes
- **Coping Strategies**: Grid seleccionable de 12 estrategias
- **Notes**: Editor de texto para notas adicionales
- **Save Button**: Botón de guardado con validación

**Características de UI:**
- Diseño minimalista
- Colores calmantes (cyan, azul pastel)
- Animaciones suaves con `.spring`
- Validación en tiempo real
- Feedback visual inmediato

#### 2. MoodHistoryView (`Views/Tools/MoodHistoryView.swift`)

Vista de historial con análisis y visualizaciones.

**Secciones:**
- **Time Range Picker**: Semana/Mes/3 Meses/Todo
- **Statistics Cards**: Total, Promedio, Máximo
- **Trend Chart**: Gráfico de líneas con SwiftUI Charts
- **Emotion Distribution**: Gráfico de pastel (donut)
- **Pattern Insights**: Tarjetas de insights automáticos
- **Recent Entries**: Lista cronológica de registros

**Visualizaciones:**
- **LineMark** para tendencias de intensidad
- **PointMark** para datos individuales
- **SectorMark** para distribución de emociones
- **RuleMark** para línea de promedio

#### 3. MoodEntryDetailView (`Views/Tools/MoodEntryDetailView.swift`)

Vista de detalle completo de una entrada.

**Secciones:**
- Header con emoji grande y nombre de emoción
- Barra de intensidad visual
- Lista de desencadenantes
- Grid de estrategias utilizadas
- Notas completas
- Selector de efectividad (👍/👎)
- Metadata (fecha, sincronización)
- Botón de eliminación

## Integración con HealthKit

### State of Mind API (iOS 18+)

El sistema sincroniza automáticamente con la API de State of Mind de HealthKit:

**Mapeo de Emociones:**
- Emociones positivas (Alegría, Calma, Emoción) → Valence positivo
- Emociones negativas (Tristeza, Ira, Miedo, Ansiedad, Vacío) → Valence negativo

**Proceso:**
1. Solicitar autorización al usuario
2. Convertir intensidad (1-10) a valence (-1.0 a 1.0)
3. Crear `HKCategorySample` con tipo `stateOfMind`
4. Guardar en HealthKit
5. Marcar entrada como sincronizada

## Análisis de Patrones

### Insights Automáticos

El sistema calcula automáticamente:

1. **Emoción más frecuente**: Identifica la emoción registrada con mayor frecuencia
2. **Estrategia más efectiva**: Analiza qué estrategia tiene mejor tasa de éxito
3. **Desencadenantes comunes**: Identifica los triggers más recurrentes
4. **Tendencia de intensidad**: Muestra si la intensidad aumenta o disminuye

### Rangos de Tiempo

- **Semana**: Últimos 7 días
- **Mes**: Últimos 30 días
- **3 Meses**: Últimos 90 días
- **Todo**: Histórico completo

## Diseño y UX

### Paleta de Colores Calmantes

```swift
// Colores principales
.calmingCyan    // RGB(0.4, 0.7, 0.8)
.calmingBlue    // RGB(0.5, 0.6, 0.8)
.calmingGreen   // RGB(0.5, 0.7, 0.6)
.softLavender   // RGB(0.7, 0.65, 0.8)
.peacefulMint   // RGB(0.6, 0.8, 0.7)
.sereneSky      // RGB(0.6, 0.75, 0.85)
```

### Principios de Diseño

1. **Minimalismo**: Interfaz limpia sin distracciones
2. **Accesibilidad**: Texto legible, contraste adecuado, SF Symbols
3. **Feedback Visual**: Animaciones suaves y confirmaciones claras
4. **Consistencia**: Patrones visuales uniformes
5. **Espaciado**: Uso generoso de padding y spacing

### Componentes Reutilizables

- `EmotionButton`: Botón de selección de emoción
- `StrategyButton`: Botón de estrategia de afrontamiento
- `StatCard`: Tarjeta de estadística
- `InsightCard`: Tarjeta de insight
- `MoodEntryRow`: Fila de lista de entrada
- `InfoRow`: Fila de información

## Flujo de Usuario

### Crear Nuevo Registro

1. Usuario toca "+" en MoodHistoryView
2. Se presenta MoodTrackingView (sheet)
3. Usuario selecciona emoción → activación del botón de guardar
4. Usuario ajusta intensidad (slider)
5. Usuario añade triggers (opcional)
6. Usuario selecciona estrategias (opcional)
7. Usuario añade notas (opcional)
8. Usuario toca "Guardar Registro"
9. Entrada se guarda en SwiftData
10. Sincronización con HealthKit (si está autorizado)
11. Sheet se cierra
12. MoodHistoryView se actualiza automáticamente

### Ver Historial

1. Usuario navega a pestaña "Estado"
2. Ve estadísticas generales
3. Selecciona rango de tiempo
4. Visualiza gráficos actualizados
5. Lee insights automáticos
6. Toca una entrada para ver detalles

### Ver Detalle

1. Usuario toca entrada en la lista
2. Se presenta MoodEntryDetailView (sheet)
3. Usuario revisa información completa
4. Usuario puede marcar efectividad
5. Usuario puede eliminar entrada (con confirmación)

## Persistencia de Datos

### SwiftData

Todos los datos se persisten usando SwiftData:

```swift
@Model
final class MoodEntry {
    // Propiedades persistidas automáticamente
}
```

### Consultas

**Fetch Descriptor para orden cronológico inverso:**
```swift
FetchDescriptor<MoodEntry>(
    sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
)
```

**Fetch con predicado de rango de fechas:**
```swift
FetchDescriptor<MoodEntry>(
    predicate: #Predicate { entry in
        entry.timestamp >= start && entry.timestamp <= end
    },
    sortBy: [SortDescriptor(\.timestamp)]
)
```

## Accesibilidad

### Características Implementadas

- ✅ Uso de SF Symbols para iconografía universal
- ✅ Etiquetas descriptivas en todos los controles
- ✅ Colores con suficiente contraste
- ✅ Tamaños de fuente escalables
- ✅ Navegación por teclado
- ✅ VoiceOver compatible

## Pruebas

### Previews de SwiftUI

Cada vista incluye previews con datos de ejemplo:

```swift
#Preview {
    MoodTrackingView(viewModel: MoodTrackingViewModel())
        .modelContainer(for: [MoodEntry.self])
}
```

### Datos de Prueba

El sistema puede generar datos de muestra para testing:

```swift
let sampleEntry = MoodEntry(
    emotionType: .joy,
    intensity: 7,
    triggers: ["Conversación positiva"],
    copingStrategies: [.mindfulness, .deepBreathing],
    notes: "Día muy positivo"
)
```

## Mejoras Futuras

### Corto Plazo
- [ ] Exportación de datos a PDF/CSV
- [ ] Notificaciones recordatorio diarias
- [ ] Widget de iOS para registro rápido
- [ ] Sincronización iCloud

### Mediano Plazo
- [ ] Machine Learning para predicción de patrones
- [ ] Recomendaciones personalizadas de estrategias
- [ ] Integración con Apple Watch
- [ ] Comparación de datos con terapeuta

### Largo Plazo
- [ ] Correlación con datos de sueño
- [ ] Análisis de contexto (ubicación, clima)
- [ ] Comunidad de soporte peer-to-peer
- [ ] Integración con telemedicina

## Recursos y Referencias

### Frameworks Utilizados
- SwiftUI
- SwiftData
- Charts (SwiftUI)
- HealthKit

### Estándares DBT
Basado en las técnicas de Terapia Dialéctico Conductual de Marsha Linehan:
- Regulación Emocional
- Tolerancia al Malestar
- Mindfulness
- Efectividad Interpersonal

## Mantenimiento

### Versionado del Modelo de Datos

Usar migración de SwiftData cuando se modifique MoodEntry:

```swift
// Futuras versiones
enum SchemaV2: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [MoodEntry.self]
    }
}
```

### Logging

El sistema incluye logging para debugging:
- Errores de guardado
- Errores de sincronización HealthKit
- Errores de carga de datos

## Licencia

Parte del proyecto Equilibra - Herramientas DBT
© 2025 - Uso terapéutico y educacional
