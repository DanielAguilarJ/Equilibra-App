//
//  HomeViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

@Observable
final class HomeViewModel {
    var modules: [DBTModule] = []
    var recentLogs: [EmotionalLog] = []
    var showingCrisisMode: Bool = false
    
    private var modelContext: ModelContext?
    
    init() {}
    
    func setup(with context: ModelContext) {
        self.modelContext = context
        loadModules()
        loadRecentLogs()
    }
    
    func loadModules() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<DBTModule>()
        
        do {
            modules = try context.fetch(descriptor)
            
            // Si no hay módulos, crear los 4 módulos base
            if modules.isEmpty {
                createDefaultModules()
            }
        } catch {
            print("Error loading modules: \(error)")
        }
    }
    
    func loadRecentLogs() {
        guard let context = modelContext else { return }
        
        var descriptor = FetchDescriptor<EmotionalLog>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = 5
        
        do {
            recentLogs = try context.fetch(descriptor)
        } catch {
            print("Error loading recent logs: \(error)")
        }
    }
    
    private func createDefaultModules() {
        guard let context = modelContext else { return }
        
        for moduleType in DBTModuleType.allCases {
            let module = DBTModule(type: moduleType)
            context.insert(module)
        }
        
        do {
            try context.save()
            loadModules()
        } catch {
            print("Error creating default modules: \(error)")
        }
    }
    
    func toggleCrisisMode() {
        showingCrisisMode.toggle()
    }
    
    func getModule(for type: DBTModuleType) -> DBTModule? {
        modules.first { $0.type == type }
    }
}
