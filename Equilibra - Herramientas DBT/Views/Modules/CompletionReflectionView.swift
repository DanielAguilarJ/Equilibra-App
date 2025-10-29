//
//  CompletionReflectionView.swift
//  Equilibra - Herramientas DBT
//
//  Vista de reflexión post-interacción compartida
//

import SwiftUI

struct CompletionReflectionView: View {
    @Environment(\.dismiss) private var dismiss
    let skillType: InterpersonalSkillType
    let onComplete: (String, String, Int) -> Void
    
    @State private var outcome = ""
    @State private var reflection = ""
    @State private var effectiveness = 5
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.green)
                        
                        Text("Reflexión Post-Interacción")
                            .font(.title2.bold())
                        
                        Text("Tómate un momento para reflexionar sobre cómo fue la interacción.")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // Outcome
                        VStack(alignment: .leading, spacing: 12) {
                            Label("¿Qué pasó?", systemImage: "text.bubble")
                                .font(.headline)
                            Text("Describe el resultado de la interacción")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: $outcome)
                                .frame(height: 120)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Effectiveness Rating
                        VStack(alignment: .leading, spacing: 12) {
                            Label("¿Qué tan efectivo fue?", systemImage: "star.fill")
                                .font(.headline)
                            
                            HStack {
                                Text("1")
                                    .foregroundColor(.secondary)
                                Slider(value: Binding(
                                    get: { Double(effectiveness) },
                                    set: { effectiveness = Int($0) }
                                ), in: 1...10, step: 1)
                                .tint(colorForEffectiveness)
                                Text("10")
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Spacer()
                                Text("\(effectiveness)/10")
                                    .font(.title2.bold())
                                    .foregroundColor(colorForEffectiveness)
                                Text(labelForEffectiveness)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding()
                            .background(colorForEffectiveness.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Reflection
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Reflexión", systemImage: "brain")
                                .font(.headline)
                            Text("¿Qué aprendiste? ¿Qué harías diferente?")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: $reflection)
                                .frame(height: 150)
                                .padding(8)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Reflection Prompts
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preguntas guía:")
                                .font(.subheadline.bold())
                            
                            ForEach(reflectionPrompts, id: \.self) { prompt in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.cyan)
                                        .font(.caption)
                                    Text(prompt)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.cyan.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Save Button
                    Button {
                        onComplete(outcome, reflection, effectiveness)
                        dismiss()
                    } label: {
                        Label("Guardar Reflexión", systemImage: "checkmark.circle.fill")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canSave ? Color.green : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!canSave)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
            }
            .navigationTitle("Completar Plan")
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
    
    private var canSave: Bool {
        !outcome.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var colorForEffectiveness: Color {
        switch effectiveness {
        case 1...3:
            return .red
        case 4...6:
            return .orange
        case 7...8:
            return .yellow
        case 9...10:
            return .green
        default:
            return .gray
        }
    }
    
    private var labelForEffectiveness: String {
        switch effectiveness {
        case 1...3:
            return "Poco efectivo"
        case 4...6:
            return "Moderadamente efectivo"
        case 7...8:
            return "Muy efectivo"
        case 9...10:
            return "Extremadamente efectivo"
        default:
            return ""
        }
    }
    
    private var reflectionPrompts: [String] {
        switch skillType {
        case .dearMan:
            return [
                "¿Conseguiste tu objetivo?",
                "¿Qué componentes de DEAR MAN funcionaron mejor?",
                "¿Hubo algo que te sacó del camino?",
                "¿Cómo manejaste las respuestas inesperadas?",
                "¿Qué harías diferente la próxima vez?"
            ]
        case .give:
            return [
                "¿Cómo quedó la relación después de la conversación?",
                "¿Fuiste capaz de mantener todos los componentes GIVE?",
                "¿La otra persona se sintió escuchada y validada?",
                "¿Qué fue lo más difícil de mantener?",
                "¿Cómo te sientes sobre el resultado?"
            ]
        case .fast:
            return [
                "¿Mantuviste tus valores?",
                "¿Cómo te sientes sobre tu comportamiento?",
                "¿Sacrificaste tu autorespeto en algún momento?",
                "¿Fuiste honesto/a contigo mismo/a?",
                "¿Te sientes orgulloso/a de cómo manejaste la situación?"
            ]
        }
    }
}

#Preview {
    CompletionReflectionView(skillType: .dearMan) { _, _, _ in }
}
