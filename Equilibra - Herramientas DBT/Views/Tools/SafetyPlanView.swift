//
//  SafetyPlanView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct SafetyPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SafetyPlanViewModel
    @State private var showingAuthAlert = false
    @State private var isAuthenticated = false
    @State private var showingWizard = false
    
    init() {
        _viewModel = State(initialValue: SafetyPlanViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let plan = viewModel.safetyPlan {
                    if plan.requiresAuthentication && !isAuthenticated {
                        authenticationRequiredView
                    } else if !plan.isActive || !plan.isComplete {
                        welcomeView
                    } else {
                        planOverviewView(plan: plan)
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Plan de Seguridad")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if isAuthenticated || !(viewModel.safetyPlan?.requiresAuthentication ?? true) {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Button(action: { showingWizard = true }) {
                                Label("Editar Plan", systemImage: "pencil")
                            }
                            
                            Button(action: {
                                viewModel.toggleAuthentication()
                            }) {
                                Label(
                                    viewModel.safetyPlan?.requiresAuthentication ?? false ? "Desactivar Autenticación" : "Activar Autenticación",
                                    systemImage: viewModel.safetyPlan?.requiresAuthentication ?? false ? "lock.open" : "lock"
                                )
                            }
                            
                            Divider()
                            
                            Button(role: .destructive, action: {
                                viewModel.resetPlan()
                            }) {
                                Label("Resetear Plan", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingWizard) {
                SafetyPlanWizardView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadSafetyPlan()
            }
        }
    }
    
    // MARK: - Authentication Required View
    private var authenticationRequiredView: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)
            
            Text("Plan Protegido")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Tu plan de seguridad está protegido con \(viewModel.biometricService.biometricTypeName)")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: authenticateUser) {
                HStack {
                    Image(systemName: viewModel.biometricService.biometricType == .faceID ? "faceid" : "touchid")
                    Text("Desbloquear")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            
            if let error = viewModel.biometricService.authenticationError {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
    
    // MARK: - Welcome View
    private var welcomeView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.pink)
                
                Text("Crea Tu Plan de Seguridad")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Un plan de seguridad es una herramienta personal que te ayuda a mantenerte a salvo durante momentos difíciles.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    WelcomeFeatureRow(
                        icon: "exclamationmark.triangle.fill",
                        title: "Reconoce señales",
                        description: "Identifica tus señales de advertencia personales"
                    )
                    
                    WelcomeFeatureRow(
                        icon: "brain.head.profile",
                        title: "Estrategias de afrontamiento",
                        description: "Lista de técnicas que te ayudan a calmarte"
                    )
                    
                    WelcomeFeatureRow(
                        icon: "person.2.fill",
                        title: "Red de apoyo",
                        description: "Contactos de amigos, familia y profesionales"
                    )
                    
                    WelcomeFeatureRow(
                        icon: "heart.fill",
                        title: "Razones para vivir",
                        description: "Recordatorios de lo que es importante para ti"
                    )
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.background)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
                
                Button(action: { showingWizard = true }) {
                    HStack {
                        Image(systemName: "arrow.right.circle.fill")
                        Text("Comenzar Ahora")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Plan Overview
    private func planOverviewView(plan: SafetyPlan) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.shield.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.green)
                    
                    Text("Tu Plan Está Activo")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Actualizado el \(plan.modifiedDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                
                // Quick access sections
                VStack(spacing: 12) {
                    NavigationLink(destination: WarningSignalsView(viewModel: viewModel)) {
                        SafetyPlanSectionCard(
                            icon: "exclamationmark.triangle.fill",
                            title: "Señales de Advertencia",
                            count: plan.warningSignals.count,
                            color: .orange
                        )
                    }
                    
                    NavigationLink(destination: CopingStrategiesView(viewModel: viewModel)) {
                        SafetyPlanSectionCard(
                            icon: "brain.head.profile",
                            title: "Estrategias de Afrontamiento",
                            count: plan.copingStrategies.count,
                            color: .blue
                        )
                    }
                    
                    NavigationLink(destination: SupportContactsView(viewModel: viewModel)) {
                        SafetyPlanSectionCard(
                            icon: "person.2.fill",
                            title: "Contactos de Apoyo",
                            count: plan.supportContacts.count,
                            color: .green
                        )
                    }
                    
                    NavigationLink(destination: ProfessionalContactsView(viewModel: viewModel)) {
                        SafetyPlanSectionCard(
                            icon: "stethoscope",
                            title: "Profesionales de Salud",
                            count: plan.professionalContacts.count,
                            color: .purple
                        )
                    }
                    
                    NavigationLink(destination: EmergencyContactsView(viewModel: viewModel)) {
                        SafetyPlanSectionCard(
                            icon: "phone.fill",
                            title: "Contactos de Emergencia",
                            count: plan.emergencyContacts.count,
                            color: .red
                        )
                    }
                    
                    NavigationLink(destination: ReasonsToLiveView(viewModel: viewModel)) {
                        SafetyPlanSectionCard(
                            icon: "heart.fill",
                            title: "Razones para Vivir",
                            count: plan.reasonsToLive.count,
                            color: .pink
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Authentication
    private func authenticateUser() {
        viewModel.biometricService.authenticate { success, error in
            if success {
                withAnimation {
                    isAuthenticated = true
                }
            }
        }
    }
}

// MARK: - Supporting Views
struct WelcomeFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
    }
}

struct SafetyPlanSectionCard: View {
    let icon: String
    let title: String
    let count: Int
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.2))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text("\(count) elemento\(count != 1 ? "s" : "")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
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
}

#Preview {
    SafetyPlanView()
        .modelContainer(for: [SafetyPlan.self], inMemory: true)
}
