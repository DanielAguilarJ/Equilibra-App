//
//  MindfulnessViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
#if canImport(UIKit)
import UIKit
#endif

@MainActor
class MindfulnessViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var isBreathing = false
    @Published var currentPhase: BreathingPhase = .inhale
    @Published var cyclesCompleted = 0
    @Published var timeRemaining = 0
    @Published var progress: Double = 0.0
    @Published var currentExercise: BreathingExercise?
    
    // Mindfulness timer
    @Published var isMeditating = false
    @Published var meditationTimeRemaining = 0
    @Published var meditationProgress: Double = 0.0
    @Published var currentMindfulnessExercise: MindfulnessExercise?
    @Published var currentInstructionIndex = 0
    
    // Audio
    private var audioPlayer: AVAudioPlayer?
    #if canImport(UIKit)
    private let hapticGenerator = UINotificationFeedbackGenerator()
    private let impactGenerator = UIImpactFeedbackGenerator(style: .medium)
    #endif
    
    // Timers
    private var breathingTimer: Timer?
    private var meditationTimer: Timer?
    
    // MARK: - Breathing Exercise Methods
    
    func startBreathing(exercise: BreathingExercise) {
        guard !isBreathing else { return }
        
        currentExercise = exercise
        isBreathing = true
        cyclesCompleted = 0
        currentPhase = .inhale
        
        startBreathingCycle()
        #if canImport(UIKit)
        hapticGenerator.prepare()
        #endif
    }
    
    func stopBreathing() {
        isBreathing = false
        breathingTimer?.invalidate()
        breathingTimer = nil
        progress = 0.0
        
        if let exercise = currentExercise, cyclesCompleted > 0 {
            exercise.markPracticed()
        }
    }
    
    private func startBreathingCycle() {
        guard let exercise = currentExercise, isBreathing else { return }
        
        if cyclesCompleted >= exercise.totalCycles {
            completeBreathingExercise()
            return
        }
        
        executePhase(.inhale, duration: exercise.inhaleDuration)
    }
    
    private func executePhase(_ phase: BreathingPhase, duration: Int) {
        guard isBreathing else { return }
        
        currentPhase = phase
        timeRemaining = duration
        
        // Haptic feedback al inicio de cada fase
        #if canImport(UIKit)
        if duration > 0 {
            impactGenerator.impactOccurred()
        }
        #endif
        
        breathingTimer?.invalidate()
        breathingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateBreathingTimer()
        }
    }
    
    private func updateBreathingTimer() {
        guard let exercise = currentExercise else { return }
        
        timeRemaining -= 1
        
        let totalCycleDuration = exercise.cycleDuration
        let currentDuration: Int
        
        switch currentPhase {
        case .inhale:
            currentDuration = exercise.inhaleDuration - timeRemaining
            progress = Double(currentDuration) / Double(exercise.inhaleDuration)
        case .holdAfterInhale:
            currentDuration = exercise.holdAfterInhaleDuration - timeRemaining
            progress = Double(currentDuration) / Double(exercise.holdAfterInhaleDuration)
        case .exhale:
            currentDuration = exercise.exhaleDuration - timeRemaining
            progress = 1.0 - (Double(currentDuration) / Double(exercise.exhaleDuration))
        case .holdAfterExhale:
            currentDuration = exercise.holdAfterExhaleDuration - timeRemaining
            progress = Double(currentDuration) / Double(exercise.holdAfterExhaleDuration)
        }
        
        if timeRemaining <= 0 {
            moveToNextPhase()
        }
    }
    
    private func moveToNextPhase() {
        guard let exercise = currentExercise else { return }
        
        breathingTimer?.invalidate()
        
        switch currentPhase {
        case .inhale:
            if exercise.holdAfterInhaleDuration > 0 {
                executePhase(.holdAfterInhale, duration: exercise.holdAfterInhaleDuration)
            } else {
                executePhase(.exhale, duration: exercise.exhaleDuration)
            }
            
        case .holdAfterInhale:
            executePhase(.exhale, duration: exercise.exhaleDuration)
            
        case .exhale:
            if exercise.holdAfterExhaleDuration > 0 {
                executePhase(.holdAfterExhale, duration: exercise.holdAfterExhaleDuration)
            } else {
                completeCycle()
            }
            
        case .holdAfterExhale:
            completeCycle()
        }
    }
    
    private func completeCycle() {
        cyclesCompleted += 1
        #if canImport(UIKit)
        hapticGenerator.notificationOccurred(.success)
        #endif
        
        if cyclesCompleted >= (currentExercise?.totalCycles ?? 0) {
            completeBreathingExercise()
        } else {
            executePhase(.inhale, duration: currentExercise?.inhaleDuration ?? 4)
        }
    }
    
    private func completeBreathingExercise() {
        playCompletionSound()
        #if canImport(UIKit)
        hapticGenerator.notificationOccurred(.success)
        #endif
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.stopBreathing()
        }
    }
    
    // MARK: - Mindfulness Exercise Methods
    
    func startMindfulness(exercise: MindfulnessExercise) {
        guard !isMeditating else { return }
        
        currentMindfulnessExercise = exercise
        isMeditating = true
        meditationTimeRemaining = exercise.duration * 60 // convertir a segundos
        currentInstructionIndex = 0
        meditationProgress = 0.0
        
        meditationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateMeditationTimer()
        }
        
        // Tocar campana de inicio
        playBellSound()
        #if canImport(UIKit)
        hapticGenerator.prepare()
        #endif
    }
    
    func stopMindfulness() {
        isMeditating = false
        meditationTimer?.invalidate()
        meditationTimer = nil
        meditationProgress = 0.0
        currentInstructionIndex = 0
        
        if let exercise = currentMindfulnessExercise, meditationProgress > 0.5 {
            exercise.markPracticed()
        }
    }
    
    func completeMindfulness() {
        guard let exercise = currentMindfulnessExercise else { return }
        
        exercise.completeSession()
        playBellSound()
        #if canImport(UIKit)
        hapticGenerator.notificationOccurred(.success)
        #endif
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.stopMindfulness()
        }
    }
    
    private func updateMeditationTimer() {
        guard let exercise = currentMindfulnessExercise else { return }
        
        meditationTimeRemaining -= 1
        let totalSeconds = exercise.duration * 60
        meditationProgress = 1.0 - (Double(meditationTimeRemaining) / Double(totalSeconds))
        
        // Avanzar instrucciones
        let instructionInterval = totalSeconds / exercise.instructions.count
        let newIndex = Int(meditationProgress * Double(exercise.instructions.count))
        
        if newIndex != currentInstructionIndex && newIndex < exercise.instructions.count {
            currentInstructionIndex = newIndex
            #if canImport(UIKit)
            impactGenerator.impactOccurred()
            #endif
        }
        
        if meditationTimeRemaining <= 0 {
            completeMindfulness()
        }
    }
    
    func nextInstruction() {
        guard let exercise = currentMindfulnessExercise else { return }
        
        if currentInstructionIndex < exercise.instructions.count - 1 {
            currentInstructionIndex += 1
            #if canImport(UIKit)
            impactGenerator.impactOccurred()
            #endif
        }
    }
    
    func previousInstruction() {
        if currentInstructionIndex > 0 {
            currentInstructionIndex -= 1
            #if canImport(UIKit)
            impactGenerator.impactOccurred()
            #endif
        }
    }
    
    // MARK: - Audio Methods
    
    private func playBellSound() {
        // Generar un sonido de campana suave usando síntesis
        AudioServicesPlaySystemSound(1013) // Campana del sistema
    }
    
    private func playCompletionSound() {
        AudioServicesPlaySystemSound(1057) // Sonido de completado
    }
    
    // MARK: - Cleanup
    
    deinit {
        breathingTimer?.invalidate()
        meditationTimer?.invalidate()
    }
}
