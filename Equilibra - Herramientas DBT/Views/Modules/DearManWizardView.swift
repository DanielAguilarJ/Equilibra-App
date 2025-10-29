//
//  DearManWizardView.swift
//  Equilibra - Herramientas DBT
//
//  Wizard interactivo paso a paso para DEAR MAN
//

import SwiftUI
import Combine

struct DearManWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: InterpersonalSkillsViewModel
    @Bindable var plan: DearManPlan
    
    @State private var currentStep = 0
    private let totalSteps = 9 // Situación + 7 componentes + Revisión
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: Double(currentStep), total: Double(totalSteps - 1))
                    .tint(Color.blue)
                    .padding()
                
                // Step Content
                ScrollView {
                    VStack(spacing: 20) {
                        stepContent
                            .padding()
                    }
                }
                
                // Navigation Buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button {
                            withAnimation {
                                currentStep -= 1
                            }
                        } label: {
                            Label("Anterior", systemImage: "chevron.left")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.primary)
                                .cornerRadius(12)
                        }
                    }
                    
                    Button {
                        handleNextStep()
                    } label: {
                        Label(
                            currentStep == totalSteps - 1 ? "Guardar Plan" : "Siguiente",
                            systemImage: currentStep == totalSteps - 1 ? "checkmark" : "chevron.right"
                        )
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(canProceed ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(!canProceed)
                }
                .padding()
            }
            .navigationTitle("DEAR MAN Wizard")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            setupStep
        case 1:
            describeStep
        case 2:
            expressStep
        case 3:
            assertStep
        case 4:
            reinforceStep
        case 5:
            mindfulStep
        case 6:
            appearConfidentStep
        case 7:
            negotiateStep
        case 8:
            reviewStep
        default:
            EmptyView()
        }
    }
    
    // MARK: - Steps
    
    private var setupStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "target")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
                .frame(maxWidth: .infinity)
            
            Text("Define tu Objetivo")
                .font(.title2.bold())
            
            Text("Antes de comenzar, identifiquemos claramente tu situación y lo que quieres lograr.")
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("¿Cuál es la situación?")
                    .font(.headline)
                TextEditor(text: $plan.situation)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Text("¿Qué objetivo específico quieres lograr?")
                    .font(.headline)
                TextEditor(text: $plan.goal)
                    .frame(height: 100)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            InfoBox(
                icon: "lightbulb.fill",
                text: "Ejemplo: Situación: 'Mi compañero de cuarto deja la cocina sucia'. Objetivo: 'Que respete nuestra rutina de limpieza'",
                color: .blue
            )
        }
    }
    
    private var describeStep: some View {
        ComponentStepView(
            letter: "D",
            title: "Describe",
            subtitle: "Describe solo los hechos",
            tip: InterpersonalSkillType.dearMan.components[0],
            text: $plan.describe,
            placeholder: "Escribe una descripción objetiva de la situación..."
        )
    }
    
    private var expressStep: some View {
        ComponentStepView(
            letter: "E",
            title: "Express",
            subtitle: "Expresa tus sentimientos",
            tip: InterpersonalSkillType.dearMan.components[1],
            text: $plan.express,
            placeholder: "Describe cómo te hace sentir esta situación..."
        )
    }
    
    private var assertStep: some View {
        ComponentStepView(
            letter: "A",
            title: "Assert",
            subtitle: "Afirma lo que quieres",
            tip: InterpersonalSkillType.dearMan.components[2],
            text: $plan.assert,
            placeholder: "¿Qué es específicamente lo que pides?"
        )
    }
    
    private var reinforceStep: some View {
        ComponentStepView(
            letter: "R",
            title: "Reinforce",
            subtitle: "Refuerza las consecuencias positivas",
            tip: InterpersonalSkillType.dearMan.components[3],
            text: $plan.reinforce,
            placeholder: "¿Qué beneficios traerá esto?"
        )
    }
    
    private var mindfulStep: some View {
        ComponentStepView(
            letter: "M",
            title: "Mindful",
            subtitle: "Mantén el foco",
            tip: InterpersonalSkillType.dearMan.components[4],
            text: $plan.mindful,
            placeholder: "¿Cómo mantendrás el foco si hay distracciones?"
        )
    }
    
    private var appearConfidentStep: some View {
        ComponentStepView(
            letter: "A",
            title: "Appear Confident",
            subtitle: "Aparenta confianza",
            tip: InterpersonalSkillType.dearMan.components[5],
            text: $plan.appearConfident,
            placeholder: "¿Qué harás para proyectar confianza?"
        )
    }
    
    private var negotiateStep: some View {
        ComponentStepView(
            letter: "N",
            title: "Negotiate",
            subtitle: "Negocia si es necesario",
            tip: InterpersonalSkillType.dearMan.components[6],
            text: $plan.negotiate,
            placeholder: "¿Qué alternativas o compromisos puedes ofrecer?"
        )
    }
    
    private var reviewStep: some View {
        VStack(alignment: .leading, spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 60))
                .foregroundStyle(.green)
                .frame(maxWidth: .infinity)
            
            Text("Revisa tu Plan")
                .font(.title2.bold())
            
            Text("Aquí está tu plan DEAR MAN completo. Revísalo antes de tu conversación.")
                .foregroundColor(.secondary)
            
            ReviewCard(title: "Situación", content: plan.situation)
            ReviewCard(title: "Objetivo", content: plan.goal)
            
            Divider()
            
            VStack(spacing: 12) {
                ReviewCard(title: "Describe", content: plan.describe, icon: "D")
                ReviewCard(title: "Express", content: plan.express, icon: "E")
                ReviewCard(title: "Assert", content: plan.assert, icon: "A")
                ReviewCard(title: "Reinforce", content: plan.reinforce, icon: "R")
                ReviewCard(title: "Mindful", content: plan.mindful, icon: "M")
                ReviewCard(title: "Appear Confident", content: plan.appearConfident, icon: "A")
                ReviewCard(title: "Negotiate", content: plan.negotiate, icon: "N")
            }
        }
    }
    
    // MARK: - Validation
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !plan.situation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                   !plan.goal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 1:
            return !plan.describe.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2:
            return !plan.express.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 3:
            return !plan.assert.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 4:
            return !plan.reinforce.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 5:
            return !plan.mindful.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 6:
            return !plan.appearConfident.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 7:
            return !plan.negotiate.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 8:
            return true
        default:
            return false
        }
    }
    
    private func handleNextStep() {
        if currentStep == totalSteps - 1 {
            // Save and dismiss
            viewModel.updateDearManPlan(plan)
            dismiss()
        } else {
            withAnimation {
                currentStep += 1
            }
        }
    }
}

