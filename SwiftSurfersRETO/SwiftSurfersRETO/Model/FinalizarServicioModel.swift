//
//  FinalizarServicioModel.swift
//  SwiftSurfersRETO
//
//  Created by Perla Reyes on 12/11/25.
//

import Foundation


//END POINT GET - Obtener la hora de inicio y km de inicio
//PARAMETRO: ID_DETALLE
struct GetInicio: Codable {
    let horaInicio: String
    let idAmbulancia, idDetalle: Int
    let idMedico: Int?
    let idServicio, kmInicio: Int
}

//END POINT PUT - Actualiza la hora final, km final, tiempo total y km totales
//PARAMETRO: ID_DETALLE
struct PutFinalizar: Codable {
    let horaFinal: String
    let idDetalle, kmFinal: Int
}


