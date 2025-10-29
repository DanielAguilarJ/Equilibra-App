//
//  JournalingPromptsService.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation

/// Servicio que proporciona prompts terapéuticos específicos para TLP
final class JournalingPromptsService {
    static let shared = JournalingPromptsService()
    
    private init() {}
    
    /// Todos los prompts terapéuticos disponibles
    let allPrompts: [TherapeuticPrompt] = [
        // MARK: - Prompts Emocionales
        TherapeuticPrompt(
            text: "¿Qué emoción estoy sintiendo ahora mismo?",
            category: .emotional,
            description: "Identifica y nombra tu emoción actual"
        ),
        TherapeuticPrompt(
            text: "¿Dónde siento esta emoción en mi cuerpo?",
            category: .emotional,
            description: "Conecta con las sensaciones físicas de tu emoción"
        ),
        TherapeuticPrompt(
            text: "¿Cuál es la intensidad de esta emoción del 1 al 10?",
            category: .emotional,
            description: "Cuantifica tu experiencia emocional"
        ),
        TherapeuticPrompt(
            text: "¿Qué emociones han estado presentes hoy?",
            category: .emotional,
            description: "Reflexiona sobre tu día emocional"
        ),
        TherapeuticPrompt(
            text: "¿Esta emoción es primaria o secundaria?",
            category: .emotional,
            description: "Distingue entre emociones primarias y secundarias"
        ),
        
        // MARK: - Prompts Cognitivos
        TherapeuticPrompt(
            text: "¿Qué evidencia tengo de que esto es cierto?",
            category: .cognitive,
            description: "Examina los hechos objetivamente"
        ),
        TherapeuticPrompt(
            text: "¿Qué evidencia tengo de que esto NO es cierto?",
            category: .cognitive,
            description: "Considera perspectivas alternativas"
        ),
        TherapeuticPrompt(
            text: "¿Estoy pensando en blanco y negro?",
            category: .cognitive,
            description: "Identifica pensamiento dicotómico"
        ),
        TherapeuticPrompt(
            text: "¿Qué le diría a un amigo en esta situación?",
            category: .cognitive,
            description: "Practica la autocompasión"
        ),
        TherapeuticPrompt(
            text: "¿Qué interpretaciones alternativas existen?",
            category: .cognitive,
            description: "Explora diferentes perspectivas"
        ),
        TherapeuticPrompt(
            text: "¿Estoy confundiendo un pensamiento con un hecho?",
            category: .cognitive,
            description: "Diferencia entre pensamientos y realidad"
        ),
        
        // MARK: - Prompts de Validación
        TherapeuticPrompt(
            text: "¿Qué tiene sentido acerca de lo que siento?",
            category: .validation,
            description: "Valida tu experiencia emocional"
        ),
        TherapeuticPrompt(
            text: "¿Qué he hecho bien hoy?",
            category: .validation,
            description: "Reconoce tus logros"
        ),
        TherapeuticPrompt(
            text: "¿Cómo he demostrado fortaleza recientemente?",
            category: .validation,
            description: "Identifica tu resiliencia"
        ),
        TherapeuticPrompt(
            text: "¿Qué aspectos de mi respuesta fueron efectivos?",
            category: .validation,
            description: "Reconoce tus habilidades de afrontamiento"
        ),
        
        // MARK: - Prompts de Necesidades
        TherapeuticPrompt(
            text: "¿Qué necesito en este momento?",
            category: .needs,
            description: "Identifica tus necesidades actuales"
        ),
        TherapeuticPrompt(
            text: "¿Cómo me gustaría sentirme?",
            category: .needs,
            description: "Define tu objetivo emocional"
        ),
        TherapeuticPrompt(
            text: "¿Qué me ayudaría a sentirme mejor ahora?",
            category: .needs,
            description: "Planifica acciones de autocuidado"
        ),
        TherapeuticPrompt(
            text: "¿Qué necesidad no satisfecha está detrás de esta emoción?",
            category: .needs,
            description: "Explora necesidades subyacentes"
        ),
        TherapeuticPrompt(
            text: "¿Qué tipo de apoyo necesito?",
            category: .needs,
            description: "Identifica necesidades de apoyo"
        ),
        
        // MARK: - Prompts de Comportamiento
        TherapeuticPrompt(
            text: "¿Qué acciones estoy considerando tomar?",
            category: .behavior,
            description: "Explora tus impulsos de acción"
        ),
        TherapeuticPrompt(
            text: "¿Esta acción me acerca o aleja de mis valores?",
            category: .behavior,
            description: "Evalúa coherencia con valores"
        ),
        TherapeuticPrompt(
            text: "¿Qué habilidad DBT podría usar ahora?",
            category: .behavior,
            description: "Identifica habilidades útiles"
        ),
        TherapeuticPrompt(
            text: "¿Qué consecuencias a corto y largo plazo tendría esta acción?",
            category: .behavior,
            description: "Considera las consecuencias"
        ),
        TherapeuticPrompt(
            text: "¿Qué me funcionó la última vez que me sentí así?",
            category: .behavior,
            description: "Recuerda estrategias efectivas"
        ),
        
        // MARK: - Prompts de Relaciones
        TherapeuticPrompt(
            text: "¿Cómo afecta esta situación a mis relaciones?",
            category: .relationships,
            description: "Explora el impacto relacional"
        ),
        TherapeuticPrompt(
            text: "¿Qué necesito comunicar a los demás?",
            category: .relationships,
            description: "Identifica necesidades de comunicación"
        ),
        TherapeuticPrompt(
            text: "¿Cómo puedo expresar esto de manera efectiva?",
            category: .relationships,
            description: "Planifica comunicación asertiva"
        ),
        TherapeuticPrompt(
            text: "¿Qué límites necesito establecer?",
            category: .relationships,
            description: "Reconoce necesidades de límites"
        ),
        TherapeuticPrompt(
            text: "¿Qué estoy asumiendo sobre las intenciones del otro?",
            category: .relationships,
            description: "Examina interpretaciones sobre otros"
        )
    ]
    
    /// Obtiene un prompt aleatorio
    func getRandomPrompt() -> TherapeuticPrompt {
        allPrompts.randomElement() ?? allPrompts[0]
    }
    
    /// Obtiene un prompt aleatorio de una categoría específica
    func getRandomPrompt(from category: TherapeuticPrompt.PromptCategory) -> TherapeuticPrompt? {
        let categoryPrompts = allPrompts.filter { $0.category == category }
        return categoryPrompts.randomElement()
    }
    
    /// Obtiene todos los prompts de una categoría
    func getPrompts(for category: TherapeuticPrompt.PromptCategory) -> [TherapeuticPrompt] {
        allPrompts.filter { $0.category == category }
    }
    
    /// Obtiene múltiples prompts aleatorios sin repetición
    func getRandomPrompts(count: Int) -> [TherapeuticPrompt] {
        Array(allPrompts.shuffled().prefix(count))
    }
}
