//
//  HomeView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = HomeViewModel()
    @State private var selectedModule: DBTModule?
    @State private var showingMoodTracking = false
    @State private var showingSafetyPlan = false
    @State private var showingMindfulness = false
    @State private var showingEmotionRegulation = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection
                    
                    // Crisis Button
                    CrisisButton {
                        viewModel.toggleCrisisMode()
                    }
                    .padding(.horizontal)
                    
                    // Quick Mood Tracking - NEW
                    quickMoodTrackingButton
                    
                    // Safety Plan Quick Access
                    quickSafetyPlanButton
                    
                    // Mindfulness Module Quick Access
                    quickMindfulnessButton
                    
                    // Emotion Regulation Tools Quick Access
                    quickEmotionRegulationButton
                    
                    // Modules Section
                    modulesSection
                    
                    // Recent Emotional Logs
                    if !viewModel.recentLogs.isEmpty {
                        recentLogsSection
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Equilibra")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.setup(with: modelContext)
            }
            .sheet(isPresented: $viewModel.showingCrisisMode) {
                CrisisToolsView()
            }
            .sheet(isPresented: $showingMoodTracking) {
                MoodTrackingView(viewModel: MoodTrackingViewModel())
            }
            .sheet(isPresented: $showingSafetyPlan) {
                SafetyPlanView()
            }
            .sheet(isPresented: $showingMindfulness) {
                MindfulnessModuleView()
            }
            .sheet(isPresented: $showingEmotionRegulation) {
                EmotionRegulationToolsView()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hola, bienvenido/a")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("¿Cómo te sientes hoy?")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    // MARK: - Quick Mood Tracking Button
    private var quickMoodTrackingButton: some View {
        Button(action: {
            showingMoodTracking = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                            .font(.title2)
                        
                        Text("Registrar mi Estado")
                            .font(.headline)
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.cyan, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    
                    Text("Seguimiento emocional diario")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.cyan.opacity(0.1), .blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.cyan.opacity(0.3), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    
    // MARK: - Quick Safety Plan Button
    private var quickSafetyPlanButton: some View {
        Button(action: {
            showingSafetyPlan = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "shield.lefthalf.filled")
                            .font(.title2)
                        
                        Text("Plan de Seguridad")
                            .font(.headline)
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    
                    Text("Tu red de apoyo personal")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.1), .pink.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple.opacity(0.3), .pink.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    
    // MARK: - Quick Mindfulness Button
    private var quickMindfulnessButton: some View {
        Button(action: {
            showingMindfulness = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.title2)
                        
                        Text("Mindfulness")
                            .font(.headline)
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    
                    Text("Respiración y meditación guiada")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.purple.opacity(0.1), .blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.purple.opacity(0.3), .blue.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    
    // MARK: - Quick Emotion Regulation Button
    private var quickEmotionRegulationButton: some View {
        Button(action: {
            showingEmotionRegulation = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "heart.circle.fill")
                            .font(.title2)
                        
                        Text("Regulación Emocional")
                            .font(.headline)
                    }
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    
                    Text("Herramientas DBT interactivas")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.1), .cyan.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: [.blue.opacity(0.3), .cyan.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
    
    // MARK: - Modules Section
    private var modulesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Módulos DBT")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
            
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(viewModel.modules) { module in
                    Button {
                        selectedModule = module
                    } label: {
                        ModuleCard(module: module)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Recent Logs Section
    private var recentLogsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Registros Recientes")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                NavigationLink("Ver todos") {
                    EmotionalLogsListView()
                }
                .font(.caption)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                ForEach(viewModel.recentLogs) { log in
                    EmotionalLogCard(log: log)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: [DBTModule.self, EmotionalLog.self, DBTSkill.self, SafetyPlan.self, MoodEntry.self])
}
