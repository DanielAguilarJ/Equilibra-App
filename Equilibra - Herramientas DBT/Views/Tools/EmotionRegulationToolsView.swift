//
//  EmotionRegulationToolsView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData
import Combine

struct EmotionRegulationToolsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = EmotionRegulationViewModel()
    @State private var selectedTool: EmotionRegulationToolType?
    @State private var showingStats = false
    
    @Query(sort: \EmotionRegulationSession.date, order: .reverse)
    private var sessions: [EmotionRegulationSession]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Tools Grid
                    toolsGrid
                    
                    // Recent Sessions
                    if !sessions.isEmpty {
                        recentSessionsSection
                    }
                    
                    // Statistics
                    statsSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Regulación Emocional")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingStats.toggle()
                    } label: {
                        Image(systemName: "chart.bar.fill")
                    }
                }
            }
            .sheet(item: $selectedTool) { tool in
                toolDetailView(for: tool)
            }
            .sheet(isPresented: $showingStats) {
                EmotionRegulationStatsView(sessions: sessions)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .font(.title)
                    .foregroundStyle(.blue.gradient)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Herramientas DBT")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Aprende a regular tus emociones de manera saludable")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.blue.opacity(0.1))
            )
        }
    }
    
    private var toolsGrid: some View {
        VStack(spacing: 16) {
            ForEach(EmotionRegulationToolType.allCases, id: \.self) { toolType in
                ToolCard(toolType: toolType) {
                    selectedTool = toolType
                }
            }
        }
    }
    
    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sesiones Recientes")
                .font(.headline)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                ForEach(sessions.prefix(3)) { session in
                    SessionCard(session: session)
                }
            }
        }
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resumen")
                .font(.headline)
                .padding(.horizontal, 4)
            
            HStack(spacing: 12) {
                StatCard(
                    title: "Total Sesiones",
                    value: "\(sessions.count)",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .blue
                )
                
                StatCard(
                    title: "Esta Semana",
                    value: "\(sessionsThisWeek)",
                    icon: "calendar",
                    color: .green
                )
            }
        }
    }
    
    private var sessionsThisWeek: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sessions.filter { $0.date >= weekAgo }.count
    }
    
    @ViewBuilder
    private func toolDetailView(for tool: EmotionRegulationToolType) -> some View {
        switch tool {
        case .please:
            PLEASEToolView()
        case .checkTheFacts:
            CheckTheFactsView()
        case .oppositeAction:
            OppositeActionView()
        }
    }
}

// MARK: - Tool Card
struct ToolCard: View {
    let toolType: EmotionRegulationToolType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: toolType.icon)
                    .font(.title2)
                    .foregroundStyle(colorForTool)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(colorForTool.opacity(0.15))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(toolType.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(toolType.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var colorForTool: Color {
        switch toolType.color {
        case "green": return .green
        case "blue": return .blue
        case "purple": return .purple
        default: return .blue
        }
    }
}

// MARK: - Session Card
struct SessionCard: View {
    let session: EmotionRegulationSession
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: session.toolType.icon)
                    .foregroundStyle(.blue)
                
                Text(session.toolType.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text(session.date, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 12) {
                Label(session.initialEmotion, systemImage: "face.dashed")
                    .font(.caption)
                
                if let finalIntensity = session.finalIntensity {
                    HStack(spacing: 4) {
                        Text("\(session.initialIntensity)")
                            .font(.caption)
                            .foregroundStyle(.red)
                        
                        Image(systemName: "arrow.right")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        
                        Text("\(finalIntensity)")
                            .font(.caption)
                            .foregroundStyle(.green)
                    }
                }
                
                if let wasHelpful = session.wasHelpful {
                    Spacer()
                    Image(systemName: wasHelpful ? "hand.thumbsup.fill" : "hand.thumbsdown.fill")
                        .font(.caption)
                        .foregroundStyle(wasHelpful ? .green : .orange)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
}

// MARK: - Stat Card
private struct EmotionRegulationStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
        )
    }
}

// MARK: - Preview
#Preview {
    EmotionRegulationToolsView()
        .modelContainer(for: [EmotionRegulationSession.self, PLEASEEntry.self])
}
