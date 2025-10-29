//
//  MoodEntry.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Tipos de emociones principales para seguimiento
enum EmotionType: String, Codable, CaseIterable {
    case joy = "Alegría"
    case sadness = "Tristeza"
    case anger = "Ira"
    case fear = "Miedo"
    case anxiety = "Ansiedad"
    case emptiness = "Vacío"
    case calm = "Calma"
    case excitement = "Emoción"
    
    var emoji: String {
        switch self {
        case .joy: return "😊"
        case .sadness: return "😢"
        case .anger: return "😠"
        case .fear: return "😰"
        case .anxiety: return "😟"
        case .emptiness: return "😶"
        case .calm: return "😌"
        case .excitement: return "🤩"
        }
    }
    
    var color: String {
        switch self {
        case .joy: return "yellow"
        case .sadness: return "blue"
        case .anger: return "red"
        case .fear: return "purple"
        case .anxiety: return "orange"
        case .emptiness: return "gray"
        case .calm: return "green"
        case .excitement: return "pink"
        }
    }
}

/// Estrategias de afrontamiento comunes en DBT
enum MoodCopingStrategy: String, Codable, CaseIterable {
    case deepBreathing = "Respiración Profunda"
    case mindfulness = "Mindfulness"
    case oppositeAction = "Acción Opuesta"
    case distraction = "Distracción"
    case selfSoothing = "Auto-consuelo"
    case tipp = "TIPP"
    case stopTechnique = "STOP"
    case radicalAcceptance = "Aceptación Radical"
    case prosAndCons = "Pros y Contras"
    case exercise = "Ejercicio Físico"
    case journaling = "Escribir/Diario"
    case socialSupport = "Apoyo Social"
    
    var icon: String {
        switch self {
        case .deepBreathing: return "wind"
        case .mindfulness: return "brain.head.profile"
        case .oppositeAction: return "arrow.triangle.2.circlepath"
        case .distraction: return "sparkles"
        case .selfSoothing: return "heart.circle"
        case .tipp: return "thermometer"
        case .stopTechnique: return "hand.raised.fill"
        case .radicalAcceptance: return "checkmark.seal"
        case .prosAndCons: return "list.bullet.clipboard"
        case .exercise: return "figure.walk"
        case .journaling: return "book.closed"
        case .socialSupport: return "person.2"
        }
    }
}

@Model
final class MoodEntry {
    var id: UUID
    var timestamp: Date
    var emotionType: EmotionType
    var intensity: Int // 1-10
    var triggers: [String]
    var copingStrategies: [MoodCopingStrategy]
    var notes: String
    var wasEffective: Bool? // Si las estrategias funcionaron
    
    // HealthKit integration fields
    var healthKitSynced: Bool
    var healthKitID: String?
    
    init(
        emotionType: EmotionType,
        intensity: Int,
        triggers: [String] = [],
        copingStrategies: [MoodCopingStrategy] = [],
        notes: String = ""
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.emotionType = emotionType
        self.intensity = max(1, min(10, intensity))
        self.triggers = triggers
        self.copingStrategies = copingStrategies
        self.notes = notes
        self.wasEffective = nil
        self.healthKitSynced = false
        self.healthKitID = nil
    }
    
    // Computed properties
    var intensityLevel: IntensityLevel {
        switch intensity {
        case 1...3: return .low
        case 4...6: return .moderate
        case 7...8: return .high
        default: return .veryHigh
        }
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    enum IntensityLevel: String {
        case low = "Baja"
        case moderate = "Moderada"
        case high = "Alta"
        case veryHigh = "Muy Alta"
    }
}
