//
//  Constants.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation

enum Constants {
    // MARK: - App Info
    enum App {
        static let name = "Equilibra"
        static let version = "1.0.0"
        static let supportEmail = "soporte@equilibra.app"
    }
    
    // MARK: - Emergency Contacts
    enum Emergency {
        static let emergencyPhone = "112"
        static let suicidePreventionLine = "024" // Línea de atención al suicidio en España
    }
    
    // MARK: - Animation Durations
    enum Animation {
        static let short: Double = 0.2
        static let medium: Double = 0.3
        static let long: Double = 0.5
    }
    
    // MARK: - Spacing
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
    }
    
    // MARK: - URLs
    enum URLs {
        static let privacyPolicy = "https://equilibra.app/privacidad"
        static let termsOfService = "https://equilibra.app/terminos"
        static let dbtResource = "https://www.dbt-es.com/"
    }
}
