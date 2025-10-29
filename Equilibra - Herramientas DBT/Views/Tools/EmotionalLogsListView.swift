//
//  EmotionalLogsListView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct EmotionalLogsListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = EmotionalLogViewModel()
    @State private var showingAddLog = false
    
    var body: some View {
        List {
            ForEach(viewModel.logs) { log in
                EmotionalLogCard(log: log)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteLogs)
        }
        .listStyle(.plain)
        .navigationTitle("Registros Emocionales")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingAddLog = true }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingAddLog) {
            AddEmotionalLogView(viewModel: viewModel)
        }
        .onAppear {
            viewModel.setup(with: modelContext)
        }
        .overlay {
            if viewModel.logs.isEmpty {
                emptyStateView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("No hay registros aún")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Comienza a registrar tus emociones para entender mejor tus patrones")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Agregar Registro") {
                showingAddLog = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private func deleteLogs(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteLog(viewModel.logs[index])
        }
    }
}

#Preview {
    NavigationStack {
        EmotionalLogsListView()
            .modelContainer(for: [EmotionalLog.self])
    }
}
