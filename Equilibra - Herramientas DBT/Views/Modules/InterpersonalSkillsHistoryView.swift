//
//  InterpersonalSkillsHistoryView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct InterpersonalSkillsHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Historial de Habilidades Interpersonales")
                        .font(.title2)
                        .padding()
                    
                    // Placeholder for future implementation
                    Text("Próximamente: Ver historial de prácticas")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .navigationTitle("Historial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}
