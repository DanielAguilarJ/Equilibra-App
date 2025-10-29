//
//  GroundingExerciseView.swift
//  Equilibra - Herramientas DBT
//
//  Ejercicio de Grounding 5-4-3-2-1
//

import SwiftUI

struct GroundingExerciseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    @State private var completedSteps: Set<Int> = []
    
    let steps = [
        GroundingStep(number: 5, sense: "Vista", instruction: "Nombra 5 cosas que puedes VER a tu alrededor", icon: "eye.fill", color: .blue),
        GroundingStep(number: 4, sense: "Tacto", instruction: "Nombra 4 cosas que puedes TOCAR", icon: "hand.raised.fill", color: .green),
        GroundingStep(number: 3, sense: "Oído", instruction: "Nombra 3 cosas que puedes OÍR", icon: "ear.fill", color: .purple),
        GroundingStep(number: 2, sense: "Olfato", instruction: "Nombra 2 cosas que puedes OLER", icon: "nose.fill", color: .orange),
        GroundingStep(number: 1, sense: "Gusto", instruction: "Nombra 1 cosa que puedes SABOREAR", icon: "mouth.fill", color: .pink)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.green)
                    
                    Text("Grounding 5-4-3-2-1")
                        .font(.title2.bold())
                    
                    Text("Este ejercicio te ayuda a conectar con el momento presente usando tus sentidos.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                
                // Progress
                ProgressView(value: Double(completedSteps.count), total: Double(steps.count))
                    .tint(.green)
                    .padding(.horizontal)
                
                // Steps
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            GroundingStepCard(
                                step: step,
                                isCompleted: completedSteps.contains(index),
                                onComplete: {
                                    completedSteps.insert(index)
                                }
                            )
                        }
                    }
                    .padding()
                }
                
                // Complete button
                if completedSteps.count == steps.count {
                    Button {
                        dismiss()
                    } label: {
                        Text("Completar Ejercicio")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Grounding")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct GroundingStep {
    let number: Int
    let sense: String
    let instruction: String
    let icon: String
    let color: Color
}

struct GroundingStepCard: View {
    let step: GroundingStep
    let isCompleted: Bool
    let onComplete: () -> Void
    
    @State private var items: [String] = []
    @State private var currentItem = ""
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Circle()
                        .fill(isCompleted ? step.color : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: step.icon)
                                .foregroundStyle(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.sense)
                            .font(.headline)
                        Text("\(step.number) cosas")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title2)
                    } else {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text(step.instruction)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    // Items list
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(step.color)
                            Text(item)
                                .font(.body)
                        }
                    }
                    
                    // Add item
                    if items.count < step.number {
                        HStack {
                            TextField("Escribe algo que \(step.sense.lowercased())...", text: $currentItem)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                if !currentItem.isEmpty {
                                    items.append(currentItem)
                                    currentItem = ""
                                    
                                    if items.count == step.number {
                                        onComplete()
                                    }
                                }
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundStyle(step.color)
                                    .font(.title2)
                            }
                            .disabled(currentItem.isEmpty)
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCompleted ? step.color.opacity(0.1) : Color(.systemGray6))
        )
    }
}

#Preview {
    GroundingExerciseView()
}
