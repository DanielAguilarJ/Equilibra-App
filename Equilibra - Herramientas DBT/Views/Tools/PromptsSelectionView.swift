//
//  PromptsSelectionView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import Combine

struct PromptsSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedPrompts: [TherapeuticPrompt]
    let onSelectPrompt: (TherapeuticPrompt) -> Void
    
    @State private var selectedCategory: TherapeuticPrompt.PromptCategory? = nil
    
    private let promptsService = JournalingPromptsService.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Categorías
                    categoriesSection
                    
                    // Prompts
                    promptsSection
                }
                .padding()
            }
            .navigationTitle("Prompts Terapéuticos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categorías")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    CategoryButton(
                        category: nil,
                        isSelected: selectedCategory == nil,
                        action: { selectedCategory = nil }
                    )
                    
                    ForEach(TherapeuticPrompt.PromptCategory.allCases, id: \.self) { category in
                        CategoryButton(
                            category: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
            }
        }
    }
    
    private var promptsSection: some View {
        VStack(spacing: 12) {
            let prompts = selectedCategory == nil 
                ? promptsService.allPrompts 
                : promptsService.getPrompts(for: selectedCategory!)
            
            ForEach(prompts) { prompt in
                PromptCard(
                    prompt: prompt,
                    isSelected: selectedPrompts.contains(where: { $0.id == prompt.id }),
                    onTap: {
                        onSelectPrompt(prompt)
                    }
                )
            }
        }
    }
}

struct CategoryButton: View {
    let category: TherapeuticPrompt.PromptCategory?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let category = category {
                    Image(systemName: category.icon)
                    Text(category.rawValue)
                } else {
                    Image(systemName: "sparkles")
                    Text("Todos")
                }
            }
            .font(.subheadline)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
    }
}

struct PromptCard: View {
    let prompt: TherapeuticPrompt
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: prompt.category.icon)
                        .foregroundColor(.accentColor)
                    
                    Text(prompt.category.rawValue)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
                
                Text(prompt.text)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text(prompt.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    PromptsSelectionView(
        selectedPrompts: .constant([]),
        onSelectPrompt: { _ in }
    )
}
