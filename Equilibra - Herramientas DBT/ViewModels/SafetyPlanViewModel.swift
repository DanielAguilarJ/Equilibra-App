//
//  SafetyPlanViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class SafetyPlanViewModel {
    var safetyPlan: SafetyPlan?
    var modelContext: ModelContext?
    var biometricService = BiometricAuthService()
    
    // Estado del wizard
    var currentStep = 0
    var isEditMode = false
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
        loadSafetyPlan()
    }
    
    func loadSafetyPlan() {
        guard let context = modelContext else { return }
        
        let descriptor = FetchDescriptor<SafetyPlan>(
            sortBy: [SortDescriptor(\.createdDate, order: .reverse)]
        )
        
        do {
            let plans = try context.fetch(descriptor)
            safetyPlan = plans.first
            
            // Si no existe, crear uno nuevo
            if safetyPlan == nil {
                let newPlan = SafetyPlan()
                context.insert(newPlan)
                safetyPlan = newPlan
                try context.save()
            }
        } catch {
            print("Error loading safety plan: \(error)")
        }
    }
    
    // MARK: - Warning Signals
    func addWarningSignal(_ signal: String) {
        guard let plan = safetyPlan else { return }
        plan.warningSignals.append(signal)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func removeWarningSignal(at index: Int) {
        guard let plan = safetyPlan else { return }
        plan.warningSignals.remove(at: index)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func updateWarningSignal(at index: Int, with signal: String) {
        guard let plan = safetyPlan else { return }
        plan.warningSignals[index] = signal
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Coping Strategies
    func addCopingStrategy(_ strategy: SafetyCopingStrategy) {
        guard let plan = safetyPlan else { return }
        var newStrategy = strategy
        newStrategy.order = plan.copingStrategies.count
        plan.copingStrategies.append(newStrategy)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func removeCopingStrategy(at index: Int) {
        guard let plan = safetyPlan else { return }
        plan.copingStrategies.remove(at: index)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func updateCopingStrategy(at index: Int, with strategy: SafetyCopingStrategy) {
        guard let plan = safetyPlan else { return }
        plan.copingStrategies[index] = strategy
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Support Contacts
    func addSupportContact(_ contact: SupportContact) {
        guard let plan = safetyPlan else { return }
        var newContact = contact
        newContact.order = plan.supportContacts.count
        plan.supportContacts.append(newContact)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func removeSupportContact(at index: Int) {
        guard let plan = safetyPlan else { return }
        plan.supportContacts.remove(at: index)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func updateSupportContact(at index: Int, with contact: SupportContact) {
        guard let plan = safetyPlan else { return }
        plan.supportContacts[index] = contact
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Professional Contacts
    func addProfessionalContact(_ contact: ProfessionalContact) {
        guard let plan = safetyPlan else { return }
        var newContact = contact
        newContact.order = plan.professionalContacts.count
        plan.professionalContacts.append(newContact)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func removeProfessionalContact(at index: Int) {
        guard let plan = safetyPlan else { return }
        plan.professionalContacts.remove(at: index)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func updateProfessionalContact(at index: Int, with contact: ProfessionalContact) {
        guard let plan = safetyPlan else { return }
        plan.professionalContacts[index] = contact
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Emergency Contacts
    func addEmergencyContact(_ contact: EmergencyContact) {
        guard let plan = safetyPlan else { return }
        var newContact = contact
        newContact.order = plan.emergencyContacts.count
        plan.emergencyContacts.append(newContact)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func removeEmergencyContact(at index: Int) {
        guard let plan = safetyPlan else { return }
        plan.emergencyContacts.remove(at: index)
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Reasons to Live
    func addReasonToLive(_ reason: String) {
        guard let plan = safetyPlan else { return }
        plan.reasonsToLive.append(reason)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func removeReasonToLive(at index: Int) {
        guard let plan = safetyPlan else { return }
        plan.reasonsToLive.remove(at: index)
        plan.updateModifiedDate()
        saveContext()
    }
    
    func updateReasonToLive(at index: Int, with reason: String) {
        guard let plan = safetyPlan else { return }
        plan.reasonsToLive[index] = reason
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Plan Management
    func activatePlan() {
        guard let plan = safetyPlan else { return }
        plan.isActive = true
        plan.updateModifiedDate()
        saveContext()
    }
    
    func toggleAuthentication() {
        guard let plan = safetyPlan else { return }
        plan.requiresAuthentication.toggle()
        saveContext()
    }
    
    func resetPlan() {
        guard let plan = safetyPlan else { return }
        plan.warningSignals.removeAll()
        plan.copingStrategies.removeAll()
        plan.supportContacts.removeAll()
        plan.professionalContacts.removeAll()
        plan.emergencyContacts.removeAll()
        plan.reasonsToLive.removeAll()
        plan.isActive = false
        plan.updateModifiedDate()
        saveContext()
    }
    
    // MARK: - Helpers
    private func saveContext() {
        guard let context = modelContext else { return }
        do {
            try context.save()
        } catch {
            print("Error saving safety plan: \(error)")
        }
    }
    
    func makePhoneCall(to number: String) {
        let phoneNumber = number.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "tel://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
    
    func sendMessage(to number: String) {
        let phoneNumber = number.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        
        if let url = URL(string: "sms://\(phoneNumber)") {
            UIApplication.shared.open(url)
        }
    }
}
