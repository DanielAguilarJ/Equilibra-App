//
//  CustomBreathingConfigView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct CustomBreathingConfigView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var inhaleDuration: Double = 4
    @State private var holdAfterInhale: Double = 4
    @State private var exhaleDuration: Double = 4
    @State private var holdAfterExhale: Double = 4
    @State private var totalCycles: Double = 5
    
    let onStart: (BreathingExercise) -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 50))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .yellow],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        Text("Respiración Personalizada")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Configura tu patrón ideal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Configuración de duraciones
                    VStack(spacing: 20) {
                        DurationSlider(
                            title: "Inhalar",
                            icon: "arrow.down.circle.fill",
                            color: .blue,
                            value: $inhaleDuration,
                            range: 2...10
                        )
                        
                        DurationSlider(
                            title: "Mantener (después de inhalar)",
                            icon: "pause.circle.fill",
                            color: .purple,
                            value: $holdAfterInhale,
                            range: 0...10
                        )
                        
                        DurationSlider(
                            title: "Exhalar",
                            icon: "arrow.up.circle.fill",
                            color: .green,
                            value: $exhaleDuration,
                            range: 2...10
                        )
                        
                        DurationSlider(
                            title: "Mantener (después de exhalar)",
                            icon: "pause.circle.fill",
                            color: .cyan,
                            value: $holdAfterExhale,
                            range: 0...10
                        )
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        DurationSlider(
                            title: "Ciclos totales",
                            icon: "repeat.circle.fill",
                            color: .orange,
                            value: $totalCycles,
                            range: 1...20,
                            isInteger: true
                        )
                    }
                    .padding(.horizontal)
                    
                    // Preview del ciclo
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Resumen del Ciclo")
                            .font(.headline)
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                SummaryRow(
                                    label: "Duración por ciclo",
                                    value: "\(cycleDuration) seg"
                                )
                                SummaryRow(
                                    label: "Duración total",
                                    value: "\(totalDuration) seg ≈ \(totalDuration / 60) min"
                                )
                                SummaryRow(
                                    label: "Ciclos",
                                    value: "\(Int(totalCycles))"
                                )
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Botón de inicio
                    Button {
                        startCustomExercise()
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
                                colors: [.orange, .yellow],
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
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var cycleDuration: Int {
        Int(inhaleDuration + holdAfterInhale + exhaleDuration + holdAfterExhale)
    }
    
    private var totalDuration: Int {
        cycleDuration * Int(totalCycles)
    }
    
    // MARK: - Methods
    
    private func startCustomExercise() {
        let exercise = BreathingExercise(
            techniqueType: .custom,
            inhaleDuration: Int(inhaleDuration),
            holdAfterInhaleDuration: Int(holdAfterInhale),
            exhaleDuration: Int(exhaleDuration),
            holdAfterExhaleDuration: Int(holdAfterExhale),
            totalCycles: Int(totalCycles)
        )
        
        dismiss()
        onStart(exercise)
    }
}

// MARK: - Duration Slider

struct DurationSlider: View {
    let title: String
    let icon: String
    let color: Color
    @Binding var value: Double
    let range: ClosedRange<Double>
    var isInteger: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(displayValue)
                    .font(.headline)
                    .foregroundColor(color)
                    .monospacedDigit()
            }
            
            Slider(value: $value, in: range, step: 1)
                .tint(color)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(12)
    }
    
    private var displayValue: String {
        if isInteger {
            return "\(Int(value))"
        } else {
            return "\(Int(value)) seg"
        }
    }
}

// MARK: - Summary Row

struct SummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

// MARK: - Preview

#Preview {
    CustomBreathingConfigView { exercise in
        print("Starting exercise: \(exercise.techniqueType)")
    }
}
