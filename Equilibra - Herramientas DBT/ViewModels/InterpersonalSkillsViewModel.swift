//
//  InterpersonalSkillsViewModel.swift
//  Equilibra - Herramientas DBT
//
//  ViewModel para habilidades interpersonales
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class InterpersonalSkillsViewModel {
    var modelContext: ModelContext
    
    // DEAR MAN Plans
    var dearManPlans: [DearManPlan] = []
    var activeDearManPlan: DearManPlan?
    
    // GIVE Plans
    var givePlans: [GivePlan] = []
    var activeGivePlan: GivePlan?
    
    // FAST Plans
    var fastPlans: [FastPlan] = []
    var activeFastPlan: FastPlan?
    
    // UI State
    var selectedSkill: InterpersonalSkillType?
    var showingWizard = false
    var currentStep = 0
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadAllPlans()
    }
    
    // MARK: - Data Loading
    
    func loadAllPlans() {
        loadDearManPlans()
        loadGivePlans()
        loadFastPlans()
    }
    
    private func loadDearManPlans() {
        let descriptor = FetchDescriptor<DearManPlan>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        dearManPlans = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func loadGivePlans() {
        let descriptor = FetchDescriptor<GivePlan>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        givePlans = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    private func loadFastPlans() {
        let descriptor = FetchDescriptor<FastPlan>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        fastPlans = (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - DEAR MAN Actions
    
    func createDearManPlan(situation: String, goal: String) {
        let plan = DearManPlan(situation: situation, goal: goal)
        modelContext.insert(plan)
        activeDearManPlan = plan
        save()
        loadDearManPlans()
    }
    
    func updateDearManPlan(_ plan: DearManPlan) {
        save()
        loadDearManPlans()
    }
    
    func completeDearManPlan(_ plan: DearManPlan, outcome: String, reflection: String, effectiveness: Int) {
        plan.outcome = outcome
        plan.reflection = reflection
        plan.effectiveness = effectiveness
        plan.completed = true
        save()
        loadDearManPlans()
    }
    
    func deleteDearManPlan(_ plan: DearManPlan) {
        modelContext.delete(plan)
        if activeDearManPlan?.id == plan.id {
            activeDearManPlan = nil
        }
        save()
        loadDearManPlans()
    }
    
    // MARK: - GIVE Actions
    
    func createGivePlan(situation: String, relationship: String) {
        let plan = GivePlan(situation: situation, relationship: relationship)
        modelContext.insert(plan)
        activeGivePlan = plan
        save()
        loadGivePlans()
    }
    
    func updateGivePlan(_ plan: GivePlan) {
        save()
        loadGivePlans()
    }
    
    func completeGivePlan(_ plan: GivePlan, outcome: String, reflection: String, effectiveness: Int) {
        plan.outcome = outcome
        plan.reflection = reflection
        plan.effectiveness = effectiveness
        plan.completed = true
        save()
        loadGivePlans()
    }
    
    func deleteGivePlan(_ plan: GivePlan) {
        modelContext.delete(plan)
        if activeGivePlan?.id == plan.id {
            activeGivePlan = nil
        }
        save()
        loadGivePlans()
    }
    
    // MARK: - FAST Actions
    
    func createFastPlan(situation: String) {
        let plan = FastPlan(situation: situation)
        modelContext.insert(plan)
        activeFastPlan = plan
        save()
        loadFastPlans()
    }
    
    func updateFastPlan(_ plan: FastPlan) {
        save()
        loadFastPlans()
    }
    
    func completeFastPlan(_ plan: FastPlan, outcome: String, reflection: String, effectiveness: Int) {
        plan.outcome = outcome
        plan.reflection = reflection
        plan.effectiveness = effectiveness
        plan.completed = true
        save()
        loadFastPlans()
    }
    
    func deleteFastPlan(_ plan: FastPlan) {
        modelContext.delete(plan)
        if activeFastPlan?.id == plan.id {
            activeFastPlan = nil
        }
        save()
        loadFastPlans()
    }
    
    // MARK: - Statistics
    
    func averageEffectiveness(for skill: InterpersonalSkillType) -> Double {
        let completedPlans: [Int]
        
        switch skill {
        case .dearMan:
            completedPlans = dearManPlans.compactMap { $0.completed ? $0.effectiveness : nil }
        case .give:
            completedPlans = givePlans.compactMap { $0.completed ? $0.effectiveness : nil }
        case .fast:
            completedPlans = fastPlans.compactMap { $0.completed ? $0.effectiveness : nil }
        }
        
        guard !completedPlans.isEmpty else { return 0 }
        return Double(completedPlans.reduce(0, +)) / Double(completedPlans.count)
    }
    
    func totalPlansCount(for skill: InterpersonalSkillType) -> Int {
        switch skill {
        case .dearMan:
            return dearManPlans.count
        case .give:
            return givePlans.count
        case .fast:
            return fastPlans.count
        }
    }
    
    func completedPlansCount(for skill: InterpersonalSkillType) -> Int {
        switch skill {
        case .dearMan:
            return dearManPlans.filter { $0.completed }.count
        case .give:
            return givePlans.filter { $0.completed }.count
        case .fast:
            return fastPlans.filter { $0.completed }.count
        }
    }
    
    // MARK: - Helpers
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func startWizard(for skill: InterpersonalSkillType) {
        selectedSkill = skill
        currentStep = 0
        showingWizard = true
    }
    
    func nextStep() {
        currentStep += 1
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    func resetWizard() {
        currentStep = 0
        showingWizard = false
        activeDearManPlan = nil
        activeGivePlan = nil
        activeFastPlan = nil
    }
}
