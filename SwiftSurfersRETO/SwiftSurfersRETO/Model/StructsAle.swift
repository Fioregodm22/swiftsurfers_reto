//
//  StructsAle.swift
//  SwiftSurfersRETO
//
//  Created by Alejandra on 12/11/25.
//

import Foundation

struct ServicioHistorial: Codable, Identifiable {
    var id: Int { idServicio }
    let idServicio: Int
    let idNumeroSocio: Int
    let fecha: String
    let hora: String?
    let origen: String?
    let destino: String?
    let tipoServicio: String?
    let nombreAsociado: String
    let estatusDescripcion: String?
    let estatusColor: String?
    let tiempoTotal: Int?
    let kmTotales: Int?
    let placas: String?
}

struct CrearServicioRequest: Codable {
    let idNumeroSocio: Int
    let idPersonal: Int
    let fecha: String
    let hora: String
    let tipoServicio: String
    let origen: String
    let destino: String
    let idMedico: Int?
    let idAmbulancia: Int?
    let latitudOrigen: Double?
    let longitudOrigen: Double?
    let latitudDestino: Double?
    let longitudDestino: Double?
}

struct ActualizarEstatusRequest: Codable {
    let idEstatusTraslado: Int
}

struct IniciarServicioRequest: Codable {
    let kmInicio: Int
}

struct CrearServicioResponse: Codable {
    let idServicio: Int
    let idDetalle: Int
    let idEstatus: Int
}

struct IniciarServicioResponse: Codable {
    let success: Bool
    let idEstatus: Int
}

struct FinalizarServicioResponse: Codable {
    let success: Bool
    let idEstatus: Int
}

