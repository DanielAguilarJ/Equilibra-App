//
//  MindfulnessExercise.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import SwiftData

/// Tipo de ejercicio de mindfulness
enum MindfulnessExerciseType: String, Codable, CaseIterable {
    case bodyScan = "Body Scan"
    case emotionObservation = "Observación de Emociones"
    case fiveSenses = "5 Sentidos"
    case lovingKindness = "Compasión y Amabilidad"
    
    var displayName: String {
        switch self {
        case .bodyScan:
            return "Escaneo Corporal"
        case .emotionObservation:
            return "Observación de Emociones"
        case .fiveSenses:
            return "Ejercicio de los 5 Sentidos"
        case .lovingKindness:
            return "Compasión y Amabilidad"
        }
    }
    
    var description: String {
        switch self {
        case .bodyScan:
            return "Recorre mentalmente tu cuerpo, observando sensaciones sin juzgarlas."
        case .emotionObservation:
            return "Observa tus emociones como nubes pasando, sin apegarte a ellas."
        case .fiveSenses:
            return "Conecta con el presente identificando 5 cosas que ves, 4 que tocas, 3 que oyes, 2 que hueles y 1 que saboreas."
        case .lovingKindness:
            return "Cultiva compasión hacia ti mismo y los demás con afirmaciones positivas."
        }
    }
    
    var icon: String {
        switch self {
        case .bodyScan:
            return "figure.stand"
        case .emotionObservation:
            return "eye.fill"
        case .fiveSenses:
            return "hand.raised.fill"
        case .lovingKindness:
            return "heart.circle.fill"
        }
    }
    
    var recommendedDuration: Int {
        switch self {
        case .bodyScan:
            return 10 // minutos
        case .emotionObservation:
            return 5
        case .fiveSenses:
            return 3
        case .lovingKindness:
            return 7
        }
    }
    
    var color: String {
        switch self {
        case .bodyScan:
            return "purple"
        case .emotionObservation:
            return "blue"
        case .fiveSenses:
            return "green"
        case .lovingKindness:
            return "pink"
        }
    }
}

@Model
final class MindfulnessExercise {
    var id: UUID
    var exerciseType: MindfulnessExerciseType
    var duration: Int // en minutos
    var instructions: [String]
    var createdDate: Date
    var lastPracticedDate: Date?
    var practiceCount: Int
    var completedSessions: Int
    var notes: String
    
    init(
        exerciseType: MindfulnessExerciseType,
        duration: Int? = nil
    ) {
        self.id = UUID()
        self.exerciseType = exerciseType
        self.duration = duration ?? exerciseType.recommendedDuration
        self.createdDate = Date()
        self.practiceCount = 0
        self.completedSessions = 0
        self.notes = ""
        
        // Configurar instrucciones según el tipo
        switch exerciseType {
        case .bodyScan:
            self.instructions = [
                "Encuentra una posición cómoda, sentado o acostado",
                "Cierra los ojos suavemente",
                "Comienza por los dedos de los pies, observa las sensaciones",
                "Sube lentamente por las piernas, caderas, torso",
                "Continúa por los brazos, manos, hombros",
                "Finaliza en el cuello, rostro y cabeza",
                "Si encuentras tensión, simplemente obsérvala sin juzgar",
                "Respira naturalmente durante todo el ejercicio"
            ]
            
        case .emotionObservation:
            self.instructions = [
                "Siéntate cómodamente y cierra los ojos",
                "Observa qué emoción está presente ahora",
                "No intentes cambiarla, solo nómbrala",
                "Observa dónde la sientes en tu cuerpo",
                "Imagina que es una nube pasando por el cielo",
                "Permítele estar ahí sin apegarte",
                "Recuerda: las emociones van y vienen",
                "Respira con aceptación y curiosidad"
            ]
            
        case .fiveSenses:
            self.instructions = [
                "5 COSAS QUE PUEDES VER: Mira a tu alrededor lentamente",
                "4 COSAS QUE PUEDES TOCAR: Siente texturas diferentes",
                "3 COSAS QUE PUEDES OÍR: Escucha sonidos cercanos y lejanos",
                "2 COSAS QUE PUEDES OLER: Percibe aromas a tu alrededor",
                "1 COSA QUE PUEDES SABOREAR: Nota el sabor en tu boca",
                "Este ejercicio te ancla al momento presente",
                "Úsalo cuando te sientas ansioso o desconectado"
            ]
            
        case .lovingKindness:
            self.instructions = [
                "Siéntate cómodamente y respira profundo",
                "Piensa en alguien que te ama incondicionalmente",
                "Siente ese amor y dirígelo hacia ti mismo",
                "Repite: 'Que esté seguro, que esté en paz'",
                "'Que esté saludable, que viva con facilidad'",
                "Extiende estos deseos a alguien querido",
                "Luego a alguien neutral, después a alguien difícil",
                "Finalmente, a todos los seres"
            ]
        }
    }
    
    func markPracticed() {
        lastPracticedDate = Date()
        practiceCount += 1
    }
    
    func completeSession() {
        completedSessions += 1
        markPracticed()
    }
}

// MARK: - Preset Exercises
extension MindfulnessExercise {
    static var presets: [MindfulnessExercise] {
        MindfulnessExerciseType.allCases.map { type in
            MindfulnessExercise(exerciseType: type)
        }
    }
}
