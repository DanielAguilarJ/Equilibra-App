//
//  AddEmotionalLogView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct AddEmotionalLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: EmotionalLogViewModel
    
    let commonEmotions = [
        "Felicidad", "Tristeza", "Ansiedad", "Miedo",
        "Ira", "Vergüenza", "Culpa", "Frustración",
        "Soledad", "Confusión"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("¿Qué emoción sientes?") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(commonEmotions, id: \.self) { emotion in
                                EmotionChip(
                                    emotion: emotion,
                                    isSelected: viewModel.selectedEmotion == emotion
                                ) {
                                    viewModel.selectedEmotion = emotion
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowInsets(EdgeInsets())
                    
                    TextField("O escribe otra emoción", text: $viewModel.selectedEmotion)
                }
                
                Section("Intensidad (1-10)") {
                    HStack {
                        Text("1")
                            .foregroundStyle(.secondary)
                        
                        Slider(
                            value: Binding(
                                get: { Double(viewModel.intensity) },
                                set: { viewModel.intensity = Int($0) }
                            ),
                            in: 1...10,
                            step: 1
                        )
                        
                        Text("10")
                            .foregroundStyle(.secondary)
                        
                        Text("\(viewModel.intensity)")
                            .fontWeight(.bold)
                            .frame(width: 30)
                    }
                }
                
                Section("Desencadenante (opcional)") {
                    TextField("¿Qué causó esta emoción?", text: $viewModel.trigger, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section("Notas (opcional)") {
                    TextField("¿Qué hiciste? ¿Funcionó?", text: $viewModel.notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("Registrar Emoción")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardar") {
                        viewModel.saveLog()
                        dismiss()
                    }
                    .disabled(viewModel.selectedEmotion.isEmpty)
                }
            }
        }
    }
}

struct EmotionChip: View {
    let emotion: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(emotion)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
                )
                .foregroundStyle(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddEmotionalLogView(viewModel: EmotionalLogViewModel())
}
