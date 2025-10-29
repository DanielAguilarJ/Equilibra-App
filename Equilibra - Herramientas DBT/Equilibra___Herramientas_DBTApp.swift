//
//  Equilibra_Herramientas_DBTApp.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

@main
struct Equilibra_Herramientas_DBTApp: App {
    // SwiftData model container
    let modelContainer: ModelContainer
    
    init() {
        do {
            // Configurar el contenedor de SwiftData con todos los modelos
            modelContainer = try ModelContainer(
                for: DBTModule.self,
                    DBTSkill.self,
                    EmotionalLog.self,
                    SafetyPlan.self,
                    MoodEntry.self,
                    EmotionRegulationSession.self,
                    PLEASEEntry.self,
                    JournalEntry.self
            )
        } catch {
            fatalError("Error al inicializar ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
                .themed() // Aplicar tema
        }
    }
}
