//
//  EmotionalLogCard.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

/// Tarjeta para mostrar un registro emocional
struct EmotionalLogCard: View {
    let log: EmotionalLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(log.emotion)
                    .font(.headline)
                
                Spacer()
                
                Text(log.date, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            // Intensity indicator
            HStack(spacing: 4) {
                ForEach(1...10, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(level <= log.intensity ? intensityColor : Color.gray.opacity(0.2))
                        .frame(height: 6)
                }
            }
            
            if !log.trigger.isEmpty {
                Text("Desencadenante: \(log.trigger)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            
            if !log.notes.isEmpty {
                Text(log.notes)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
    
    private var intensityColor: Color {
        switch log.intensity {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
}

#Preview {
    EmotionalLogCard(
        log: EmotionalLog(
            emotion: "Ansiedad",
            intensity: 7,
            trigger: "Conversación difícil",
            notes: "Usé técnica de respiración"
        )
    )
    .padding()
}
