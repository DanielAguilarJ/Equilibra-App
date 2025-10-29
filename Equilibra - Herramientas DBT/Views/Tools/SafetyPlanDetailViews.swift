//
//  SafetyPlanDetailViews.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

// MARK: - Warning Signals View
struct WarningSignalsView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var newSignal = ""
    @State private var editingIndex: Int?
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Nueva señal de advertencia", text: $newSignal)
                        .focused($isInputFocused)
                        .submitLabel(.done)
                        .onSubmit { addSignal() }
                    
                    Button(action: addSignal) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(newSignal.isEmpty ? .gray : .orange)
                    }
                    .disabled(newSignal.isEmpty)
                }
            }
            
            if let signals = viewModel.safetyPlan?.warningSignals, !signals.isEmpty {
                Section("Mis Señales de Advertencia") {
                    ForEach(Array(signals.enumerated()), id: \.offset) { index, signal in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundStyle(.orange)
                            Text(signal)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeWarningSignal(at: $0) }
                    }
                }
            }
        }
        .navigationTitle("Señales de Advertencia")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addSignal() {
        guard !newSignal.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        viewModel.addWarningSignal(newSignal)
        newSignal = ""
        isInputFocused = false
    }
}

// MARK: - Coping Strategies View
struct CopingStrategiesView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        List {
            if let strategies = viewModel.safetyPlan?.copingStrategies, !strategies.isEmpty {
                ForEach(Array(strategies.enumerated()), id: \.element.id) { index, strategy in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(strategy.title)
                                .font(.headline)
                            Spacer()
                            Text(strategy.category.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .foregroundStyle(.blue)
                                .cornerRadius(4)
                        }
                        
                        Text(strategy.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.removeCopingStrategy(at: $0) }
                }
            } else {
                ContentUnavailableView(
                    "Sin estrategias",
                    systemImage: "brain.head.profile",
                    description: Text("Añade estrategias de afrontamiento")
                )
            }
        }
        .navigationTitle("Estrategias de Afrontamiento")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddCopingStrategySheet(viewModel: viewModel)
        }
    }
}

// MARK: - Support Contacts View
struct SupportContactsView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        List {
            if let contacts = viewModel.safetyPlan?.supportContacts, !contacts.isEmpty {
                ForEach(Array(contacts.enumerated()), id: \.element.id) { index, contact in
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(contact.name)
                                .font(.headline)
                            Text(contact.relationship)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let notes = contact.notes {
                            Text(notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: { viewModel.makePhoneCall(to: contact.phone) }) {
                                Label("Llamar", systemImage: "phone.fill")
                                    .font(.caption)
                            }
                            .buttonStyle(.bordered)
                            .tint(.green)
                            
                            Button(action: { viewModel.sendMessage(to: contact.phone) }) {
                                Label("Mensaje", systemImage: "message.fill")
                                    .font(.caption)
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.removeSupportContact(at: $0) }
                }
            } else {
                ContentUnavailableView(
                    "Sin contactos",
                    systemImage: "person.2",
                    description: Text("Añade personas de apoyo")
                )
            }
        }
        .navigationTitle("Contactos de Apoyo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddSupportContactSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Professional Contacts View
struct ProfessionalContactsView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        List {
            if let professionals = viewModel.safetyPlan?.professionalContacts, !professionals.isEmpty {
                ForEach(Array(professionals.enumerated()), id: \.element.id) { index, professional in
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(professional.name)
                                .font(.headline)
                            Text(professional.role.rawValue)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            if let org = professional.organization {
                                Text(org)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        
                        if let hours = professional.availabilityHours {
                            Label(hours, systemImage: "clock")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: { viewModel.makePhoneCall(to: professional.phone) }) {
                                Label("Llamar", systemImage: "phone.fill")
                                    .font(.caption)
                            }
                            .buttonStyle(.bordered)
                            .tint(.purple)
                            
                            if let email = professional.email {
                                Link(destination: URL(string: "mailto:\(email)")!) {
                                    Label("Email", systemImage: "envelope.fill")
                                        .font(.caption)
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete { indexSet in
                    indexSet.forEach { viewModel.removeProfessionalContact(at: $0) }
                }
            } else {
                ContentUnavailableView(
                    "Sin profesionales",
                    systemImage: "stethoscope",
                    description: Text("Añade profesionales de salud mental")
                )
            }
        }
        .navigationTitle("Profesionales de Salud")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddProfessionalContactSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Emergency Contacts View
struct EmergencyContactsView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var showingAddSheet = false
    
    var body: some View {
        List {
            Section("Líneas de Crisis Recomendadas") {
                ForEach(CrisisHotline.spanish) { hotline in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(hotline.name)
                            .font(.headline)
                        
                        HStack {
                            Text(hotline.phone)
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                            
                            if hotline.isAvailable24h {
                                Spacer()
                                Text("24/7")
                                    .font(.caption)
                                    .foregroundStyle(.green)
                            }
                        }
                        
                        Button(action: { viewModel.makePhoneCall(to: hotline.phone) }) {
                            Label("Llamar Ahora", systemImage: "phone.fill")
                                .font(.caption)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            if let emergencyContacts = viewModel.safetyPlan?.emergencyContacts, !emergencyContacts.isEmpty {
                Section("Mis Contactos de Emergencia") {
                    ForEach(Array(emergencyContacts.enumerated()), id: \.element.id) { index, contact in
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(contact.name)
                                        .font(.headline)
                                    Text(contact.type.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                if contact.isAvailable24h {
                                    Text("24/7")
                                        .font(.caption)
                                        .foregroundStyle(.green)
                                }
                            }
                            
                            Button(action: { viewModel.makePhoneCall(to: contact.phone) }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text(contact.phone)
                                }
                                .font(.caption)
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeEmergencyContact(at: $0) }
                    }
                }
            }
        }
        .navigationTitle("Contactos de Emergencia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddEmergencyContactSheet(viewModel: viewModel)
        }
    }
}

// MARK: - Reasons to Live View
struct ReasonsToLiveView: View {
    @Bindable var viewModel: SafetyPlanViewModel
    @State private var newReason = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        List {
            Section {
                HStack {
                    TextField("Nueva razón para vivir", text: $newReason)
                        .focused($isInputFocused)
                        .submitLabel(.done)
                        .onSubmit { addReason() }
                    
                    Button(action: addReason) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(newReason.isEmpty ? .gray : .pink)
                    }
                    .disabled(newReason.isEmpty)
                }
            }
            
            if let reasons = viewModel.safetyPlan?.reasonsToLive, !reasons.isEmpty {
                Section("Mis Razones para Vivir") {
                    ForEach(Array(reasons.enumerated()), id: \.offset) { index, reason in
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.pink)
                            Text(reason)
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { viewModel.removeReasonToLive(at: $0) }
                    }
                }
            }
        }
        .navigationTitle("Razones para Vivir")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func addReason() {
        guard !newReason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        viewModel.addReasonToLive(newReason)
        newReason = ""
        isInputFocused = false
    }
}

#Preview("Warning Signals") {
    NavigationStack {
        WarningSignalsView(viewModel: SafetyPlanViewModel())
    }
}

#Preview("Coping Strategies") {
    NavigationStack {
        CopingStrategiesView(viewModel: SafetyPlanViewModel())
    }
}

#Preview("Support Contacts") {
    NavigationStack {
        SupportContactsView(viewModel: SafetyPlanViewModel())
    }
}

#Preview("Reasons to Live") {
    NavigationStack {
        ReasonsToLiveView(viewModel: SafetyPlanViewModel())
    }
}
