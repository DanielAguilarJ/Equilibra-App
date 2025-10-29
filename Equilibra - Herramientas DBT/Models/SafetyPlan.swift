//
//  SafetyPlan.swift
//  Equilibra - Herramientas DBT
//
//  Modelo para Plan de Seguridad Personal
//

import Foundation
import SwiftData

/// Plan de seguridad personal para manejar crisis
@Model
final class SafetyPlan {
    var id: UUID
    var createdDate: Date
    var modifiedDate: Date
    
    // Señales de advertencia
    var warningSignals: [String]
    
    // Estrategias de afrontamiento
    var copingStrategies: [SafetyCopingStrategy]
    
    // Contactos de apoyo
    var supportContacts: [SupportContact]
    
    // Contactos de emergencia
    var emergencyContacts: [EmergencyContact]
    
    // Pasos para hacer el entorno seguro
    var safeEnvironmentSteps: [String]
    
    // Contactos profesionales
    var professionalContacts: [ProfessionalContact]
    
    // Razones para vivir
    var reasonsToLive: [String]
    
    // Estado activo
    var isActive: Bool
    
    // Requiere autenticación
    var requiresAuthentication: Bool
    
    // Plan completado
    var isComplete: Bool
    
    init() {
        self.id = UUID()
        self.createdDate = Date()
        self.modifiedDate = Date()
        self.warningSignals = []
        self.copingStrategies = []
        self.supportContacts = []
        self.emergencyContacts = []
        self.safeEnvironmentSteps = []
        self.professionalContacts = []
        self.reasonsToLive = []
        self.isActive = true
        self.requiresAuthentication = false
        self.isComplete = false
    }
    
    func updateModifiedDate() {
        self.modifiedDate = Date()
    }
}

/// Estrategia de afrontamiento para el plan de seguridad
struct SafetyCopingStrategy: Codable, Identifiable {
    var id: UUID
    var title: String
    var description: String
    var category: CopingCategory
    var timesUsed: Int
    var effectiveness: Int? // 1-10
    var order: Int
    
    init(
        title: String = "",
        description: String = "",
        category: CopingCategory = .distraction,
        timesUsed: Int = 0,
        effectiveness: Int? = nil,
        order: Int = 0
    ) {
        self.id = UUID()
        self.title = title
        self.description = description
        self.category = category
        self.timesUsed = timesUsed
        self.effectiveness = effectiveness
        self.order = order
    }
}

/// Categorías de estrategias de afrontamiento
enum CopingCategory: String, Codable, CaseIterable {
    case distraction = "Distracción"
    case grounding = "Anclaje"
    case breathing = "Respiración"
    case movement = "Movimiento"
    case social = "Social"
    case creative = "Creativo"
    case sensory = "Sensorial"
    case other = "Otro"
    
    var icon: String {
        switch self {
        case .distraction: return "gamecontroller.fill"
        case .grounding: return "tree.fill"
        case .breathing: return "wind"
        case .movement: return "figure.walk"
        case .social: return "person.2.fill"
        case .creative: return "paintbrush.fill"
        case .sensory: return "hand.tap.fill"
        case .other: return "star.fill"
        }
    }
    
    var color: String {
        switch self {
        case .distraction: return "blue"
        case .grounding: return "green"
        case .breathing: return "cyan"
        case .movement: return "orange"
        case .social: return "pink"
        case .creative: return "purple"
        case .sensory: return "indigo"
        case .other: return "gray"
        }
    }
}

/// Contacto de emergencia
struct EmergencyContact: Codable, Identifiable {
    enum EmergencyType: String, Codable, CaseIterable {
        case crisisHotline = "Línea de Crisis"
        case hospital = "Hospital"
        case emergencyServices = "Servicios de Emergencia"
        case other = "Otro"
    }
    
    var id: UUID
    var name: String
    var relationship: String
    var phone: String
    var notes: String
    var type: EmergencyType
    var isAvailable24h: Bool
    var order: Int
    
    init(
        name: String = "",
        relationship: String = "",
        phone: String = "",
        notes: String = "",
        type: EmergencyType = .other,
        isAvailable24h: Bool = false,
        order: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.relationship = relationship
        self.phone = phone
        self.notes = notes
        self.type = type
        self.isAvailable24h = isAvailable24h
        self.order = order
    }
}

/// Contacto profesional
struct ProfessionalContact: Codable, Identifiable {
    enum ProfessionalRole: String, Codable, CaseIterable {
        case therapist = "Terapeuta"
        case psychiatrist = "Psiquiatra"
        case psychologist = "Psicólogo/a"
        case socialWorker = "Trabajador/a Social"
        case counselor = "Consejero/a"
        case other = "Otro"
    }
    
    var id: UUID
    var name: String
    var role: ProfessionalRole
    var organization: String?
    var phone: String
    var email: String?
    var availabilityHours: String?
    var notes: String?
    var order: Int
    
    init(
        name: String = "",
        role: ProfessionalRole = .other,
        organization: String? = nil,
        phone: String = "",
        email: String? = nil,
        availabilityHours: String? = nil,
        notes: String? = nil,
        order: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.role = role
        self.organization = organization
        self.phone = phone
        self.email = email
        self.availabilityHours = availabilityHours
        self.notes = notes
        self.order = order
    }
}

/// Contacto de apoyo
struct SupportContact: Codable, Identifiable {
    var id: UUID
    var name: String
    var relationship: String
    var phone: String
    var notes: String?
    var order: Int
    
    init(
        name: String = "",
        relationship: String = "",
        phone: String = "",
        notes: String? = nil,
        order: Int = 0
    ) {
        self.id = UUID()
        self.name = name
        self.relationship = relationship
        self.phone = phone
        self.notes = notes
        self.order = order
    }
}

/// Línea de ayuda en crisis
struct CrisisHotline: Identifiable, Codable {
    let id: UUID
    let name: String
    let phone: String
    let country: String
    let isAvailable24h: Bool
    let description: String
    
    init(
        name: String,
        phone: String,
        country: String,
        isAvailable24h: Bool = true,
        description: String
    ) {
        self.id = UUID()
        self.name = name
        self.phone = phone
        self.country = country
        self.isAvailable24h = isAvailable24h
        self.description = description
    }
    
    static let defaultHotlines = [
        CrisisHotline(
            name: "Línea de la Vida",
            phone: "800-273-8255",
            country: "México",
            isAvailable24h: true,
            description: "Prevención del suicidio 24/7"
        ),
        CrisisHotline(
            name: "SAPTEL",
            phone: "55-5259-8121",
            country: "México",
            isAvailable24h: true,
            description: "Sistema de apoyo psicológico por teléfono"
        ),
        CrisisHotline(
            name: "Consejo Ciudadano",
            phone: "55-5533-5533",
            country: "México",
            isAvailable24h: true,
            description: "Apoyo en situaciones de crisis"
        ),
        CrisisHotline(
            name: "Emergency Services",
            phone: "911",
            country: "General",
            isAvailable24h: true,
            description: "Servicios de emergencia"
        )
    ]
    
    static let spanish = defaultHotlines
}
