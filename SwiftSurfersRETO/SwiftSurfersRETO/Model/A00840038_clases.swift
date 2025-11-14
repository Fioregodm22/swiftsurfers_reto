//
//  A00840038_clases.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 12/11/25.
//

import Foundation


struct Viaje: Identifiable {
    let id = UUID()
    let nombre: String
    let distancia: String
    let idServicio: Int
    let fecha: Date
    let estatus: String?
}

struct ViajeData: Decodable, Identifiable {
    let idServicio: Int
    let kmFinal: Double?
    let fecha: String
    let estatus: String?
    
    var id: Int { idServicio }
    
    var fechaDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: fecha)
    }
}

struct ViajeAPIResponse: Decodable {
    let Info: [ViajeData]
    let id_usuario: String
    let mensaje: String
    let fecha_filtro: String?
    let total_viajes: Int
}
