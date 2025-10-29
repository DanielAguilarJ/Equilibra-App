# Guía Rápida de Desarrollo - Equilibra

## 🚀 Inicio Rápido

### Estructura del Proyecto Creada

```
✅ Models/                    (4 archivos)
✅ ViewModels/                (2 archivos)
✅ Views/                     (9 archivos en 5 carpetas)
✅ Services/                  (1 archivo)
✅ Utilities/                 (2 archivos)
✅ Archivos principales       (2 archivos)
```

**Total: 20 archivos Swift creados**

## 📋 Checklist de Implementación

### ✅ Completado

- [x] Estructura de carpetas MVVM
- [x] Modelos de datos con SwiftData
  - [x] DBTModule (4 módulos de DBT)
  - [x] DBTSkill (habilidades por módulo)
  - [x] EmotionalLog (registro de emociones)
  - [x] CrisisPlan (plan de seguridad)
- [x] ViewModels con @Observable
  - [x] HomeViewModel
  - [x] EmotionalLogViewModel
- [x] Vistas principales
  - [x] HomeView (dashboard)
  - [x] ModulesView (lista de módulos)
  - [x] ModuleDetailView (detalle de módulo)
  - [x] EmotionalLogsListView (lista de registros)
  - [x] AddEmotionalLogView (agregar registro)
  - [x] CrisisToolsView (herramientas de crisis)
  - [x] SettingsView (configuración completa)
- [x] Componentes reutilizables
  - [x] ModuleCard
  - [x] EmotionalLogCard
  - [x] CrisisButton
- [x] Servicios
  - [x] AccessibilityService (accesibilidad)
- [x] Utilidades
  - [x] ThemeManager (dark mode)
  - [x] Constants (constantes de app)
- [x] Configuración SwiftData
- [x] TabView con navegación
- [x] Soporte para Dark Mode
- [x] Accesibilidad básica

### 🔨 Siguiente Paso: Agregar Archivos a Xcode

**IMPORTANTE**: Los archivos están creados pero necesitan ser agregados al proyecto de Xcode.

#### Opción 1: Manualmente en Xcode (Recomendado)

1. Abre `Equilibra - Herramientas DBT.xcodeproj` en Xcode
2. Para cada carpeta creada:
   - Click derecho en el proyecto → "Add Files to..."
   - Selecciona las carpetas: Models, ViewModels, Views, Services, Utilities
   - ✅ Marca "Copy items if needed"
   - ✅ Marca "Create groups"
   - ✅ Selecciona el target "Equilibra - Herramientas DBT"
3. Reemplaza ContentView.swift y Equilibra___Herramientas_DBTApp.swift con los nuevos

#### Opción 2: Recrear el proyecto

Si prefieres empezar limpio:
1. Crea un nuevo proyecto SwiftUI
2. Copia todas las carpetas creadas
3. Agrega los archivos al proyecto

## 🎯 Características Implementadas

### 1. Dashboard (HomeView)
- Saludo personalizado
- Botón de crisis destacado
- Grid de módulos DBT
- Registros emocionales recientes
- Navegación a todas las secciones

### 2. Módulos DBT
- 4 módulos implementados:
  - 💜 Mindfulness
  - 💙 Regulación Emocional
  - 💚 Eficacia Interpersonal
  - 🧡 Tolerancia al Malestar
- Seguimiento de progreso
- Vista de detalle con habilidades

### 3. Registro Emocional
- Lista de emociones comunes
- Slider de intensidad (1-10)
- Campo de desencadenante
- Notas opcionales
- Historial completo

### 4. Modo Crisis
- Botón de acceso rápido (rojo/naranja)
- Herramientas disponibles:
  - Ejercicio de respiración
  - Técnica TIPP
  - Grounding 5-4-3-2-1
  - Contactos de apoyo
  - Plan de seguridad
- Botón 112 para emergencias

### 5. Configuración
- Selector de tema (Claro/Oscuro/Sistema)
- Recordatorios diarios
- Recursos DBT
- Líneas de ayuda
- Información de la app
- Opciones de datos

## 🎨 Guía de Colores

```swift
// Módulos
.purple     // Mindfulness
.blue       // Regulación Emocional
.green      // Eficacia Interpersonal
.orange     // Tolerancia al Malestar

// Intensidad Emocional
.green      // 1-3 (baja)
.yellow     // 4-6 (moderada)
.orange     // 7-8 (alta)
.red        // 9-10 (muy alta)

// Crisis
.red/.orange gradient // Botón de crisis
```

## 📱 Próximos Pasos de Desarrollo

### Prioridad Alta
1. **Agregar archivos al proyecto Xcode**
2. **Compilar y corregir errores** (si hay)
3. **Probar en simulador**
4. **Implementar contenido de habilidades DBT**
   - Crear datos de ejemplo para cada módulo
   - Agregar descripciones detalladas
   - Incluir instrucciones paso a paso

### Prioridad Media
5. **Ejercicios interactivos**
   - Respiración guiada con animación
   - Timer para ejercicios
   - Técnica TIPP paso a paso
6. **Gráficos de seguimiento**
   - Charts para emociones a lo largo del tiempo
   - Progreso por módulo
7. **Notificaciones locales**
   - Recordatorios diarios
   - Sugerencias de práctica

### Prioridad Baja
8. **Widget iOS**
9. **Apple Watch companion**
10. **Exportación de datos**
11. **iCloud sync**

## 🐛 Testing Checklist

Una vez agregados los archivos a Xcode:

- [ ] Compilación sin errores
- [ ] Navegación entre tabs funciona
- [ ] Crear registro emocional
- [ ] Ver lista de registros
- [ ] Abrir modo crisis
- [ ] Cambiar tema (claro/oscuro)
- [ ] Ver detalle de módulo
- [ ] VoiceOver funciona correctamente
- [ ] Dark mode se aplica correctamente
- [ ] Datos persisten con SwiftData

## 💡 Tips de Desarrollo

### SwiftData
```swift
// Insertar datos
context.insert(object)
try context.save()

// Query
@Query(sort: \.property) var items: [Model]

// Delete
context.delete(object)
```

### @Observable (iOS 17+)
```swift
@Observable
class ViewModel {
    var property: String = ""
}

// En la vista
@State private var viewModel = ViewModel()
```

### Navegación
```swift
NavigationStack {
    // Contenido
}

NavigationLink("Título") {
    DestinationView()
}
```

## 🔗 Recursos Útiles

- [SwiftData Documentation](https://developer.apple.com/documentation/swiftdata)
- [SwiftUI Navigation](https://developer.apple.com/documentation/swiftui/navigation)
- [Accessibility Guidelines](https://developer.apple.com/accessibility/)
- [DBT Resources](https://www.dbt-es.com/)

## 📞 Soporte

Si encuentras problemas:
1. Revisa los errores de compilación en Xcode
2. Verifica que todos los archivos estén en el target
3. Limpia el build folder (Cmd+Shift+K)
4. Rebuild (Cmd+B)

---

**¡La estructura base está completa! Ahora solo falta agregar los archivos a Xcode y compilar.** 🎉
