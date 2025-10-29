//
//  TIPPTechniqueView.swift
//  Equilibra - Herramientas DBT
//
//  Técnica TIPP para reducir rápidamente la activación emocional
//

import SwiftUI

struct TIPPTechniqueView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var completedSteps: Set<TIPPStep> = []
    
    enum TIPPStep: String, CaseIterable {
        case temperature = "Temperature"
        case intense = "Intense Exercise"
        case paced = "Paced Breathing"
        case progressive = "Progressive Relaxation"
        
        var title: String { rawValue }
        
        var description: String {
            switch self {
            case .temperature:
                return "Cambia tu temperatura corporal"
            case .intense:
                return "Ejercicio intenso breve"
            case .paced:
                return "Respiración controlada"
            case .progressive:
                return "Relajación muscular"
            }
        }
        
        var icon: String {
            switch self {
            case .temperature: return "thermometer"
            case .intense: return "figure.run"
            case .paced: return "wind"
            case .progressive: return "hand.raised.slash.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .temperature: return .cyan
            case .intense: return .orange
            case .paced: return .blue
            case .progressive: return .purple
            }
        }
        
        var instructions: [String] {
            switch self {
            case .temperature:
                return [
                    "Sumerge tu cara en agua fría (o usa una bolsa de hielo)",
                    "Mantén por 30 segundos",
                    "Esto activa el reflejo de buceo y calma el sistema nervioso",
                    "Alternativa: Toma una ducha fría o sostén hielo en tus manos"
                ]
            case .intense:
                return [
                    "Haz ejercicio intenso por 5-10 minutos",
                    "Opciones: saltar, correr en el lugar, flexiones, burpees",
                    "Esto quema la adrenalina acumulada",
                    "Para hasta sentir que tu ritmo cardíaco aumenta"
                ]
            case .paced:
                return [
                    "Respira lentamente: Inhala por 4 segundos",
                    "Sostén por 1-2 segundos",
                    "Exhala por 6 segundos",
                    "Repite por 3-5 minutos o hasta sentirte más calmado/a"
                ]
            case .progressive:
                return [
                    "Tensa grupos musculares por 5 segundos, luego relaja",
                    "Comienza con los pies y sube por el cuerpo",
                    "Nota la diferencia entre tensión y relajación",
                    "Esto libera la tensión física acumulada"
                ]
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "bolt.heart.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.cyan)
                        
                        Text("Técnica TIPP")
                            .font(.title2.bold())
                        
                        Text("Reduce rápidamente la intensidad emocional cuando estés muy activado/a.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    // Progress
                    VStack(spacing: 8) {
                        HStack {
                            Text("Progreso")
                                .font(.headline)
                            Spacer()
                            Text("\(completedSteps.count)/\(TIPPStep.allCases.count)")
                                .font(.headline)
                                .foregroundStyle(.cyan)
                        }
                        
                        ProgressView(value: Double(completedSteps.count), total: Double(TIPPStep.allCases.count))
                            .tint(.cyan)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // TIPP Steps
                    VStack(spacing: 16) {
                        ForEach(TIPPStep.allCases, id: \.self) { step in
                            TIPPStepCard(
                                step: step,
                                isCompleted: completedSteps.contains(step),
                                onComplete: {
                                    completedSteps.insert(step)
                                },
                                onUncomplete: {
                                    completedSteps.remove(step)
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Complete button
                    if completedSteps.count == TIPPStep.allCases.count {
                        VStack(spacing: 12) {
                            Text("¡Excelente trabajo!")
                                .font(.headline)
                            
                            Text("Has completado todos los pasos de TIPP. ¿Cómo te sientes ahora?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                            
                            Button {
                                dismiss()
                            } label: {
                                Text("Terminar")
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.cyan)
                                    .foregroundStyle(.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.bottom)
            }
            .navigationTitle("TIPP")
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

struct TIPPStepCard: View {
    let step: TIPPTechniqueView.TIPPStep
    let isCompleted: Bool
    let onComplete: () -> Void
    let onUncomplete: () -> Void
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Circle()
                        .fill(isCompleted ? step.color : Color.gray.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Image(systemName: step.icon)
                                .font(.title3)
                                .foregroundStyle(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.headline)
                        Text(step.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.title2)
                    }
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                    
                    Text("Instrucciones:")
                        .font(.subheadline.bold())
                    
                    ForEach(Array(step.instructions.enumerated()), id: \.offset) { index, instruction in
                        HStack(alignment: .top, spacing: 12) {
                            Text("\(index + 1).")
                                .font(.caption.bold())
                                .foregroundStyle(step.color)
                            
                            Text(instruction)
                                .font(.subheadline)
                        }
                    }
                    
                    Button {
                        if isCompleted {
                            onUncomplete()
                        } else {
                            onComplete()
                        }
                    } label: {
                        HStack {
                            Image(systemName: isCompleted ? "arrow.uturn.backward" : "checkmark")
                            Text(isCompleted ? "Marcar como no completado" : "Marcar como completado")
                        }
                        .font(.subheadline.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isCompleted ? Color.gray.opacity(0.2) : step.color)
                        .foregroundColor(isCompleted ? .primary : .white)
                        .cornerRadius(10)
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
    TIPPTechniqueView()
}
