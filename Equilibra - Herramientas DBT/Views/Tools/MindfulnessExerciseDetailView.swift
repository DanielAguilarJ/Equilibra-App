//
//  MindfulnessExerciseDetailView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct MindfulnessExerciseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: MindfulnessExercise
    let onStart: () -> Void
    
    @State private var customDuration: Double
    
    init(exercise: MindfulnessExercise, onStart: @escaping () -> Void) {
        self.exercise = exercise
        self.onStart = onStart
        _customDuration = State(initialValue: Double(exercise.duration))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: exercise.exerciseType.icon)
                            .font(.system(size: 70))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: gradientColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text(exercise.exerciseType.displayName)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(exercise.exerciseType.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // Duración
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(gradientColors.first)
                            Text("Duración de la sesión")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(Int(customDuration)) min")
                                .font(.headline)
                                .foregroundColor(gradientColors.first)
                        }
                        
                        Slider(value: $customDuration, in: 1...30, step: 1)
                            .tint(gradientColors.first)
                    }
                    .padding()
                    .background(Color.secondaryBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Instrucciones
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard.fill")
                                .foregroundColor(gradientColors.first)
                            Text("Pasos del Ejercicio")
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(Array(exercise.instructions.enumerated()), id: \.offset) { index, instruction in
                                HStack(alignment: .top, spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(gradientColors.first?.opacity(0.2) ?? .clear)
                                            .frame(width: 28, height: 28)
                                        
                                        Text("\(index + 1)")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(gradientColors.first)
                                    }
                                    
                                    Text(instruction)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .background(Color.secondaryBackground)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Estadísticas si existe
                    if exercise.practiceCount > 0 {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(gradientColors.first)
                                Text("Tu Práctica")
                                    .font(.headline)
                            }
                            
                            HStack(spacing: 20) {
                                MindfulnessStatBox(
                                    value: "\(exercise.practiceCount)",
                                    label: "Sesiones",
                                    color: gradientColors.first ?? .purple
                                )
                                
                                MindfulnessStatBox(
                                    value: "\(exercise.completedSessions)",
                                    label: "Completadas",
                                    color: .green
                                )
                                
                                if let lastDate = exercise.lastPracticedDate {
                                    MindfulnessStatBox(
                                        value: lastDate.formatted(.relative(presentation: .named)),
                                        label: "Última vez",
                                        color: .blue
                                    )
                                }
                            }
                        }
                        .padding()
                        .background(gradientColors.first?.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    // Beneficios
                    BenefitsSection(exerciseType: exercise.exerciseType)
                        .padding(.horizontal)
                    
                    // Botón de inicio
                    Button {
                        exercise.duration = Int(customDuration)
                        onStart()
                    } label: {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Comenzar Ejercicio")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
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
    
    private var gradientColors: [Color] {
        switch exercise.exerciseType {
        case .bodyScan:
            return [.purple, .pink]
        case .emotionObservation:
            return [.blue, .cyan]
        case .fiveSenses:
            return [.green, .mint]
        case .lovingKindness:
            return [.pink, .orange]
        }
    }
}

// MARK: - Stat Box

private struct MindfulnessStatBox: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(10)
    }
}

// MARK: - Benefits Section

struct BenefitsSection: View {
    let exerciseType: MindfulnessExerciseType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.pink)
                Text("Beneficios")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(benefits, id: \.self) { benefit in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                        
                        Text(benefit)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.05))
        .cornerRadius(12)
    }
    
    private var benefits: [String] {
        switch exerciseType {
        case .bodyScan:
            return [
                "Reduce la tensión muscular",
                "Aumenta la consciencia corporal",
                "Mejora la relajación profunda",
                "Ayuda a identificar estrés físico",
                "Promueve el sueño reparador"
            ]
            
        case .emotionObservation:
            return [
                "Desarrolla inteligencia emocional",
                "Reduce la reactividad emocional",
                "Aumenta la aceptación de emociones",
                "Mejora la regulación emocional",
                "Cultiva la auto-compasión"
            ]
            
        case .fiveSenses:
            return [
                "Ancla rápidamente al presente",
                "Reduce ansiedad y pánico",
                "Interrumpe pensamientos rumiativos",
                "Aumenta la consciencia sensorial",
                "Técnica portable y discreta"
            ]
            
        case .lovingKindness:
            return [
                "Aumenta sentimientos de conexión",
                "Reduce autocrítica y juicio",
                "Mejora la compasión por otros",
                "Incrementa emociones positivas",
                "Fortalece la resiliencia emocional"
            ]
        }
    }
}

// MARK: - Preview

#Preview {
    MindfulnessExerciseDetailView(
        exercise: MindfulnessExercise(exerciseType: .bodyScan),
        onStart: {
            print("Starting exercise")
        }
    )
}
