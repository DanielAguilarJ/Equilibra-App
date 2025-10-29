//
//  SampleMoodData.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Servicio para generar datos de muestra para el sistema de seguimiento emocional
enum SampleMoodData {
    
    /// Genera un conjunto de entradas de mood de ejemplo para testing y demos
    static func generateSampleEntries() -> [MoodEntry] {
        var entries: [MoodEntry] = []
        let calendar = Calendar.current
        let now = Date()
        
        // Últimos 30 días con diferentes patrones
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            
            // 1-3 entradas por día (simulando uso real)
            let entriesPerDay = Int.random(in: 1...3)
            
            for entryIndex in 0..<entriesPerDay {
                let hourOffset = entryIndex * 8 // Mañana, tarde, noche
                guard let timestamp = calendar.date(byAdding: .hour, value: hourOffset, to: date) else { continue }
                
                let entry = createSampleEntry(for: timestamp, dayNumber: dayOffset)
                entries.append(entry)
            }
        }
        
        return entries
    }
    
    private static func createSampleEntry(for date: Date, dayNumber: Int) -> MoodEntry {
        // Simular diferentes patrones emocionales
        let emotion: EmotionType
        let intensity: Int
        let triggers: [String]
        let strategies: [MoodCopingStrategy]
        
        // Patrón: Mejora gradual en las últimas 2 semanas
        if dayNumber < 14 {
            // Últimas 2 semanas - emociones más positivas
            emotion = [.joy, .calm, .excitement].randomElement()!
            intensity = Int.random(in: 3...7)
            triggers = positiveTriggersPool.randomSample(count: Int.random(in: 0...2))
            strategies = effectiveStrategiesPool.randomSample(count: Int.random(in: 1...3))
        } else {
            // Semanas anteriores - más variabilidad
            emotion = EmotionType.allCases.randomElement()!
            intensity = Int.random(in: 4...9)
            triggers = allTriggersPool.randomSample(count: Int.random(in: 1...3))
            strategies = MoodCopingStrategy.allCases.randomSample(count: Int.random(in: 1...4))
        }
        
        let notes = generateSampleNotes(for: emotion, intensity: intensity)
        
        let entry = MoodEntry(
            emotionType: emotion,
            intensity: intensity,
            triggers: triggers,
            copingStrategies: strategies,
            notes: notes
        )
        
        // Ajustar timestamp
        entry.timestamp = date
        
        // Marcar efectividad basada en intensidad
        if !strategies.isEmpty {
            entry.wasEffective = intensity <= 6
        }
        
        return entry
    }
    
    // MARK: - Pools de Datos
    
    private static let positiveTriggersPool = [
        "Conversación agradable con amigo",
        "Logro en el trabajo",
        "Ejercicio matutino",
        "Tiempo de calidad con familia",
        "Buen descanso nocturno",
        "Actividad creativa",
        "Música relajante",
        "Paseo por la naturaleza"
    ]
    
    private static let allTriggersPool = [
        "Conflicto interpersonal",
        "Presión laboral",
        "Preocupación financiera",
        "Falta de sueño",
        "Noticias negativas",
        "Fecha límite estresante",
        "Crítica recibida",
        "Cambio inesperado de planes",
        "Problema de salud",
        "Soledad",
        "Comparación en redes sociales",
        "Tráfico intenso",
        "Conversación agradable con amigo",
        "Logro en el trabajo",
        "Ejercicio matutino"
    ]
    
    private static let effectiveStrategiesPool: [MoodCopingStrategy] = [
        .mindfulness,
        .deepBreathing,
        .exercise,
        .selfSoothing,
        .journaling
    ]
    
    private static func generateSampleNotes(for emotion: EmotionType, intensity: Int) -> String {
        let notesPool: [String]
        
        switch emotion {
        case .joy:
            notesPool = [
                "Fue un día muy productivo y me siento satisfecho con mis logros.",
                "La sesión de terapia de hoy fue muy reveladora.",
                "Disfruté mucho el tiempo con mi familia.",
                ""
            ]
        case .sadness:
            notesPool = [
                "Me siento un poco desanimado, pero sé que es temporal.",
                "Extraño a personas importantes en mi vida.",
                "Hoy fue un día difícil emocionalmente.",
                ""
            ]
        case .anger:
            notesPool = [
                "Tuve un desacuerdo que me frustró, pero logré mantener la calma.",
                "Me siento molesto por la situación, pero estoy trabajando en procesarlo.",
                ""
            ]
        case .anxiety:
            notesPool = [
                "Nervioso por el evento de mañana, pero respiré profundo.",
                "La ansiedad aumentó durante el día, usé técnicas de grounding.",
                "Preocupado por varias cosas, pero reconozco que no puedo controlar todo.",
                ""
            ]
        case .calm:
            notesPool = [
                "Después de meditar me siento muy en paz.",
                "Día tranquilo, disfruté de la quietud.",
                "Logré mantener la calma a pesar de las circunstancias.",
                ""
            ]
        case .fear:
            notesPool = [
                "Sentí miedo ante lo desconocido, pero enfrenté la situación.",
                "Nervioso por el cambio, pero confío en que puedo manejarlo.",
                ""
            ]
        case .emptiness:
            notesPool = [
                "Me sentí desconectado hoy, pero reconozco que es parte del proceso.",
                "Día de poca energía emocional.",
                ""
            ]
        case .excitement:
            notesPool = [
                "¡Muy emocionado por las nuevas oportunidades!",
                "Lleno de energía positiva hoy.",
                "Entusiasmado con los planes futuros.",
                ""
            ]
        }
        
        return notesPool.randomElement() ?? ""
    }
}

