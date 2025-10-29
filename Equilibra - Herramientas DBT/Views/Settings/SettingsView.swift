//
//  SettingsView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    @State private var showingAbout = false
    @State private var notificationsEnabled = true
    @State private var reminderTime = Date()
    
    var body: some View {
        NavigationStack {
            List {
                // Appearance section
                Section("Apariencia") {
                    Picker("Tema", selection: $themeManager.currentTheme) {
                        ForEach(ThemeManager.Theme.allCases, id: \.self) { theme in
                            Text(theme.displayName).tag(theme)
                        }
                    }
                    .onChange(of: themeManager.currentTheme) { _, newValue in
                        themeManager.setTheme(newValue)
                    }
                }
                
                // Notifications section
                Section("Recordatorios") {
                    Toggle("Recordatorios diarios", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        DatePicker(
                            "Hora del recordatorio",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
                
                // Accessibility section
                Section("Accesibilidad") {
                    NavigationLink("Opciones de accesibilidad") {
                        AccessibilitySettingsView()
                    }
                }
                
                // Support section
                Section("Soporte") {
                    NavigationLink("Recursos DBT") {
                        ResourcesView()
                    }
                    
                    Button(action: {
                        if let url = URL(string: "mailto:\(Constants.App.supportEmail)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Text("Contactar soporte")
                            Spacer()
                            Image(systemName: "envelope")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink("Líneas de ayuda") {
                        SettingsEmergencyContactsView()
                    }
                }
                
                // About section
                Section("Acerca de") {
                    HStack {
                        Text("Versión")
                        Spacer()
                        Text(Constants.App.version)
                            .foregroundStyle(.secondary)
                    }
                    
                    Button("Acerca de Equilibra") {
                        showingAbout = true
                    }
                    
                    Link("Política de privacidad", destination: URL(string: Constants.URLs.privacyPolicy)!)
                    Link("Términos de servicio", destination: URL(string: Constants.URLs.termsOfService)!)
                }
                
                // Data section
                Section("Datos") {
                    Button(role: .destructive) {
                        // TODO: Implement data export
                    } label: {
                        Text("Exportar datos")
                    }
                    
                    Button(role: .destructive) {
                        // TODO: Implement data deletion with confirmation
                    } label: {
                        Text("Eliminar todos los datos")
                    }
                }
            }
            .navigationTitle("Ajustes")
            .sheet(isPresented: $showingAbout) {
                AboutView()
            }
        }
    }
}

// MARK: - Accessibility Settings View
struct AccessibilitySettingsView: View {
    let accessibilityService = AccessibilityService.shared
    
    var body: some View {
        List {
            Section("Estado del sistema") {
                HStack {
                    Text("VoiceOver")
                    Spacer()
                    Text(accessibilityService.isVoiceOverEnabled ? "Activado" : "Desactivado")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Reducir movimiento")
                    Spacer()
                    Text(accessibilityService.isReduceMotionEnabled ? "Activado" : "Desactivado")
                        .foregroundStyle(.secondary)
                }
                
                HStack {
                    Text("Alto contraste")
                    Spacer()
                    Text(accessibilityService.isHighContrastEnabled ? "Activado" : "Desactivado")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Text("Estas opciones se configuran desde Ajustes del sistema > Accesibilidad")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Accesibilidad")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Resources View
struct ResourcesView: View {
    var body: some View {
        List {
            Section("¿Qué es la DBT?") {
                Text("La Terapia Dialéctico-Conductual (DBT) es un tratamiento basado en evidencia desarrollado específicamente para personas con desregulación emocional intensa.")
                    .font(.body)
            }
            
            Section("Recursos externos") {
                Link(destination: URL(string: Constants.URLs.dbtResource)!) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("DBT en Español")
                                .font(.headline)
                            Text("Información sobre DBT")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.forward.square")
                    }
                }
            }
            
            Section("Los 4 Módulos") {
                ModuleInfoRow(
                    title: "Mindfulness",
                    description: "Aprender a estar presente y consciente",
                    icon: "brain.head.profile",
                    color: .purple
                )
                
                ModuleInfoRow(
                    title: "Regulación Emocional",
                    description: "Comprender y manejar las emociones",
                    icon: "heart.circle.fill",
                    color: .blue
                )
                
                ModuleInfoRow(
                    title: "Eficacia Interpersonal",
                    description: "Mejorar relaciones y comunicación",
                    icon: "person.2.fill",
                    color: .green
                )
                
                ModuleInfoRow(
                    title: "Tolerancia al Malestar",
                    description: "Sobrevivir a situaciones de crisis",
                    icon: "shield.fill",
                    color: .orange
                )
            }
        }
        .navigationTitle("Recursos DBT")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ModuleInfoRow: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Emergency Contacts View
private struct SettingsEmergencyContactsView: View {
    var body: some View {
        List {
            Section("España") {
                EmergencyContactRow(
                    title: "Emergencias",
                    number: Constants.Emergency.emergencyPhone,
                    description: "Policía, bomberos, ambulancia"
                )
                
                EmergencyContactRow(
                    title: "Línea de Atención al Suicidio",
                    number: Constants.Emergency.suicidePreventionLine,
                    description: "Disponible 24/7, gratuita"
                )
            }
            
            Section {
                Text("Si estás en peligro inmediato, llama al 112")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Líneas de Ayuda")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EmergencyContactRow: View {
    let title: String
    let number: String
    let description: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: "tel://\(number)") {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Text(number)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.blue)
            }
        }
    }
}

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App icon and name
                    VStack(spacing: 12) {
                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(.blue)
                        
                        Text(Constants.App.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Versión \(Constants.App.version)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Acerca de la App")
                            .font(.headline)
                        
                        Text("Equilibra es una aplicación diseñada para apoyar a personas que practican la Terapia Dialéctico-Conductual (DBT). Proporciona herramientas para registrar emociones, aprender habilidades y gestionar situaciones de crisis.")
                            .font(.body)
                        
                        Text("Esta aplicación NO sustituye el tratamiento profesional. Si estás en crisis, busca ayuda profesional inmediata.")
                            .font(.caption)
                            .foregroundStyle(.red)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    // Credits
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Desarrollado con ❤️")
                            .font(.headline)
                        
                        Text("Para personas en su camino de recuperación emocional")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Acerca de")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
