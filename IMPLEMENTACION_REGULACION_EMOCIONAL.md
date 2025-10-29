# Herramientas de Regulación Emocional DBT

## Resumen

Se han implementado tres herramientas interactivas de Regulación Emocional basadas en la Terapia Dialéctico-Conductual (DBT):

1. **PLEASE Skill** - Cuidado de la salud física
2. **Check the Facts** - Evaluación objetiva de situaciones
3. **Opposite Action** - Cambio emocional mediante acción opuesta

## Estructura de la Implementación

### Modelos (`EmotionRegulationTool.swift`)

#### EmotionRegulationSession
Registra cada sesión de uso de herramientas:
- Tipo de herramienta utilizada
- Emoción inicial e intensidad
- Intensidad final (después de usar la herramienta)
- Notas y pasos completados
- Evaluación de efectividad

#### PLEASEEntry
Tracking diario de los componentes PLEASE:
- **P**hysical illness - Medicación y tratamiento
- **L**eating - Alimentación balanceada
- **E**avoid substances - Evitar sustancias
- **A**sleep - Calidad y cantidad de sueño
- **S**exercise - Actividad física

### ViewModel (`EmotionRegulationViewModel.swift`)

Gestiona:
- Estado de las sesiones
- Preguntas socráticas para Check the Facts
- Sugerencias de acciones opuestas
- Estadísticas de uso y efectividad

### Vistas

#### EmotionRegulationToolsView
Vista principal que muestra:
- Cards para cada herramienta con descripción
- Sesiones recientes
- Estadísticas de uso
- Navegación a cada herramienta específica

#### PLEASEToolView
Herramienta interactiva con:
- Secciones expandibles para cada componente PLEASE
- Tracking de progreso diario
- Historial de registros previos
- Tips y recomendaciones contextuales
- Sistema de validación (checkmarks)

**Características:**
- Progressive disclosure (secciones colapsables)
- Validación visual del progreso
- Recordatorios de medicación
- Feedback positivo al completar

#### CheckTheFactsView
Proceso guiado paso a paso:
1. Identificar emoción inicial e intensidad
2. Describir la situación (solo hechos)
3. Responder preguntas socráticas (8 preguntas clave)
4. Revisar cambio emocional y efectividad

**Características:**
- Navegación paso a paso con progreso visual
- Diferenciación entre hechos e interpretaciones
- Preguntas guiadas para evaluar pensamiento
- Comparación antes/después de intensidad emocional

#### OppositeActionView
Guía interactiva en 4 pasos:
1. Identificar emoción y su intensidad
2. Reconocer el impulso típico
3. Elegir y planificar acción opuesta
4. Evaluar resultados

**Características:**
- Ejemplos específicos para cada emoción
- 5 emociones principales con acciones sugeridas
- Visualización de cambio en intensidad emocional
- Énfasis en compromiso total con la acción

#### EmotionRegulationStatsView
Dashboard de estadísticas:
- Total de sesiones y frecuencia semanal
- Gráfico de uso por herramienta
- Efectividad de cada técnica
- Emociones más trabajadas
- Gráfico de cambios de intensidad

## Integración en la App

### Acceso desde HomeView
Botón de acceso rápido "Regulación Emocional" con:
- Icono distintivo
- Gradiente azul/cyan
- Descripción clara

### Acceso desde ModuleDetailView
Cuando el usuario navega al módulo de Regulación Emocional:
- Botón destacado "Herramientas Interactivas"
- Descripción de las técnicas disponibles
- Acceso directo a EmotionRegulationToolsView

### Persistencia de Datos
Todos los modelos usan SwiftData:
- `EmotionRegulationSession` - Historial de uso
- `PLEASEEntry` - Registros diarios PLEASE

Integrados en el ModelContainer principal de la app.

## Características de UX/UI

### Design Patterns Implementados

1. **Progressive Disclosure**
   - Secciones colapsables en PLEASE
   - Preguntas expandibles en Check the Facts
   - Navegación paso a paso

2. **Feedback Positivo**
   - Checkmarks visuales
   - Progreso en tiempo real
   - Mensajes de confirmación
   - Comparaciones antes/después

3. **Cards y Componentes Reutilizables**
   - ToolCard - Tarjetas de herramientas
   - StepCard - Tarjetas de pasos
   - PLEASECard - Componente colapsable
   - SessionCard - Historial de sesiones
   - StatCard/StatBox - Estadísticas visuales

4. **Visualización de Datos**
   - Gráficos con Swift Charts
   - Progress bars
   - Sliders para intensidad emocional
   - Código de colores (verde/naranja/rojo)

### Accesibilidad

- Uso de SF Symbols para iconografía
- Colores con suficiente contraste
- Textos con jerarquía clara
- Componentes nativos de SwiftUI
- Feedback visual y textual

## Flujo de Usuario

### PLEASE Skill
1. Usuario abre la herramienta
2. Ve su progreso del día (porcentaje)
3. Expande cada sección PLEASE
4. Completa los campos relevantes
5. Recibe tips contextuales
6. Guarda el registro
7. Ve historial de días previos

### Check the Facts
1. Identifica emoción actual (slider 1-10)
2. Describe la situación objetivamente
3. Responde 8 preguntas socráticas
4. Evalúa si la emoción cambió
5. Marca si fue útil
6. Guarda la sesión

### Opposite Action
1. Selecciona emoción de lista predefinida
2. Lee impulso típico para esa emoción
3. Describe su impulso personal
4. Ve acción opuesta sugerida con ejemplos
5. Crea plan de acción específico
6. Evalúa cambio emocional
7. Marca efectividad

## Datos Rastreados

### Por Sesión
- Tipo de herramienta
- Fecha y hora
- Emoción trabajada
- Intensidad inicial (1-10)
- Intensidad final (1-10)
- Notas personales
- Efectividad (útil/no útil)
- Pasos completados

### PLEASE Diario
- Medicación tomada
- Comidas balanceadas
- Sustancias evitadas
- Horas de sueño
- Calidad del sueño
- Minutos de ejercicio
- Tipo de ejercicio

### Estadísticas Generadas
- Total de sesiones
- Sesiones por semana
- Efectividad general
- Efectividad por herramienta
- Mejora promedio en intensidad
- Emociones más frecuentes
- Tendencias de uso

## Extensibilidad

La arquitectura permite fácil adición de:
- Nuevas herramientas de regulación emocional
- Más preguntas socráticas
- Emociones adicionales para Opposite Action
- Componentes PLEASE personalizados
- Métricas y gráficos adicionales

## Notas de Implementación

- SwiftUI + SwiftData para persistencia
- Observable macro para ViewModels
- Swift Charts para visualizaciones
- Navegación con NavigationStack
- Sheets para modales
- Animaciones con spring response

## Próximos Pasos Sugeridos

1. **Notificaciones**: Recordatorios para PLEASE diario
2. **Export**: Compartir estadísticas con terapeuta
3. **Personalización**: Agregar herramientas personalizadas
4. **Insights**: IA para detectar patrones emocionales
5. **Integración**: Conexión con Apple Health para sueño/ejercicio
