# Sistema de Journaling Terapéutico para TLP

## Descripción General

Sistema completo de diario terapéutico con prompts específicos para el Trastorno Límite de Personalidad (TLP), diseñado con encriptación local para máxima privacidad y seguridad.

## Características Implementadas

### 1. Modelo de Datos (JournalEntry)

**Propiedades:**
- ✅ Título y contenido de la entrada
- ✅ Fecha de creación y última modificación
- ✅ Tags emocionales personalizables
- ✅ Prompts terapéuticos utilizados
- ✅ Estado de ánimo pre-escritura (1-10)
- ✅ Estado de ánimo post-escritura (1-10)
- ✅ Cálculo automático de mejora de ánimo
- ✅ Conteo de palabras automático
- ✅ Sistema de favoritos
- ✅ Soporte para encriptación AES-256-GCM

### 2. Encriptación y Seguridad (EncryptionService)

**Características de Seguridad:**
- ✅ Encriptación AES-GCM de grado militar
- ✅ Almacenamiento seguro de claves en Keychain
- ✅ Encriptación local (los datos nunca salen del dispositivo)
- ✅ Protección de privacidad máxima
- ✅ Manejo seguro de errores

**Implementación:**
```swift
// Las claves se almacenan en Keychain con:
// - kSecAttrAccessibleWhenUnlockedThisDeviceOnly
// - No se pueden exportar
// - Protegidas por el sistema de seguridad de iOS
```

### 3. Prompts Terapéuticos (JournalingPromptsService)

**30+ Prompts Categorizados:**

**Emocionales (5 prompts):**
- Identificación de emociones actuales
- Localización corporal de emociones
- Cuantificación de intensidad emocional
- Reflexión del día emocional
- Distinción entre emociones primarias/secundarias

**Cognitivos (6 prompts):**
- Análisis de evidencia a favor
- Análisis de evidencia en contra
- Identificación de pensamiento dicotómico
- Ejercicio de autocompasión
- Exploración de interpretaciones alternativas
- Diferenciación pensamiento vs. hecho

**Validación (4 prompts):**
- Validación de experiencia emocional
- Reconocimiento de logros
- Identificación de fortalezas
- Reconocimiento de habilidades efectivas

**Necesidades (5 prompts):**
- Identificación de necesidades actuales
- Definición de objetivos emocionales
- Planificación de autocuidado
- Exploración de necesidades subyacentes
- Identificación de necesidades de apoyo

**Comportamiento (5 prompts):**
- Exploración de impulsos de acción
- Evaluación de coherencia con valores
- Identificación de habilidades DBT útiles
- Consideración de consecuencias
- Recordatorio de estrategias efectivas

**Relaciones (5 prompts):**
- Impacto relacional
- Necesidades de comunicación
- Planificación de comunicación asertiva
- Establecimiento de límites
- Examen de interpretaciones sobre otros

### 4. Vista Principal (JournalingView)

**Funcionalidades:**
- ✅ Lista de entradas con vista de tarjetas
- ✅ Búsqueda en tiempo real (incluso en contenido encriptado)
- ✅ Estadísticas resumidas (entradas, palabras, mejora)
- ✅ Indicadores visuales (favoritos, encriptado, mejora de ánimo)
- ✅ Vista de estado vacío motivadora
- ✅ Navegación a detalle de entrada
- ✅ Acceso rápido a filtros

### 5. Nueva Entrada (NewJournalEntryView)

**Características:**
- ✅ Editor de texto enriquecido
- ✅ Slider de ánimo pre-escritura (visual con emojis)
- ✅ Sistema de prompts aleatorios por categoría
- ✅ Galería de prompts terapéuticos
- ✅ Selección de tags emocionales comunes
- ✅ Tags personalizados con FlowLayout
- ✅ Slider de ánimo post-escritura opcional
- ✅ Cálculo de mejora en tiempo real
- ✅ Toggle de encriptación
- ✅ Contador de palabras y caracteres en vivo
- ✅ Validación antes de guardar

