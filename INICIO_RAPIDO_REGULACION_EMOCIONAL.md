# Inicio Rápido - Herramientas de Regulación Emocional

## 🚀 Para Probar en iPhone 17 Pro Simulator

### Compilar y Ejecutar

1. Abre el proyecto en Xcode:
   ```bash
   open "Equilibra - Herramientas DBT.xcodeproj"
   ```

2. Selecciona el simulador **iPhone 17 Pro** en el menú de dispositivos

3. Compila y ejecuta: **⌘ + R**

## 📱 Flujo de Prueba Sugerido

### Primera Prueba: PLEASE Skill (5 min)

1. **Abrir la app** → Toca "Regulación Emocional" en la pantalla principal
2. **Selecciona "PLEASE"**
3. **Expande cada sección** tocando en ella:
   - Physical Illness: Marca que tomaste medicación
   - Eating: Marca alimentación balanceada, agrega 3 comidas
   - Avoid Substances: Deja marcado (por defecto está en true)
   - Sleep: Desliza a 7-8 horas, calidad 4/5
   - Exercise: Desliza a 30 minutos, escribe "Caminar"
4. **Observa el progreso** subir a 100%
5. **Agrega notas:** "Me siento mejor cuando duermo 8 horas"
6. **Guarda** → Verás confirmación

**Resultado esperado:** Registro guardado, aparece en "Registros Recientes"

---

### Segunda Prueba: Check the Facts (7 min)

1. **Desde herramientas** → Toca "Check the Facts"
2. **Paso 1 - Emoción:**
   - Escribe: "Ansiedad"
   - Desliza intensidad a: 8
   - Toca "Siguiente"

3. **Paso 2 - Situación:**
   - Escribe: "Mi jefe no respondió mi email en 2 días"
   - Toca "Siguiente"

4. **Paso 3 - Preguntas:**
   - Expande al menos 4 preguntas
   - Responde, por ejemplo:
     - Q1: "Envié email importante, no hay respuesta"
     - Q2: "Creo que está molesto conmigo"
     - Q3: "Ninguna evidencia concreta"
     - Q4: "Podría estar ocupado, de viaje, o no vio el email"
   - Toca "Siguiente"

5. **Paso 4 - Revisión:**
   - Desliza intensidad final a: 4
   - Toca "Sí" (fue útil)
   - Toca "Completar"

**Resultado esperado:** 
- Resumen muestra reducción de 8 → 4 (mejora de 4 puntos)
- Sesión guardada en historial

---

### Tercera Prueba: Opposite Action (6 min)

1. **Desde herramientas** → Toca "Opposite Action"
2. **Paso 1 - Emoción:**
   - Selecciona: "Tristeza"
   - Desliza intensidad a: 7
   - Toca "Siguiente"

3. **Paso 2 - Impulso:**
   - Lee el impulso típico
   - Escribe tu impulso: "Quiero quedarme en cama todo el día"
   - Toca "Siguiente"

4. **Paso 3 - Acción Opuesta:**
   - Lee los 4 ejemplos proporcionados
   - Escribe tu plan: "Voy a salir a caminar 20 minutos y llamar a mi mamá"
   - Toca "Siguiente"

5. **Paso 4 - Resultados:**
   - Desliza intensidad final a: 4
   - Toca "Sí" (fue útil)
   - Toca "Completar"

**Resultado esperado:**
- Comparación visual 7 → 4
- Mensaje de reducción de 3 puntos
- Guardado exitoso

---

### Cuarta Prueba: Estadísticas (3 min)

1. **En la vista principal de herramientas** → Toca el icono de gráfico (arriba derecha)
2. **Observa:**
   - Total sesiones: 2 (Check Facts + Opposite Action)
   - Gráfico de barras mostrando uso
   - Efectividad por herramienta (100% si marcaste útil)
   - Top emociones: "Ansiedad" y "Tristeza"
   - Gráfico de líneas con cambios de intensidad

**Resultado esperado:** Visualizaciones claras de tu uso

---

### Quinta Prueba: Acceso desde Módulos (2 min)

1. **Ve a la pestaña "Módulos"**
2. **Toca "Regulación Emocional"**
3. **Observa el botón "Herramientas Interactivas"** destacado en azul
4. **Tócalo** → Debe abrir la misma vista de herramientas

**Resultado esperado:** Navegación alternativa funciona

