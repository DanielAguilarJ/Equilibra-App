//
//  OppositeActionView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct OppositeActionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel = EmotionRegulationViewModel()
    @State private var selectedEmotion: EmotionAction?
    @State private var currentEmotion = ""
    @State private var intensityBefore: Double = 5
    @State private var urgeDescription = ""
    @State private var selectedAction = ""
    @State private var actionPlan = ""
    @State private var intensityAfter: Double = 5
    @State private var wasHelpful: Bool? = nil
    @State private var showingCompletion = false
    @State private var currentStep = 0
    
    private let emotions = ["Tristeza", "Ansiedad/Miedo", "Ira/Enojo", "Vergüenza/Culpa", "Celos/Envidia"]
    
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
                        
                        // Step content
                        stepContent
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
                
                // Navigation
                navigationButtons
            }
            .navigationTitle("Opposite Action")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("¡Completado!", isPresented: $showingCompletion) {
                Button("Guardar") {
                    saveSession()
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Has completado el ejercicio de Opposite Action. ¿Deseas guardar tu progreso?")
            }
        }
    }
    
    private var progressBar: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Paso \(currentStep + 1) de 4")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            .padding(.horizontal)
            
            ProgressView(value: Double(currentStep + 1), total: 4)
                .tint(.purple)
                .padding(.horizontal)
        }
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                    .font(.title)
                    .foregroundStyle(.purple.gradient)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Opposite Action")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Cambia tu emoción actuando de forma opuesta")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Cuando tu emoción no se ajusta a los hechos o no es efectiva, actuar de manera opuesta a tu impulso puede cambiar la emoción.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.purple.opacity(0.1))
        )
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            step1IdentifyEmotion
        case 1:
            step2IdentifyUrge
        case 2:
            step3ChooseOppositeAction
        case 3:
            step4Review
        default:
            EmptyView()
        }
    }
    
    // MARK: - Step 1: Identify Emotion
    private var step1IdentifyEmotion: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Identifica tu emoción",
                icon: "face.dashed",
                color: .purple
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("¿Qué emoción estás sintiendo?")
                        .font(.headline)
                    
                    VStack(spacing: 8) {
                        ForEach(emotions, id: \.self) { emotion in
                            Button {
                                currentEmotion = emotion
                                selectedEmotion = viewModel.getOppositeActions().first { $0.emotion == emotion }
                            } label: {
                                HStack {
                                    Text(emotion)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    if currentEmotion == emotion {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.purple)
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(currentEmotion == emotion ? Color.purple.opacity(0.1) : Color(.systemGray6))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    if !currentEmotion.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Intensidad de la emoción")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
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
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
    
    // MARK: - Step 2: Identify Urge
    private var step2IdentifyUrge: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Identifica tu impulso",
                icon: "bolt.fill",
                color: .purple
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    if let emotion = selectedEmotion {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Impulso típico para \(emotion.emotion):")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            Text(emotion.typicalUrge)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.orange.opacity(0.1))
                                )
                        }
                    }
                    
                    Text("¿Qué tienes ganas de hacer ahora?")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text("Describe tu impulso actual")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextEditor(text: $urgeDescription)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Text("💡 Tip: Sé honesto sobre lo que realmente quieres hacer, incluso si sabes que no es la mejor opción.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Step 3: Choose Opposite Action
    private var step3ChooseOppositeAction: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Elige una acción opuesta",
                icon: "arrow.triangle.2.circlepath",
                color: .purple
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    if let emotion = selectedEmotion {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundStyle(.yellow)
                                
                                Text("Acción opuesta recomendada:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            Text(emotion.oppositeAction)
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.green.opacity(0.1))
                                )
                            
                            Text("Ejemplos específicos:")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.top, 8)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(emotion.examples.enumerated()), id: \.offset) { index, example in
                                    HStack(alignment: .top, spacing: 8) {
                                        Text("\(index + 1).")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        
                                        Text(example)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    Text("Tu plan de acción:")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text("¿Qué acción específica vas a realizar?")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextEditor(text: $actionPlan)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("⚡ Importante:")
                            .font(.caption)
                            .fontWeight(.bold)
                        
                        Text("Para que Opposite Action funcione, debes actuar COMPLETAMENTE de forma opuesta. Hazlo con toda tu energía y compromiso.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    // MARK: - Step 4: Review
    private var step4Review: some View {
        VStack(alignment: .leading, spacing: 20) {
            StepCard(
                title: "Revisión",
                icon: "checkmark.circle.fill",
                color: .green
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Después de realizar la acción opuesta:")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Intensidad emocional actual")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
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
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // Comparison
                    HStack(spacing: 20) {
                        VStack {
                            Text("Antes")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(Int(intensityBefore))")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(12)
                        
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary)
                        
                        VStack {
                            Text("Después")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text("\(Int(intensityAfter))")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    if intensityAfter < intensityBefore {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                            Text("¡Tu emoción disminuyó en \(Int(intensityBefore - intensityAfter)) puntos!")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    Text("¿Te ayudó este ejercicio?")
                        .font(.headline)
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
                            .cornerRadius(12)
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
                            .cornerRadius(12)
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
                if currentStep < 3 {
                    withAnimation {
                        currentStep += 1
                    }
                } else {
                    showingCompletion = true
                }
            } label: {
                HStack {
                    Text(currentStep < 3 ? "Siguiente" : "Completar")
                    if currentStep < 3 {
                        Image(systemName: "chevron.right")
                    } else {
                        Image(systemName: "checkmark")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(canProceed ? AnyShapeStyle(Color.purple.gradient) : AnyShapeStyle(Color(.systemGray5)))
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
            return !currentEmotion.isEmpty
        case 1:
            return !urgeDescription.isEmpty
        case 2:
            return !actionPlan.isEmpty
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
            toolType: .oppositeAction,
            initialEmotion: currentEmotion,
            initialIntensity: Int(intensityBefore)
        )
        session.finalIntensity = Int(intensityAfter)
        session.notes = "Impulso: \(urgeDescription)\nPlan: \(actionPlan)"
        session.wasHelpful = wasHelpful
        session.completedSteps = ["Identificar emoción", "Identificar impulso", "Elegir acción opuesta", "Revisar resultados"]
        
        modelContext.insert(session)
        dismiss()
    }
}

#Preview {
    OppositeActionView()
        .modelContainer(for: EmotionRegulationSession.self)
}
