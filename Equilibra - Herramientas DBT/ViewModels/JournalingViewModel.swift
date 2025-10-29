//
//  JournalingViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
final class JournalingViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var filteredEntries: [JournalEntry] = []
    @Published var searchText: String = ""
    @Published var selectedTags: Set<String> = []
    @Published var selectedMoodRange: ClosedRange<Double>? = nil
    @Published var showFavoritesOnly: Bool = false
    @Published var sortOption: SortOption = .dateDescending
    
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let modelContext: ModelContext
    private let encryptionService = EncryptionService.shared
    private let promptsService = JournalingPromptsService.shared
    
    enum SortOption: String, CaseIterable {
        case dateDescending = "Más recientes"
        case dateAscending = "Más antiguos"
        case titleAscending = "Título A-Z"
        case wordCountDescending = "Más extensos"
        case moodImprovement = "Mayor mejora de ánimo"
        
        func sort(_ entries: [JournalEntry]) -> [JournalEntry] {
            switch self {
            case .dateDescending:
                return entries.sorted { $0.date > $1.date }
            case .dateAscending:
                return entries.sorted { $0.date < $1.date }
            case .titleAscending:
                return entries.sorted { $0.title < $1.title }
            case .wordCountDescending:
                return entries.sorted { $0.wordCount > $1.wordCount }
            case .moodImprovement:
                return entries.sorted { (e1, e2) in
                    let imp1 = e1.moodImprovement ?? Int.min
                    let imp2 = e2.moodImprovement ?? Int.min
                    return imp1 > imp2
                }
            }
        }
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadEntries()
    }
    
    // MARK: - Data Loading
    
    func loadEntries() {
        let descriptor = FetchDescriptor<JournalEntry>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        
        do {
            entries = try modelContext.fetch(descriptor)
            applyFilters()
        } catch {
            errorMessage = "Error al cargar entradas: \(error.localizedDescription)"
        }
    }
    
    // MARK: - CRUD Operations
    
    func createEntry(
        title: String,
        content: String,
        emotionalTags: [String],
        promptsUsed: [String],
        preWritingMood: Int,
        postWritingMood: Int?,
        encrypt: Bool
    ) {
        let entry = JournalEntry(
            title: title,
            content: encrypt ? "" : content,
            emotionalTags: emotionalTags,
            promptsUsed: promptsUsed,
            preWritingMood: preWritingMood,
            postWritingMood: postWritingMood
        )
        
        if encrypt {
            do {
                entry.encryptedContent = try encryptionService.encrypt(content)
                entry.isEncrypted = true
            } catch {
                errorMessage = "Error al encriptar: \(error.localizedDescription)"
                return
            }
        }
        
        modelContext.insert(entry)
        saveContext()
        loadEntries()
    }
    
    func updateEntry(
        _ entry: JournalEntry,
        title: String,
        content: String,
        emotionalTags: [String],
        postWritingMood: Int?,
        encrypt: Bool
    ) {
        entry.title = title
        entry.emotionalTags = emotionalTags
        entry.postWritingMood = postWritingMood
        
        if encrypt {
            do {
                entry.encryptedContent = try encryptionService.encrypt(content)
                entry.isEncrypted = true
                entry.content = ""
            } catch {
                errorMessage = "Error al encriptar: \(error.localizedDescription)"
                return
            }
        } else {
            entry.content = content
            entry.encryptedContent = nil
            entry.isEncrypted = false
        }
        
        entry.updateWordCount()
        saveContext()
        loadEntries()
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        modelContext.delete(entry)
        saveContext()
        loadEntries()
    }
    
    func toggleFavorite(_ entry: JournalEntry) {
        entry.isFavorite.toggle()
        saveContext()
        applyFilters()
    }
    
    func getDecryptedContent(for entry: JournalEntry) -> String {
        if entry.isEncrypted, let encrypted = entry.encryptedContent {
            do {
                return try encryptionService.decrypt(encrypted)
            } catch {
                return "Error al desencriptar el contenido"
            }
        }
        return entry.content
    }
    
    // MARK: - Filtering & Search
    
    func applyFilters() {
        var result = entries
        
        // Búsqueda de texto
        if !searchText.isEmpty {
            result = result.filter { entry in
                let content = getDecryptedContent(for: entry)
                return entry.title.localizedCaseInsensitiveContains(searchText) ||
                       content.localizedCaseInsensitiveContains(searchText) ||
                       entry.emotionalTags.contains(where: { $0.localizedCaseInsensitiveContains(searchText) })
            }
        }
        
        // Filtro de tags
        if !selectedTags.isEmpty {
            result = result.filter { entry in
                !Set(entry.emotionalTags).isDisjoint(with: selectedTags)
            }
        }
        
        // Filtro de rango de ánimo
        if let moodRange = selectedMoodRange {
            result = result.filter { entry in
                let mood = Double(entry.preWritingMood)
                return moodRange.contains(mood)
            }
        }
        
        // Filtro de favoritos
        if showFavoritesOnly {
            result = result.filter { $0.isFavorite }
        }
        
        // Aplicar ordenamiento
        filteredEntries = sortOption.sort(result)
    }
    
    func clearFilters() {
        searchText = ""
        selectedTags.removeAll()
        selectedMoodRange = nil
        showFavoritesOnly = false
        applyFilters()
    }
    
    // MARK: - Analytics
    
    func getAllTags() -> [String] {
        let allTags = entries.flatMap { $0.emotionalTags }
        return Array(Set(allTags)).sorted()
    }
    
    func getTagFrequency() -> [String: Int] {
        let allTags = entries.flatMap { $0.emotionalTags }
        return Dictionary(grouping: allTags) { $0 }.mapValues { $0.count }
    }
    
    func getTopTags(limit: Int = 10) -> [(tag: String, count: Int)] {
        let frequency = getTagFrequency()
        return frequency.sorted { $0.value > $1.value }.prefix(limit).map { ($0.key, $0.value) }
    }
    
    func getAverageMoodImprovement() -> Double {
        let improvements = entries.compactMap { $0.moodImprovement }
        guard !improvements.isEmpty else { return 0 }
        return Double(improvements.reduce(0, +)) / Double(improvements.count)
    }
    
    func getEntriesGroupedByMonth() -> [(month: String, entries: [JournalEntry])] {
        let grouped = Dictionary(grouping: entries) { entry in
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: entry.date)
        }
        
        return grouped.sorted { $0.key > $1.key }.map { ($0.key, $0.value) }
    }
    
    func getTotalWordCount() -> Int {
        entries.reduce(0) { $0 + $1.wordCount }
    }
    
    // MARK: - Export
    
    func exportToPDF(entries: [JournalEntry]) -> Data? {
        // TODO: Implementar generación de PDF
        // Por ahora retorna nil, se puede implementar con PDFKit
        return nil
    }
    
    // MARK: - Private Methods
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            errorMessage = "Error al guardar: \(error.localizedDescription)"
        }
    }
}
