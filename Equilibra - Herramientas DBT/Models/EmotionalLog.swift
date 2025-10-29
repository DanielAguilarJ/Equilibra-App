//
//  EmotionalLog.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData
import Combine

/// Modelo para registrar emociones y su intensidad a lo largo del tiempo
@Model
final class EmotionalLog {
    var id: UUID
    var date: Date
    var emotion: String
    var intensity: Int // 1-10 escala
    var trigger: String
    var skillsUsed: [String]
    var notes: String
    var wasHelpful: Bool?
    
    init(
        emotion: String,
        intensity: Int,
        trigger: String = "",
        skillsUsed: [String] = [],
        notes: String = ""
    ) {
        self.id = UUID()
        self.date = Date()
        self.emotion = emotion
        self.intensity = max(1, min(10, intensity))
        self.trigger = trigger
        self.skillsUsed = skillsUsed
        self.notes = notes
        self.wasHelpful = nil
    }
}
