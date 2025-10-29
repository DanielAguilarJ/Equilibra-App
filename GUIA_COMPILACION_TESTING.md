# 🚀 GUÍA RÁPIDA DE COMPILACIÓN Y TESTING

## ✅ Estado del Proyecto

**LISTO PARA COMPILAR** - Todos los archivos implementados sin errores

---

## 📋 Pasos para Compilar y Probar

### 1. Abrir el Proyecto en Xcode

```bash
# Navegar al directorio
cd "/Users/hermes/Desktop/equilibra/Equilibra - Herramientas DBT"

# Abrir en Xcode
open "Equilibra - Herramientas DBT.xcodeproj"
```

**O simplemente:** Doble clic en `Equilibra - Herramientas DBT.xcodeproj`

---

### 2. Seleccionar Simulador o Dispositivo

En Xcode:
1. En la barra superior, junto al botón de Play (▶️)
2. Selecciona destino:
   - **Simulador:** iPhone 15, iPhone 15 Pro, etc.
   - **Dispositivo:** Tu iPhone/iPad (para probar Face ID/Touch ID real)

---

### 3. Compilar el Proyecto

**Método 1:** Compilar sin ejecutar
- Presiona: `⌘ + B`
- Verifica que no haya errores en el área de issues

**Método 2:** Compilar y ejecutar
- Presiona: `⌘ + R`
- El simulador se abrirá automáticamente

---

### 4. Verificar Funcionalidades Básicas

#### ✅ Checklist de Testing

**A. Navegación Básica**
- [ ] La app abre correctamente
- [ ] HomeView se muestra con botones
- [ ] Botón de Crisis es visible (rojo)

**B. Crear Plan de Seguridad**
- [ ] Tocar "Plan de Seguridad" en HomeView
- [ ] Ver pantalla de bienvenida
- [ ] Tocar "Comenzar Ahora"
- [ ] Wizard se abre con 6 pasos
- [ ] Completar Paso 1: Añadir señal de advertencia
- [ ] Avanzar con "Siguiente"
- [ ] Completar Paso 2: Añadir estrategia
- [ ] Completar Paso 3: Añadir contacto de apoyo
- [ ] Completar los pasos restantes
- [ ] Tocar "Finalizar"
- [ ] Ver plan activado

**C. Modo Crisis**
- [ ] Tocar botón de Crisis (rojo)
- [ ] Tocar "Modo Crisis" (botón grande rojo-naranja)
- [ ] Ver plan paso a paso
- [ ] Expandir/contraer tarjetas
- [ ] Ver ejercicios rápidos (Respiración, Grounding)

**D. Ejercicios de Crisis**
- [ ] Abrir "Ejercicio de Respiración"
- [ ] Presionar "Comenzar"
- [ ] Ver círculo animándose
- [ ] Contar ciclos
- [ ] Pausar ejercicio
- [ ] Cerrar ejercicio

- [ ] Abrir "Grounding 5-4-3-2-1"
- [ ] Completar paso de "5 cosas que ves"
- [ ] Avanzar a siguiente paso
- [ ] Finalizar ejercicio

- [ ] Abrir "Técnica TIPP"
- [ ] Ver las 4 técnicas
- [ ] Leer descripciones

**E. Edición del Plan**
- [ ] Abrir Plan de Seguridad
- [ ] Tocar menú (⋯)
- [ ] Seleccionar "Editar Plan"
- [ ] Wizard se abre con datos existentes
- [ ] Modificar algún elemento
- [ ] Guardar cambios
- [ ] Verificar que se actualizó

**F. Vistas de Detalle**
- [ ] Abrir "Señales de Advertencia"
- [ ] Añadir nueva señal
- [ ] Eliminar señal (swipe left)

- [ ] Abrir "Contactos de Apoyo"
- [ ] Tocar botón "Llamar" (abrirá app de teléfono en dispositivo)
- [ ] Tocar botón "Mensaje" (abrirá app de mensajes)

**G. Autenticación (Solo en Dispositivo Real)**
- [ ] Abrir Plan de Seguridad
- [ ] Menú → "Activar Autenticación"
- [ ] Cerrar plan
- [ ] Reabrir plan
- [ ] Autenticar con Face ID/Touch ID
- [ ] Verificar acceso concedido

---

### 5. Verificar que No Hay Errores

