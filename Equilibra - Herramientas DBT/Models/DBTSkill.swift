//
//  DBTSkill.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

@Model
final class DBTSkill {
    var id: UUID
    var title: String
    var skillDescription: String
    var moduleType: DBTModuleType
    var instructions: String
    var isCompleted: Bool
    var completedDate: Date?
    var practiceCount: Int
    var notes: String
    
    init(
        title: String,
        description: String,
        moduleType: DBTModuleType,
        instructions: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.skillDescription = description
        self.moduleType = moduleType
        self.instructions = instructions
        self.isCompleted = false
        self.completedDate = nil
        self.practiceCount = 0
        self.notes = ""
    }
}
