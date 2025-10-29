//
//  JournalEntry.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Modelo para entradas de diario terapéutico con soporte para encriptación
@Model
final class JournalEntry {
    var id: UUID
    var date: Date
    var title: String
    var content: String
    var encryptedContent: Data? // Contenido encriptado para privacidad
    var isEncrypted: Bool
    
    // Etiquetas y categorización
    var emotionalTags: [String]
    var promptsUsed: [String]
    
    // Estado emocional antes y después
    var preWritingMood: Int // 1-10
    var postWritingMood: Int? // 1-10
    
    // Metadata
    var isFavorite: Bool
    var wordCount: Int
    var lastModified: Date
    
    init(
        title: String,
        content: String,
        emotionalTags: [String] = [],
        promptsUsed: [String] = [],
        preWritingMood: Int,
        postWritingMood: Int? = nil,
        isFavorite: Bool = false
    ) {
        self.id = UUID()
        self.date = Date()
        self.title = title
        self.content = content
        self.encryptedContent = nil
        self.isEncrypted = false
        self.emotionalTags = emotionalTags
        self.promptsUsed = promptsUsed
        self.preWritingMood = max(1, min(10, preWritingMood))
        self.postWritingMood = postWritingMood.map { max(1, min(10, $0)) }
        self.isFavorite = isFavorite
        self.wordCount = content.split(separator: " ").count
        self.lastModified = Date()
    }
    
    /// Actualiza el conteo de palabras basado en el contenido actual
    func updateWordCount() {
        self.wordCount = content.split(separator: " ").count
        self.lastModified = Date()
    }
    
    /// Calcula la mejora de ánimo después de escribir
    var moodImprovement: Int? {
        guard let post = postWritingMood else { return nil }
        return post - preWritingMood
    }
}

/// Prompt terapéutico para guiar la escritura
struct TherapeuticPrompt: Identifiable, Codable {
    let id: UUID
    let text: String
    let category: PromptCategory
    let description: String
    
    enum PromptCategory: String, Codable, CaseIterable {
        case emotional = "Emocional"
        case cognitive = "Cognitivo"
        case validation = "Validación"
        case needs = "Necesidades"
        case behavior = "Comportamiento"
        case relationships = "Relaciones"
        
        var icon: String {
            switch self {
            case .emotional: return "heart.fill"
            case .cognitive: return "brain.head.profile"
            case .validation: return "checkmark.seal.fill"
            case .needs: return "hand.raised.fill"
            case .behavior: return "figure.walk"
            case .relationships: return "person.2.fill"
            }
        }
    }
    
    init(id: UUID = UUID(), text: String, category: PromptCategory, description: String) {
        self.id = id
        self.text = text
        self.category = category
        self.description = description
    }
}
