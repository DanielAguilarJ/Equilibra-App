# Equilibra - Herramientas DBT

Una aplicación iOS diseñada para apoyar a personas con Trastorno Límite de Personalidad (TLP/BPD) mediante herramientas de Terapia Dialéctico-Conductual (DBT).

## 📱 Características

### Módulos DBT
- **Mindfulness**: Ejercicios de atención plena
- **Regulación Emocional**: Herramientas para comprender y gestionar emociones
- **Eficacia Interpersonal**: Mejora de habilidades de comunicación
- **Tolerancia al Malestar**: Estrategias para situaciones de crisis

### Funcionalidades Principales
- ✅ Registro de emociones con intensidad y desencadenantes
- ✅ Modo crisis con herramientas de emergencia
- ✅ Seguimiento de progreso por módulo
- ✅ Sistema de habilidades DBT
- ✅ Plan de seguridad personalizado
- ✅ Soporte para Dark Mode
- ✅ Accesibilidad completa (VoiceOver, Dynamic Type)
- ✅ Persistencia de datos con SwiftData

## 🏗️ Arquitectura

### Patrón MVVM (Model-View-ViewModel)
```
Equilibra - Herramientas DBT/
├── Models/                    # Modelos de datos (SwiftData)
│   ├── DBTModule.swift
│   ├── DBTSkill.swift
│   ├── EmotionalLog.swift
│   └── CrisisPlan.swift
│
├── ViewModels/               # Lógica de negocio
│   ├── HomeViewModel.swift
│   └── EmotionalLogViewModel.swift
│
├── Views/                    # Interfaz de usuario
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Modules/
│   │   ├── ModulesView.swift
│   │   └── ModuleDetailView.swift
│   ├── Tools/
│   │   ├── CrisisToolsView.swift
│   │   ├── EmotionalLogsListView.swift
│   │   └── AddEmotionalLogView.swift
│   ├── Settings/
│   │   └── SettingsView.swift
│   └── Components/
│       ├── ModuleCard.swift
│       ├── CrisisButton.swift
│       └── EmotionalLogCard.swift
│
├── Services/                 # Servicios de la app
│   └── AccessibilityService.swift
│
├── Utilities/               # Utilidades y helpers
│   ├── ThemeManager.swift
│   └── Constants.swift
│
├── ContentView.swift        # Vista principal con TabView
└── Equilibra_Herramientas_DBTApp.swift  # App entry point
```

## 🛠️ Tecnologías

- **SwiftUI**: Framework de UI declarativo
- **SwiftData**: Persistencia de datos (iOS 17+)
- **Observation Framework**: Gestión de estado reactivo (@Observable)
- **NavigationStack**: Navegación moderna de SwiftUI
- **Accessibility**: Soporte completo para VoiceOver y Dynamic Type

## 📊 Modelos de Datos

### DBTModule
Representa los 4 módulos principales de DBT con seguimiento de progreso.

### DBTSkill
Habilidades individuales dentro de cada módulo.

### EmotionalLog
Registro de emociones con:
- Emoción identificada
- Intensidad (1-10)
- Desencadenante
- Habilidades utilizadas
- Notas

### CrisisPlan
Plan de seguridad personalizado con:
- Señales de advertencia
- Estrategias de afrontamiento
- Contactos de apoyo
- Pasos para crear entorno seguro

## 🎨 Temas y Accesibilidad

### Temas
- Modo claro
- Modo oscuro
- Automático (según sistema)

### Accesibilidad
- ✅ Soporte VoiceOver completo
- ✅ Dynamic Type (ajuste de tamaño de texto)
- ✅ Alto contraste
- ✅ Reducir movimiento
- ✅ Labels y hints descriptivos

## 🚨 Características de Seguridad

- **Botón de Crisis**: Acceso rápido a herramientas de emergencia
- **Líneas de Ayuda**: Números de emergencia integrados (112, 024)
- **Plan de Seguridad**: Personalizable para cada usuario
- **Herramientas Rápidas**: 
  - Ejercicios de respiración
  - Técnica TIPP
  - Grounding 5-4-3-2-1
  - Contactos de apoyo

## 📝 Próximas Funcionalidades

- [ ] Ejercicios de respiración guiada con animaciones
- [ ] Técnicas TIPP interactivas
- [ ] Ejercicio Grounding 5-4-3-2-1
- [ ] Gráficos de seguimiento emocional
- [ ] Exportación de datos
- [ ] Recordatorios personalizables
- [ ] Widget para acceso rápido
- [ ] Contenido de habilidades DBT completo
- [ ] Sistema de logros y motivación
- [ ] Diario de gratitud

## ⚠️ Advertencia Importante

Esta aplicación es una **herramienta de apoyo** y NO sustituye el tratamiento profesional. Si estás en crisis o tienes pensamientos suicidas, busca ayuda profesional inmediata:

- **Emergencias**: 112
- **Línea de Atención al Suicidio**: 024 (España)

## 🔧 Requisitos del Sistema

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 📄 Licencia

Este proyecto es de código educativo y debe usarse solo como apoyo al tratamiento profesional.

## 👨‍💻 Desarrollo

Desarrollado con SwiftUI y las mejores prácticas de iOS development:
- Clean Architecture (MVVM)
- Separation of Concerns
- Dependency Injection
- Reactive Programming con @Observable
- Type-safe Navigation

---

**Nota**: Esta app está diseñada pensando en la salud mental. Todos los textos y funcionalidades han sido creados con sensibilidad hacia las personas con TLP/BPD.
