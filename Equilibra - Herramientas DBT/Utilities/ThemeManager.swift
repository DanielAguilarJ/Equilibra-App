//
//  ThemeManager.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import Combine

/// Gestor de temas y colores de la aplicación
final class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @AppStorage("selectedTheme") private var selectedTheme: String = "system"
    @Published var currentTheme: Theme = .system
    
    enum Theme: String, CaseIterable {
        case light = "light"
        case dark = "dark"
        case system = "system"
        
        var displayName: String {
            switch self {
            case .light: return "Claro"
            case .dark: return "Oscuro"
            case .system: return "Sistema"
            }
        }
        
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
    }
    
    private init() {
        if let theme = Theme(rawValue: selectedTheme) {
            currentTheme = theme
        }
    }
    
    func setTheme(_ theme: Theme) {
        currentTheme = theme
        selectedTheme = theme.rawValue
    }
}

// MARK: - Color Extensions
extension Color {
    // Colores para módulos DBT
    static let mindfulnessColor = Color.purple
    static let emotionalRegulationColor = Color.blue
    static let interpersonalColor = Color.green
    static let distressToleranceColor = Color.orange
    
    // Colores para intensidad emocional
    static let lowIntensity = Color.green
    static let mediumIntensity = Color.yellow
    static let highIntensity = Color.orange
    static let veryHighIntensity = Color.red
    
    // Colores de la app
    static let primaryBackground = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let tertiaryBackground = Color(.tertiarySystemBackground)
}

// MARK: - Theme View Modifier
struct ThemedView: ViewModifier {
    @ObservedObject var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

extension View {
    func themed() -> some View {
        modifier(ThemedView())
    }
}