**Tags Emocionales Predefinidos:**
Ansiedad, Tristeza, Ira, Miedo, Alegría, Frustración, Calma, Confusión, Esperanza, Soledad, Gratitud, Culpa, Vergüenza, Amor, Enojo

### 6. Detalle de Entrada (JournalEntryDetailView)

**Funcionalidades:**
- ✅ Vista completa de la entrada
- ✅ Desencriptación automática si es necesario
- ✅ Visualización de mejora de ánimo con indicadores visuales
- ✅ Lista de prompts utilizados
- ✅ Tags emocionales
- ✅ Modo edición in-line
- ✅ Toggle de favoritos
- ✅ Opciones de compartir
- ✅ Eliminación con confirmación
- ✅ Metadata (palabras, última modificación)

### 7. Historial y Analytics (JournalHistoryView)

**Tres Vistas Principales:**

**Timeline:**
- ✅ Agrupación por mes
- ✅ Vista de timeline visual
- ✅ Indicador de favoritos
- ✅ Vista previa de contenido
- ✅ Indicador de mejora de ánimo

**Análisis:**
- ✅ Tarjetas de estadísticas resumidas:
  - Total de entradas
  - Días activos de escritura
  - Palabras totales escritas
  - Mejora promedio de ánimo
- ✅ Gráfico de tendencia de ánimo (iOS 16+)
  - Línea pre-escritura
  - Línea post-escritura
  - Últimas 20 entradas
- ✅ Gráfico de frecuencia de escritura (últimas 12 semanas)
- ✅ Top 5 emociones más frecuentes con barras

**Word Cloud (Temas):**
- ✅ Nube de palabras de tags emocionales
- ✅ Tamaño basado en frecuencia
- ✅ Opacidad proporcional a uso
- ✅ Top 20 temas más recurrentes
- ✅ Layout fluido responsivo

### 8. Filtros Avanzados (JournalFiltersView)

**Opciones de Filtrado:**
- ✅ 5 opciones de ordenamiento:
  - Más recientes
  - Más antiguos
  - Título A-Z
  - Más extensos (por palabras)
  - Mayor mejora de ánimo
- ✅ Filtro de favoritos
- ✅ Filtro por rango de ánimo (slider dual)
- ✅ Filtro multi-selección por tags emocionales
- ✅ Resumen de filtros activos
- ✅ Limpieza rápida de todos los filtros

### 9. ViewModel (JournalingViewModel)

**Gestión de Datos:**
- ✅ Integración con SwiftData
- ✅ CRUD completo (Create, Read, Update, Delete)
- ✅ Encriptación/desencriptación transparente
- ✅ Búsqueda en tiempo real
- ✅ Filtrado multi-criterio
- ✅ Ordenamiento flexible
- ✅ Manejo de errores

**Analytics:**
- ✅ Obtención de todos los tags
- ✅ Cálculo de frecuencia de tags
- ✅ Top tags más utilizados
- ✅ Promedio de mejora de ánimo
- ✅ Agrupación por mes
- ✅ Conteo total de palabras

### 10. Componentes Reutilizables

**FlowLayout:**
- ✅ Layout personalizado para tags
- ✅ Ajuste automático de filas
- ✅ Espaciado configurable

**Componentes de UI:**
- ✅ StatItem: Estadística con icono
- ✅ JournalEntryCard: Tarjeta de entrada
- ✅ TimelineEntryCard: Tarjeta de timeline
- ✅ AnalyticCard: Tarjeta de análisis
- ✅ TagButton: Botón de tag seleccionable
- ✅ PromptCard: Tarjeta de prompt terapéutico
- ✅ CategoryButton: Botón de categoría

## Arquitectura del Sistema

