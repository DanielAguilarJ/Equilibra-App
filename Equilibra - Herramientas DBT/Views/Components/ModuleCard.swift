//
//  ModuleCard.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

/// Tarjeta visual para mostrar cada módulo DBT
struct ModuleCard: View {
    let module: DBTModule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: module.type.icon)
                    .font(.title2)
                    .foregroundStyle(colorForModule)
                
                Spacer()
                
                if module.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                        .font(.caption)
                }
            }
            
            Text(module.type.rawValue)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Text(module.type.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            // Progress bar
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Progreso")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(Int(module.progress * 100))%")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                ProgressView(value: module.progress)
                    .tint(colorForModule)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
    
    private var colorForModule: Color {
        switch module.type.color {
        case "purple": return .purple
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        default: return .blue
        }
    }
}

#Preview {
    ModuleCard(module: DBTModule(type: .mindfulness))
    .padding()
}
