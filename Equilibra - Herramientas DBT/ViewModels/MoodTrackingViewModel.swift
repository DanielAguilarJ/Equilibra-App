//
//  MoodTrackingViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData
import HealthKit

@Observable
final class MoodTrackingViewModel {
    var moodEntries: [MoodEntry] = []
    var selectedEmotion: EmotionType?
    var intensity: Int = 5
    var currentTrigger: String = ""
    var triggers: [String] = []
    var selectedMoodCopingStrategies: Set<MoodCopingStrategy> = []
    var notes: String = ""
    
    private var modelContext: ModelContext?
    private let healthStore = HKHealthStore()
    private var isHealthKitAuthorized = false
    
    init() {}
    
    func setup(with context: ModelContext) {
        self.modelContext = context
        loadMoodEntries()
        // requestHealthKitAuthorization() // Commented out due to API availability
    }
    
    // MARK: - Data Loading
    func loadMoodEntries() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<MoodEntry>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            moodEntries = try context.fetch(descriptor)
        } catch {
            print("Error loading mood entries: \(error)")
        }
    }
    
    func loadEntriesForDateRange(start: Date, end: Date) -> [MoodEntry] {
        guard let context = modelContext else { return [] }
        
        let descriptor = FetchDescriptor<MoodEntry>(
            predicate: #Predicate { entry in
                entry.timestamp >= start && entry.timestamp <= end
            },
            sortBy: [SortDescriptor(\.timestamp)]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error loading entries for date range: \(error)")
            return []
        }
    }
    
    // MARK: - Create Entry
    func addTrigger() {
        guard !currentTrigger.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        triggers.append(currentTrigger)
        currentTrigger = ""
    }
    
    func removeTrigger(at index: Int) {
        triggers.remove(at: index)
    }
    
    func toggleStrategy(_ strategy: MoodCopingStrategy) {
        if selectedMoodCopingStrategies.contains(strategy) {
            selectedMoodCopingStrategies.remove(strategy)
        } else {
            selectedMoodCopingStrategies.insert(strategy)
        }
    }
    
    func saveMoodEntry() {
        guard let context = modelContext,
              let emotion = selectedEmotion else { return }
        
        let entry = MoodEntry(
            emotionType: emotion,
            intensity: intensity,
            triggers: triggers,
            copingStrategies: Array(selectedMoodCopingStrategies),
            notes: notes
        )
        
        context.insert(entry)
        
        do {
            try context.save()
            
            // Sync with HealthKit if authorized
            // if isHealthKitAuthorized {
            //     syncToHealthKit(entry: entry)
            // }
            
            loadMoodEntries()
            resetForm()
        } catch {
            print("Error saving mood entry: \(error)")
        }
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        guard let context = modelContext else { return }
        context.delete(entry)
        
        do {
            try context.save()
            loadMoodEntries()
        } catch {
            print("Error deleting entry: \(error)")
        }
    }
    
    func resetForm() {
        selectedEmotion = nil
        intensity = 5
        triggers = []
        currentTrigger = ""
        selectedMoodCopingStrategies = []
        notes = ""
    }
    
    // MARK: - Analytics
    func averageIntensityForEmotion(_ emotion: EmotionType) -> Double {
        let entries = moodEntries.filter { $0.emotionType == emotion }
        guard !entries.isEmpty else { return 0 }
        let sum = entries.reduce(0) { $0 + $1.intensity }
        return Double(sum) / Double(entries.count)
    }
    
    func mostCommonEmotion() -> EmotionType? {
        let emotionCounts = Dictionary(grouping: moodEntries) { $0.emotionType }
            .mapValues { $0.count }
        return emotionCounts.max { $0.value < $1.value }?.key
    }
    
    func mostEffectiveStrategy() -> MoodCopingStrategy? {
        var strategyCounts: [MoodCopingStrategy: Int] = [:]
        
        for entry in moodEntries where entry.wasEffective == true {
            for strategy in entry.copingStrategies {
                strategyCounts[strategy, default: 0] += 1
            }
        }
        
        return strategyCounts.max { $0.value < $1.value }?.key
    }
    
    func entriesThisWeek() -> [MoodEntry] {
        let calendar = Calendar.current
        let now = Date()
        guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            return []
        }
        return moodEntries.filter { $0.timestamp >= weekAgo }
    }
    
    // MARK: - HealthKit Integration
    func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit not available on this device")
            return
        }
        
        // State of Mind is available in iOS 17+
        if #available(iOS 17.0, *) {
            // let stateOfMindType = HKCategoryType.categoryType(forIdentifier: .stateOfMind)!
            // let typesToShare: Set<HKSampleType> = [stateOfMindType]
            // let typesToRead: Set<HKObjectType> = [stateOfMindType]
            
            // healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            //     DispatchQueue.main.async {
            //         self.isHealthKitAuthorized = success
            //         if let error = error {
            //             print("HealthKit authorization error: \(error)")
            //         }
            //     }
            // }
        }
    }
    
    @available(iOS 17.0, *)
    private func syncToHealthKit(entry: MoodEntry) {
        // Map emotion type to HKStateOfMind valence
        let valence: Double
        switch entry.emotionType {
        case .joy, .calm, .excitement:
            valence = Double(entry.intensity) / 10.0 // Positive
        case .sadness, .anger, .fear, .anxiety, .emptiness:
            valence = -Double(entry.intensity) / 10.0 // Negative
        }
        
        // Create StateOfMind sample
        // let stateOfMind = HKStateOfMind(
        //     dateInterval: DateInterval(start: entry.timestamp, end: entry.timestamp),
        //     valence: valence
        // )
        
        // healthStore.save(stateOfMind) { success, error in
        //     if success {
        //         DispatchQueue.main.async {
        //             entry.healthKitSynced = true
        //             entry.healthKitID = stateOfMind.uuid.uuidString
        //         }
        //     } else if let error = error {
        //         print("Error syncing to HealthKit: \(error)")
        //     }
        // }
    }
}
