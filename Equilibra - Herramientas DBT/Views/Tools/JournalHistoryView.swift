//
//  JournalHistoryView.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import SwiftUI
import Charts
import SwiftData

struct JournalHistoryView: View {
    @ObservedObject var viewModel: JournalingViewModel
    @State private var selectedTab: HistoryTab = .timeline
    
    enum HistoryTab: String, CaseIterable {
        case timeline = "Timeline"
        case analytics = "Análisis"
        case wordCloud = "Temas"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab selector
                Picker("Vista", selection: $selectedTab) {
                    ForEach(HistoryTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content
                ScrollView {
                    switch selectedTab {
                    case .timeline:
                        timelineView
                    case .analytics:
                        analyticsView
                    case .wordCloud:
                        wordCloudView
                    }
                }
            }
            .navigationTitle("Historial")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Timeline View
    
    private var timelineView: some View {
        VStack(spacing: 20) {
            ForEach(viewModel.getEntriesGroupedByMonth(), id: \.month) { group in
                VStack(alignment: .leading, spacing: 12) {
                    // Month header
                    HStack {
                        Text(group.month)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("\(group.entries.count) entradas")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Entries for this month
                    ForEach(group.entries) { entry in
                        NavigationLink(destination: JournalEntryDetailView(entry: entry, viewModel: viewModel)) {
                            TimelineEntryCard(entry: entry, viewModel: viewModel)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Analytics View
    
    private var analyticsView: some View {
        VStack(spacing: 24) {
            // Summary stats
            summaryStatsSection
            
            // Mood trends chart
            moodTrendsChart
            
            // Writing frequency
            writingFrequencySection
            
            // Top emotions
            topEmotionsSection
        }
        .padding()
    }
    
    private var summaryStatsSection: some View {
        VStack(spacing: 16) {
            Text("Resumen General")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                AnalyticCard(
                    icon: "book.fill",
                    value: "\(viewModel.entries.count)",
                    label: "Total de Entradas",
                    color: .blue
                )
                
                AnalyticCard(
                    icon: "calendar",
                    value: "\(uniqueDays)",
                    label: "Días Activos",
                    color: .green
                )
                
                AnalyticCard(
                    icon: "text.word.spacing",
                    value: "\(viewModel.getTotalWordCount())",
                    label: "Palabras Escritas",
                    color: .orange
                )
                
                AnalyticCard(
                    icon: "chart.line.uptrend.xyaxis",
                    value: String(format: "%.1f", viewModel.getAverageMoodImprovement()),
                    label: "Mejora Promedio",
                    color: viewModel.getAverageMoodImprovement() >= 0 ? .green : .orange
                )
            }
        }
    }
    
    private var moodTrendsChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tendencia de Ánimo")
                .font(.headline)
            
            if #available(iOS 16.0, *) {
                Chart {
                    ForEach(viewModel.entries.suffix(20).reversed()) { entry in
                        if let postMood = entry.postWritingMood {
                            LineMark(
                                x: .value("Fecha", entry.date),
                                y: .value("Ánimo", postMood)
                            )
                            .foregroundStyle(Color.green)
                            
                            PointMark(
                                x: .value("Fecha", entry.date),
                                y: .value("Ánimo", postMood)
                            )
                            .foregroundStyle(Color.green)
                        }
                        
                        LineMark(
                            x: .value("Fecha", entry.date),
                            y: .value("Ánimo", entry.preWritingMood)
                        )
                        .foregroundStyle(Color.blue)
                        
                        PointMark(
                            x: .value("Fecha", entry.date),
                            y: .value("Ánimo", entry.preWritingMood)
                        )
                        .foregroundStyle(Color.blue)
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 1...10)
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            } else {
                Text("Gráfico disponible en iOS 16+")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                Label("Pre-escritura", systemImage: "circle.fill")
                    .foregroundColor(.blue)
                    .font(.caption)
                
                Label("Post-escritura", systemImage: "circle.fill")
                    .foregroundColor(.green)
                    .font(.caption)
            }
            .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var writingFrequencySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Frecuencia de Escritura")
                .font(.headline)
            
            let entriesPerWeek = calculateEntriesPerWeek()
            
            HStack(alignment: .bottom, spacing: 8) {
                ForEach(entriesPerWeek.suffix(12), id: \.week) { data in
                    VStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentColor.opacity(min(Double(data.count) / 7.0, 1.0)))
                            .frame(width: 20, height: max(CGFloat(data.count) * 10, 4))
                        
                        Text(data.week)
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var topEmotionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Emociones Más Frecuentes")
                .font(.headline)
            
            ForEach(viewModel.getTopTags(limit: 5), id: \.tag) { item in
                HStack {
                    Text(item.tag)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 150, height: 20)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentColor)
                            .frame(width: CGFloat(item.count) * 15, height: 20)
                    }
                    
                    Text("\(item.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(width: 30, alignment: .trailing)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Word Cloud View
    
    private var wordCloudView: some View {
        VStack(spacing: 20) {
            Text("Temas Recurrentes")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            let topTags = viewModel.getTopTags(limit: 20)
            let maxCount = topTags.first?.count ?? 1
            
            FlowLayout(spacing: 12) {
                ForEach(topTags, id: \.tag) { item in
                    let size = calculateFontSize(count: item.count, maxCount: maxCount)
                    
                    Text(item.tag)
                        .font(.system(size: size))
                        .fontWeight(item.count > maxCount / 2 ? .bold : .regular)
                        .foregroundColor(Color.accentColor.opacity(Double(item.count) / Double(maxCount)))
                        .padding(8)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
    }
    
    // MARK: - Helper Methods
    
    private var uniqueDays: Int {
        let days = Set(viewModel.entries.map { Calendar.current.startOfDay(for: $0.date) })
        return days.count
    }
    
    private func calculateEntriesPerWeek() -> [(week: String, count: Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: viewModel.entries) { entry in
            calendar.component(.weekOfYear, from: entry.date)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        return grouped.map { week, entries in
            let weekStart = entries.first?.date ?? Date()
            return (dateFormatter.string(from: weekStart), entries.count)
        }.sorted { $0.week < $1.week }
    }
    
    private func calculateFontSize(count: Int, maxCount: Int) -> CGFloat {
        let minSize: CGFloat = 12
        let maxSize: CGFloat = 36
        let ratio = CGFloat(count) / CGFloat(maxCount)
        return minSize + (maxSize - minSize) * ratio
    }
}

// MARK: - Supporting Views

struct TimelineEntryCard: View {
    let entry: JournalEntry
    let viewModel: JournalingViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Timeline indicator
            VStack {
                Circle()
                    .fill(entry.isFavorite ? Color.yellow : Color.accentColor)
                    .frame(width: 12, height: 12)
                
                Rectangle()
                    .fill(Color.accentColor.opacity(0.3))
                    .frame(width: 2)
            }
            
            // Entry card
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.title)
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(viewModel.getDecryptedContent(for: entry))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if let improvement = entry.moodImprovement {
                    HStack(spacing: 4) {
                        Image(systemName: improvement >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(improvement >= 0 ? .green : .orange)
                            .font(.caption)
                        
                        Text("\(improvement > 0 ? "+" : "")\(improvement)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
        .padding(.leading)
    }
}

struct AnalyticCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    JournalHistoryView(viewModel: JournalingViewModel(modelContext: ModelContext(try! ModelContainer(for: JournalEntry.self))))
}
