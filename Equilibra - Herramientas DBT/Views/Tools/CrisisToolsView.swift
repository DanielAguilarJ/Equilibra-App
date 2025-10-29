//
//  CrisisToolsView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

/// Vista de herramientas para situaciones de crisis
struct CrisisToolsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingBreathingExercise = false
    @State private var showingTIPP = false
    @State private var showingGrounding = false
    @State private var showingSafetyPlan = false
    @State private var showingCrisisMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Crisis header
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.red)
                        
                        Text("Estás a salvo")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Respira profundo. Aquí tienes herramientas que pueden ayudarte ahora.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                    
                    // Crisis Mode - Priority Access
                    Button(action: { showingCrisisMode = true }) {
                        HStack {
                            Image(systemName: "exclamationmark.shield.fill")
                                .font(.title2)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Modo Crisis")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Acceso rápido a tu plan de seguridad")
                                    .font(.caption)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.title2)
                        }
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.red, .orange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    
                    // Quick tools
                    VStack(spacing: 16) {
                        CrisisToolButton(
                            title: "Ejercicio de Respiración",
                            icon: "wind",
                            color: .blue
                        ) {
                            showingBreathingExercise = true
                        }
                        
                        CrisisToolButton(
                            title: "Técnica TIPP",
                            icon: "thermometer",
                            color: .cyan
                        ) {
                            showingTIPP = true
                        }
                        
                        CrisisToolButton(
                            title: "Grounding 5-4-3-2-1",
                            icon: "hand.raised.fill",
                            color: .green
                        ) {
                            showingGrounding = true
                        }
                        
                        CrisisToolButton(
                            title: "Mi Plan de Seguridad",
                            icon: "shield.fill",
                            color: .purple
                        ) {
                            showingSafetyPlan = true
                        }
                    }
                    .padding(.horizontal)
                    
                    // Emergency contacts
                    VStack(spacing: 12) {
                        Text("Líneas de Crisis 24/7")
                            .font(.headline)
                        
                        ForEach(CrisisHotline.spanish.prefix(2)) { hotline in
                            Button(action: {
                                if let url = URL(string: "tel://\(hotline.phone)") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(hotline.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text(hotline.phone)
                                        .font(.headline)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .foregroundStyle(.red)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Emergency contact
                    VStack(spacing: 12) {
                        Text("Si estás en peligro inmediato")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Button(action: {
                            if let url = URL(string: "tel://112") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text("Llamar al 112")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Herramientas de Crisis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingBreathingExercise) {
                BreathingView()
            }
            .sheet(isPresented: $showingTIPP) {
                TIPPTechniqueView()
            }
            .sheet(isPresented: $showingGrounding) {
                GroundingExerciseView()
            }
            .sheet(isPresented: $showingSafetyPlan) {
                SafetyPlanView()
            }
            .fullScreenCover(isPresented: $showingCrisisMode) {
                CrisisView()
            }
        }
    }
}

struct CrisisToolButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.2))
                    .foregroundStyle(color)
                    .cornerRadius(10)
                
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                    .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CrisisToolsView()
}
