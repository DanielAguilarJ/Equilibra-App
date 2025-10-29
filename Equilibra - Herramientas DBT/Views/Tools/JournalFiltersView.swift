//
//  JournalFiltersView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct JournalFiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalingViewModel
    
    @State private var localSelectedTags: Set<String>
    @State private var localShowFavorites: Bool
    @State private var localSortOption: JournalingViewModel.SortOption
    @State private var localMoodRange: ClosedRange<Double>?
    
    init(viewModel: JournalingViewModel) {
        self.viewModel = viewModel
        _localSelectedTags = State(initialValue: viewModel.selectedTags)
        _localShowFavorites = State(initialValue: viewModel.showFavoritesOnly)
        _localSortOption = State(initialValue: viewModel.sortOption)
        _localMoodRange = State(initialValue: viewModel.selectedMoodRange)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Sort options
                Section("Ordenar Por") {
                    Picker("Ordenamiento", selection: $localSortOption) {
                        ForEach(JournalingViewModel.SortOption.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                }
                
                // Favorites filter
                Section {
                    Toggle("Solo Favoritos", isOn: $localShowFavorites)
                }
                
                // Mood filter
                Section("Filtrar por Ánimo") {
                    Toggle("Activar filtro de ánimo", isOn: Binding(
                        get: { localMoodRange != nil },
                        set: { isOn in
                            if isOn {
                                localMoodRange = 1...10
                            } else {
                                localMoodRange = nil
                            }
                        }
                    ))
                    
                    if localMoodRange != nil {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Rango: \(Int(localMoodRange!.lowerBound)) - \(Int(localMoodRange!.upperBound))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                            
                            // Custom range slider (simplified)
                            VStack(spacing: 8) {
                                HStack {
                                    Text("Mínimo: \(Int(localMoodRange!.lowerBound))")
                                        .font(.caption)
                                    Spacer()
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { localMoodRange!.lowerBound },
                                        set: { newValue in
                                            let upper = localMoodRange!.upperBound
                                            localMoodRange = min(newValue, upper - 1)...upper
                                        }
                                    ),
                                    in: 1...9,
                                    step: 1
                                )
                                
                                HStack {
                                    Text("Máximo: \(Int(localMoodRange!.upperBound))")
                                        .font(.caption)
                                    Spacer()
                                }
                                
                                Slider(
                                    value: Binding(
                                        get: { localMoodRange!.upperBound },
                                        set: { newValue in
                                            let lower = localMoodRange!.lowerBound
                                            localMoodRange = lower...max(newValue, lower + 1)
                                        }
                                    ),
                                    in: 2...10,
                                    step: 1
                                )
                            }
                        }
                    }
                }
                
                // Tags filter
                Section("Filtrar por Emociones") {
                    let allTags = viewModel.getAllTags()
                    
                    if allTags.isEmpty {
                        Text("No hay etiquetas disponibles")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(allTags, id: \.self) { tag in
                            Toggle(tag, isOn: Binding(
                                get: { localSelectedTags.contains(tag) },
                                set: { isSelected in
                                    if isSelected {
                                        localSelectedTags.insert(tag)
                                    } else {
                                        localSelectedTags.remove(tag)
                                    }
                                }
                            ))
                        }
                    }
                }
                
                // Active filters summary
                if hasActiveFilters {
                    Section {
                        Button(role: .destructive, action: clearAllFilters) {
                            Label("Limpiar Todos los Filtros", systemImage: "xmark.circle")
                        }
                    }
                }
            }
            .navigationTitle("Filtros")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Aplicar") {
                        applyFilters()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var hasActiveFilters: Bool {
        localShowFavorites || !localSelectedTags.isEmpty || localMoodRange != nil
    }
    
    private func applyFilters() {
        viewModel.selectedTags = localSelectedTags
        viewModel.showFavoritesOnly = localShowFavorites
        viewModel.sortOption = localSortOption
        viewModel.selectedMoodRange = localMoodRange
        viewModel.applyFilters()
    }
    
    private func clearAllFilters() {
        localSelectedTags.removeAll()
        localShowFavorites = false
        localMoodRange = nil
        localSortOption = .dateDescending
    }
}

#Preview {
    JournalFiltersView(viewModel: JournalingViewModel(modelContext: ModelContext(try! ModelContainer(for: JournalEntry.self))))
}
