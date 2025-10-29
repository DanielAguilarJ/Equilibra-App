//
//  BreathingExercise.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Tipo de técnica de respiración
enum BreathingTechniqueType: String, Codable, CaseIterable {
    case boxBreathing = "Box Breathing"
    case breathing478 = "4-7-8 Breathing"
    case diaphragmatic = "Respiración Diafragmática"
    case custom = "Personalizada"
    
    var displayName: String {
        switch self {
        case .boxBreathing:
            return "Respiración Cuadrada"
        case .breathing478:
            return "Respiración 4-7-8"
        case .diaphragmatic:
            return "Respiración Diafragmática"
        case .custom:
            return "Personalizada"
        }
    }
    
    var description: String {
        switch self {
        case .boxBreathing:
            return "Inhala 4 segundos, mantén 4, exhala 4, mantén 4. Excelente para reducir estrés y ansiedad."
        case .breathing478:
            return "Inhala 4 segundos, mantén 7, exhala 8. Ideal para conciliar el sueño y calmar la mente."
        case .diaphragmatic:
            return "Respiración profunda desde el diafragma. Mejora la oxigenación y reduce tensión."
        case .custom:
            return "Configura tu propio patrón de respiración personalizado."
        }
    }
    
    var icon: String {
        switch self {
        case .boxBreathing:
            return "square.fill"
        case .breathing478:
            return "moon.stars.fill"
        case .diaphragmatic:
            return "waveform.path.ecg"
        case .custom:
            return "slider.horizontal.3"
        }
    }
}

/// Fase del ciclo de respiración
enum BreathingPhase: String, Codable {
    case inhale = "Inhalar"
    case holdAfterInhale = "Mantener (después de inhalar)"
    case exhale = "Exhalar"
    case holdAfterExhale = "Mantener (después de exhalar)"
    
    var instruction: String {
        switch self {
        case .inhale:
            return "Inhala profundamente"
        case .holdAfterInhale:
            return "Mantén el aire"
        case .exhale:
            return "Exhala lentamente"
        case .holdAfterExhale:
            return "Mantén vacío"
        }
    }
    
    var color: String {
        switch self {
        case .inhale:
            return "blue"
        case .holdAfterInhale:
            return "purple"
        case .exhale:
            return "green"
        case .holdAfterExhale:
            return "cyan"
        }
    }
}

@Model
final class BreathingExercise {
    var id: UUID
    var techniqueType: BreathingTechniqueType
    var inhaleDuration: Int // en segundos
    var holdAfterInhaleDuration: Int
    var exhaleDuration: Int
    var holdAfterExhaleDuration: Int
    var totalCycles: Int
    var isCustom: Bool
    var createdDate: Date
    var lastPracticedDate: Date?
    var practiceCount: Int
    
    init(
        techniqueType: BreathingTechniqueType,
        inhaleDuration: Int = 4,
        holdAfterInhaleDuration: Int = 4,
        exhaleDuration: Int = 4,
        holdAfterExhaleDuration: Int = 4,
        totalCycles: Int = 5
    ) {
        self.id = UUID()
        self.techniqueType = techniqueType
        self.isCustom = techniqueType == .custom
        self.createdDate = Date()
        self.practiceCount = 0
        
        // Configurar duraciones según el tipo
        switch techniqueType {
        case .boxBreathing:
            self.inhaleDuration = 4
            self.holdAfterInhaleDuration = 4
            self.exhaleDuration = 4
            self.holdAfterExhaleDuration = 4
            
        case .breathing478:
            self.inhaleDuration = 4
            self.holdAfterInhaleDuration = 7
            self.exhaleDuration = 8
            self.holdAfterExhaleDuration = 0
            
        case .diaphragmatic:
            self.inhaleDuration = 4
            self.holdAfterInhaleDuration = 2
            self.exhaleDuration = 6
            self.holdAfterExhaleDuration = 0
            
        case .custom:
            self.inhaleDuration = inhaleDuration
            self.holdAfterInhaleDuration = holdAfterInhaleDuration
            self.exhaleDuration = exhaleDuration
            self.holdAfterExhaleDuration = holdAfterExhaleDuration
        }
        
        self.totalCycles = totalCycles
    }
    
    var cycleDuration: Int {
        inhaleDuration + holdAfterInhaleDuration + exhaleDuration + holdAfterExhaleDuration
    }
    
    var totalDuration: Int {
        cycleDuration * totalCycles
    }
    
    func markPracticed() {
        lastPracticedDate = Date()
        practiceCount += 1
    }
}

// MARK: - Preset Exercises
extension BreathingExercise {
    static var presets: [BreathingExercise] {
        [
            BreathingExercise(techniqueType: .boxBreathing, totalCycles: 5),
            BreathingExercise(techniqueType: .breathing478, totalCycles: 4),
            BreathingExercise(techniqueType: .diaphragmatic, totalCycles: 5)
        ]
    }
}
