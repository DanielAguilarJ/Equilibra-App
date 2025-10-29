//
//  FastGuideView.swift
//  Equilibra - Herramientas DBT
//
//  Auto-evaluación y journaling para FAST (autorespeto)
//

import SwiftUI

struct FastGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: InterpersonalSkillsViewModel
    @Bindable var plan: FastPlan
    
    @State private var showingCompletion = false
    @State private var currentTab = 0
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Custom Tab Picker
                Picker("", selection: $currentTab) {
                    Text("Preparación").tag(0)
                    Text("Auto-evaluación").tag(1)
                    Text("Reflexión").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        switch currentTab {
                        case 0:
                            preparationTab
                        case 1:
                            evaluationTab
                        case 2:
                            reflectionTab
                        default:
                            EmptyView()
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Guía FAST")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        viewModel.updateFastPlan(plan)
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    if currentTab == 2 && isComplete {
                        Button("Completar") {
                            showingCompletion = true
                        }
                    }
                }
            }
            .sheet(isPresented: $showingCompletion) {
                CompletionReflectionView(
                    skillType: .fast,
                    onComplete: { outcome, reflection, effectiveness in
                        viewModel.completeFastPlan(plan, outcome: outcome, reflection: reflection, effectiveness: effectiveness)
                        dismiss()
                    }
                )
            }
        }
    }
    
    // MARK: - Tabs
    
    private var preparationTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "shield.checkered")
                    .font(.system(size: 60))
                    .foregroundStyle(.purple)
                
                Text("FAST: Mantener el Autorespeto")
                    .font(.title2.bold())
                
                Text("Esta guía te ayudará a mantener tu dignidad y valores en interacciones difíciles.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            // Situation
            VStack(alignment: .leading, spacing: 12) {
                Label("¿Cuál es la situación?", systemImage: "text.bubble")
                    .font(.headline)
                Text("Describe la interacción o decisión que enfrentas")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $plan.situation)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            // Values Identification
            VStack(alignment: .leading, spacing: 12) {
                Label("Identifica tus valores", systemImage: "star.circle")
                    .font(.headline)
                Text("¿Qué es importante para ti en esta situación?")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $plan.myValues)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            InfoBox(
                icon: "lightbulb.fill",
                text: "Ejemplos de valores: honestidad, respeto, autonomía, lealtad, justicia, compasión",
                color: .purple
            )
            
            // Common Values
            VStack(alignment: .leading, spacing: 12) {
                Text("Valores comunes:")
                    .font(.subheadline.bold())
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                    ForEach(commonValues, id: \.self) { value in
                        Button {
                            addValue(value)
                        } label: {
                            Text(value)
                                .font(.subheadline)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.purple.opacity(0.1))
                                .foregroundColor(.purple)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            Button {
                viewModel.updateFastPlan(plan)
                withAnimation {
                    currentTab = 1
                }
            } label: {
                Label("Continuar a Auto-evaluación", systemImage: "arrow.right")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(!plan.situation.isEmpty && !plan.myValues.isEmpty ? Color.purple : Color.gray.opacity(0.3))
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(plan.situation.isEmpty || plan.myValues.isEmpty)
        }
    }
    
    private var evaluationTab: some View {
        VStack(spacing: 16) {
            Text("Evalúa cada componente FAST")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Marca cada elemento que hayas aplicado o planeas aplicar")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            FastComponentCard(
                letter: "F",
                title: "Fair (Justo)",
                subtitle: "Sé justo/a contigo y con otros",
                tip: InterpersonalSkillType.fast.components[0],
                isChecked: $plan.fair,
                notes: $plan.fairNotes
            )
            
            FastComponentCard(
                letter: "A",
                title: "Apologies (Disculpas)",
                subtitle: "No te disculpes excesivamente",
                tip: InterpersonalSkillType.fast.components[1],
                isChecked: $plan.apologies,
                notes: $plan.apologiesNotes
            )
            
            FastComponentCard(
                letter: "S",
                title: "Stick to Values",
                subtitle: "Mantente fiel a tus valores",
                tip: InterpersonalSkillType.fast.components[2],
                isChecked: $plan.stickToValues,
                notes: $plan.stickToValuesNotes
            )
            
            FastComponentCard(
                letter: "T",
                title: "Truthful (Honesto)",
                subtitle: "Sé honesto/a sin exagerar",
                tip: InterpersonalSkillType.fast.components[3],
                isChecked: $plan.truthful,
                notes: $plan.truthfulNotes
            )
            
            // Progress
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "chart.bar.fill")
                        .foregroundColor(.purple)
                    Text("Progreso")
                        .font(.headline)
                    Spacer()
                    Text("\(completedCount)/4")
                        .font(.headline)
                        .foregroundColor(.purple)
                }
                
                ProgressView(value: Double(completedCount), total: 4.0)
                    .tint(.purple)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Button {
                viewModel.updateFastPlan(plan)
                withAnimation {
                    currentTab = 2
                }
            } label: {
                Label("Continuar a Reflexión", systemImage: "arrow.right")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
    }
    
    private var reflectionTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reflexión Final")
                .font(.title2.bold())
            
            Text("Revisa tu plan FAST antes de la interacción")
                .foregroundColor(.secondary)
            
            // Summary Cards
            VStack(spacing: 12) {
                SummaryCard(icon: "text.bubble", title: "Situación", content: plan.situation)
                SummaryCard(icon: "star.circle", title: "Mis Valores", content: plan.myValues)
            }
            
            Divider()
            
            Text("Componentes FAST aplicados:")
                .font(.headline)
            
            VStack(spacing: 8) {
                CheckmarkRow(isChecked: plan.fair, title: "Fair - Ser justo/a", note: plan.fairNotes)
                CheckmarkRow(isChecked: plan.apologies, title: "Apologies - No disculparse excesivamente", note: plan.apologiesNotes)
                CheckmarkRow(isChecked: plan.stickToValues, title: "Stick to Values - Mantener valores", note: plan.stickToValuesNotes)
                CheckmarkRow(isChecked: plan.truthful, title: "Truthful - Ser honesto/a", note: plan.truthfulNotes)
            }
            
            if isComplete {
                InfoBox(
                    icon: "checkmark.seal.fill",
                    text: "¡Excelente! Has completado tu plan FAST. Cuando hayas tenido la interacción, toca 'Completar' para reflexionar sobre el resultado.",
                    color: .green
                )
            } else {
                InfoBox(
                    icon: "exclamationmark.triangle.fill",
                    text: "Completa todos los componentes en la pestaña 'Auto-evaluación' antes de finalizar.",
                    color: .orange
                )
            }
            
            Button {
                viewModel.updateFastPlan(plan)
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
    }
    
    // MARK: - Helpers
    
    private var completedCount: Int {
        var count = 0
        if plan.fair { count += 1 }
        if plan.apologies { count += 1 }
        if plan.stickToValues { count += 1 }
        if plan.truthful { count += 1 }
        return count
    }
    
    private var isComplete: Bool {
        !plan.situation.isEmpty &&
        !plan.myValues.isEmpty &&
        plan.fair &&
        plan.apologies &&
        plan.stickToValues &&
        plan.truthful
    }
    
    private let commonValues = [
        "Honestidad", "Respeto", "Lealtad", "Justicia",
        "Compasión", "Autonomía", "Integridad", "Responsabilidad"
    ]
    
    private func addValue(_ value: String) {
        if plan.myValues.isEmpty {
            plan.myValues = value
        } else {
            plan.myValues += ", " + value
        }
    }
}

// MARK: - FAST Component Card

struct FastComponentCard: View {
    let letter: String
    let title: String
    let subtitle: String
    let tip: ComponentTip
    @Binding var isChecked: Bool
    @Binding var notes: String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Circle()
                        .fill(isChecked ? Color.purple : Color.gray.opacity(0.3))
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
                    InfoBox(icon: "lightbulb.fill", text: tip.tip, color: .purple)
                    
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
                    
                    Toggle(isOn: $isChecked) {
                        Text("He aplicado/aplicaré este componente")
                            .font(.subheadline)
                    }
                    .tint(.purple)
                    
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
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - Supporting Views

struct SummaryCard: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
            Text(content)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct CheckmarkRow: View {
    let isChecked: Bool
    let title: String
    let note: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isChecked ? .green : .gray)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                if !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
