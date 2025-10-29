//
//  CheckTheFactsView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct CheckTheFactsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel = EmotionRegulationViewModel()
    @State private var currentStep = 0
    @State private var situation = ""
    @State private var emotionBefore = ""
    @State private var intensityBefore: Double = 5
    @State private var emotionAfter = ""
    @State private var intensityAfter: Double = 5
    @State private var wasHelpful: Bool? = nil
    @State private var showingCompletion = false
    
    private let totalSteps = 4
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress
                progressBar
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        if currentStep == 0 {
                            headerSection
                        }
                        
                        // Content based on step
                        stepContent
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                
                // Navigation buttons
                navigationButtons
            }
            .navigationTitle("Check the Facts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingCompletion) {
                CompletionView(
                    emotionBefore: emotionBefore,
                    intensityBefore: Int(intensityBefore),
                    intensityAfter: Int(intensityAfter),
                    wasHelpful: wasHelpful
                ) {
                    saveSession()
                }
            }
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Paso \(currentStep + 1) de \(totalSteps)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                .tint(.blue)
                .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue.gradient)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Check the Facts")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Evalúa objetivamente tus pensamientos")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Esta técnica te ayuda a separar los hechos de las interpretaciones y evaluar si tu emoción se ajusta a la realidad de la situación.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.blue.opacity(0.1))
        )
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            step1InitialEmotion
        case 1:
            step2DescribeSituation
        case 2:
            step3AnswerQuestions
        case 3:
            step4Review
        default:
            EmptyView()
        }
    }
    
    // MARK: - Step 1: Initial Emotion
    private var step1InitialEmotion: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Identifica tu emoción",
                icon: "face.dashed",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("¿Qué emoción estás sintiendo?")
                        .font(.headline)
                    
                    TextField("Ej: Ansiedad, tristeza, enojo", text: $emotionBefore)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("¿Qué tan intensa es esta emoción?")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Leve")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(intensityBefore))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(colorForIntensity(intensityBefore))
                            
                            Spacer()
                            
                            Text("Intensa")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Slider(value: $intensityBefore, in: 1...10, step: 1)
                            .tint(colorForIntensity(intensityBefore))
                    }
                    
                    Text("💡 Tip: Sé específico con la emoción. En lugar de \"me siento mal\", intenta \"me siento ansioso\" o \"me siento frustrado\".")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Step 2: Describe Situation
    private var step2DescribeSituation: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Describe la situación",
                icon: "text.alignleft",
                color: .blue
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("¿Qué sucedió exactamente?")
                        .font(.headline)
                    
                    Text("Describe solo los hechos observables, sin interpretaciones.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextEditor(text: $situation)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Diferencia entre hechos e interpretaciones:")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("Hecho: \"Mi amigo no respondió mi mensaje\"")
                                .font(.caption)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                            Text("Interpretación: \"Mi amigo me está ignorando\"")
                                .font(.caption)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Step 3: Answer Questions
    private var step3AnswerQuestions: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Preguntas Socráticas")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Responde estas preguntas para evaluar tu pensamiento:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            ForEach(Array(viewModel.checkFactsQuestions.enumerated()), id: \.element.id) { index, question in
                QuestionCard(
                    number: index + 1,
                    question: question.question,
                    answer: Binding(
                        get: { viewModel.checkFactsQuestions[index].answer },
                        set: { viewModel.checkFactsQuestions[index].answer = $0 }
                    )
                )
            }
        }
    }
    
    // MARK: - Step 4: Review
    private var step4Review: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Revisión y Conclusión",
                icon: "checkmark.circle.fill",
                color: .green
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Después de revisar los hechos:")
                        .font(.headline)
                    
                    Text("¿Tu emoción cambió?")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    TextField("Emoción actual (si cambió)", text: $emotionAfter)
                        .textFieldStyle(.roundedBorder)
                    
                    Text("Intensidad actual")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    VStack(spacing: 8) {
                        HStack {
                            Text("Leve")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text("\(Int(intensityAfter))")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(colorForIntensity(intensityAfter))
                            
                            Spacer()
                            
                            Text("Intensa")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Slider(value: $intensityAfter, in: 1...10, step: 1)
                            .tint(colorForIntensity(intensityAfter))
                    }
                    
                    if intensityAfter < intensityBefore {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                                .foregroundStyle(.green)
                            Text("Tu intensidad emocional disminuyó")
                                .font(.subheadline)
                                .foregroundStyle(.green)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Text("¿Te fue útil este ejercicio?")
                        .font(.subheadline)
                        .padding(.top, 8)
                    
                    HStack(spacing: 12) {
                        Button {
                            wasHelpful = true
                        } label: {
                            HStack {
                                Image(systemName: "hand.thumbsup.fill")
                                Text("Sí")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(wasHelpful == true ? Color.green : Color(.systemGray6))
                            .foregroundStyle(wasHelpful == true ? .white : .primary)
                            .cornerRadius(8)
                        }
                        
                        Button {
                            wasHelpful = false
                        } label: {
                            HStack {
                                Image(systemName: "hand.thumbsdown.fill")
                                Text("No")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(wasHelpful == false ? Color.orange : Color(.systemGray6))
                            .foregroundStyle(wasHelpful == false ? .white : .primary)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
    
    private var navigationButtons: some View {
        HStack(spacing: 12) {
            if currentStep > 0 {
                Button {
                    withAnimation {
                        currentStep -= 1
                    }
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Anterior")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .foregroundStyle(.primary)
                    .cornerRadius(12)
                }
            }
            
            Button {
                if currentStep < totalSteps - 1 {
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    showingCompletion = true
                }
            } label: {
                HStack {
                    Text(currentStep < totalSteps - 1 ? "Siguiente" : "Completar")
                    if currentStep < totalSteps - 1 {
                        Image(systemName: "chevron.right")
                    } else {
                        Image(systemName: "checkmark")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(canProceed ? Color.blue : Color(.systemGray5))
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .disabled(!canProceed)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0:
            return !emotionBefore.isEmpty
        case 1:
            return !situation.isEmpty
        case 2:
            return viewModel.checkFactsQuestions.filter { !$0.answer.isEmpty }.count >= 4
        case 3:
            return wasHelpful != nil
        default:
            return true
        }
    }
    
    private func colorForIntensity(_ intensity: Double) -> Color {
        switch intensity {
        case 1...3:
            return .green
        case 4...6:
            return .orange
        default:
            return .red
        }
    }
    
    private func saveSession() {
        let session = EmotionRegulationSession(
            toolType: .checkTheFacts,
            initialEmotion: emotionBefore,
            initialIntensity: Int(intensityBefore)
        )
        session.finalIntensity = Int(intensityAfter)
        session.notes = situation
        session.wasHelpful = wasHelpful
        session.completedSteps = viewModel.checkFactsQuestions.map { $0.question }
        
        modelContext.insert(session)
        dismiss()
    }
}

// MARK: - Supporting Views
struct StepCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
    }
}

struct QuestionCard: View {
    let number: Int
    let question: String
    @Binding var answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    Text("\(number)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(Circle().fill(.blue))
                    
                    Text(question)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .imageScale(.small)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                TextEditor(text: $answer)
                    .frame(height: 80)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4)
        )
        .animation(.spring(response: 0.3), value: isExpanded)
    }
}

struct CompletionView: View {
    @Environment(\.dismiss) private var dismiss
    let emotionBefore: String
    let intensityBefore: Int
    let intensityAfter: Int
    let wasHelpful: Bool?
    let onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.green.gradient)
                
                Text("¡Ejercicio Completado!")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Emoción:")
                        Spacer()
                        Text(emotionBefore)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Intensidad inicial:")
                        Spacer()
                        Text("\(intensityBefore)/10")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Intensidad final:")
                        Spacer()
                        Text("\(intensityAfter)/10")
                            .fontWeight(.medium)
                            .foregroundStyle(intensityAfter < intensityBefore ? .green : .primary)
                    }
                    
                    if intensityAfter < intensityBefore {
                        Text("Reducción: -\(intensityBefore - intensityAfter) puntos")
                            .font(.headline)
                            .foregroundStyle(.green)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                
                Spacer()
                
                Button {
                    onSave()
                    dismiss()
                } label: {
                    Text("Guardar y Cerrar")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                        )
                }
            }
            .padding()
            .navigationTitle("Resumen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CheckTheFactsView()
        .modelContainer(for: EmotionRegulationSession.self)
}
