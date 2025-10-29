//
//  MoodHistoryView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import SwiftData
import Charts

struct MoodHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = MoodTrackingViewModel()
    @State private var showingAddMood = false
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedEntry: MoodEntry?
    @State private var showingDetail = false
    
    enum TimeRange: String, CaseIterable {
        case week = "Semana"
        case month = "Mes"
        case threeMonths = "3 Meses"
        case all = "Todo"
        
        var days: Int {
            switch self {
            case .week: return 7
            case .month: return 30
            case .threeMonths: return 90
            case .all: return 365 * 10 // Large number
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Time range picker
                    timeRangePicker
                    
                    // Statistics cards
                    statisticsSection
                    
                    // Trend chart
                    trendChartSection
                    
                    // Emotion distribution
                    emotionDistributionSection
                    
                    // Pattern insights
                    if !filteredEntries.isEmpty {
                        patternInsightsSection
                    }
                    
                    // Entries list
                    entriesListSection
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Historial Emocional")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddMood = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddMood) {
                MoodTrackingView(viewModel: viewModel)
            }
            .sheet(item: $selectedEntry) { entry in
                MoodEntryDetailView(entry: entry, viewModel: viewModel)
            }
            .onAppear {
                viewModel.setup(with: modelContext)
            }
            .overlay {
                if viewModel.moodEntries.isEmpty {
                    emptyStateView
                }
            }
        }
    }
    
    // MARK: - Time Range Picker
    private var timeRangePicker: some View {
        Picker("Rango", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Text(range.rawValue).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    // MARK: - Statistics Section
    private var statisticsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                title: "Total",
                value: "\(filteredEntries.count)",
                icon: "list.bullet",
                color: .blue
            )
            
            StatCard(
                title: "Promedio",
                value: String(format: "%.1f", averageIntensity),
                icon: "chart.line.uptrend.xyaxis",
                color: .green
            )
            
            StatCard(
                title: "Más Alta",
                value: "\(maxIntensity)",
                icon: "arrow.up.circle",
                color: .orange
            )
        }
        .padding(.horizontal)
    }
    
    // MARK: - Trend Chart
    private var trendChartSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tendencia de Intensidad")
                .font(.headline)
                .padding(.horizontal)
            
            if filteredEntries.isEmpty {
                Text("No hay datos para mostrar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Chart {
                    ForEach(filteredEntries) { entry in
                        LineMark(
                            x: .value("Fecha", entry.timestamp),
                            y: .value("Intensidad", entry.intensity)
                        )
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan.opacity(0.7), .blue.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .interpolationMethod(.catmullRom)
                        
                        PointMark(
                            x: .value("Fecha", entry.timestamp),
                            y: .value("Intensidad", entry.intensity)
                        )
                        .foregroundStyle(colorForIntensity(entry.intensity))
                        .symbolSize(60)
                    }
                    
                    // Average line
                    RuleMark(y: .value("Promedio", averageIntensity))
                        .foregroundStyle(.gray.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                }
                .chartYScale(domain: 0...10)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 220)
                .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Emotion Distribution
    private var emotionDistributionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Distribución de Emociones")
                .font(.headline)
                .padding(.horizontal)
            
            if emotionCounts.isEmpty {
                Text("No hay datos para mostrar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
            } else {
                Chart(emotionCounts, id: \.emotion) { item in
                    SectorMark(
                        angle: .value("Cantidad", item.count),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Emoción", item.emotion.rawValue))
                    .annotation(position: .overlay) {
                        Text(item.emotion.emoji)
                            .font(.title2)
                    }
                }
                .chartLegend(position: .bottom, alignment: .center)
                .frame(height: 250)
                .padding()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Pattern Insights
    private var patternInsightsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights y Patrones")
                .font(.headline)
            
            VStack(spacing: 12) {
                if let mostCommon = viewModel.mostCommonEmotion() {
                    InsightCard(
                        icon: "chart.pie.fill",
                        title: "Emoción más frecuente",
                        value: "\(mostCommon.emoji) \(mostCommon.rawValue)",
                        color: .blue
                    )
                }
                
                if let mostEffective = viewModel.mostEffectiveStrategy() {
                    InsightCard(
                        icon: "star.fill",
                        title: "Estrategia más efectiva",
                        value: mostEffective.rawValue,
                        color: .green
                    )
                }
                
                if !mostCommonTriggers.isEmpty {
                    InsightCard(
                        icon: "bolt.fill",
                        title: "Desencadenante común",
                        value: mostCommonTriggers.first ?? "",
                        color: .orange
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Entries List
    private var entriesListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Registros Recientes")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(filteredEntries.prefix(10)) { entry in
                Button(action: {
                    selectedEntry = entry
                    showingDetail = true
                }) {
                    MoodEntryRow(entry: entry)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.text.square")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.cyan.opacity(0.7), .blue.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No hay registros aún")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Comienza a registrar tus emociones para ver tendencias y patrones")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Agregar Registro") {
                showingAddMood = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue)
        }
    }
    
    // MARK: - Computed Properties
    private var filteredEntries: [MoodEntry] {
        let calendar = Calendar.current
        let now = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -selectedTimeRange.days, to: now) else {
            return viewModel.moodEntries
        }
        return viewModel.loadEntriesForDateRange(start: startDate, end: now)
    }
    
    private var averageIntensity: Double {
        guard !filteredEntries.isEmpty else { return 0 }
        let sum = filteredEntries.reduce(0) { $0 + $1.intensity }
        return Double(sum) / Double(filteredEntries.count)
    }
    
    private var maxIntensity: Int {
        filteredEntries.map { $0.intensity }.max() ?? 0
    }
    
    private var emotionCounts: [(emotion: EmotionType, count: Int)] {
        let grouped = Dictionary(grouping: filteredEntries) { $0.emotionType }
        return grouped.map { (emotion: $0.key, count: $0.value.count) }
            .sorted { $0.count > $1.count }
    }
    
    private var mostCommonTriggers: [String] {
        let allTriggers = filteredEntries.flatMap { $0.triggers }
        let counts = Dictionary(grouping: allTriggers) { $0 }
            .mapValues { $0.count }
        return counts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
    }
    
    private func colorForIntensity(_ intensity: Int) -> Color {
        switch intensity {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct InsightCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(color.opacity(0.2))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

struct MoodEntryRow: View {
    let entry: MoodEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Emotion emoji
            Text(entry.emotionType.emoji)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(entry.emotionType.rawValue)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(entry.formattedTime)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                // Intensity bar
                HStack(spacing: 4) {
                    ForEach(1...10, id: \.self) { level in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(level <= entry.intensity ? intensityColor(entry.intensity) : Color.gray.opacity(0.2))
                            .frame(height: 6)
                    }
                }
                
                // Triggers preview
                if !entry.triggers.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill")
                            .font(.caption2)
                            .foregroundStyle(.orange)
                        
                        Text(entry.triggers.joined(separator: ", "))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                // Strategies preview
                if !entry.copingStrategies.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)
                        
                        Text("\(entry.copingStrategies.count) estrategia(s)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private func intensityColor(_ intensity: Int) -> Color {
        switch intensity {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        default: return .red
        }
    }
}

#Preview {
    MoodHistoryView()
        .modelContainer(for: [MoodEntry.self])
}
