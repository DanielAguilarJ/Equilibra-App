//
//  CrisisPlan.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Plan de seguridad personalizado para situaciones de crisis
@Model
final class SafetyPlan {
    var id: UUID
    var createdDate: Date
    var lastModifiedDate: Date
    
    // 1. Señales de advertencia
    var warningSignals: [String]
    
    // 2. Estrategias de afrontamiento internas
    var copingStrategies: [CopingStrategy]
    
    // 3. Contactos de apoyo (amigos/familia)
    var supportContacts: [SupportContact]
    
    // 4. Recursos profesionales
    var professionalContacts: [ProfessionalContact]
    
    // 5. Contactos de emergencia
    var emergencyContacts: [EmergencyContact]
    
    // 6. Razones para vivir
    var reasonsToLive: [String]
    
    // Configuración
    var isActive: Bool
    var requiresAuthentication: Bool
    
    init() {
        self.id = UUID()
        self.createdDate = Date()
        self.lastModifiedDate = Date()
        self.warningSignals = []
        self.copingStrategies = []
        self.supportContacts = []
        self.professionalContacts = []
        self.emergencyContacts = []
        self.reasonsToLive = []
        self.isActive = false
        self.requiresAuthentication = true
    }
    
    var isComplete: Bool {
        !warningSignals.isEmpty &&
        !copingStrategies.isEmpty &&
        !supportContacts.isEmpty &&
        !reasonsToLive.isEmpty
    }
    
    func updateModifiedDate() {
        self.lastModifiedDate = Date()
    }
}

struct CopingStrategy: Codable, Identifiable {
    var id: UUID
    var title: String
    var description: String
    var category: CopingCategory
    var order: Int
    
    init(id: UUID = UUID(), title: String, description: String, category: CopingCategory, order: Int = 0) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.order = order
    }
    
    enum CopingCategory: String, Codable, CaseIterable {
        case distraction = "Distracción"
        case grounding = "Grounding"
        case selfSoothing = "Auto-calmante"
        case physical = "Actividad Física"
        case creative = "Creatividad"
        case other = "Otro"
    }
}

struct SupportContact: Codable, Identifiable {
    var id: UUID
    var name: String
    var relationship: String
    var phone: String
    var email: String?
    var notes: String?
    var isEmergency: Bool
    var order: Int
    
    init(id: UUID = UUID(), name: String, relationship: String, phone: String, email: String? = nil, notes: String? = nil, isEmergency: Bool = false, order: Int = 0) {
        self.id = id
        self.name = name
        self.relationship = relationship
        self.phone = phone
        self.email = email
        self.notes = notes
        self.isEmergency = isEmergency
        self.order = order
    }
}

struct ProfessionalContact: Codable, Identifiable {
    var id: UUID
    var name: String
    var role: ProfessionalRole
    var organization: String?
    var phone: String
    var email: String?
    var address: String?
    var availabilityHours: String?
    var order: Int
    
    init(id: UUID = UUID(), name: String, role: ProfessionalRole, organization: String? = nil, phone: String, email: String? = nil, address: String? = nil, availabilityHours: String? = nil, order: Int = 0) {
        self.id = id
        self.name = name
        self.role = role
        self.organization = organization
        self.phone = phone
        self.email = email
        self.address = address
        self.availabilityHours = availabilityHours
        self.order = order
    }
    
    enum ProfessionalRole: String, Codable, CaseIterable {
        case therapist = "Terapeuta"
        case psychiatrist = "Psiquiatra"
        case doctor = "Médico"
        case socialWorker = "Trabajador Social"
        case counselor = "Consejero"
        case other = "Otro"
    }
}

struct EmergencyContact: Codable, Identifiable {
    var id: UUID
    var name: String
    var phone: String
    var type: EmergencyType
    var isAvailable24h: Bool
    var order: Int
    
    init(id: UUID = UUID(), name: String, phone: String, type: EmergencyType, isAvailable24h: Bool = true, order: Int = 0) {
        self.id = id
        self.name = name
        self.phone = phone
        self.type = type
        self.isAvailable24h = isAvailable24h
        self.order = order
    }
    
    enum EmergencyType: String, Codable, CaseIterable {
        case emergencyServices = "Emergencias (112)"
        case crisisHotline = "Línea de Crisis"
        case suicidePrevention = "Prevención Suicidio"
        case hospital = "Hospital"
        case other = "Otro"
    }
}

// Líneas de crisis predefinidas por país/región
struct CrisisHotline: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
    let country: String
    let isAvailable24h: Bool
    let languages: [String]
    
    static let spanish: [CrisisHotline] = [
        CrisisHotline(name: "Teléfono de la Esperanza", phone: "717003717", country: "España", isAvailable24h: true, languages: ["Español"]),
        CrisisHotline(name: "Línea de Atención al Suicidio 024", phone: "024", country: "España", isAvailable24h: true, languages: ["Español"]),
        CrisisHotline(name: "ANAR (Menores)", phone: "900202010", country: "España", isAvailable24h: true, languages: ["Español"]),
    ]
    
    static let latinAmerica: [CrisisHotline] = [
        CrisisHotline(name: "Línea de Prevención del Suicidio", phone: "018005551212", country: "México", isAvailable24h: true, languages: ["Español"]),
        CrisisHotline(name: "Centro de Atención Integral en Salud Mental", phone: "018009113200", country: "México", isAvailable24h: true, languages: ["Español"]),
    ]
}
