//
//  CrisisView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

/// Vista optimizada para momentos de crisis - muestra el plan paso a paso
struct CrisisView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: SafetyPlanViewModel
    @State private var currentStep = 0
    @State private var isAuthenticated = false
    @State private var showingGroundingExercise = false
    @State private var showingBreathingExercise = false
    
    init() {
        _viewModel = State(initialValue: SafetyPlanViewModel())
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if let plan = viewModel.safetyPlan {
                    if plan.requiresAuthentication && !isAuthenticated {
                        authenticationView
                    } else if plan.isActive && plan.isComplete {
                        crisisStepsView(plan: plan)
                    } else {
                        noPlanView
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Modo Crisis")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salir") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                viewModel.modelContext = modelContext
                viewModel.loadSafetyPlan()
            }
            .sheet(isPresented: $showingGroundingExercise) {
                GroundingExerciseView()
            }
            .sheet(isPresented: $showingBreathingExercise) {
                BreathingView()
            }
        }
    }
    
    // MARK: - Authentication View
    private var authenticationView: some View {
        VStack(spacing: 24) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)
            
            Text("Autenticación Requerida")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: authenticateUser) {
                HStack {
                    Image(systemName: viewModel.biometricService.biometricType == .faceID ? "faceid" : "touchid")
                    Text("Autenticar")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    // MARK: - No Plan View
    private var noPlanView: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.orange)
            
            Text("Plan No Configurado")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Necesitas configurar tu plan de seguridad primero.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            
            // Emergency fallback
            emergencySection
        }
        .padding()
    }
    
    // MARK: - Crisis Steps View
    private func crisisStepsView(plan: SafetyPlan) -> some View {
        ScrollView {
            VStack(spacing: 20) {
                // Emergency alert header
                VStack(spacing: 12) {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.red)
                    
                    Text("Estás a Salvo")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Sigue estos pasos a tu ritmo. No estás solo/a.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                // Quick exercises
                VStack(spacing: 12) {
                    Text("Ejercicios Rápidos")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 12) {
                        Button(action: { showingGroundingExercise = true }) {
                            VStack {
                                Image(systemName: "hand.raised.fill")
                                    .font(.title)
                                Text("Grounding")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        }
                        
                        Button(action: { showingBreathingExercise = true }) {
                            VStack {
                                Image(systemName: "wind")
                                    .font(.title)
                                Text("Respirar")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Step by step plan
                VStack(spacing: 16) {
                    // Step 1: Warning signals recognition
                    if !plan.warningSignals.isEmpty {
                        CrisisStepCard(
                            stepNumber: 1,
                            title: "Reconoce tus Señales",
                            icon: "exclamationmark.triangle.fill",
                            color: .orange
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("¿Estás experimentando alguna de estas señales?")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                ForEach(plan.warningSignals.prefix(5), id: \.self) { signal in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 6))
                                        Text(signal)
                                            .font(.body)
                                    }
                                }
                            }
                        }
                    }
                    
                    // Step 2: Coping strategies
                    if !plan.copingStrategies.isEmpty {
                        CrisisStepCard(
                            stepNumber: 2,
                            title: "Usa tus Estrategias",
                            icon: "brain.head.profile",
                            color: .blue
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Intenta estas actividades:")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                ForEach(plan.copingStrategies.prefix(3)) { strategy in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(strategy.title)
                                            .font(.headline)
                                        Text(strategy.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Step 3: Contact support
                    if !plan.supportContacts.isEmpty {
                        CrisisStepCard(
                            stepNumber: 3,
                            title: "Contacta a Alguien",
                            icon: "person.2.fill",
                            color: .green
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Habla con alguien de confianza:")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                ForEach(plan.supportContacts.prefix(3)) { contact in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(contact.name)
                                                .font(.headline)
                                            Text(contact.relationship)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: { viewModel.makePhoneCall(to: contact.phone) }) {
                                            Image(systemName: "phone.fill")
                                                .padding(8)
                                                .background(Color.green)
                                                .foregroundStyle(.white)
                                                .cornerRadius(8)
                                        }
                                        
                                        Button(action: { viewModel.sendMessage(to: contact.phone) }) {
                                            Image(systemName: "message.fill")
                                                .padding(8)
                                                .background(Color.blue)
                                                .foregroundStyle(.white)
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding()
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Step 4: Professional help
                    if !plan.professionalContacts.isEmpty {
                        CrisisStepCard(
                            stepNumber: 4,
                            title: "Ayuda Profesional",
                            icon: "stethoscope",
                            color: .purple
                        ) {
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(plan.professionalContacts) { professional in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(professional.name)
                                                .font(.headline)
                                            Text(professional.role.rawValue)
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Button(action: { viewModel.makePhoneCall(to: professional.phone) }) {
                                            HStack {
                                                Image(systemName: "phone.fill")
                                                Text("Llamar")
                                                    .font(.caption)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.purple)
                                            .foregroundStyle(.white)
                                            .cornerRadius(8)
                                        }
                                    }
                                    .padding()
                                    .background(Color.purple.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Step 5: Emergency services
                    CrisisStepCard(
                        stepNumber: 5,
                        title: "Servicios de Emergencia",
                        icon: "phone.fill",
                        color: .red
                    ) {
                        VStack(spacing: 12) {
                            Text("Si estás en peligro inmediato:")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Emergency services
                            Button(action: { viewModel.makePhoneCall(to: "112") }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text("Llamar al 112 (Emergencias)")
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .foregroundStyle(.white)
                                .cornerRadius(8)
                            }
                            
                            // Crisis hotlines
                            ForEach(CrisisHotline.spanish.prefix(2)) { hotline in
                                Button(action: { viewModel.makePhoneCall(to: hotline.phone) }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(hotline.name)
                                                .font(.caption)
                                            Text(hotline.phone)
                                                .font(.headline)
                                        }
                                        Spacer()
                                        Image(systemName: "phone.fill")
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundStyle(.red)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                    
                    // Step 6: Reasons to live
                    if !plan.reasonsToLive.isEmpty {
                        CrisisStepCard(
                            stepNumber: 6,
                            title: "Recuerda Por Qué",
                            icon: "heart.fill",
                            color: .pink
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Estas son tus razones para vivir:")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                ForEach(plan.reasonsToLive, id: \.self) { reason in
                                    HStack(alignment: .top) {
                                        Image(systemName: "heart.fill")
                                            .foregroundStyle(.pink)
                                            .font(.caption)
                                        Text(reason)
                                            .font(.body)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.pink.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Emergency Section
    private var emergencySection: some View {
        VStack(spacing: 12) {
            Text("Líneas de Crisis Disponibles")
                .font(.headline)
            
            ForEach(CrisisHotline.spanish) { hotline in
                Button(action: { viewModel.makePhoneCall(to: hotline.phone) }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(hotline.name)
                            .font(.headline)
                        Text(hotline.phone)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
            }
            
            Button(action: { viewModel.makePhoneCall(to: "112") }) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("Llamar al 112 (Emergencias)")
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

// MARK: - Crisis Step Card
struct CrisisStepCard<Content: View>: View {
    let stepNumber: Int
    let title: String
    let icon: String
    let color: Color
    @ViewBuilder let content: Content
    
    @State private var isExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(color)
                                .frame(width: 40, height: 40)
                            
                            Text("\(stepNumber)")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Paso \(stepNumber)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(title)
                                .font(.headline)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content
                    .transition(.opacity)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    CrisisView()
        .modelContainer(for: [SafetyPlan.self], inMemory: true)
}
