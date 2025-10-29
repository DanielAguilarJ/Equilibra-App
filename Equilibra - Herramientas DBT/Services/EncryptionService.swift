//
//  EncryptionService.swift
//  Equilibra - Herramientas DBT
//
//  Created by HERMES on 28/10/25.
//

import Foundation
import CryptoKit
import Security

/// Servicio de encriptación para proteger el contenido del diario
final class EncryptionService {
    static let shared = EncryptionService()
    
    private let keychainService = "com.equilibra.journaling"
    private let keychainAccount = "encryption-key"
    
    private init() {}
    
    // MARK: - Key Management
    
    /// Obtiene o genera la clave de encriptación del Keychain
    private func getOrCreateEncryptionKey() throws -> SymmetricKey {
        // Intentar obtener la clave existente
        if let existingKey = try? getKeyFromKeychain() {
            return existingKey
        }
        
        // Generar nueva clave si no existe
        let newKey = SymmetricKey(size: .bits256)
        try saveKeyToKeychain(newKey)
        return newKey
    }
    
    /// Guarda la clave de encriptación en el Keychain
    private func saveKeyToKeychain(_ key: SymmetricKey) throws {
        let keyData = key.withUnsafeBytes { Data($0) }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecValueData as String: keyData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        
        // Eliminar clave existente si hay
        SecItemDelete(query as CFDictionary)
        
        // Agregar nueva clave
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw EncryptionError.keychainError
        }
    }
    
    /// Obtiene la clave de encriptación del Keychain
    private func getKeyFromKeychain() throws -> SymmetricKey {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let keyData = result as? Data else {
            throw EncryptionError.keychainError
        }
        
        return SymmetricKey(data: keyData)
    }
    
    // MARK: - Encryption/Decryption
    
    /// Encripta un texto usando AES-GCM
    func encrypt(_ text: String) throws -> Data {
        let key = try getOrCreateEncryptionKey()
        let data = Data(text.utf8)
        
        let sealedBox = try AES.GCM.seal(data, using: key)
        
        guard let combined = sealedBox.combined else {
            throw EncryptionError.encryptionFailed
        }
        
        return combined
    }
    
    /// Desencripta datos usando AES-GCM
    func decrypt(_ encryptedData: Data) throws -> String {
        let key = try getOrCreateEncryptionKey()
        
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        
        guard let text = String(data: decryptedData, encoding: .utf8) else {
            throw EncryptionError.decryptionFailed
        }
        
        return text
    }
    
    /// Elimina la clave de encriptación del Keychain
    func deleteEncryptionKey() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecAttrAccount as String: keychainAccount
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw EncryptionError.keychainError
        }
    }
}

// MARK: - Error Types

enum EncryptionError: LocalizedError {
    case keychainError
    case encryptionFailed
    case decryptionFailed
    
    var errorDescription: String? {
        switch self {
        case .keychainError:
            return "Error al acceder al Keychain"
        case .encryptionFailed:
            return "Error al encriptar el contenido"
        case .decryptionFailed:
            return "Error al desencriptar el contenido"
        }
    }
}