```
Models/
├── JournalEntry.swift          # Modelo principal con SwiftData
└── TherapeuticPrompt.swift     # Struct para prompts (en JournalEntry.swift)

Services/
├── EncryptionService.swift     # Encriptación AES-GCM + Keychain
└── JournalingPromptsService.swift  # Gestión de prompts terapéuticos

ViewModels/
└── JournalingViewModel.swift   # Lógica de negocio y gestión de estado

Views/Tools/
├── JournalingView.swift           # Vista principal
├── NewJournalEntryView.swift      # Nueva entrada
├── JournalEntryDetailView.swift   # Detalle de entrada
├── JournalHistoryView.swift       # Historial y analytics
├── JournalFiltersView.swift       # Filtros avanzados
└── PromptsSelectionView.swift     # Galería de prompts
```

## Flujo de Uso

### Crear Nueva Entrada:

1. Usuario abre JournalingView
2. Tap en botón "Nueva Entrada"
3. Selecciona ánimo pre-escritura
4. Opcionalmente obtiene prompt aleatorio
5. Escribe contenido libre
6. Selecciona tags emocionales
7. Opcionalmente registra ánimo post-escritura
8. Elige si encriptar el contenido
9. Guarda la entrada

### Buscar y Filtrar:

1. Usa la barra de búsqueda para texto
2. Abre filtros para criterios avanzados
3. Selecciona tags emocionales
4. Define rango de ánimo
5. Activa solo favoritos si desea
6. Elige ordenamiento preferido
7. Los resultados se actualizan automáticamente

### Analizar Progreso:

1. Abre JournalHistoryView
2. Vista Timeline para recorrido cronológico
3. Vista Análisis para estadísticas y gráficos
4. Vista Temas para word cloud de emociones
5. Identifica patrones y tendencias
6. Reconoce mejoras en el tiempo

## Seguridad y Privacidad

### Encriptación:

- **Algoritmo:** AES-256-GCM (Advanced Encryption Standard)
- **Almacenamiento de claves:** iOS Keychain
- **Accesibilidad:** Solo cuando el dispositivo está desbloqueado
- **Sincronización:** No (solo local)
- **Exportación:** No permitida

### Protección de Datos:

- Los datos nunca se envían a servidores externos
- La encriptación es opcional por entrada
- Las claves se generan automáticamente
- No hay backdoors ni acceso de terceros
- Compatible con autenticación biométrica del dispositivo

## Beneficios Terapéuticos

### Para Personas con TLP:

1. **Regulación Emocional:** Tracking de emociones antes y después de escribir
2. **Awareness:** Prompts que fomentan la conciencia emocional
3. **Validación:** Reconocimiento de logros y fortalezas
4. **Patrones:** Identificación de temas recurrentes
5. **Progreso:** Visualización de mejoras en el tiempo
6. **DBT Integration:** Prompts alineados con terapia dialéctica conductual

### Evidencia del Impacto:

- Cálculo automático de mejora de ánimo
- Estadísticas de escritura regular
- Visualización de tendencias emocionales
- Identificación de emociones más frecuentes

## Uso en la Aplicación

Para integrar el sistema de journaling en la app principal:

```swift
import SwiftUI
import SwiftData

struct MainAppView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            // Otras vistas...
            
            JournalingView(modelContext: modelContext)
                .tabItem {
                    Label("Diario", systemImage: "book.fill")
                }
        }
    }
}
```

## Requisitos del Sistema

- **iOS:** 17.0+
- **Frameworks:**
  - SwiftUI
  - SwiftData
  - CryptoKit
  - Security (Keychain)
  - Charts (iOS 16+ para gráficos)

## Próximas Mejoras Posibles

- [ ] Export a PDF con formateo
- [ ] Recordatorios para escribir
- [ ] Plantillas de entrada personalizadas
- [ ] Integración con widgets
- [ ] Sincronización iCloud encriptada
- [ ] Voz a texto
- [ ] Modo oscuro personalizado
- [ ] Temas de color personalizables
- [ ] Estadísticas más avanzadas (ML para detección de patrones)

## Conclusión

El sistema de journaling implementado proporciona una herramienta terapéutica completa, segura y centrada en el usuario, específicamente diseñada para personas con TLP. La combinación de prompts terapéuticos, analytics visuales y encriptación robusta crea una experiencia única que fomenta la autoexploración segura y el seguimiento del progreso emocional.
