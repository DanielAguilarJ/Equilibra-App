//
//  DBTModule.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Representa los 4 módulos principales de la Terapia Dialéctico-Conductual
enum DBTModuleType: String, Codable, CaseIterable, Comparable {
    case mindfulness = "Mindfulness"
    case emotionalRegulation = "Regulación Emocional"
    case interpersonalEffectiveness = "Eficacia Interpersonal"
    case distressTolerance = "Tolerancia al Malestar"
    
    var icon: String {
        switch self {
        case .mindfulness:
            return "brain.head.profile"
        case .emotionalRegulation:
            return "heart.circle.fill"
        case .interpersonalEffectiveness:
            return "person.2.fill"
        case .distressTolerance:
            return "shield.fill"
        }
    }
    
    var color: String {
        switch self {
        case .mindfulness:
            return "purple"
        case .emotionalRegulation:
            return "blue"
        case .interpersonalEffectiveness:
            return "green"
        case .distressTolerance:
            return "orange"
        }
    }
    
    var description: String {
        switch self {
        case .mindfulness:
            return "Aprende a estar presente en el momento actual sin juzgar"
        case .emotionalRegulation:
            return "Comprende y gestiona tus emociones de manera saludable"
        case .interpersonalEffectiveness:
            return "Mejora tus relaciones y comunicación con los demás"
        case .distressTolerance:
            return "Desarrolla habilidades para manejar situaciones de crisis"
        }
    }
}

// MARK: - Comparable Implementation
extension DBTModuleType {
    static func < (lhs: DBTModuleType, rhs: DBTModuleType) -> Bool {
        let order: [DBTModuleType] = [.mindfulness, .emotionalRegulation, .interpersonalEffectiveness, .distressTolerance]
        guard let lhsIndex = order.firstIndex(of: lhs), let rhsIndex = order.firstIndex(of: rhs) else {
            return false
        }
        return lhsIndex < rhsIndex
    }
}

@Model
final class DBTModule {
    var id: UUID
    var type: DBTModuleType
    var completedSkills: Int
    var totalSkills: Int
    var lastAccessed: Date?
    var isFavorite: Bool
    
    init(type: DBTModuleType, totalSkills: Int = 10) {
        self.id = UUID()
        self.type = type
        self.completedSkills = 0
        self.totalSkills = totalSkills
        self.lastAccessed = nil
        self.isFavorite = false
    }
    
    var progress: Double {
        guard totalSkills > 0 else { return 0.0 }
        return Double(completedSkills) / Double(totalSkills)
    }
}
