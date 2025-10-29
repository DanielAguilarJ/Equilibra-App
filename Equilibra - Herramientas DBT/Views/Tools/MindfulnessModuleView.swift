//
//  MindfulnessModuleView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI

struct MindfulnessModuleView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MindfulnessViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                BreathingView()
                    .tabItem {
                        Label("Respiración", systemImage: "wind")
                    }
                    .tag(0)
                
                MeditationView()
                    .tabItem {
                        Label("Meditación", systemImage: "brain.head.profile")
                    }
                    .tag(1)
            }
            .navigationTitle("Mindfulness")
            .navigationBarTitleDisplayMode(.large)
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

// Placeholder views - these should be replaced with actual implementations
struct MeditationView: View {
    var body: some View {
        Text("Vista de Meditación")
            .font(.title)
    }
}

#Preview {
    MindfulnessModuleView()
}
