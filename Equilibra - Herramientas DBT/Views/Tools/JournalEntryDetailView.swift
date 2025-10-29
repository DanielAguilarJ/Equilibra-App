//
//  JournalEntryDetailView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct JournalEntryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let entry: JournalEntry
    @ObservedObject var viewModel: JournalingViewModel
    
    @State private var isEditing = false
    @State private var editTitle: String
    @State private var editContent: String
    @State private var editTags: [String]
    @State private var editPostMood: Double?
    @State private var showingDeleteAlert = false
    @State private var showingShareSheet = false
    
    init(entry: JournalEntry, viewModel: JournalingViewModel) {
        self.entry = entry
        self.viewModel = viewModel
        _editTitle = State(initialValue: entry.title)
        _editContent = State(initialValue: viewModel.getDecryptedContent(for: entry))
        _editTags = State(initialValue: entry.emotionalTags)
        _editPostMood = State(initialValue: entry.postWritingMood.map { Double($0) })
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isEditing {
                    editingView
                } else {
                    displayView
                }
            }
            .padding()
        }
        .navigationTitle(isEditing ? "Editar" : "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Guardar") {
                        saveChanges()
                    }
                } else {
                    Menu {
                        Button(action: { isEditing = true }) {
                            Label("Editar", systemImage: "pencil")
                        }
                        
                        Button(action: { viewModel.toggleFavorite(entry) }) {
                            Label(
                                entry.isFavorite ? "Quitar de Favoritos" : "Añadir a Favoritos",
                                systemImage: entry.isFavorite ? "star.slash" : "star"
                            )
                        }
                        
                        Button(action: { showingShareSheet = true }) {
                            Label("Compartir", systemImage: "square.and.arrow.up")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive, action: { showingDeleteAlert = true }) {
                            Label("Eliminar", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .alert("Eliminar Entrada", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                viewModel.deleteEntry(entry)
                dismiss()
            }
        } message: {
            Text("¿Estás seguro de que quieres eliminar esta entrada? Esta acción no se puede deshacer.")
        }
    }
    
    // MARK: - Display View
    
    private var displayView: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    if entry.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                    }
                }
                
                HStack {
                    Text(entry.date.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if entry.isEncrypted {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.accentColor)
                            .font(.caption)
                    }
                }
            }
            
            Divider()
            
            // Mood indicators
            moodSection
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                Text("Contenido")
                    .font(.headline)
                
                Text(viewModel.getDecryptedContent(for: entry))
                    .font(.body)
                    .lineSpacing(4)
            }
            
            // Prompts used
            if !entry.promptsUsed.isEmpty {
                promptsUsedSection
            }
            
            // Emotional tags
            if !entry.emotionalTags.isEmpty {
                tagsSection
            }
            
            // Metadata
            metadataSection
        }
    }
    
    private var moodSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 20) {
                // Pre-writing mood
                VStack(spacing: 8) {
                    Text("Antes de escribir")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Text(moodEmoji(for: entry.preWritingMood))
                            .font(.title2)
                        
                        Text("\(entry.preWritingMood)")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                
                if let postMood = entry.postWritingMood {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.secondary)
                    
                    // Post-writing mood
                    VStack(spacing: 8) {
                        Text("Después de escribir")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            Text(moodEmoji(for: postMood))
                                .font(.title2)
                            
                            Text("\(postMood)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Mood improvement
            if let improvement = entry.moodImprovement {
                HStack {
                    Image(systemName: improvement >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(improvement >= 0 ? .green : .orange)
                    
                    Text("Cambio de ánimo: \(improvement > 0 ? "+" : "")\(improvement) puntos")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(
                    (improvement >= 0 ? Color.green : Color.orange).opacity(0.1)
                )
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var promptsUsedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Prompts Utilizados")
                .font(.headline)
            
            ForEach(entry.promptsUsed, id: \.self) { prompt in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.accentColor)
                        .font(.caption)
                    
                    Text(prompt)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.accentColor.opacity(0.05))
                .cornerRadius(8)
            }
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Emociones")
                .font(.headline)
            
            FlowLayout(spacing: 8) {
                ForEach(entry.emotionalTags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.2))
                        .foregroundColor(.accentColor)
                        .cornerRadius(16)
                }
            }
        }
    }
    
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Divider()
            
            HStack {
                Label("\(entry.wordCount) palabras", systemImage: "text.word.spacing")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label("Modificado: \(entry.lastModified.formatted(date: .abbreviated, time: .shortened))", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Editing View
    
    private var editingView: some View {
        VStack(alignment: .leading, spacing: 20) {
            TextField("Título", text: $editTitle)
                .font(.title2)
                .fontWeight(.bold)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Contenido")
                    .font(.headline)
                
                TextEditor(text: $editContent)
                    .frame(minHeight: 300)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            if editPostMood == nil {
                Button("Añadir ánimo post-escritura") {
                    editPostMood = 5
                }
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ánimo después de escribir")
                        .font(.headline)
                    
                    HStack {
                        Text("😢")
                        Slider(value: Binding($editPostMood)!, in: 1...10, step: 1)
                        Text("😊")
                        Text("\(Int(editPostMood ?? 5))")
                            .frame(width: 30)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func moodEmoji(for mood: Int) -> String {
        switch mood {
        case 1...2: return "😢"
        case 3...4: return "😔"
        case 5...6: return "😐"
        case 7...8: return "🙂"
        case 9...10: return "😊"
        default: return "😐"
        }
    }
    
    private func saveChanges() {
        viewModel.updateEntry(
            entry,
            title: editTitle,
            content: editContent,
            emotionalTags: editTags,
            postWritingMood: editPostMood.map { Int($0) },
            encrypt: entry.isEncrypted
        )
        isEditing = false
    }
}

#Preview {
    @Previewable @State var entry = JournalEntry(
        title: "Un día difícil",
        content: "Hoy me sentí muy ansioso...",
        emotionalTags: ["Ansiedad", "Tristeza"],
        promptsUsed: ["¿Qué emoción estoy sintiendo ahora?"],
        preWritingMood: 3,
        postWritingMood: 6
    )
    
    NavigationStack {
        JournalEntryDetailView(entry: entry, viewModel: JournalingViewModel(modelContext: ModelContext(try! ModelContainer(for: JournalEntry.self))))
    }
}
