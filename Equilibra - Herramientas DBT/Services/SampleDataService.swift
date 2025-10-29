//
//  SampleDataService.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Servicio para crear datos de ejemplo y poblar la base de datos
final class SampleDataService {
    static let shared = SampleDataService()
    
    private init() {}
    
    /// Crea datos de ejemplo en el contexto proporcionado
    func createSampleData(in context: ModelContext) {
        // Verificar si ya hay datos
        let moduleDescriptor = FetchDescriptor<DBTModule>()
        if let existingModules = try? context.fetch(moduleDescriptor), !existingModules.isEmpty {
            print("Los datos de ejemplo ya existen")
            return
        }
        
        // Crear módulos
        createModules(in: context)
        
        // Crear habilidades de ejemplo
        createSampleSkills(in: context)
        
        // Crear registros emocionales de ejemplo
        createSampleEmotionalLogs(in: context)
        
        // Crear entradas de seguimiento emocional
        createSampleMoodEntries(in: context)
        
        // Guardar cambios
        do {
            try context.save()
            print("✅ Datos de ejemplo creados exitosamente")
        } catch {
            print("❌ Error al crear datos de ejemplo: \(error)")
        }
    }
    
    // MARK: - Create Modules
    private func createModules(in context: ModelContext) {
        for moduleType in DBTModuleType.allCases {
            let module = DBTModule(type: moduleType, totalSkills: 10)
            context.insert(module)
        }
    }
    
    // MARK: - Create Sample Skills
    private func createSampleSkills(in context: ModelContext) {
        // Mindfulness Skills
        let mindfulnessSkills = [
            ("Mente Sabia", "Integra la mente racional y la mente emocional para tomar decisiones equilibradas."),
            ("Observar", "Observa tus experiencias sin juzgarlas ni reaccionar ante ellas."),
            ("Describir", "Pon palabras a tu experiencia, describiendo los hechos sin interpretaciones."),
            ("Participar", "Sumérgete completamente en la actividad del momento presente."),
            ("No Juzgar", "Adopta una postura no evaluativa hacia ti mismo y tu experiencia."),
            ("Una Cosa a la Vez", "Enfócate completamente en una sola actividad en el momento presente."),
            ("Efectividad", "Haz lo que funciona en la situación, dejando de lado el 'debería'."),
        ]
        
        for (title, description) in mindfulnessSkills {
            let skill = DBTSkill(
                title: title,
                description: description,
                moduleType: .mindfulness,
                instructions: "Practica esta habilidad diariamente durante al menos 5 minutos."
            )
            context.insert(skill)
        }
        
        // Emotional Regulation Skills
        let emotionalRegulationSkills = [
            ("Identificar Emociones", "Aprende a reconocer y nombrar tus emociones con precisión."),
            ("Reducir Vulnerabilidad", "Cuida tu bienestar físico y emocional para manejar mejor las emociones."),
            ("Acción Opuesta", "Actúa de forma contraria a tu impulso emocional cuando sea necesario."),
            ("Verificar los Hechos", "Examina si tus emociones se ajustan a los hechos de la situación."),
            ("Resolver Problemas", "Toma pasos activos para cambiar situaciones que causan emociones dolorosas."),
            ("ABC PLEASE", "Maneja la vulnerabilidad emocional cuidando tu salud física."),
        ]
        
        for (title, description) in emotionalRegulationSkills {
            let skill = DBTSkill(
                title: title,
                description: description,
                moduleType: .emotionalRegulation,
                instructions: "Utiliza esta habilidad cuando experimentes emociones intensas."
            )
            context.insert(skill)
        }
        
        // Interpersonal Effectiveness Skills
        let interpersonalSkills = [
            ("DEAR MAN", "Técnica para pedir lo que necesitas o decir no de manera efectiva."),
            ("GIVE", "Mantén y mejora tus relaciones mientras obtienes lo que necesitas."),
            ("FAST", "Mantén el respeto por ti mismo en las interacciones."),
            ("Validación", "Reconoce y acepta las emociones y experiencias de otros."),
            ("Recuperación de Relaciones", "Repara y fortalece relaciones después de conflictos."),
        ]
        
        for (title, description) in interpersonalSkills {
            let skill = DBTSkill(
                title: title,
                description: description,
                moduleType: .interpersonalEffectiveness,
                instructions: "Practica en situaciones interpersonales desafiantes."
            )
            context.insert(skill)
        }
        
        // Distress Tolerance Skills
        let distressToleranceSkills = [
            ("TIPP", "Técnica de crisis: Temperatura, Intenso ejercicio, Respiración Pausada, Relajación muscular Progresiva."),
            ("STOP", "Detente, Da un paso atrás, Observa, Procede con atención."),
            ("Pros y Contras", "Evalúa las consecuencias de tolerar vs. no tolerar el malestar."),
            ("Distraer", "Aparta tu atención del dolor emocional temporalmente."),
            ("Auto-consuelo", "Usa tus cinco sentidos para calmarte y consolarte."),
            ("Mejorar el Momento", "Cambia tu experiencia del momento presente."),
            ("Aceptación Radical", "Acepta completamente la realidad tal como es, sin juzgar."),
        ]
        
        for (title, description) in distressToleranceSkills {
            let skill = DBTSkill(
                title: title,
                description: description,
                moduleType: .distressTolerance,
                instructions: "Utiliza en momentos de crisis o malestar intenso."
            )
            context.insert(skill)
        }
    }
    