// MARK: - Array Extension
extension Array {
    func randomSample(count: Int) -> [Element] {
        guard count > 0, !isEmpty else { return [] }
        let actualCount = Swift.min(count, self.count)
        return Array(shuffled().prefix(actualCount))
    }
}

// MARK: - Preview Helper
extension SampleMoodData {
    /// Genera una única entrada de ejemplo para previews
    static func sampleEntry() -> MoodEntry {
        MoodEntry(
            emotionType: .joy,
            intensity: 7,
            triggers: ["Conversación positiva", "Buen día en el trabajo"],
            copingStrategies: [.mindfulness, .deepBreathing, .exercise],
            notes: "Hoy fue un gran día. Practiqué mindfulness por la mañana y me ayudó a mantenerme centrado durante todo el día. Me siento agradecido por el progreso que estoy haciendo."
        )
    }
    
    /// Genera un conjunto pequeño de entradas para previews
    static func previewEntries() -> [MoodEntry] {
        [
            MoodEntry(
                emotionType: .joy,
                intensity: 8,
                triggers: ["Logro personal"],
                copingStrategies: [.mindfulness],
                notes: "Gran día"
            ),
            MoodEntry(
                emotionType: .anxiety,
                intensity: 6,
                triggers: ["Reunión importante"],
                copingStrategies: [.deepBreathing, .tipp],
                notes: "Nervioso pero manejable"
            ),
            MoodEntry(
                emotionType: .calm,
                intensity: 4,
                triggers: [],
                copingStrategies: [.mindfulness],
                notes: "Día tranquilo"
            ),
            MoodEntry(
                emotionType: .sadness,
                intensity: 7,
                triggers: ["Recuerdos del pasado"],
                copingStrategies: [.journaling, .socialSupport],
                notes: "Proceso difícil pero necesario"
            )
        ]
    }
}

// Nota: Para usar estos datos de muestra, agrega esto en tu ViewModel o SampleDataService:
/*
func loadSampleMoodData(context: ModelContext) {
    let entries = SampleMoodData.generateSampleEntries()
    entries.forEach { context.insert($0) }
    try? context.save()
}
*/
