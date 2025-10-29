//
//  SkillActionSheet.swift
//  Equilibra - Herramientas DBT
//
//  Sheet de acciones para iniciar una guía de habilidad
//

import SwiftUI
import SwiftData

struct SkillActionSheet: View {
    @Environment(\.dismiss) private var dismiss
    let skill: InterpersonalSkillType
    @Bindable var viewModel: InterpersonalSkillsViewModel
    
    @State private var showingGuide = false
    @State private var situation = ""
    @State private var goal = ""
    @State private var relationship = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Circle()
                            .fill(skillColor.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: skill.icon)
                                    .font(.system(size: 40))
                                    .foregroundColor(skillColor)
                            )
                        
                        Text(skill.title)
                            .font(.title2.bold())
                        
                        Text(skill.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Setup Fields
                    VStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("Situación", systemImage: "text.bubble")
                                .font(.headline)
                            TextEditor(text: $situation)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        if skill == .dearMan {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Objetivo", systemImage: "target")
                                    .font(.headline)
                                Text("¿Qué quieres conseguir?")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                TextEditor(text: $goal)
                                    .frame(height: 80)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        
                        if skill == .give {
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Relación", systemImage: "person.2")
                                    .font(.headline)
                                Text("¿Con quién es la interacción?")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                TextEditor(text: $relationship)
                                    .frame(height: 60)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Info about skill
                    SkillInfoBox(skill: skill)
                        .padding(.horizontal)
                    
                    // Start Button
                    Button {
                        startGuide()
                    } label: {
                        Label("Comenzar Guía Interactiva", systemImage: "arrow.right.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canStart ? skillColor : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!canStart)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Preparar \(skill.title)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingGuide) {
                guideView
            }
        }
    }
    
    @ViewBuilder
    private var guideView: some View {
        switch skill {
        case .dearMan:
            if let plan = viewModel.activeDearManPlan {
                DearManWizardView(viewModel: viewModel, plan: plan)
            }
        case .give:
            if let plan = viewModel.activeGivePlan {
                GiveGuideView(viewModel: viewModel, plan: plan)
            }
        case .fast:
            if let plan = viewModel.activeFastPlan {
                FastGuideView(viewModel: viewModel, plan: plan)
            }
        }
    }
    
    private var canStart: Bool {
        switch skill {
        case .dearMan:
            return !situation.isEmpty && !goal.isEmpty
        case .give:
            return !situation.isEmpty && !relationship.isEmpty
        case .fast:
            return !situation.isEmpty
        }
    }
    
    private var skillColor: Color {
        switch skill {
        case .dearMan: return .blue
        case .give: return .pink
        case .fast: return .purple
        }
    }
    
    private func startGuide() {
        switch skill {
        case .dearMan:
            viewModel.createDearManPlan(situation: situation, goal: goal)
        case .give:
            viewModel.createGivePlan(situation: situation, relationship: relationship)
        case .fast:
            viewModel.createFastPlan(situation: situation)
        }
        showingGuide = true
    }
}

struct SkillInfoBox: View {
    let skill: InterpersonalSkillType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Componentes de \(skill.title):")
                .font(.headline)
            
            ForEach(Array(skill.components.enumerated()), id: \.offset) { index, component in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(skillColor.opacity(0.2))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text(extractLetter(from: component.component))
                                .font(.caption.bold())
                                .foregroundColor(skillColor)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(component.component)
                            .font(.subheadline.bold())
                        Text(component.tip)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(skillColor.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var skillColor: Color {
        switch skill {
        case .dearMan: return .blue
        case .give: return .pink
        case .fast: return .purple
        }
    }
    
    private func extractLetter(from component: String) -> String {
        switch skill {
        case .dearMan:
            if component.contains("Describe") { return "D" }
            if component.contains("Express") { return "E" }
            if component.contains("Assert") { return "A" }
            if component.contains("Reinforce") { return "R" }
            if component.contains("Mindful") { return "M" }
            if component.contains("Appear") { return "A" }
            if component.contains("Negotiate") { return "N" }
        case .give:
            if component.contains("Gentle") { return "G" }
            if component.contains("Interested") { return "I" }
            if component.contains("Validate") { return "V" }
            if component.contains("Easy") { return "E" }
        case .fast:
            if component.contains("Fair") { return "F" }
            if component.contains("Apologies") { return "A" }
            if component.contains("Stick") { return "S" }
            if component.contains("Truthful") { return "T" }
        }
        return "?"
    }
}

#Preview {
    SkillActionSheet(
        skill: .dearMan,
        viewModel: InterpersonalSkillsViewModel(
            modelContext: ModelContext(try! ModelContainer(for: DearManPlan.self))
        )
    )
}
