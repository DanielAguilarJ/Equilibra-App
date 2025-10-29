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
final class CrisisPlan {
    var id: UUID
    var createdDate: Date
    var warningSignals: [String]
    var copingStrategies: [String]
    var supportContacts: [CrisisSupportContact]
    var safeEnvironmentSteps: [String]
    var professionalContacts: [String]
    var isActive: Bool
    
    init() {
        self.id = UUID()
        self.createdDate = Date()
        self.warningSignals = []
        self.copingStrategies = []
        self.supportContacts = []
        self.safeEnvironmentSteps = []
        self.professionalContacts = []
        self.isActive = true
    }
}

struct CrisisSupportContact: Codable {
    var name: String
    var relationship: String
    var phone: String
    var isEmergency: Bool
}
