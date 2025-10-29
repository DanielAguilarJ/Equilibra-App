//
//  EmotionRegulationViewModel.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
class EmotionRegulationViewModel {
    var currentSession: EmotionRegulationSession?
    var showingToolDetail = false
    var selectedTool: EmotionRegulationToolType?
    
    // Check the Facts state
    var checkFactsQuestions: [CheckFactsQuestion] = []
    var situation: String = ""
    var emotionIdentified: String = ""
    var factsVsInterpretations: String = ""
    
    // Opposite Action state
    var currentEmotion: String = ""
    var emotionIntensity: Double = 5.0
    var selectedOppositeAction: EmotionAction?
    
    // Statistics
    var sessions: [EmotionRegulationSession] = []
    
    init() {
        initializeCheckFactsQuestions()
    }
    
    func initializeCheckFactsQuestions() {
        checkFactsQuestions = [
            CheckFactsQuestion(question: "¿Qué sucedió exactamente? (Solo los hechos)"),
            CheckFactsQuestion(question: "¿Cuál fue mi interpretación de la situación?"),
            CheckFactsQuestion(question: "¿Qué evidencia tengo de que mi interpretación es correcta?"),
            CheckFactsQuestion(question: "¿Qué evidencia tengo de que mi interpretación podría ser incorrecta?"),
            CheckFactsQuestion(question: "¿Hay otras formas de interpretar esta situación?"),
            CheckFactsQuestion(question: "¿Estoy considerando solo lo negativo o también lo positivo?"),
            CheckFactsQuestion(question: "¿Estoy asumiendo lo peor?"),
            CheckFactsQuestion(question: "¿Mi emoción se ajusta a los hechos de la situación?")
        ]
    }
    
    func startSession(toolType: EmotionRegulationToolType, emotion: String, intensity: Int) {
        currentSession = EmotionRegulationSession(
            toolType: toolType,
            initialEmotion: emotion,
            initialIntensity: intensity
        )
    }
    
    func completeSession(finalIntensity: Int, notes: String, wasHelpful: Bool) {
        guard let session = currentSession else { return }
        session.finalIntensity = finalIntensity
        session.notes = notes
        session.wasHelpful = wasHelpful
        sessions.append(session)
        currentSession = nil
    }
    
    func getOppositeActions() -> [EmotionAction] {
        return [
            EmotionAction(
                emotion: "Tristeza",
                typicalUrge: "Aislarse, quedarse en cama, evitar actividades",
                oppositeAction: "Activarte y socializar",
                examples: [
                    "Salir a caminar o hacer ejercicio",
                    "Llamar a un amigo o familiar",
                    "Realizar una actividad que normalmente disfrutas",
                    "Escuchar música alegre y moverte"
                ]
            ),
            EmotionAction(
                emotion: "Ansiedad/Miedo",
                typicalUrge: "Evitar la situación, huir, esconderse",
                oppositeAction: "Acercarte gradualmente a lo que temes",
                examples: [
                    "Enfrentar la situación paso a paso",
                    "Practicar respiración profunda mientras te acercas",
                    "Mantener contacto visual si es social",
                    "Repetir la exposición hasta que disminuya la ansiedad"
                ]
            ),
            EmotionAction(
                emotion: "Ira/Enojo",
                typicalUrge: "Atacar, gritar, ser agresivo",
                oppositeAction: "Ser amable y retirarte suavemente",
                examples: [
                    "Alejarte de la situación temporalmente",
                    "Hablar con voz calmada y baja",
                    "Hacer algo amable por la persona",
                    "Practicar empatía y ver su perspectiva"
                ]
            ),
            EmotionAction(
                emotion: "Vergüenza/Culpa",
                typicalUrge: "Esconderse, evitar el contacto visual",
                oppositeAction: "Mantener la cabeza alta y hacer reparaciones",
                examples: [
                    "Mantener contacto visual",
                    "Disculparte si es apropiado y seguir adelante",
                    "Compartir tu experiencia con alguien de confianza",
                    "Recordar que todos cometemos errores"
                ]
            ),
            EmotionAction(
                emotion: "Celos/Envidia",
                typicalUrge: "Sabotear, comparar constantemente",
                oppositeAction: "Celebrar el éxito de otros",
                examples: [
                    "Felicitar genuinamente a la persona",
                    "Enfocarte en tus propios logros",
                    "Practicar gratitud por lo que tienes",
                    "Usar su éxito como inspiración"
                ]
            )
        ]
    }
    
    func getToolStats(for toolType: EmotionRegulationToolType) -> (uses: Int, effectiveness: Double) {
        let toolSessions = sessions.filter { $0.toolType == toolType }
        let uses = toolSessions.count
        
        let helpfulSessions = toolSessions.filter { $0.wasHelpful == true }.count
        let effectiveness = uses > 0 ? Double(helpfulSessions) / Double(uses) : 0.0
        
        return (uses, effectiveness)
    }
    
    func resetCheckFacts() {
        initializeCheckFactsQuestions()
        situation = ""
        emotionIdentified = ""
        factsVsInterpretations = ""
    }
}
