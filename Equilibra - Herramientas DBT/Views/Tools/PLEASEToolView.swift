//
//  PLEASEToolView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct PLEASEToolView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var entry = PLEASEEntry()
    @State private var showingMedicationReminder = false
    @State private var showingSaveConfirmation = false
    @State private var expandedSection: PLEASESection? = nil
    
    @Query(sort: \PLEASEEntry.date, order: .reverse)
    private var previousEntries: [PLEASEEntry]
    
    enum PLEASESection: String, CaseIterable {
        case physical = "Physical Illness"
        case eating = "Eating"
        case avoidSubstances = "Avoid Substances"
        case sleep = "Sleep"
        case exercise = "Exercise"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Progress Overview
                    progressSection
                    
                    // PLEASE Components
                    VStack(spacing: 12) {
                        physicalIllnessSection
                        eatingSection
                        avoidSubstancesSection
                        sleepSection
                        exerciseSection
                    }
                    
                    // Notes
                    notesSection
                    
                    // Recent Entries
                    if !previousEntries.isEmpty {
                        recentEntriesSection
                    }
                    
                    // Save Button
                    saveButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("PLEASE Skill")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingMedicationReminder.toggle()
                    } label: {
                        Image(systemName: "bell.badge")
                    }
                }
            }
            .alert("Guardado", isPresented: $showingSaveConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Tu registro PLEASE ha sido guardado exitosamente.")
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .font(.title)
                    .foregroundStyle(.green.gradient)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("PLEASE")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Cuida tu salud física para regular tus emociones")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Cuando cuidamos nuestra salud física, somos más capaces de manejar nuestras emociones.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.green.opacity(0.1))
        )
    }
    
    private var progressSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Progreso del Día")
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(entry.completionPercentage * 100))%")
                    .font(.headline)
                    .foregroundStyle(.green)
            }
            
            ProgressView(value: entry.completionPercentage)
                .tint(.green)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
    
    // MARK: - Physical Illness Section
    private var physicalIllnessSection: some View {
        PLEASECard(
            title: "Physical Illness",
            subtitle: "Trata enfermedades físicas",
            icon: "cross.case.fill",
            color: .red,
            isExpanded: expandedSection == .physical
        ) {
            expandedSection = expandedSection == .physical ? nil : .physical
        } content: {
            VStack(alignment: .leading, spacing: 12) {
                Toggle("Tomé mi medicación", isOn: $entry.tookMedication)
                    .tint(.green)
                
                if entry.tookMedication {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Detalles de medicación")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $entry.medicationNotes)
                            .frame(height: 60)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                
                Text("💡 Tip: Toma tus medicamentos según lo prescrito y consulta con tu médico cualquier molestia.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Eating Section
    private var eatingSection: some View {
        PLEASECard(
            title: "Eating",
            subtitle: "Alimentación balanceada",
            icon: "fork.knife",
            color: .orange,
            isExpanded: expandedSection == .eating
        ) {
            expandedSection = expandedSection == .eating ? nil : .eating
        } content: {
            VStack(alignment: .leading, spacing: 12) {
                Toggle("Comí de forma balanceada", isOn: $entry.ateBalanced)
                    .tint(.green)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Comidas del día: \(entry.mealsCount)")
                        .font(.subheadline)
                    
                    Stepper("", value: $entry.mealsCount, in: 0...10)
                        .labelsHidden()
                }
                
                Text("💡 Tip: Intenta comer regularmente durante el día, sin saltarte comidas. Incluye frutas y verduras.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Avoid Substances Section
    private var avoidSubstancesSection: some View {
        PLEASECard(
            title: "Avoid Substances",
            subtitle: "Evita sustancias que alteran el ánimo",
            icon: "nosign",
            color: .purple,
            isExpanded: expandedSection == .avoidSubstances
        ) {
            expandedSection = expandedSection == .avoidSubstances ? nil : .avoidSubstances
        } content: {
            VStack(alignment: .leading, spacing: 12) {
                Toggle("Evité sustancias no prescritas", isOn: $entry.avoidedSubstances)
                    .tint(.green)
                
                if !entry.avoidedSubstances {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Notas")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        TextEditor(text: $entry.substanceNotes)
                            .frame(height: 60)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                
                Text("💡 Tip: Alcohol y drogas pueden intensificar las emociones negativas. Busca alternativas saludables.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Sleep Section
    private var sleepSection: some View {
        PLEASECard(
            title: "Sleep",
            subtitle: "Dormir suficiente y bien",
            icon: "moon.stars.fill",
            color: .indigo,
            isExpanded: expandedSection == .sleep
        ) {
            expandedSection = expandedSection == .sleep ? nil : .sleep
        } content: {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Horas de sueño: \(String(format: "%.1f", entry.sleepHours))")
                        .font(.subheadline)
                    
                    Slider(value: $entry.sleepHours, in: 0...12, step: 0.5)
                        .tint(.indigo)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Calidad del sueño")
                        .font(.subheadline)
                    
                    Picker("Calidad", selection: $entry.sleepQuality) {
                        Text("Muy mala").tag(1)
                        Text("Mala").tag(2)
                        Text("Regular").tag(3)
                        Text("Buena").tag(4)
                        Text("Excelente").tag(5)
                    }
                    .pickerStyle(.segmented)
                }
                
                Text("💡 Tip: Intenta dormir 7-9 horas por noche. Mantén un horario regular y evita pantallas antes de dormir.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Exercise Section
    private var exerciseSection: some View {
        PLEASECard(
            title: "Exercise",
            subtitle: "Actividad física regular",
            icon: "figure.run",
            color: .cyan,
            isExpanded: expandedSection == .exercise
        ) {
            expandedSection = expandedSection == .exercise ? nil : .exercise
        } content: {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Minutos de ejercicio: \(entry.exerciseMinutes)")
                        .font(.subheadline)
                    
                    Slider(value: Binding(
                        get: { Double(entry.exerciseMinutes) },
                        set: { entry.exerciseMinutes = Int($0) }
                    ), in: 0...180, step: 5)
                    .tint(.cyan)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tipo de ejercicio")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    TextField("Ej: Caminar, yoga, natación", text: $entry.exerciseType)
                        .textFieldStyle(.roundedBorder)
                }
                
                Text("💡 Tip: Incluso 20 minutos de actividad pueden mejorar tu estado de ánimo. Elige algo que disfrutes.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Notas Adicionales")
                .font(.headline)
            
            TextEditor(text: $entry.notes)
                .frame(height: 100)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
    
    // MARK: - Recent Entries
    private var recentEntriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Registros Recientes")
                .font(.headline)
            
            ForEach(previousEntries.prefix(3)) { previousEntry in
                PLEASEHistoryCard(entry: previousEntry)
            }
        }
    }
    
    // MARK: - Save Button
    private var saveButton: some View {
        Button {
            saveEntry()
        } label: {
            Text("Guardar Registro")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.green.gradient)
                )
        }
    }
    
    private func saveEntry() {
        modelContext.insert(entry)
        showingSaveConfirmation = true
    }
}

// MARK: - PLEASE Card Component
struct PLEASECard<Content: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let isExpanded: Bool
    let toggleAction: () -> Void
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: toggleAction) {
                HStack {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(color)
                        .frame(width: 40)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)
                        
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .imageScale(.small)
                }
                .padding()
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
        .animation(.spring(response: 0.3), value: isExpanded)
    }
}

// MARK: - History Card
struct PLEASEHistoryCard: View {
    let entry: PLEASEEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(entry.completionPercentage * 100))%")
                    .font(.subheadline)
                    .foregroundStyle(.green)
            }
            
            ProgressView(value: entry.completionPercentage)
                .tint(.green)
            
            HStack(spacing: 12) {
                if entry.tookMedication {
                    Label("Med", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                if entry.ateBalanced {
                    Label("Comida", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                if entry.sleepHours >= 6 {
                    Label("Sueño", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
                
                if entry.exerciseMinutes >= 20 {
                    Label("Ejercicio", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    PLEASEToolView()
        .modelContainer(for: PLEASEEntry.self)
}
