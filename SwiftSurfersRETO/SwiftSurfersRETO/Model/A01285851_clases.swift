//
//  A01285851_clases.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 11/11/25.
//

import Foundation
 
let usuarioprueba = UserData(idPersonal: 0, nombre: "", apellidoPaterno: "", codigoUsuario: "", correoElectronico : "", telefono: "", estatus: "Cargando...")

struct LoginResponse: Decodable {
    let valido: Bool
    let id_usuario: String
    let mensaje: String
}


struct UserData: Decodable {
    let idPersonal: Int
    let nombre: String
    let apellidoPaterno: String
    let codigoUsuario: String
    let correoElectronico : String
    let telefono: String
    let estatus: String
   
}

struct APIResponse: Decodable {
    let Info:[ UserData]
    
}

struct StatusUpdateResponse: Decodable {
    let success: Bool
    let message: String
    let id_usuario: Int
    let nuevo_status: String
}


struct LoginRequest: Encodable {
    let id_usuario: Int
    let contrasena: String // O el nombre de tu variable de contraseña (password)
}
