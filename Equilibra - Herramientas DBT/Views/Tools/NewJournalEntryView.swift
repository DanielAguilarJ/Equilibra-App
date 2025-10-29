//
//  NewJournalEntryView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct NewJournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JournalingViewModel
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var selectedTags: [String] = []
    @State private var preWritingMood: Double = 5
    @State private var postWritingMood: Double = 5
    @State private var hasPostMood: Bool = false
    @State private var shouldEncrypt: Bool = true
    @State private var showingPrompts: Bool = false
    @State private var selectedPrompts: [TherapeuticPrompt] = []
    @State private var currentPrompt: TherapeuticPrompt?
    
    @FocusState private var contentIsFocused: Bool
    
    private let promptsService = JournalingPromptsService.shared
    private let commonTags = [
        "Ansiedad", "Tristeza", "Ira", "Miedo", "Alegría",
        "Frustración", "Calma", "Confusión", "Esperanza", "Soledad",
        "Gratitud", "Culpa", "Vergüenza", "Amor", "Enojo"
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Título
                    titleSection
                    
                    // Ánimo pre-escritura
                    preMoodSection
                    
                    // Prompts terapéuticos
                    promptsSection
                    
                    // Editor de contenido
                    contentSection
                    
                    // Tags emocionales
                    tagsSection
                    
                    // Ánimo post-escritura
                    postMoodSection
                    
                    // Opciones de privacidad
                    privacySection
                }
                .padding()
            }
            .navigationTitle("Nueva Entrada")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        saveEntry()
                    }
                    .disabled(!canSave)
                }
            }
            .sheet(isPresented: $showingPrompts) {
                PromptsSelectionView(
                    selectedPrompts: $selectedPrompts,
                    onSelectPrompt: { prompt in
                        currentPrompt = prompt
                        showingPrompts = false
                        contentIsFocused = true
                    }
                )
            }
        }
    }
    
    // MARK: - Sections
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Título")
                .font(.headline)
            
            TextField("Título de la entrada...", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
    
    private var preMoodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿Cómo te sientes ahora?")
                .font(.headline)
            
            HStack {
                Text("😢")
                    .font(.title2)
                
                Slider(value: $preWritingMood, in: 1...10, step: 1)
                
                Text("😊")
                    .font(.title2)
                
                Text("\(Int(preWritingMood))")
                    .font(.headline)
                    .frame(width: 30)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var promptsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Prompts Terapéuticos")
                    .font(.headline)
                
                Spacer()
                
                Button(action: { showingPrompts = true }) {
                    Label("Ver Prompts", systemImage: "lightbulb.fill")
                        .font(.caption)
                }
            }
            
            if let prompt = currentPrompt {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: prompt.category.icon)
                            .foregroundColor(.accentColor)
                        
                        Text(prompt.category.rawValue)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                        
                        Spacer()
                        
                        Button(action: { getRandomPrompt() }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.caption)
                        }
                    }
                    
                    Text(prompt.text)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(prompt.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(10)
            } else {
                Button(action: { getRandomPrompt() }) {
                    HStack {
                        Image(systemName: "sparkles")
                        Text("Obtener Prompt Aleatorio")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(10)
                }
            }
            
            // Prompts usados
            if !selectedPrompts.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Prompts usados:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ForEach(selectedPrompts) { prompt in
                        Text("• \(prompt.text)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Escribe libremente")
                .font(.headline)
            
            ZStack(alignment: .topLeading) {
                if content.isEmpty {
                    Text("Empieza a escribir sobre tus pensamientos y emociones...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $content)
                    .frame(minHeight: 200)
                    .padding(4)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .focused($contentIsFocused)
            }
            
            HStack {
                Text("\(content.split(separator: " ").count) palabras")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(content.count) caracteres")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Etiquetas Emocionales")
                .font(.headline)
            
            FlowLayout(spacing: 8) {
                ForEach(commonTags, id: \.self) { tag in
                    TagButton(
                        tag: tag,
                        isSelected: selectedTags.contains(tag),
                        action: { toggleTag(tag) }
                    )
                }
            }
        }
    }
    
    private var postMoodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("Registrar ánimo después de escribir", isOn: $hasPostMood)
                .font(.headline)
            
            if hasPostMood {
                HStack {
                    Text("😢")
                        .font(.title2)
                    
                    Slider(value: $postWritingMood, in: 1...10, step: 1)
                    
                    Text("😊")
                        .font(.title2)
                    
                    Text("\(Int(postWritingMood))")
                        .font(.headline)
                        .frame(width: 30)
                }
                
                if hasPostMood {
                    let improvement = Int(postWritingMood - preWritingMood)
                    HStack {
                        Image(systemName: improvement >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(improvement >= 0 ? .green : .orange)
                        
                        Text("Cambio: \(improvement > 0 ? "+" : "")\(improvement) puntos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle(isOn: $shouldEncrypt) {
                HStack {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.accentColor)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Encriptar Contenido")
                            .font(.headline)
                        
                        Text("Protege tu privacidad con encriptación local")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Actions
    
    private func getRandomPrompt() {
        let prompt = promptsService.getRandomPrompt()
        currentPrompt = prompt
        if !selectedPrompts.contains(where: { $0.id == prompt.id }) {
            selectedPrompts.append(prompt)
        }
    }
    
    private func toggleTag(_ tag: String) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
    }
    
    private var canSave: Bool {
        !title.isEmpty && !content.isEmpty
    }
    
    private func saveEntry() {
        let promptTexts = selectedPrompts.map { $0.text }
        
        viewModel.createEntry(
            title: title,
            content: content,
            emotionalTags: selectedTags,
            promptsUsed: promptTexts,
            preWritingMood: Int(preWritingMood),
            postWritingMood: hasPostMood ? Int(postWritingMood) : nil,
            encrypt: shouldEncrypt
        )
        
        dismiss()
    }
}

// MARK: - Supporting Views

struct TagButton: View {
    let tag: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(tag)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    NewJournalEntryView(viewModel: JournalingViewModel(modelContext: ModelContext(try! ModelContainer(for: JournalEntry.self))))
}
