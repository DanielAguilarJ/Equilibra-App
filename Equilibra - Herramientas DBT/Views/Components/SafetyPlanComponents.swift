//
//  SafetyPlanComponents.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

// MARK: - Coping Strategy Components
struct CopingStrategyCard: View {
    let strategy: SafetyCopingStrategy
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(strategy.title)
                        .font(.headline)
                    
                    Text(strategy.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
            
            Text(strategy.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 4)
        )
    }
}

struct AddCopingStrategySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SafetyPlanViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var category: CopingCategory = .distraction
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Información") {
                    TextField("Título", text: $title)
                    
                    Picker("Categoría", selection: $category) {
                        ForEach(CopingCategory.allCases, id: \.self) { cat in
                            Text(cat.rawValue).tag(cat)
                        }
                    }
                }
                
                Section("Descripción") {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Nueva Estrategia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardar") {
                        let strategy = SafetyCopingStrategy(
                            title: title,
                            description: description,
                            category: category
                        )
                        viewModel.addCopingStrategy(strategy)
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
}

// MARK: - Support Contact Components
struct SupportContactCard: View {
    let contact: SupportContact
    let viewModel: SafetyPlanViewModel
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.headline)
                    
                    Text(contact.relationship)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
            
            HStack(spacing: 12) {
                Button(action: { viewModel.makePhoneCall(to: contact.phone) }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Llamar")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                }
                
                Button(action: { viewModel.sendMessage(to: contact.phone) }) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Mensaje")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 4)
        )
    }
}

struct AddSupportContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SafetyPlanViewModel
    
    @State private var name = ""
    @State private var relationship = ""
    @State private var phone = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Información del Contacto") {
                    TextField("Nombre", text: $name)
                    TextField("Relación (ej: Mejor amigo/a)", text: $relationship)
                    TextField("Teléfono", text: $phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Notas") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
                }
            }
            .navigationTitle("Nuevo Contacto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardar") {
                        let contact = SupportContact(
                            name: name,
                            relationship: relationship,
                            phone: phone,
                            notes: notes.isEmpty ? nil : notes
                        )
                        viewModel.addSupportContact(contact)
                        dismiss()
                    }
                    .disabled(name.isEmpty || relationship.isEmpty || phone.isEmpty)
                }
            }
        }
    }
}

// MARK: - Professional Contact Components
struct ProfessionalContactCard: View {
    let contact: ProfessionalContact
    let viewModel: SafetyPlanViewModel
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.headline)
                    
                    Text(contact.role.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    if let org = contact.organization {
                        Text(org)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
            
            if let hours = contact.availabilityHours {
                Label(hours, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 12) {
                Button(action: { viewModel.makePhoneCall(to: contact.phone) }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("Llamar")
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.purple)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
                }
                
                if let email = contact.email, !email.isEmpty {
                    Link(destination: URL(string: "mailto:\(email)")!) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Email")
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(8)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 4)
        )
    }
}

struct AddProfessionalContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SafetyPlanViewModel
    
    @State private var name = ""
    @State private var role: ProfessionalContact.ProfessionalRole = .therapist
    @State private var organization = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var availabilityHours = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Información del Profesional") {
                    TextField("Nombre", text: $name)
                    
                    Picker("Rol", selection: $role) {
                        ForEach(ProfessionalContact.ProfessionalRole.allCases, id: \.self) { r in
                            Text(r.rawValue).tag(r)
                        }
                    }
                    
                    TextField("Organización (opcional)", text: $organization)
                    TextField("Teléfono", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Email (opcional)", text: $email)
                        .keyboardType(.emailAddress)
                }
                
                Section("Detalles Adicionales") {
                    TextField("Horario de disponibilidad", text: $availabilityHours)
                }
            }
            .navigationTitle("Nuevo Profesional")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardar") {
                        let contact = ProfessionalContact(
                            name: name,
                            role: role,
                            organization: organization.isEmpty ? nil : organization,
                            phone: phone,
                            email: email.isEmpty ? nil : email,
                            availabilityHours: availabilityHours.isEmpty ? nil : availabilityHours,
                            notes: nil
                        )
                        viewModel.addProfessionalContact(contact)
                        dismiss()
                    }
                    .disabled(name.isEmpty || phone.isEmpty)
                }
            }
        }
    }
}

// MARK: - Emergency Contact Components
struct EmergencyContactCard: View {
    let contact: EmergencyContact
    let viewModel: SafetyPlanViewModel
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.headline)
                    
                    Text(contact.relationship)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red)
                }
            }
            
            Button(action: { viewModel.makePhoneCall(to: contact.phone) }) {
                HStack {
                    Image(systemName: "phone.fill")
                    Text(contact.phone)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundStyle(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.background)
                .shadow(color: .black.opacity(0.05), radius: 4)
        )
    }
}

struct AddEmergencyContactSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SafetyPlanViewModel
    
    @State private var name = ""
    @State private var relationship = ""
    @State private var phone = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Información de Emergencia") {
                    TextField("Nombre", text: $name)
                    TextField("Relación", text: $relationship)
                    TextField("Teléfono", text: $phone)
                        .keyboardType(.phonePad)
                    TextField("Notas (opcional)", text: $notes)
                }
            }
            .navigationTitle("Contacto de Emergencia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Guardar") {
                        let contact = EmergencyContact(
                            name: name,
                            relationship: relationship,
                            phone: phone,
                            notes: notes,
                            type: .other,
                            isAvailable24h: false
                        )
                        viewModel.addEmergencyContact(contact)
                        dismiss()
                    }
                    .disabled(name.isEmpty || relationship.isEmpty || phone.isEmpty)
                }
            }
        }
    }
}

// MARK: - Hotline Card
struct HotlineCard: View {
    let hotline: CrisisHotline
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(hotline.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(hotline.phone)
                    .font(.headline)
                    .foregroundStyle(.blue)
                
                if hotline.isAvailable24h {
                    Text("Disponible 24/7")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            
            Spacer()
            
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        )
    }
}
