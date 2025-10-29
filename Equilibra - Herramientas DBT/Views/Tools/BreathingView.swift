//
//  BreathingView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct BreathingView: View {
    @StateObject private var viewModel = MindfulnessViewModel()
    @State private var selectedExercise: BreathingExercise?
    @State private var showCustomConfig = false
    
    var body: some View {
        ZStack {
            // Fondo gradiente calmante
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.1),
                    Color.purple.opacity(0.1),
                    Color.cyan.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isBreathing {
                activeBreathingView
            } else {
                exerciseSelectionView
            }
        }
        .navigationTitle("Ejercicios de Respiración")
        .navigationBarTitleDisplayMode(.large)
    }
    
    // MARK: - Exercise Selection View
    
    private var exerciseSelectionView: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 12) {
                    Image(systemName: "wind")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text("Respiración Consciente")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Selecciona una técnica para comenzar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                
                // Ejercicios predefinidos
                VStack(spacing: 16) {
                    ForEach(BreathingTechniqueType.allCases.filter { $0 != .custom }, id: \.self) { type in
                        BreathingExerciseCard(
                            type: type,
                            onSelect: {
                                selectedExercise = BreathingExercise(techniqueType: type)
                                viewModel.startBreathing(exercise: selectedExercise!)
                            }
                        )
                    }
                    
                    // Botón de ejercicio personalizado
                    Button {
                        showCustomConfig = true
                    } label: {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Personalizado")
                                    .font(.headline)
                                Text("Crea tu propio patrón")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color.secondaryBackground)
                        .cornerRadius(16)
                    }
                    .foregroundColor(.primary)
                }
                .padding(.horizontal)
                
                // Información
                InfoBox(
                    icon: "info.circle.fill",
                    text: "Beneficios de la Respiración Consciente: Reduce el estrés y la ansiedad, Mejora la concentración, Regula el sistema nervioso, Ayuda a dormir mejor, Aumenta la consciencia del presente",
                    color: .blue
                )
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showCustomConfig) {
            CustomBreathingConfigView { exercise in
                selectedExercise = exercise
                viewModel.startBreathing(exercise: exercise)
            }
        }
    }
    
    // MARK: - Active Breathing View
    
    private var activeBreathingView: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Contador de ciclos
            VStack(spacing: 8) {
                Text("Ciclo \(viewModel.cyclesCompleted + 1) de \(selectedExercise?.totalCycles ?? 0)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(selectedExercise?.techniqueType.displayName ?? "")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            // Círculo de respiración animado
            ZStack {
                // Círculo de fondo
                Circle()
                    .fill(
                        LinearGradient(
                            colors: phaseColors.map { $0.opacity(0.1) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 300, height: 300)
                
                // Círculo animado
                Circle()
                    .fill(
                        LinearGradient(
                            colors: phaseColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: animatedSize, height: animatedSize)
                    .shadow(color: phaseColors.first?.opacity(0.5) ?? .clear, radius: 20)
                    .animation(.easeInOut(duration: 1.0), value: animatedSize)
                
                // Anillo de progreso
                Circle()
                    .stroke(
                        Color.white.opacity(0.3),
                        lineWidth: 4
                    )
                    .frame(width: 310, height: 310)
                
                // Contador en el centro
                VStack(spacing: 8) {
                    Text("\(viewModel.timeRemaining)")
                        .font(.system(size: 60, weight: .bold, design: .rounded))
                    
                    Text(viewModel.currentPhase.instruction)
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
            }
            
            // Barra de progreso del ciclo
            ProgressView(value: Double(viewModel.cyclesCompleted), total: Double(selectedExercise?.totalCycles ?? 1))
                .tint(phaseColors.first)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Botón para detener
            Button {
                viewModel.stopBreathing()
            } label: {
                HStack {
                    Image(systemName: "stop.fill")
                    Text("Detener")
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
    
    // MARK: - Computed Properties
    
    private var animatedSize: CGFloat {
        switch viewModel.currentPhase {
        case .inhale:
            return 100 + (200 * viewModel.progress)
        case .holdAfterInhale:
            return 300
        case .exhale:
            return 100 + (200 * viewModel.progress)
        case .holdAfterExhale:
            return 100
        }
    }
    
    private var phaseColors: [Color] {
        switch viewModel.currentPhase {
        case .inhale:
            return [.blue, .cyan]
        case .holdAfterInhale:
            return [.purple, .pink]
        case .exhale:
            return [.green, .mint]
        case .holdAfterExhale:
            return [.cyan, .blue]
        }
    }
}

// MARK: - Breathing Exercise Card

struct BreathingExerciseCard: View {
    let type: BreathingTechniqueType
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                // Icono
                Image(systemName: type.icon)
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .background(gradientColors.first?.opacity(0.1))
                    .cornerRadius(12)
                
                // Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(type.displayName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(type.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.secondaryBackground)
            .cornerRadius(16)
        }
    }
    
    private var gradientColors: [Color] {
        switch type {
        case .boxBreathing:
            return [.blue, .cyan]
        case .breathing478:
            return [.purple, .pink]
        case .diaphragmatic:
            return [.green, .mint]
        case .custom:
            return [.orange, .yellow]
        }
    }
}

// MARK: - Info Box

struct InfoBox: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        BreathingView()
    }
}
