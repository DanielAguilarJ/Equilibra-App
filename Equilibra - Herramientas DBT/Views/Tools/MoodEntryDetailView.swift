//
//  MoodEntryDetailView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct MoodEntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let entry: MoodEntry
    @Bindable var viewModel: MoodTrackingViewModel
    @State private var showingDeleteAlert = false
    @State private var wasEffectiveSelection: Bool?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header with emotion
                    headerSection
                    
                    // Intensity display
                    intensitySection
                    
                    // Triggers
                    if !entry.triggers.isEmpty {
                        triggersSection
                    }
                    
                    // Coping strategies
                    if !entry.copingStrategies.isEmpty {
                        strategiesSection
                    }
                    
                    // Notes
                    if !entry.notes.isEmpty {
                        notesSection
                    }
                    
                    // Effectiveness feedback
                    effectivenessSection
                    
                    // Metadata
                    metadataSection
                    
                    // Delete button
                    deleteButton
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Detalle de Registro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .alert("Eliminar Registro", isPresented: $showingDeleteAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Eliminar", role: .destructive) {
                    viewModel.deleteEntry(entry)
                    dismiss()
                }
            } message: {
                Text("¿Estás seguro de que quieres eliminar este registro? Esta acción no se puede deshacer.")
            }
        }
        .onAppear {
            wasEffectiveSelection = entry.wasEffective
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            Text(entry.emotionType.emoji)
                .font(.system(size: 80))
            
            Text(entry.emotionType.rawValue)
                .font(.title)
                .fontWeight(.bold)
            
            Text(entry.formattedTime)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(emotionColor.opacity(0.1))
        )
    }
    
    // MARK: - Intensity Section
    private var intensitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Intensidad")
                    .font(.headline)
                
                Spacer()
                
                Text("\(entry.intensity)/10")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(intensityColor)
            }
            
            // Visual intensity bar
            HStack(spacing: 4) {
                ForEach(1...10, id: \.self) { level in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(level <= entry.intensity ? intensityColor : Color.gray.opacity(0.2))
                        .frame(height: 12)
                }
            }
            
            Text(entry.intensityLevel.rawValue)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Triggers Section
    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Desencadenantes", systemImage: "bolt.fill")
                .font(.headline)
                .foregroundStyle(.orange)
            
            ForEach(entry.triggers, id: \.self) { trigger in
                HStack {
                    Circle()
                        .fill(.orange)
                        .frame(width: 6, height: 6)
                    
                    Text(trigger)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Strategies Section
    private var strategiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Estrategias Utilizadas", systemImage: "checkmark.seal.fill")
                .font(.headline)
                .foregroundStyle(.green)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {
                ForEach(entry.copingStrategies, id: \.self) { strategy in
                    HStack(spacing: 8) {
                        Image(systemName: strategy.icon)
                            .font(.caption)
                        
                        Text(strategy.rawValue)
                            .font(.caption)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.1))
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Notes Section
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Notas", systemImage: "note.text")
                .font(.headline)
            
            Text(entry.notes)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Effectiveness Section
    private var effectivenessSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿Las estrategias fueron efectivas?")
                .font(.headline)
            
            HStack(spacing: 16) {
                Button(action: {
                    wasEffectiveSelection = true
                    entry.wasEffective = true
                    try? modelContext.save()
                }) {
                    Label("Sí", systemImage: "hand.thumbsup.fill")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(wasEffectiveSelection == true ? Color.green.opacity(0.2) : Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(wasEffectiveSelection == true ? Color.green : Color.clear, lineWidth: 2)
                                )
                        )
                        .foregroundStyle(wasEffectiveSelection == true ? .green : .primary)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    wasEffectiveSelection = false
                    entry.wasEffective = false
                    try? modelContext.save()
                }) {
                    Label("No", systemImage: "hand.thumbsdown.fill")
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(wasEffectiveSelection == false ? Color.red.opacity(0.2) : Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(wasEffectiveSelection == false ? Color.red : Color.clear, lineWidth: 2)
                                )
                        )
                        .foregroundStyle(wasEffectiveSelection == false ? .red : .primary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Metadata Section
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información Adicional")
                .font(.headline)
            
            VStack(spacing: 8) {
                MoodInfoRow(
                    icon: "calendar",
                    label: "Fecha de creación",
                    value: entry.formattedTime
                )
                
                if entry.healthKitSynced {
                    MoodInfoRow(
                        icon: "heart.fill",
                        label: "Sincronizado con Health",
                        value: "Sí"
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    
    // MARK: - Delete Button
    private var deleteButton: some View {
        Button(action: {
            showingDeleteAlert = true
        }) {
            Label("Eliminar Registro", systemImage: "trash.fill")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.red.opacity(0.1))
                )
                .foregroundStyle(.red)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Computed Properties
    private var emotionColor: Color {
        switch entry.emotionType.color {
        case "yellow": return .yellow
        case "blue": return .blue
        case "red": return .red
        case "purple": return .purple
        case "orange": return .orange
        case "gray": return .gray
        case "green": return .green
        case "pink": return .pink
        default: return .blue
        }
    }
    
    private var intensityColor: Color {
        switch entry.intensity {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
}

// MARK: - Supporting Views
private struct MoodInfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: MoodEntry.self, configurations: config)
    
    let strategies: [MoodCopingStrategy] = [.mindfulness, .deepBreathing]
    let sampleEntry = MoodEntry(
        emotionType: .joy,
        intensity: 7,
        triggers: ["Conversación positiva", "Buen día en el trabajo"],
        copingStrategies: strategies,
        notes: "Me sentí muy bien hoy después de practicar mindfulness por la mañana."
    )
    
    container.mainContext.insert(sampleEntry)
    
    return MoodEntryDetailView(entry: sampleEntry, viewModel: MoodTrackingViewModel())
        .modelContainer(container)
}