    // MARK: - Create Sample Emotional Logs
    private func createSampleEmotionalLogs(in context: ModelContext) {
        let sampleLogs = [
            EmotionalLog(
                emotion: "Ansiedad",
                intensity: 7,
                trigger: "Reunión importante en el trabajo",
                skillsUsed: ["Respiración", "STOP"],
                notes: "Las técnicas de respiración me ayudaron a calmarme antes de la reunión."
            ),
            EmotionalLog(
                emotion: "Tristeza",
                intensity: 5,
                trigger: "Discusión con un amigo",
                skillsUsed: ["Mindfulness", "Verificar los Hechos"],
                notes: "Intenté ver la situación desde su perspectiva."
            ),
            EmotionalLog(
                emotion: "Alegría",
                intensity: 8,
                trigger: "Completé un proyecto personal",
                skillsUsed: [],
                notes: "¡Me siento orgulloso/a de mi logro!"
            ),
        ]
        
        for log in sampleLogs {
            // Ajustar la fecha para que sean de diferentes días
            var adjustedLog = log
            adjustedLog.date = Calendar.current.date(
                byAdding: .day,
                value: -Int.random(in: 1...7),
                to: Date()
            ) ?? Date()
            context.insert(adjustedLog)
        }
    }
    
    // MARK: - Create Sample Mood Entries
    private func createSampleMoodEntries(in context: ModelContext) {
        let calendar = Calendar.current
        let now = Date()
        
        let sampleMoods: [(EmotionType, Int, [String], [MoodCopingStrategy], String)] = [
            (.anxiety, 7, ["Presentación en el trabajo"], [.deepBreathing, .tipp], "Las técnicas de respiración realmente ayudaron."),
            (.joy, 8, ["Día soleado", "Tiempo con amigos"], [.mindfulness], "Me sentí muy presente y agradecido."),
            (.sadness, 5, ["Noticias tristes"], [.selfSoothing, .journaling], "Escribir me ayudó a procesar."),
            (.calm, 6, ["Meditación matinal"], [.mindfulness, .deepBreathing], "Empecé bien el día."),
            (.anger, 6, ["Discusión con familiar"], [.oppositeAction, .stopTechnique], "Logré no reaccionar impulsivamente."),
            (.fear, 4, ["Pensamientos sobre el futuro"], [.radicalAcceptance, .prosAndCons], "Aceptar la incertidumbre fue difícil pero útil."),
            (.anxiety, 8, ["Examen importante"], [.tipp, .distraction], "TIPP fue muy efectivo para reducir la ansiedad."),
            (.joy, 9, ["Logro personal"], [], "¡Fue un día increíble!"),
            (.emptiness, 5, ["Sin razón aparente"], [.selfSoothing, .socialSupport], "Llamar a un amigo ayudó."),
            (.calm, 7, ["Práctica de yoga"], [.mindfulness, .exercise], "El yoga fue muy relajante."),
        ]
        
        for (index, (emotion, intensity, triggers, strategies, notes)) in sampleMoods.enumerated() {
            let entry = MoodEntry(
                emotionType: emotion,
                intensity: intensity,
                triggers: triggers,
                copingStrategies: strategies,
                notes: notes
            )
            
            // Distribuir las entradas en los últimos 10 días
            if let adjustedDate = calendar.date(byAdding: .day, value: -(10 - index), to: now) {
                entry.timestamp = adjustedDate
            }
            
            // Marcar algunas como efectivas
            if !strategies.isEmpty && intensity < 8 {
                entry.wasEffective = true
            } else if !strategies.isEmpty {
                entry.wasEffective = Bool.random()
            }
            
            context.insert(entry)
        }
    }
    
    // MARK: - Clear All Data
    func clearAllData(in context: ModelContext) {
        do {
            // Delete all modules
            let moduleDescriptor = FetchDescriptor<DBTModule>()
            let modules = try context.fetch(moduleDescriptor)
            modules.forEach { context.delete($0) }
            
            // Delete all skills
            let skillDescriptor = FetchDescriptor<DBTSkill>()
            let skills = try context.fetch(skillDescriptor)
            skills.forEach { context.delete($0) }
            
            // Delete all emotional logs
            let logDescriptor = FetchDescriptor<EmotionalLog>()
            let logs = try context.fetch(logDescriptor)
            logs.forEach { context.delete($0) }
            
            // Delete all crisis plans
            let planDescriptor = FetchDescriptor<CrisisPlan>()
            let plans = try context.fetch(planDescriptor)
            plans.forEach { context.delete($0) }
            
            // Delete all mood entries
            let moodDescriptor = FetchDescriptor<MoodEntry>()
            let moods = try context.fetch(moodDescriptor)
            moods.forEach { context.delete($0) }
            
            try context.save()
            print("✅ Todos los datos han sido eliminados")
        } catch {
            print("❌ Error al eliminar datos: \(error)")
        }
    }
}
