//
//  EmotionRegulationStatsView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData
import Charts

struct EmotionRegulationStatsView: View {
    @Environment(\.dismiss) private var dismiss
    let sessions: [EmotionRegulationSession]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overall Stats
                    overallStatsSection
                    
                    // Tool Usage
                    toolUsageSection
                    
                    // Effectiveness
                    effectivenessSection
                    
                    // Recent Emotions
                    recentEmotionsSection
                    
                    // Intensity Changes
                    intensityChangesSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Estadísticas")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var overallStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Resumen General")
                .font(.headline)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                StatBox(
                    title: "Total Sesiones",
                    value: "\(sessions.count)",
                    icon: "chart.bar.fill",
                    color: Color.blue
                )
                
                StatBox(
                    title: "Esta Semana",
                    value: "\(sessionsThisWeek)",
                    icon: "calendar",
                    color: Color.green
                )
                
                StatBox(
                    title: "Efectividad",
                    value: "\(Int(overallEffectiveness * 100))%",
                    icon: "checkmark.circle.fill",
                    color: Color.purple
                )
                
                StatBox(
                    title: "Promedio Mejora",
                    value: String(format: "%.1f", averageImprovement),
                    icon: "arrow.down.circle.fill",
                    color: Color.orange
                )
            }
        }
    }
    
    private var toolUsageSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Uso de Herramientas")
                .font(.headline)
            
            if !sessions.isEmpty {
                Chart {
                    ForEach(EmotionRegulationToolType.allCases, id: \.self) { tool in
                        let count = sessions.filter { $0.toolType == tool }.count
                        BarMark(
                            x: .value("Herramienta", tool.title),
                            y: .value("Usos", count)
                        )
                        .foregroundStyle(by: .value("Tool", tool.title))
                        .annotation(position: .top) {
                            if count > 0 {
                                Text("\(count)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .chartForegroundStyleScale([
                    "PLEASE": Color.green,
                    "Check the Facts": Color.blue,
                    "Opposite Action": Color.purple
                ])
                .frame(height: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                )
            } else {
                Text("No hay datos disponibles")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                    )
            }
        }
    }
    
    private var effectivenessSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Efectividad por Herramienta")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(EmotionRegulationToolType.allCases, id: \.self) { tool in
                    let toolSessions = sessions.filter { $0.toolType == tool }
                    let helpful = toolSessions.filter { $0.wasHelpful == true }.count
                    let total = toolSessions.count
                    let percentage = total > 0 ? Double(helpful) / Double(total) : 0.0
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tool.title)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Text("\(helpful) de \(total) sesiones")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(Int(percentage * 100))%")
                            .font(.headline)
                            .foregroundStyle(colorForTool(tool))
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemBackground))
                    )
                }
            }
        }
    }
    
    private var recentEmotionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Emociones Más Trabajadas")
                .font(.headline)
            
            let emotionCounts = Dictionary(grouping: sessions, by: { $0.initialEmotion })
                .mapValues { $0.count }
                .sorted { $0.value > $1.value }
                .prefix(5)
            
            VStack(spacing: 8) {
                ForEach(Array(emotionCounts.enumerated()), id: \.offset) { index, item in
                    HStack {
                        Text("\(index + 1).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 20)
                        
                        Text(item.key)
                            .font(.subheadline)
                        
                        Spacer()
                        
                        Text("\(item.value)")
                            .font(.headline)
                            .foregroundStyle(Color.blue)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                    )
                }
            }
        }
    }
    
    private var intensityChangesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cambios de Intensidad")
                .font(.headline)
            
            if let recentSessions = sessions.filter({ $0.finalIntensity != nil }).suffix(7).reversed() as? [EmotionRegulationSession],
               !recentSessions.isEmpty {
                Chart {
                    ForEach(Array(recentSessions.enumerated()), id: \.offset) { index, session in
                        LineMark(
                            x: .value("Sesión", index + 1),
                            y: .value("Inicial", session.initialIntensity),
                            series: .value("Type", "Antes")
                        )
                        .foregroundStyle(.red)
                        .symbol(.circle)
                        
                        if let final = session.finalIntensity {
                            LineMark(
                                x: .value("Sesión", index + 1),
                                y: .value("Final", final),
                                series: .value("Type", "Después")
                            )
                            .foregroundStyle(.green)
                            .symbol(.square)
                        }
                    }
                }
                .chartYScale(domain: 0...10)
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel()
                        AxisGridLine()
                    }
                }
                .frame(height: 200)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                )
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red)
                            .frame(width: 8, height: 8)
                        Text("Antes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Después")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Computed Properties
    private var sessionsThisWeek: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return sessions.filter { $0.date >= weekAgo }.count
    }
    
    private var overallEffectiveness: Double {
        let helpful = sessions.filter { $0.wasHelpful == true }.count
        return sessions.count > 0 ? Double(helpful) / Double(sessions.count) : 0.0
    }
    
    private var averageImprovement: Double {
        let improvements = sessions.compactMap { session -> Int? in
            guard let final = session.finalIntensity else { return nil }
            return session.initialIntensity - final
        }
        
        guard !improvements.isEmpty else { return 0.0 }
        let sum = improvements.reduce(0, +)
        return Double(sum) / Double(improvements.count)
    }
    
    private func colorForTool(_ tool: EmotionRegulationToolType) -> Color {
        switch tool.color {
        case "green": return Color.green
        case "blue": return Color.blue
        case "purple": return Color.purple
        default: return Color.blue
        }
    }
}

// MARK: - Stat Box Component
private struct StatBox: View {
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

#Preview {
    EmotionRegulationStatsView(sessions: [])
        .modelContainer(for: EmotionRegulationSession.self)
}