// MARK: - Component Step View

struct ComponentStepView: View {
    let letter: String
    let title: String
    let subtitle: String
    let tip: ComponentTip
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 60, height: 60)
                    .overlay(
                        Text(letter)
                            .font(.title.bold())
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title2.bold())
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            InfoBox(icon: "lightbulb.fill", text: tip.tip, color: .blue)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("Ejemplo correcto:")
                        .font(.subheadline.bold())
                }
                Text(tip.example)
                    .font(.subheadline)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
            }
            
            if let warning = tip.warning {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                        Text("Evita:")
                            .font(.subheadline.bold())
                    }
                    Text(warning)
                        .font(.subheadline)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Tu respuesta:")
                    .font(.headline)
                TextEditor(text: $text)
                    .frame(height: 120)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if text.isEmpty {
                                Text(placeholder)
                                    .foregroundColor(.secondary)
                                    .padding(.leading, 12)
                                    .padding(.top, 16)
                                    .allowsHitTesting(false)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }
                    )
            }
        }
    }
}

// MARK: - Review Card

struct ReviewCard: View {
    let title: String
    let content: String
    var icon: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let icon = icon {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Text(icon)
                                .font(.caption.bold())
                                .foregroundColor(.blue)
                        )
                }
                Text(title)
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
            }
            Text(content)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
