//
//  SituationSelectorView.swift
//  Equilibra - Herramientas DBT
//
//  Selector contextual de habilidad según la situación
//

import SwiftUI
import SwiftData

struct SituationSelectorView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: InterpersonalSkillsViewModel
    
    @State private var selectedSituation: InterpersonalSituation?
    @State private var showingSkillGuide = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.cyan)
                        
                        Text("¿Qué situación enfrentas?")
                            .font(.title2.bold())
                        
                        Text("Selecciona la que mejor describe tu situación y te recomendaremos la habilidad más apropiada.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // Situations
                    VStack(spacing: 12) {
                        ForEach(InterpersonalSituation.commonSituations) { situation in
                            SituationCard(
                                situation: situation,
                                isSelected: selectedSituation?.id == situation.id,
                                onTap: {
                                    selectedSituation = situation
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    if selectedSituation != nil {
                        Button {
                            if let situation = selectedSituation {
                                viewModel.selectedSkill = situation.recommendedSkill
                                showingSkillGuide = true
                            }
                        } label: {
                            Label("Comenzar Guía", systemImage: "arrow.right.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.cyan)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Selector de Situación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingSkillGuide) {
                if let skill = viewModel.selectedSkill {
                    SkillActionSheet(skill: skill, viewModel: viewModel)
                }
            }
        }
    }
}

struct SituationCard: View {
    let situation: InterpersonalSituation
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(situation.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(situation.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.cyan)
                            .font(.title2)
                    }
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: situation.recommendedSkill.icon)
                            .foregroundColor(skillColor)
                            .font(.caption)
                        Text("Habilidad recomendada:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                    }
                    
                    Text(situation.recommendedSkill.title)
                        .font(.subheadline.bold())
                        .foregroundColor(skillColor)
                }
                
                Text("Ejemplo: \(situation.example)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .italic()
            }
            .padding()
            .background(isSelected ? skillColor.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? skillColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var skillColor: Color {
        switch situation.recommendedSkill {
        case .dearMan: return .blue
        case .give: return .pink
        case .fast: return .purple
        }
    }
}

#Preview {
    SituationSelectorView(
        viewModel: InterpersonalSkillsViewModel(
            modelContext: ModelContext(try! ModelContainer(for: DearManPlan.self))
        )
    )
}
