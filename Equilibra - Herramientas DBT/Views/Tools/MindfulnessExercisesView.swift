//
//  MindfulnessExercisesView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct MindfulnessExercisesView: View {
    @StateObject private var viewModel = MindfulnessViewModel()
    @State private var selectedExercise: MindfulnessExercise?
    @State private var showExerciseDetail = false
    
    var body: some View {
        ZStack {
            // Fondo gradiente
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.1),
                    Color.blue.opacity(0.1),
                    Color.pink.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isMeditating, let exercise = selectedExercise {
                ActiveMindfulnessView(
                    viewModel: viewModel,
                    exercise: exercise
                )
            } else {
                exerciseListView
            }
        }
        .navigationTitle("Mindfulness")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Exercise List View
    
    private var exerciseListView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, .pink],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Práctica de Mindfulness")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Cultiva la atención plena y la consciencia del presente")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)
                
                // Ejercicios
                VStack(spacing: 16) {
                    ForEach(MindfulnessExerciseType.allCases, id: \.self) { type in
                        MindfulnessExerciseCard(
                            type: type,
                            onSelect: {
                                selectedExercise = MindfulnessExercise(exerciseType: type)
                                showExerciseDetail = true
                            }
                        )
                    }
                }
                .padding(.horizontal)
                
                // Principios de Mindfulness
                VStack(alignment: .leading, spacing: 16) {
                    Text("Principios de Mindfulness DBT")
                        .font(.headline)
                    
                    MindfulnessPrincipleCard(
                        title: "Observar",
                        description: "Nota las experiencias sin reaccionar",
                        icon: "eye.fill",
                        color: .blue
                    )
                    
                    MindfulnessPrincipleCard(
                        title: "Describir",
                        description: "Pon palabras a tu experiencia",
                        icon: "text.bubble.fill",
                        color: .green
                    )
                    
                    MindfulnessPrincipleCard(
                        title: "Participar",
                        description: "Sumérgete completamente en el momento",
                        icon: "figure.wave",
                        color: .purple
                    )
                    
                    MindfulnessPrincipleCard(
                        title: "No Juzgar",
                        description: "Observa sin etiquetar como bueno o malo",
                        icon: "scale.3d",
                        color: .orange
                    )
                    
                    MindfulnessPrincipleCard(
                        title: "Una Cosa a la Vez",
                        description: "Enfoca tu atención en el presente",
                        icon: "circle.fill",
                        color: .cyan
                    )
                    
                    MindfulnessPrincipleCard(
                        title: "Efectividad",
                        description: "Haz lo que funciona en este momento",
                        icon: "checkmark.circle.fill",
                        color: .pink
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showExerciseDetail) {
            if let exercise = selectedExercise {
                MindfulnessExerciseDetailView(
                    exercise: exercise,
                    onStart: {
                        showExerciseDetail = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            viewModel.startMindfulness(exercise: exercise)
                        }
                    }
                )
            }
        }
    }
}

// MARK: - Mindfulness Exercise Card

struct MindfulnessExerciseCard: View {
    let type: MindfulnessExerciseType
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: type.icon)
                        .font(.system(size: 28))
                        .foregroundColor(cardColor)
                        .frame(width: 50, height: 50)
                        .background(cardColor.opacity(0.2))
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(type.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                            Text("\(type.recommendedDuration) min")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                
                Text(type.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(16)
        }
    }
    
    private var cardColor: Color {
        switch type {
        case .bodyScan:
            return .purple
        case .emotionObservation:
            return .blue
        case .fiveSenses:
            return .green
        case .lovingKindness:
            return .pink
        }
    }
}

// MARK: - Mindfulness Principle Card

struct MindfulnessPrincipleCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.15))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.secondaryBackground.opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Active Mindfulness View

struct ActiveMindfulnessView: View {
    @ObservedObject var viewModel: MindfulnessViewModel
    let exercise: MindfulnessExercise
    
    var body: some View {
        VStack(spacing: 0) {
            // Header con timer
            VStack(spacing: 16) {
                Text(exercise.exerciseType.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Timer circular
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.meditationProgress)
                        .stroke(
                            LinearGradient(
                                colors: [exerciseColor, exerciseColor.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear, value: viewModel.meditationProgress)
                    
                    VStack(spacing: 4) {
                        Text(timeString)
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .monospacedDigit()
                        
                        Text("restante")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 20)
            }
            .padding(.top, 40)
            
            // Instrucciones
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.currentInstructionIndex < exercise.instructions.count {
                        VStack(spacing: 16) {
                            Text("Paso \(viewModel.currentInstructionIndex + 1) de \(exercise.instructions.count)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text(exercise.instructions[viewModel.currentInstructionIndex])
                                .font(.title3)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .transition(.opacity.combined(with: .scale))
                        }
                        .padding()
                        .background(exerciseColor.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    
                    // Navegación de instrucciones
                    HStack(spacing: 20) {
                        Button {
                            viewModel.previousInstruction()
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(viewModel.currentInstructionIndex > 0 ? exerciseColor : .gray)
                        }
                        .disabled(viewModel.currentInstructionIndex == 0)
                        
                        Button {
                            viewModel.nextInstruction()
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(
                                    viewModel.currentInstructionIndex < exercise.instructions.count - 1
                                    ? exerciseColor
                                    : .gray
                                )
                        }
                        .disabled(viewModel.currentInstructionIndex >= exercise.instructions.count - 1)
                    }
                    .padding()
                }
            }
            
            Spacer()
            
            // Botón de finalizar
            Button {
                viewModel.stopMindfulness()
            } label: {
                HStack {
                    Image(systemName: "stop.fill")
                    Text("Finalizar Sesión")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
    
    private var exerciseColor: Color {
        switch exercise.exerciseType {
        case .bodyScan:
            return .purple
        case .emotionObservation:
            return .blue
        case .fiveSenses:
            return .green
        case .lovingKindness:
            return .pink
        }
    }
    
    private var timeString: String {
        let minutes = viewModel.meditationTimeRemaining / 60
        let seconds = viewModel.meditationTimeRemaining % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        MindfulnessExercisesView()
    }
}