---

## ✅ Checklist de Funcionalidades

### PLEASE
- [ ] Secciones se expanden/colapsan al tocar
- [ ] Progreso se actualiza en tiempo real
- [ ] Guardado funciona
- [ ] Historial muestra registros previos
- [ ] Tips son visibles y útiles

### Check the Facts
- [ ] Navegación paso a paso funciona
- [ ] Barra de progreso se actualiza
- [ ] Botón "Siguiente" se habilita/deshabilita según validación
- [ ] Preguntas se expanden individualmente
- [ ] Comparación antes/después es clara
- [ ] Sesión se guarda correctamente

### Opposite Action
- [ ] Selección de emoción funciona
- [ ] Ejemplos se muestran correctamente por emoción
- [ ] Sliders responden bien
- [ ] Comparación visual es clara
- [ ] Guardado exitoso

### Estadísticas
- [ ] Gráficos se renderizan correctamente
- [ ] Datos son precisos
- [ ] Navegación fluida

### Integración
- [ ] Acceso desde Home funciona
- [ ] Acceso desde Módulos funciona
- [ ] Navegación entre vistas es suave
- [ ] Sheets se abren/cierran correctamente

## 🐛 Posibles Problemas y Soluciones

### "Cannot find type 'EmotionRegulationSession' in scope"
**Solución:** Verifica que los archivos estén agregados al target en Xcode
- Project Navigator → Selecciona archivo → File Inspector → Target Membership

### "No such module 'Charts'"
**Solución:** Swift Charts viene con iOS 16+, debería estar disponible
- Verifica deployment target en proyecto

### Datos no se guardan
**Solución:** 
- Verifica que ModelContainer incluya los nuevos modelos
- Revisa Equilibra___Herramientas_DBTApp.swift

### Gráficos no se muestran
**Solución:**
- Necesitas al menos 1 sesión guardada
- Verifica que las sesiones tengan `wasHelpful` y `finalIntensity` completados

## 🎯 Casos de Uso Recomendados

### Caso 1: Usuario con tristeza persistente
1. PLEASE diario para identificar si falta sueño/ejercicio
2. Check the Facts si la tristeza se basa en interpretaciones
3. Opposite Action para activarse en lugar de aislarse

### Caso 2: Usuario con ansiedad social
1. Check the Facts antes del evento (evaluar pensamientos)
2. Opposite Action durante (acercarse gradualmente)
3. PLEASE después (autocuidado para recuperarse)

### Caso 3: Usuario con enojo frecuente
1. Check the Facts en el momento (evaluar si justificado)
2. Opposite Action si no es justificado (ser amable)
3. PLEASE para prevenir (suficiente sueño/ejercicio)

## 📊 Datos de Prueba Sugeridos

Para probar estadísticas completas, crea:
- 3 sesiones PLEASE en diferentes días
- 2 sesiones Check the Facts (diferentes emociones)
- 2 sesiones Opposite Action (diferentes emociones)

Varía las respuestas de "útil/no útil" para ver efectividad diferente.

## 🎨 Elementos Visuales a Observar

### Animaciones
- Expansión/colapso de secciones (spring animation)
- Transiciones entre pasos
- Progress bars animadas

### Gradientes
- Home: Azul/Cyan para Regulación Emocional
- Herramientas: Verde (PLEASE), Azul (Check Facts), Púrpura (Opposite)

### Iconografía
- Cada herramienta tiene icono único de SF Symbols
- Estados visuales (checkmarks, thumbs up/down)

### Código de Colores
- Verde: Completado, mejora, positivo
- Rojo: Intensidad alta
- Naranja: Intensidad media
- Azul: Información, navegación

## 🚦 Próximos Pasos

Después de probar:

1. **Revisar analytics** (si implementado)
2. **Ajustar textos** según feedback
3. **Agregar más emociones** a Opposite Action si es necesario
4. **Implementar notificaciones** para PLEASE diario
5. **Agregar export de datos** para compartir con terapeuta

## 📞 Soporte

Si encuentras bugs o tienes sugerencias:
- Revisa la documentación en `IMPLEMENTACION_REGULACION_EMOCIONAL.md`
- Consulta la guía de usuario en `GUIA_USUARIO_REGULACION_EMOCIONAL.md`

---

**¡Listo para probar! 🎉**

Tiempo estimado total de prueba: **25-30 minutos**
