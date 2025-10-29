//
//  AccessibilityService.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

/// Servicio para gestionar configuraciones de accesibilidad
final class AccessibilityService {
    static let shared = AccessibilityService()
    
    private init() {}
    
    /// Verifica si el modo de alto contraste está activado
    var isHighContrastEnabled: Bool {
        UIAccessibility.isDarkerSystemColorsEnabled
    }
    
    /// Verifica si reduce motion está activado
    var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
    
    /// Verifica si VoiceOver está activado
    var isVoiceOverEnabled: Bool {
        UIAccessibility.isVoiceOverRunning
    }
    
    /// Tamaño de fuente preferido por el usuario
    var preferredContentSizeCategory: UIContentSizeCategory {
        UIApplication.shared.preferredContentSizeCategory
    }
    
    /// Configura hints de accesibilidad para botones críticos
    func crisisButtonAccessibility() -> (label: String, hint: String) {
        return (
            label: "Botón de crisis",
            hint: "Activa este botón si necesitas ayuda inmediata. Te mostrará herramientas de emergencia."
        )
    }
    
    /// Configura hints de accesibilidad para registro emocional
    func emotionalLogAccessibility(emotion: String, intensity: Int) -> String {
        let intensityDescription: String
        switch intensity {
        case 1...3: intensityDescription = "baja"
        case 4...6: intensityDescription = "moderada"
        case 7...8: intensityDescription = "alta"
        default: intensityDescription = "muy alta"
        }
        
        return "Registro de \(emotion) con intensidad \(intensityDescription), nivel \(intensity) de 10"
    }
}

// MARK: - View Modifiers
struct AccessibleCardModifier: ViewModifier {
    let label: String
    let hint: String?
    
    func body(content: Content) -> some View {
        content
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}

extension View {
    func accessibleCard(label: String, hint: String? = nil) -> some View {
        modifier(AccessibleCardModifier(label: label, hint: hint))
    }
}
