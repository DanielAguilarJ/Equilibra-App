//
//  ModulesView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct ModulesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var modules: [DBTModule]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header info
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Terapia Dialéctico-Conductual")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("La DBT te ayuda a desarrollar habilidades para regular emociones, mejorar relaciones y manejar situaciones difíciles.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.blue.opacity(0.1))
                    )
                    .padding(.horizontal)
                    
                    // Modules list
                    VStack(spacing: 16) {
                        ForEach(modules) { module in
                            NavigationLink {
                                switch module.type {
                                case .mindfulness:
                                    MindfulnessModuleView()
                                case .emotionalRegulation:
                                    EmotionRegulationToolsView()
                                case .interpersonalEffectiveness:
                                    InterpersonalSkillsView()
                                case .distressTolerance:
                                    Text("Módulo de Tolerancia al Malestar próximamente")
                                        .font(.title2)
                                        .padding()
                                }
                            } label: {
                                ModuleCard(module: module)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Módulos DBT")
        }
    }
}

#Preview {
    ModulesView()
        .modelContainer(for: [DBTModule.self, DBTSkill.self])
}
