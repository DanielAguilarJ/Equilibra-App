//
//  InterpersonalSkill.swift
//  Equilibra - Herramientas DBT
//
//  Sistema de Habilidades Interpersonales DBT
//

import Foundation
import SwiftData

/// Tipos de habilidades interpersonales DBT
enum InterpersonalSkillType: String, Codable, CaseIterable {
    case dearMan = "DEAR MAN"
    case give = "GIVE"
    case fast = "FAST"
    
    var title: String { rawValue }
    
    var description: String {
        switch self {
        case .dearMan:
            return "Para obtener lo que quieres (objetivos)"
        case .give:
            return "Para mantener relaciones saludables"
        case .fast:
            return "Para mantener el autorespeto"
        }
    }
    
    var icon: String {
        switch self {
        case .dearMan:
            return "target"
        case .give:
            return "heart.circle"
        case .fast:
            return "shield.checkered"
        }
    }
    
    var color: String {
        switch self {
        case .dearMan:
            return "blue"
        case .give:
            return "pink"
        case .fast:
            return "purple"
        }
    }
}

/// Plan de acción para DEAR MAN
@Model
final class DearManPlan {
    var id: UUID
    var createdAt: Date
    var situation: String
    var goal: String
    
    // DEAR MAN Components
    var describe: String        // Describe la situación
    var express: String         // Expresa sentimientos
    var assert: String          // Afirma lo que quieres
    var reinforce: String       // Refuerza consecuencias positivas
    var mindful: String         // Mantén el foco
    var appearConfident: String // Aparenta confianza
    var negotiate: String       // Negocia si es necesario
    
    var outcome: String?
    var reflection: String?
    var effectiveness: Int?     // 1-10
    var completed: Bool
    
    init(
        situation: String = "",
        goal: String = "",
        describe: String = "",
        express: String = "",
        assert: String = "",
        reinforce: String = "",
        mindful: String = "",
        appearConfident: String = "",
        negotiate: String = ""
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.situation = situation
        self.goal = goal
        self.describe = describe
        self.express = express
        self.assert = assert
        self.reinforce = reinforce
        self.mindful = mindful
        self.appearConfident = appearConfident
        self.negotiate = negotiate
        self.completed = false
    }
}

/// Plan de acción para GIVE
@Model
final class GivePlan {
    var id: UUID
    var createdAt: Date
    var situation: String
    var relationship: String
    
    // GIVE Components
    var gentle: Bool            // Ser amable
    var gentleNotes: String
    var interested: Bool        // Mostrar interés
    var interestedNotes: String
    var validate: Bool          // Validar
    var validateNotes: String
    var easyManner: Bool        // Actitud relajada
    var easyMannerNotes: String
    
    var outcome: String?
    var reflection: String?
    var effectiveness: Int?
    var completed: Bool
    
    init(
        situation: String = "",
        relationship: String = ""
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.situation = situation
        self.relationship = relationship
        self.gentle = false
        self.gentleNotes = ""
        self.interested = false
        self.interestedNotes = ""
        self.validate = false
        self.validateNotes = ""
        self.easyManner = false
        self.easyMannerNotes = ""
        self.completed = false
    }
}

/// Plan de acción para FAST
@Model
final class FastPlan {
    var id: UUID
    var createdAt: Date
    var situation: String
    
    // FAST Components
    var fair: Bool              // Ser justo
    var fairNotes: String
    var apologies: Bool         // No disculparse excesivamente
    var apologiesNotes: String
    var stickToValues: Bool     // Adherirse a valores
    var stickToValuesNotes: String
    var truthful: Bool          // Ser honesto
    var truthfulNotes: String
    
    var myValues: String        // Valores personales identificados
    var outcome: String?
    var reflection: String?
    var effectiveness: Int?
    var completed: Bool
    
    init(situation: String = "") {
        self.id = UUID()
        self.createdAt = Date()
        self.situation = situation
        self.fair = false
        self.fairNotes = ""
        self.apologies = false
        self.apologiesNotes = ""
        self.stickToValues = false
        self.stickToValuesNotes = ""
        self.truthful = false
        self.truthfulNotes = ""
        self.myValues = ""
        self.completed = false
    }
}

/// Situación común para selector contextual
struct InterpersonalSituation: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let recommendedSkill: InterpersonalSkillType
    let example: String
    
    static let commonSituations = [
        InterpersonalSituation(
            title: "Pedir algo importante",
            description: "Necesitas pedir un favor, permiso o cambio",
            recommendedSkill: .dearMan,
            example: "Pedir un aumento, pedir ayuda, establecer un límite"
        ),
        InterpersonalSituation(
            title: "Decir no sin culpa",
            description: "Necesitas rechazar una petición manteniendo la relación",
            recommendedSkill: .dearMan,
            example: "Rechazar trabajo extra, decir no a un favor"
        ),
        InterpersonalSituation(
            title: "Resolver un conflicto",
            description: "Hay tensión en una relación importante",
            recommendedSkill: .give,
            example: "Discusión con amigo/a, malentendido familiar"
        ),
        InterpersonalSituation(
            title: "Fortalecer una relación",
            description: "Quieres mejorar la conexión con alguien",
            recommendedSkill: .give,
            example: "Conversación difícil, momento de apoyo"
        ),
        InterpersonalSituation(
            title: "Defender tus valores",
            description: "Te piden algo que va contra tus principios",
            recommendedSkill: .fast,
            example: "Presión de grupo, situación ética"
        ),
        InterpersonalSituation(
            title: "Mantener tu dignidad",
            description: "Situación donde podrías comprometer tu autorespeto",
            recommendedSkill: .fast,
            example: "Crítica injusta, manipulación"
        )
    ]
}

