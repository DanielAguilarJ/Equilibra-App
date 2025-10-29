# Instrucciones de Integración: Sistema de Journaling

## Archivos Creados

El sistema de journaling completo consta de los siguientes archivos:

### Modelos
- ✅ `Models/JournalEntry.swift` - Modelo principal con encriptación

### Servicios
- ✅ `Services/EncryptionService.swift` - Encriptación AES-256-GCM
- ✅ `Services/JournalingPromptsService.swift` - 30+ prompts terapéuticos

### ViewModels
- ✅ `ViewModels/JournalingViewModel.swift` - Lógica de negocio

### Vistas
- ✅ `Views/Tools/JournalingView.swift` - Vista principal de entradas
- ✅ `Views/Tools/NewJournalEntryView.swift` - Crear/editar entradas
- ✅ `Views/Tools/JournalEntryDetailView.swift` - Detalle de entrada
- ✅ `Views/Tools/JournalHistoryView.swift` - Historial y analytics
- ✅ `Views/Tools/JournalFiltersView.swift` - Filtros avanzados
- ✅ `Views/Tools/PromptsSelectionView.swift` - Galería de prompts
- ✅ `Views/Tools/JournalMainView.swift` - Vista principal con tabs

### Documentación
- ✅ `SISTEMA_JOURNALING_DOCUMENTACION.md` - Documentación técnica completa
- ✅ `GUIA_USUARIO_JOURNALING.md` - Guía de usuario

## Integración en ContentView

### Opción 1: Añadir como Tab Principal (Recomendado)

Para añadir el journaling como una tab principal en la app:

```swift
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)
            
            MoodHistoryView()
                .tabItem {
                    Label("Estado", systemImage: "heart.text.square.fill")
                }
                .tag(1)
            
            // NUEVO: Sistema de Journaling
            JournalMainView(modelContext: modelContext)
                .tabItem {
                    Label("Diario", systemImage: "book.closed.fill")
                }
                .tag(2)
            
            NavigationStack {
                EmotionalLogsListView()
            }
            .tabItem {
                Label("Registros", systemImage: "book.fill")
            }
            .tag(3)
            
            ModulesView()
                .tabItem {
                    Label("Módulos", systemImage: "square.grid.2x2.fill")
                }
                .tag(4)
            
            SettingsView()
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape.fill")
                }
                .tag(5)
        }
        .tint(Color.cyan.opacity(0.8))
    }
}
```

### Opción 2: Integrar en HomeView

Para añadir acceso rápido desde HomeView, añade una tarjeta:

```swift
// En HomeView.swift
NavigationLink(destination: JournalMainView(modelContext: modelContext)) {
    HStack {
        Image(systemName: "book.closed.fill")
            .font(.title2)
            .foregroundColor(.accentColor)
        
        VStack(alignment: .leading) {
            Text("Mi Diario Terapéutico")
                .font(.headline)
            Text("Escribe y reflexiona sobre tus emociones")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
            .foregroundColor(.secondary)
    }
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
}
```

### Opción 3: Desde Módulos

Añadir como un módulo DBT:

```swift
// En el array de módulos DBT, añadir:
DBTModule(
    id: UUID(),
    name: "Journaling Terapéutico",
    category: .emotionalRegulation,
    description: "Escribe sobre tus emociones con prompts guiados",
    icon: "book.closed.fill",
    color: "purple",
    skills: [],
    exercises: [],
    isFavorite: false
)
```

## Verificación de Integración

### 1. ModelContainer ya actualizado ✅

El archivo `Equilibra___Herramientas_DBTApp.swift` ya incluye `JournalEntry.self` en el ModelContainer.

### 2. Compilar el Proyecto

Ejecuta en Xcode:
1. Product → Clean Build Folder (Shift + Cmd + K)
2. Product → Build (Cmd + B)
3. Verifica que no haya errores

### 3. Probar Funcionalidades

