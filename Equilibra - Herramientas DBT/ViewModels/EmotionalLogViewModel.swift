//
//  EmotionalLogViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData
import Combine

@Observable
final class EmotionalLogViewModel {
    var logs: [EmotionalLog] = []
    var selectedEmotion: String = ""
    var intensity: Int = 5
    var trigger: String = ""
    var notes: String = ""
    
    private var modelContext: ModelContext?
    
    init() {}
    
    func setup(with context: ModelContext) {
        self.modelContext = context
        loadLogs()
    }
    
    func loadLogs() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<EmotionalLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            logs = try context.fetch(descriptor)
        } catch {
            print("Error loading logs: \(error)")
        }
    }
    
    func saveLog() {
        guard let context = modelContext else { return }
        guard !selectedEmotion.isEmpty else { return }
        
        let log = EmotionalLog(
            emotion: selectedEmotion,
            intensity: intensity,
            trigger: trigger,
            notes: notes
        )
        
        context.insert(log)
        
        do {
            try context.save()
            loadLogs()
            resetForm()
        } catch {
            print("Error saving log: \(error)")
        }
    }
    
    func deleteLog(_ log: EmotionalLog) {
        guard let context = modelContext else { return }
        context.delete(log)
        
        do {
            try context.save()
            loadLogs()
        } catch {
            print("Error deleting log: \(error)")
        }
    }
    
    private func resetForm() {
        selectedEmotion = ""
        intensity = 5
        trigger = ""
        notes = ""
    }
}