/// Tips y ejemplos para cada componente
struct ComponentTip {
    let component: String
    let tip: String
    let example: String
    let warning: String?
}

extension InterpersonalSkillType {
    var components: [ComponentTip] {
        switch self {
        case .dearMan:
            return [
                ComponentTip(
                    component: "Describe",
                    tip: "Describe solo los hechos observables, sin juicios",
                    example: "\"Ayer acordamos reunirnos a las 3pm y llegaste a las 4pm\"",
                    warning: "Evita: \"Siempre llegas tarde y no te importa mi tiempo\""
                ),
                ComponentTip(
                    component: "Express",
                    tip: "Expresa tus sentimientos usando \"yo siento\" sin culpar",
                    example: "\"Me sentí frustrado/a porque tenía otros planes\"",
                    warning: "Evita: \"Me haces sentir mal\""
                ),
                ComponentTip(
                    component: "Assert",
                    tip: "Pide específicamente lo que quieres o necesitas",
                    example: "\"Me gustaría que me avises si vas a llegar tarde\"",
                    warning: "Evita ser vago: \"Deberías ser más considerado/a\""
                ),
                ComponentTip(
                    component: "Reinforce",
                    tip: "Explica los beneficios positivos de conseguir lo que pides",
                    example: "\"Así podré planificar mejor y disfrutaremos más nuestro tiempo juntos\"",
                    warning: "Evita amenazas o castigos"
                ),
                ComponentTip(
                    component: "Mindful",
                    tip: "Mantén el foco en tu objetivo, no te distraigas",
                    example: "Si te atacan: \"Entiendo, pero volviendo a mi petición...\"",
                    warning: "No te enganches en ataques o temas secundarios"
                ),
                ComponentTip(
                    component: "Appear Confident",
                    tip: "Usa lenguaje corporal y tono seguros (aunque no te sientas así)",
                    example: "Contacto visual, postura erguida, voz firme pero calmada",
                    warning: "No confundir con agresividad"
                ),
                ComponentTip(
                    component: "Negotiate",
                    tip: "Está dispuesto/a a comprometerte o buscar alternativas",
                    example: "\"Si eso no funciona, ¿qué tal si...?\"",
                    warning: "No negocies tus valores fundamentales"
                )
            ]
            
        case .give:
            return [
                ComponentTip(
                    component: "Gentle",
                    tip: "Sé amable y respetuoso/a, evita ataques",
                    example: "Tono calmado, sin sarcasmo, sin amenazas",
                    warning: "La gentileza no significa ser pasivo/a"
                ),
                ComponentTip(
                    component: "Interested",
                    tip: "Muestra genuino interés en la perspectiva de la otra persona",
                    example: "\"Cuéntame más sobre cómo ves la situación\"",
                    warning: "Escucha activamente, no solo esperes tu turno"
                ),
                ComponentTip(
                    component: "Validate",
                    tip: "Reconoce y valida los sentimientos de la otra persona",
                    example: "\"Entiendo que esto te frustre, tiene sentido\"",
                    warning: "Validar ≠ estar de acuerdo"
                ),
                ComponentTip(
                    component: "Easy Manner",
                    tip: "Mantén una actitud relajada y amigable",
                    example: "Sonríe apropiadamente, usa humor ligero si es apropiado",
                    warning: "No minimices problemas serios"
                )
            ]
            
        case .fast:
            return [
                ComponentTip(
                    component: "Fair",
                    tip: "Sé justo/a contigo mismo/a y con los demás",
                    example: "Valida tus propios sentimientos igual que los de otros",
                    warning: "No te sacrifiques constantemente"
                ),
                ComponentTip(
                    component: "Apologies",
                    tip: "No te disculpes excesivamente o por existir",
                    example: "Evita: \"Perdón por molestar, siento ser una carga...\"",
                    warning: "Disculparse apropiadamente está bien, excesivamente no"
                ),
                ComponentTip(
                    component: "Stick to Values",
                    tip: "Mantente fiel a tus valores y creencias",
                    example: "\"Esto es importante para mí y no puedo comprometerlo\"",
                    warning: "Identifica primero cuáles son tus valores"
                ),
                ComponentTip(
                    component: "Truthful",
                    tip: "Sé honesto/a, no exageres ni minimices",
                    example: "Di la verdad sin mentiras ni manipulación",
                    warning: "La honestidad puede ser amable (combina con GIVE)"
                )
            ]
        }
    }
}
