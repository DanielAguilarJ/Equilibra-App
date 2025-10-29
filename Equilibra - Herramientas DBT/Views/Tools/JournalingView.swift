//
//  JournalingView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct JournalingView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: JournalingViewModel
    @State private var showingNewEntry = false
    @State private var showingFilters = false
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: JournalingViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.filteredEntries.isEmpty {
                    emptyStateView
                } else {
                    entriesList
                }
            }
            .navigationTitle("Mi Diario")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingFilters.toggle() }) {
                        Label("Filtros", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewEntry = true }) {
                        Label("Nueva Entrada", systemImage: "square.and.pencil")
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Buscar en entradas...")
            .onChange(of: viewModel.searchText) { _, _ in
                viewModel.applyFilters()
            }
            .sheet(isPresented: $showingNewEntry) {
                NewJournalEntryView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilters) {
                JournalFiltersView(viewModel: viewModel)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var entriesList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                // Estadísticas resumidas
                statsCard
                
                // Lista de entradas
                ForEach(viewModel.filteredEntries) { entry in
                    NavigationLink(destination: JournalEntryDetailView(entry: entry, viewModel: viewModel)) {
                        JournalEntryCard(entry: entry, viewModel: viewModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
    
    private var statsCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                StatItem(
                    icon: "book.fill",
                    value: "\(viewModel.entries.count)",
                    label: "Entradas"
                )
                
                Divider()
                
                StatItem(
                    icon: "text.word.spacing",
                    value: "\(viewModel.getTotalWordCount())",
                    label: "Palabras"
                )
                
                Divider()
                
                StatItem(
                    icon: "chart.line.uptrend.xyaxis",
                    value: String(format: "%.1f", viewModel.getAverageMoodImprovement()),
                    label: "Mejora"
                )
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 70))
                .foregroundColor(.secondary)
            
            Text("Tu Diario Está Vacío")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Comienza a escribir sobre tus pensamientos y emociones")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: { showingNewEntry = true }) {
                Label("Crear Primera Entrada", systemImage: "square.and.pencil")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
            }
            .padding(.top)
        }
        .padding()
    }
}

// MARK: - Supporting Views

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    let viewModel: JournalingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if entry.isFavorite {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
                
                if entry.isEncrypted {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.accentColor)
                        .font(.caption)
                }
            }
            
            // Preview del contenido
            Text(viewModel.getDecryptedContent(for: entry))
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            // Tags emocionales
            if !entry.emotionalTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(entry.emotionalTags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Mood indicator
            if let improvement = entry.moodImprovement {
                HStack(spacing: 4) {
                    Image(systemName: improvement >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(improvement >= 0 ? .green : .orange)
                    
                    Text("Ánimo: \(improvement > 0 ? "+" : "")\(improvement)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(entry.wordCount) palabras")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
    
    return JournalingView(modelContext: container.mainContext)
}
