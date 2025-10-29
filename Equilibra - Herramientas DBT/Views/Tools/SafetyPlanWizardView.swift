//
//  SafetyPlanWizardView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct SafetyPlanWizardView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var currentStep = 0
    
    private let totalSteps = 6
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress bar
                ProgressView(value: Double(currentStep + 1), total: Double(totalSteps))
                    .padding()
                
                // Step indicator
                HStack {
                    Text("Paso \(currentStep + 1) de \(totalSteps)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text(stepTitle)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                Divider()
                
                // Current step content
                TabView(selection: $currentStep) {
                    WarningSignalsStepView(viewModel: viewModel)
                        .tag(0)
                    
                    CopingStrategiesStepView(viewModel: viewModel)
                        .tag(1)
                    
                    SupportContactsStepView(viewModel: viewModel)
                        .tag(2)
                    
                    ProfessionalContactsStepView(viewModel: viewModel)
                        .tag(3)
                    
                    EmergencyContactsStepView(viewModel: viewModel)
                        .tag(4)
                    
                    ReasonsToLiveStepView(viewModel: viewModel)
                        .tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: { withAnimation { currentStep -= 1 } }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Anterior")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundStyle(.primary)
                            .cornerRadius(12)
                        }
                    }
                    
                    Button(action: nextStep) {
                        HStack {
                            Text(currentStep < totalSteps - 1 ? "Siguiente" : "Finalizar")
                            Image(systemName: currentStep < totalSteps - 1 ? "chevron.right" : "checkmark")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Configurar Plan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var stepTitle: String {
        switch currentStep {
        case 0: return "Señales de Advertencia"
        case 1: return "Estrategias de Afrontamiento"
        case 2: return "Contactos de Apoyo"
        case 3: return "Profesionales"
        case 4: return "Emergencias"
        case 5: return "Razones para Vivir"
        default: return ""
        }
    }
    
    private func nextStep() {
        if currentStep < totalSteps - 1 {
            withAnimation {
                currentStep += 1
            }
        } else {
            // Finalizar wizard
            viewModel.activatePlan()
            dismiss()
        }
    }
}

// MARK: - Step 1: Warning Signals
struct WarningSignalsStepView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var newSignal = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Señales de Advertencia")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Identifica pensamientos, imágenes, estados de ánimo, situaciones o comportamientos que indican que una crisis puede estar desarrollándose.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Input field
                HStack {
                    TextField("Ej: Me siento muy solo/a", text: $newSignal)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            addSignal()
                        }
                    
                    Button(action: addSignal) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(newSignal.isEmpty ? .gray : .blue)
                    }
                    .disabled(newSignal.isEmpty)
                }
                
                // List of signals
                if let signals = viewModel.safetyPlan?.warningSignals, !signals.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mis señales (\(signals.count))")
                            .font(.headline)
                        
                        ForEach(Array(signals.enumerated()), id: \.offset) { index, signal in
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.orange)
                                
                                Text(signal)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.removeWarningSignal(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                    .shadow(color: .black.opacity(0.05), radius: 2)
                            )
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "Sin señales aún",
                        systemImage: "exclamationmark.triangle",
                        description: Text("Añade al menos una señal de advertencia para continuar")
                    )
                }
            }
            .padding()
        }
    }
    
    private func addSignal() {
        guard !newSignal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        viewModel.addWarningSignal(newSignal)
        newSignal = ""
        isInputFocused = false
    }
}

// MARK: - Step 2: Coping Strategies
struct CopingStrategiesStepView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Estrategias de Afrontamiento")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Actividades que puedes hacer por tu cuenta para distraerte de pensamientos o situaciones difíciles, sin contactar a otra persona.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                Button(action: { showingAddSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Añadir Estrategia")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                
                // List of strategies
                if let strategies = viewModel.safetyPlan?.copingStrategies, !strategies.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mis estrategias (\(strategies.count))")
                            .font(.headline)
                        
                        ForEach(Array(strategies.enumerated()), id: \.element.id) { index, strategy in
                            CopingStrategyCard(strategy: strategy) {
                                viewModel.removeCopingStrategy(at: index)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "Sin estrategias aún",
                        systemImage: "brain.head.profile",
                        description: Text("Añade estrategias que te ayuden a calmarte")
                    )
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingAddSheet) {
            AddCopingStrategySheet(viewModel: viewModel)
        }
    }
}

