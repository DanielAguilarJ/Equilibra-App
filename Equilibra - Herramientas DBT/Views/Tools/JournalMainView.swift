//
//  JournalMainView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

/// Vista principal del sistema de journaling con tabs
struct JournalMainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: JournalingViewModel
    @State private var selectedTab: JournalTab = .entries
    
    enum JournalTab: String, CaseIterable {
        case entries = "Entradas"
        case history = "Historial"
        
        var icon: String {
            switch self {
            case .entries: return "book.fill"
            case .history: return "chart.bar.fill"
            }
        }
    }
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: JournalingViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            JournalingView(modelContext: modelContext)
                .tabItem {
                    Label(JournalTab.entries.rawValue, systemImage: JournalTab.entries.icon)
                }
                .tag(JournalTab.entries)
            
            JournalHistoryView(viewModel: viewModel)
                .tabItem {
                    Label(JournalTab.history.rawValue, systemImage: JournalTab.history.icon)
                }
                .tag(JournalTab.history)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: JournalEntry.self, configurations: config)
    
    return JournalMainView(modelContext: container.mainContext)
}
