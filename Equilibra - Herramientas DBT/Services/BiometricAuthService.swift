//
//  BiometricAuthService.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import LocalAuthentication
import Combine

/// Servicio para autenticación biométrica (Face ID / Touch ID)
class BiometricAuthService: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authenticationError: String?
    
    enum BiometricType {
        case none
        case touchID
        case faceID
    }
    
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        default:
            return .none
        }
    }
    
    var biometricAvailable: Bool {
        biometricType != .none
    }
    
    var biometricTypeName: String {
        switch biometricType {
        case .touchID:
            return "Touch ID"
        case .faceID:
            return "Face ID"
        case .none:
            return "No disponible"
        }
    }
    
    /// Autentica al usuario usando biometría
    func authenticate(reason: String = "Acceder a tu plan de seguridad", completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Verificar si la autenticación biométrica está disponible
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Si no hay biometría, intentar con código de dispositivo
            authenticateWithDevicePassword(context: context, reason: reason, completion: completion)
            return
        }
        
        // Realizar autenticación biométrica
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.authenticationError = nil
                    completion(true, nil)
                } else {
                    self.isAuthenticated = false
                    let errorMessage = self.handleAuthenticationError(authenticationError as? LAError)
                    self.authenticationError = errorMessage
                    completion(false, errorMessage)
                }
            }
        }
    }
    
    /// Autentica usando el código del dispositivo como fallback
    private func authenticateWithDevicePassword(context: LAContext, reason: String, completion: @escaping (Bool, String?) -> Void) {
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            DispatchQueue.main.async {
                completion(false, "No se puede autenticar en este dispositivo")
            }
            return
        }
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    self.isAuthenticated = true
                    self.authenticationError = nil
                    completion(true, nil)
                } else {
                    self.isAuthenticated = false
                    let errorMessage = self.handleAuthenticationError(authenticationError as? LAError)
                    self.authenticationError = errorMessage
                    completion(false, errorMessage)
                }
            }
        }
    }
    
    /// Maneja los errores de autenticación
    private func handleAuthenticationError(_ error: LAError?) -> String {
        guard let error = error else {
            return "Error de autenticación desconocido"
        }
        
        switch error.code {
        case .authenticationFailed:
            return "La autenticación falló. Inténtalo de nuevo."
        case .userCancel:
            return "Autenticación cancelada por el usuario"
        case .userFallback:
            return "Usuario seleccionó usar contraseña"
        case .biometryNotAvailable:
            return "La autenticación biométrica no está disponible"
        case .biometryNotEnrolled:
            return "No hay datos biométricos configurados"
        case .biometryLockout:
            return "Biometría bloqueada. Usa tu código de acceso."
        case .appCancel:
            return "Autenticación cancelada por la app"
        case .invalidContext:
            return "Contexto de autenticación inválido"
        case .passcodeNotSet:
            return "No hay código de acceso configurado en el dispositivo"
        default:
            return "Error de autenticación: \(error.localizedDescription)"
        }
    }
    
    /// Reinicia el estado de autenticación
    func logout() {
        isAuthenticated = false
        authenticationError = nil
    }
}
