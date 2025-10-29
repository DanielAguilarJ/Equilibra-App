//
//  MoodTrackingView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct MoodTrackingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: MoodTrackingViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    // Header
                    headerSection
                    
                    // Emotion Selection
                    emotionSelectionSection
                    
                    // Intensity Slider
                    intensitySection
                    
                    // Triggers
                    triggersSection
                    
                    // Coping Strategies
                    copingStrategiesSection
                    
                    // Notes
                    notesSection
                    
                    // Save Button
                    saveButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Registrar Estado Emocional")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.text.square.fill")
                .font(.system(size: 50))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan.opacity(0.7), .blue.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("¿Cómo te sientes en este momento?")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text("Registrar tus emociones te ayuda a identificar patrones")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue.opacity(0.05))
        )
    }
    
    // MARK: - Emotion Selection
    private var emotionSelectionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emoción Principal")
                .font(.headline)
                .foregroundStyle(.primary)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 16
            ) {
                ForEach(EmotionType.allCases, id: \.self) { emotion in
                    EmotionButton(
                        emotion: emotion,
                        isSelected: viewModel.selectedEmotion == emotion
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.selectedEmotion = emotion
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Intensity Section
    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Intensidad")
                    .font(.headline)
                
                Spacer()
                
                Text("\(viewModel.intensity)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(intensityColor)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(intensityColor.opacity(0.2))
                    )
            }
            
            VStack(spacing: 8) {
                Slider(
                    value: Binding(
                        get: { Double(viewModel.intensity) },
                        set: { viewModel.intensity = Int($0) }
                    ),
                    in: 1...10,
                    step: 1
                )
                .tint(intensityColor)
                
                HStack {
                    Text("Muy baja")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("Muy alta")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            // Visual intensity indicator
            HStack(spacing: 4) {
                ForEach(1...10, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(level <= viewModel.intensity ? intensityColor : Color.gray.opacity(0.2))
                        .frame(height: 8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Triggers Section
    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Desencadenantes")
                .font(.headline)
            
            Text("¿Qué causó esta emoción?")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            // Add trigger field
            HStack {
                TextField("Ej: Conversación difícil", text: $viewModel.currentTrigger)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.done)
                    .onSubmit {
                        viewModel.addTrigger()
                    }
                
                Button(action: viewModel.addTrigger) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .disabled(viewModel.currentTrigger.isEmpty)
            }
            
            // Triggers list
            if !viewModel.triggers.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(Array(viewModel.triggers.enumerated()), id: \.offset) { index, trigger in
                        HStack {
                            Image(systemName: "bolt.fill")
                                .foregroundStyle(.orange)
                                .font(.caption)
                            
                            Text(trigger)
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Button(action: { viewModel.removeTrigger(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.orange.opacity(0.1))
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Coping Strategies Section
    private var copingStrategiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Estrategias Utilizadas")
                .font(.headline)
            
            Text("¿Qué hiciste para manejar esta emoción?")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ForEach(MoodCopingStrategy.allCases, id: \.self) { strategy in
                    StrategyButton(
                        strategy: strategy,
                        isSelected: viewModel.selectedMoodCopingStrategies.contains(strategy)
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            viewModel.toggleStrategy(strategy)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notas Adicionales (Opcional)")
                .font(.headline)
            
            TextEditor(text: $viewModel.notes)
                .frame(minHeight: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button(action: {
            viewModel.saveMoodEntry()
            dismiss()
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Guardar Registro")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: viewModel.selectedEmotion != nil ?
                        [.cyan, .blue] : [.gray.opacity(0.5), .gray.opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundStyle(.white)
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(viewModel.selectedEmotion == nil)
        .padding(.horizontal)
    }
    
    // MARK: - Computed Properties
    private var intensityColor: Color {
        switch viewModel.intensity {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
}

// MARK: - Emotion Button
struct EmotionButton: View {
    let emotion: EmotionType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(emotion.emoji)
                    .font(.system(size: 40))
                
                Text(emotion.rawValue)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? emotionColor : Color(.systemGray6))
                    .shadow(color: isSelected ? emotionColor.opacity(0.4) : .clear, radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var emotionColor: Color {
        switch emotion.color {
        case "yellow": return .yellow
        case "blue": return .blue.opacity(0.7)
        case "red": return .red.opacity(0.7)
        case "purple": return .purple
        case "orange": return .orange
        case "gray": return .gray
        case "green": return .green
        case "pink": return .pink
        default: return .blue
        }
    }
}

// MARK: - Strategy Button
struct StrategyButton: View {
    let strategy: MoodCopingStrategy
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: strategy.icon)
                    .font(.caption)
                
                Text(strategy.rawValue)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.green.opacity(0.2) : Color(.systemGray6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
                    )
            )
            .foregroundStyle(isSelected ? .green : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MoodTrackingView(viewModel: MoodTrackingViewModel())
        .modelContainer(for: [MoodEntry.self])
}