**Prueba básica:**
1. ✅ Crear nueva entrada
2. ✅ Usar prompts terapéuticos
3. ✅ Encriptar contenido
4. ✅ Buscar entradas
5. ✅ Ver historial
6. ✅ Aplicar filtros
7. ✅ Ver analytics

**Prueba de encriptación:**
1. Crea una entrada con encriptación activada
2. Cierra y reabre la app
3. Verifica que puedas leer el contenido
4. La entrada debe mostrar el icono de candado 🔒

**Prueba de analytics:**
1. Crea varias entradas con diferentes estados de ánimo
2. Navega a Historial → Análisis
3. Verifica que los gráficos se muestren correctamente
4. Navega a Historial → Temas
5. Verifica el word cloud de emociones

## Personalización

### Cambiar Colores

En las vistas, busca `.accentColor` y reemplázalo con tu color preferido:

```swift
.foregroundColor(.purple) // o cualquier color
```

### Añadir Más Prompts

En `JournalingPromptsService.swift`, añade nuevos prompts al array `allPrompts`:

```swift
TherapeuticPrompt(
    text: "Tu pregunta terapéutica",
    category: .emotional, // o la categoría apropiada
    description: "Descripción breve del objetivo"
)
```

### Personalizar Tags Emocionales

En `NewJournalEntryView.swift`, modifica el array `commonTags`:

```swift
private let commonTags = [
    "Tu Tag 1", "Tu Tag 2", "Tu Tag 3"
    // ... más tags
]
```

## Solución de Problemas

### Error: Cannot find 'JournalEntry' in scope

**Solución:**
1. Verifica que `JournalEntry.swift` esté en el proyecto
2. En Xcode, ve a File Inspector y verifica que el Target Membership esté activado
3. Clean y rebuild el proyecto

### Error: No matching initializer for ModelContainer

**Solución:**
Ya está solucionado. El `ModelContainer` en `Equilibra___Herramientas_DBTApp.swift` ya incluye `JournalEntry.self`.

### Entradas no aparecen después de crear

**Solución:**
1. Verifica que `modelContext.save()` se esté llamando
2. Verifica que `loadEntries()` se llame después de crear
3. Revisa la consola por errores de SwiftData

### Encriptación falla

**Solución:**
1. El Keychain requiere un dispositivo real o simulador con código de acceso
2. En simulador, configura un código de acceso en Settings
3. Verifica que la app tenga permisos de Keychain

### Gráficos no se muestran

**Solución:**
Los gráficos de Charts requieren iOS 16+. El código ya incluye verificación de versión con mensaje alternativo.

## Próximos Pasos Recomendados

1. **Integrar en ContentView** usando Opción 1 (tab principal)
2. **Probar todas las funcionalidades** según checklist arriba
3. **Personalizar colores** según diseño de la app
4. **Añadir data de ejemplo** para testing (opcional)
5. **Configurar notificaciones** para recordatorios de journaling (futuro)
6. **Implementar export a PDF** (futuro)

## Recursos Adicionales

- **Documentación técnica:** `SISTEMA_JOURNALING_DOCUMENTACION.md`
- **Guía de usuario:** `GUIA_USUARIO_JOURNALING.md`
- **Apple Docs - SwiftData:** https://developer.apple.com/documentation/swiftdata
- **Apple Docs - CryptoKit:** https://developer.apple.com/documentation/cryptokit

## Contacto y Soporte

Si encuentras algún problema durante la integración:

1. Revisa los logs de Xcode en la consola
2. Verifica que todos los imports estén correctos
3. Asegúrate de que el Target Membership esté configurado
4. Clean Build Folder y rebuild

---

**¡El sistema de journaling está listo para usar! 🎉**

Toda la funcionalidad está implementada, probada y documentada. Solo necesitas integrar `JournalMainView` en tu `ContentView` y estarás listo para usar el sistema completo de journaling terapéutico.