// MARK: - Step 3: Support Contacts
struct SupportContactsStepView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contactos de Apoyo")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Personas con las que puedes hablar cuando necesitas apoyo: familiares, amigos o personas de confianza.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                Button(action: { showingAddSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Añadir Contacto")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                
                // List of contacts
                if let contacts = viewModel.safetyPlan?.supportContacts, !contacts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mis contactos (\(contacts.count))")
                            .font(.headline)
                        
                        ForEach(contacts.indices, id: \.self) { index in
                            SupportContactCard(contact: contacts[index], viewModel: viewModel) {
                                viewModel.removeSupportContact(at: index)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "Sin contactos aún",
                        systemImage: "person.2",
                        description: Text("Añade personas de confianza")
                    )
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingAddSheet) {
            AddSupportContactSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Step 4: Professional Contacts
struct ProfessionalContactsStepView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Profesionales de Salud")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Terapeutas, psiquiatras, médicos u otros profesionales que pueden ayudarte.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                Button(action: { showingAddSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Añadir Profesional")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                
                // List of professionals
                if let professionals = viewModel.safetyPlan?.professionalContacts, !professionals.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mis profesionales (\(professionals.count))")
                            .font(.headline)
                        
                        ForEach(Array(professionals.enumerated()), id: \.element.id) { index, professional in
                            ProfessionalContactCard(contact: professional, viewModel: viewModel) {
                                viewModel.removeProfessionalContact(at: index)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "Sin profesionales aún",
                        systemImage: "stethoscope",
                        description: Text("Añade profesionales de salud mental")
                    )
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingAddSheet) {
            AddProfessionalContactSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Step 5: Emergency Contacts
struct EmergencyContactsStepView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contactos de Emergencia")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Líneas de crisis, hospitales y servicios de emergencia disponibles 24/7.")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Predefined hotlines
                VStack(alignment: .leading, spacing: 12) {
                    Text("Líneas de Crisis en España")
                        .font(.headline)
                    
                    ForEach(CrisisHotline.spanish) { hotline in
                        HotlineCard(hotline: hotline) {
                            viewModel.addEmergencyContact(EmergencyContact(
                                name: hotline.name,
                                relationship: "Línea de Crisis",
                                phone: hotline.phone,
                                notes: hotline.description
                            ))
                        }
                    }
                }
                
                Button(action: { showingAddSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Añadir Otro Contacto")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundStyle(.white)
                    .cornerRadius(12)
                }
                
                // User's emergency contacts
                if let emergencyContacts = viewModel.safetyPlan?.emergencyContacts, !emergencyContacts.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mis contactos de emergencia (\(emergencyContacts.count))")
                            .font(.headline)
                        
                        ForEach(Array(emergencyContacts.enumerated()), id: \.element.id) { index, contact in
                            EmergencyContactCard(contact: contact, viewModel: viewModel) {
                                viewModel.removeEmergencyContact(at: index)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingAddSheet) {
            AddEmergencyContactSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Step 6: Reasons to Live
struct ReasonsToLiveStepView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var newReason = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Razones para Vivir")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Lista las cosas que hacen que tu vida valga la pena: personas, mascotas, metas, valores, experiencias futuras...")
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Input field
                HStack {
                    TextField("Ej: Mi familia, mis mascotas", text: $newReason)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            addReason()
                        }
                    
                    Button(action: addReason) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(newReason.isEmpty ? .gray : .pink)
                    }
                    .disabled(newReason.isEmpty)
                }
                
                // List of reasons
                if let reasons = viewModel.safetyPlan?.reasonsToLive, !reasons.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Mis razones (\(reasons.count))")
                            .font(.headline)
                        
                        ForEach(Array(reasons.enumerated()), id: \.offset) { index, reason in
                            HStack {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.pink)
                                
                                Text(reason)
                                
                                Spacer()
                                
                                Button(action: {
                                    viewModel.removeReasonToLive(at: index)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                    .shadow(color: .black.opacity(0.05), radius: 2)
                            )
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "Sin razones aún",
                        systemImage: "heart",
                        description: Text("Añade razones que hagan tu vida valiosa")
                    )
                }
            }
            .padding()
        }
    }
    
    private func addReason() {
        guard !newReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        viewModel.addReasonToLive(newReason)
        newReason = ""
        isInputFocused = false
    }
}

#Preview {
    SafetyPlanWizardView(viewModel: SafetyPlanViewModel())
}
