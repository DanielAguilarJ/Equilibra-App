//
//  GiveGuideView.swift
//  Equilibra - Herramientas DBT
//
//  Guía interactiva con checkboxes para GIVE
//

import SwiftUI
import SwiftData

struct GiveGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: InterpersonalSkillsViewModel
    @Bindable var plan: GivePlan
    
    @State private var showingCompletion = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.pink)
                        
                        Text("GIVE: Mantener Relaciones")
                            .font(.title2.bold())
                        
                        Text("Usa esta guía para mantener relaciones saludables mientras expresas tus necesidades.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // Situation
                    VStack(alignment: .leading, spacing: 12) {
                        Label("Situación", systemImage: "text.bubble")
                            .font(.headline)
                        TextEditor(text: $plan.situation)
                            .frame(height: 80)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        Label("Relación", systemImage: "person.2")
                            .font(.headline)
                        TextEditor(text: $plan.relationship)
                            .frame(height: 60)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // GIVE Components
                    VStack(spacing: 16) {
                        GiveComponentCard(
                            letter: "G",
                            title: "Gentle",
                            subtitle: "Sé amable y respetuoso/a",
                            tip: InterpersonalSkillType.give.components[0],
                            isChecked: $plan.gentle,
                            notes: $plan.gentleNotes
                        )
                        
                        GiveComponentCard(
                            letter: "I",
                            title: "Interested",
                            subtitle: "Muestra interés genuino",
                            tip: InterpersonalSkillType.give.components[1],
                            isChecked: $plan.interested,
                            notes: $plan.interestedNotes
                        )
                        
                        GiveComponentCard(
                            letter: "V",
                            title: "Validate",
                            subtitle: "Valida sentimientos",
                            tip: InterpersonalSkillType.give.components[2],
                            isChecked: $plan.validate,
                            notes: $plan.validateNotes
                        )
                        
                        GiveComponentCard(
                            letter: "E",
                            title: "Easy Manner",
                            subtitle: "Actitud relajada",
                            tip: InterpersonalSkillType.give.components[3],
                            isChecked: $plan.easyManner,
                            notes: $plan.easyMannerNotes
                        )
                    }
                    .padding(.horizontal)
                    
                    // Progress Indicator
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .foregroundColor(.pink)
                            Text("Progreso")
                                .font(.headline)
                            Spacer()
                            Text("\(completedCount)/4")
                                .font(.headline)
                                .foregroundColor(.pink)
                        }
                        
                        ProgressView(value: Double(completedCount), total: 4.0)
                            .tint(.pink)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button {
                            viewModel.updateGivePlan(plan)
                            showingCompletion = true
                        } label: {
                            Label("Completar y Reflexionar", systemImage: "checkmark.circle.fill")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isComplete ? Color.pink : Color.gray.opacity(0.3))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(!isComplete)
                        
                        Button {
                            viewModel.updateGivePlan(plan)
                            dismiss()
                        } label: {
                            Text("Guardar Progreso")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Guía GIVE")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        viewModel.updateGivePlan(plan)
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingCompletion) {
                CompletionReflectionView(
                    skillType: .give,
                    onComplete: { outcome, reflection, effectiveness in
                        viewModel.completeGivePlan(plan, outcome: outcome, reflection: reflection, effectiveness: effectiveness)
                        dismiss()
                    }
                )
            }
        }
    }
    
    private var completedCount: Int {
        var count = 0
        if plan.gentle { count += 1 }
        if plan.interested { count += 1 }
        if plan.validate { count += 1 }
        if plan.easyManner { count += 1 }
        return count
    }
    
    private var isComplete: Bool {
        !plan.situation.isEmpty &&
        !plan.relationship.isEmpty &&
        plan.gentle &&
        plan.interested &&
        plan.validate &&
        plan.easyManner
    }
}

// MARK: - GIVE Component Card

struct GiveComponentCard: View {
    let letter: String
    let title: String
    let subtitle: String
    let tip: ComponentTip
    @Binding var isChecked: Bool
    @Binding var notes: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Circle()
                        .fill(isChecked ? Color.pink : Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Text(letter)
                                .font(.headline.bold())
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Tip
                    InfoBox(icon: "lightbulb.fill", text: tip.tip, color: .pink)
                    
                    // Example
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Ejemplo:")
                                .font(.subheadline.bold())
                        }
                        Text(tip.example)
                            .font(.subheadline)
                            .padding(12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                    
                    if let warning = tip.warning {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Recuerda:")
                                    .font(.subheadline.bold())
                            }
                            Text(warning)
                                .font(.subheadline)
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                    
                    // Checkbox
                    Toggle(isOn: $isChecked) {
                        Text("He aplicado/aplicaré este componente")
                            .font(.subheadline)
                    }
                    .tint(.pink)
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notas personales:")
                            .font(.subheadline.bold())
                        TextEditor(text: $notes)
                            .frame(height: 80)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    GiveGuideView(
        viewModel: InterpersonalSkillsViewModel(modelContext: ModelContext(try! ModelContainer(for: GivePlan.self))),
        plan: GivePlan(situation: "Discusión con amigo", relationship: "Mejor amigo")
    )
}
