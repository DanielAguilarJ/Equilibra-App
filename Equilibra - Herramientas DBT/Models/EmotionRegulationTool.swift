//
//  EmotionRegulationTool.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData
import Combine

/// Tipos de herramientas de regulación emocional
enum EmotionRegulationToolType: String, Codable, CaseIterable, Identifiable {
    case please = "PLEASE"
    case checkTheFacts = "Check the Facts"
    case oppositeAction = "Opposite Action"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .please:
            return "heart.text.square.fill"
        case .checkTheFacts:
            return "magnifyingglass.circle.fill"
        case .oppositeAction:
            return "arrow.triangle.2.circlepath.circle.fill"
        }
    }
    
    var color: String {
        switch self {
        case .please:
            return "green"
        case .checkTheFacts:
            return "blue"
        case .oppositeAction:
            return "purple"
        }
    }
    
    var title: String {
        return self.rawValue
    }
    
    var description: String {
        switch self {
        case .please:
            return "Cuida tu salud física para regular tus emociones"
        case .checkTheFacts:
            return "Evalúa situaciones objetivamente separando hechos de interpretaciones"
        case .oppositeAction:
            return "Cambia tu emoción actuando de manera opuesta a tu impulso"
        }
    }
}

/// Modelo para registrar el uso de herramientas de regulación emocional
@Model
final class EmotionRegulationSession {
    var id: UUID
    var date: Date
    var toolType: EmotionRegulationToolType
    var initialEmotion: String
    var initialIntensity: Int // 1-10
    var finalIntensity: Int? // 1-10
    var notes: String
    var wasHelpful: Bool?
    var completedSteps: [String]
    
    init(
        toolType: EmotionRegulationToolType,
        initialEmotion: String,
        initialIntensity: Int
    ) {
        self.id = UUID()
        self.date = Date()
        self.toolType = toolType
        self.initialEmotion = initialEmotion
        self.initialIntensity = max(1, min(10, initialIntensity))
        self.finalIntensity = nil
        self.notes = ""
        self.wasHelpful = nil
        self.completedSteps = []
    }
}

/// Modelo para el tracking PLEASE
@Model
final class PLEASEEntry {
    var id: UUID
    var date: Date
    
    // Physical illness - Tratar enfermedades físicas
    var tookMedication: Bool
    var medicationNotes: String
    
    // Eating - Alimentación balanceada
    var ateBalanced: Bool
    var mealsCount: Int
    
    // Avoid mood-altering substances
    var avoidedSubstances: Bool
    var substanceNotes: String
    
    // Sleep - Dormir bien
    var sleepHours: Double
    var sleepQuality: Int // 1-5
    
    // Exercise - Ejercicio
    var exerciseMinutes: Int
    var exerciseType: String
    
    var notes: String
    
    init() {
        self.id = UUID()
        self.date = Date()
        self.tookMedication = false
        self.medicationNotes = ""
        self.ateBalanced = false
        self.mealsCount = 0
        self.avoidedSubstances = true
        self.substanceNotes = ""
        self.sleepHours = 0
        self.sleepQuality = 3
        self.exerciseMinutes = 0
        self.exerciseType = ""
        self.notes = ""
    }
    
    var completionPercentage: Double {
        var completed = 0.0
        var total = 5.0
        
        if tookMedication || medicationNotes.isEmpty { completed += 1 }
        if ateBalanced { completed += 1 }
        if avoidedSubstances { completed += 1 }
        if sleepHours >= 6 { completed += 1 }
        if exerciseMinutes >= 20 { completed += 1 }
        
        return completed / total
    }
}

/// Modelo para Check the Facts
struct CheckFactsQuestion: Identifiable, Codable {
    let id: UUID
    let question: String
    var answer: String
    
    init(question: String) {
        self.id = UUID()
        self.question = question
        self.answer = ""
    }
}

/// Modelo para Opposite Action
struct EmotionAction: Identifiable {
    let id = UUID()
    let emotion: String
    let typicalUrge: String
    let oppositeAction: String
    let examples: [String]
}