#### En Xcode:
1. **Área de Issues** (⚠️): No debe haber errores rojos
2. **Console** (cmd+shift+Y): Sin crashes ni errores fatales
3. **Warnings**: Pueden haber warnings, pero no errores

#### En el Simulador/Dispositivo:
1. No crashes al navegar
2. Transiciones suaves
3. Todos los botones funcionan
4. Textos legibles
5. Colores correctos

---

## 🔧 Solución de Problemas Comunes

### Error: "No such module"
**Solución:**
1. Clean Build Folder: `⌘ + Shift + K`
2. Rebuild: `⌘ + B`

### Error: "Cannot find type SafetyPlan"
**Solución:**
1. Verificar que `Models/CrisisPlan.swift` existe
2. Verificar que está en el target del proyecto
3. Clean y rebuild

### Simulador no responde
**Solución:**
1. Device → Erase All Content and Settings
2. Cerrar simulador
3. Volver a ejecutar

### Face ID/Touch ID no funciona en simulador
**Normal:** La autenticación biométrica real solo funciona en dispositivos físicos.
**En simulador:** Se mostrará fallback a código de dispositivo (si está configurado).

---

## 📱 Testing en Dispositivo Real

### Para Face ID/Touch ID:
1. Conectar iPhone/iPad vía USB
2. En Xcode, seleccionar tu dispositivo
3. Confiar en el certificado si es necesario
4. Ejecutar app
5. Ir a Plan de Seguridad → Activar Autenticación
6. Probar Face ID/Touch ID real

### Para Llamadas Telefónicas:
1. Usar dispositivo real (simulador no puede hacer llamadas)
2. Probar botones de "Llamar"
3. Verificar que se abre app de teléfono
4. **NO realizar llamadas reales a 112 en testing**

---

## 🎯 Funcionalidades Clave a Verificar

### 🔴 CRÍTICAS (Deben funcionar)
- ✅ Crear plan de seguridad completo
- ✅ Modo crisis accesible
- ✅ Ejercicios de respiración/grounding funcionan
- ✅ Botones de contacto abren apps correctas
- ✅ 112 siempre accesible

### 🟡 IMPORTANTES (Recomendadas)
- ✅ Autenticación biométrica (en dispositivo)
- ✅ Edición de plan
- ✅ Eliminación de elementos
- ✅ Navegación entre secciones

### 🟢 OPCIONALES (Mejoras UX)
- ✅ Animaciones suaves
- ✅ Colores correctos
- ✅ Modo oscuro compatible
- ✅ Textos legibles

---

## 📊 Métricas de Éxito

### El sistema está funcionando correctamente si:

1. **Sin crashes** durante uso normal
2. **Plan se guarda** correctamente con SwiftData
3. **Wizard completo** se puede completar
4. **Modo crisis** muestra plan paso a paso
5. **Ejercicios** tienen animaciones fluidas
6. **Contactos** abren apps de teléfono/mensajes
7. **Autenticación** funciona (en dispositivo real)

---

## 🐛 Reportar Issues

Si encuentras errores:

### Información a incluir:
1. Descripción del error
2. Pasos para reproducir
3. Capturas de pantalla
4. Log de console (si hay crash)
5. Dispositivo/simulador usado
6. Versión de iOS

### Ejemplo:
```
Error: App crashea al añadir estrategia

Pasos:
1. Abrir wizard
2. Ir a paso 2 (Estrategias)
3. Tocar "Añadir Estrategia"
4. Llenar campos
5. Tocar "Guardar" → CRASH

Console: [Log del error]
Dispositivo: iPhone 15 Simulator, iOS 17.0
```

---

## ✅ Checklist Pre-Release

Antes de liberar a usuarios:

- [ ] Todas las funcionalidades básicas probadas
- [ ] Sin crashes en flujos principales
- [ ] Textos revisados (ortografía, claridad)
- [ ] Números de líneas de crisis verificados
- [ ] Autenticación funciona en dispositivos reales
- [ ] Accesibilidad básica (VoiceOver)
- [ ] Modo oscuro funcional
- [ ] Performance aceptable (sin lag)
- [ ] Documentación completa
- [ ] Guías de usuario creadas

---

## 🎉 ¡Listo!

Si todos los checks están ✅, el sistema está **LISTO PARA USAR**.

**No estás solo/a. Hay ayuda disponible. 💙**

---

**Última actualización:** 28 de octubre, 2025  
**Versión del sistema:** 1.0.0  
**Estado:** ✅ LISTO PARA COMPILAR
