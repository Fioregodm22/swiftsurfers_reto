//
//  servicio.swift
//  SwiftSurfersRETO
//
//  Created by Maria Cavada on 14/10/25.
//

import Foundation
import SwiftUI



struct EstadoServicio2 {
    let nombre: String
    let color: Color
    let Image: String
    let id: Int

    init(id: Int) {
        self.id = id

        switch id {
        case 1:
            self.nombre = "Agendado"
            self.color = .gray
            self.Image = "time-gray"
        case 2:
            self.nombre = "En Proceso"
            self.color = Color(red: 1/255, green: 104/255, blue: 138/255)
            self.Image = "time-blue"
        case 3:
            self.nombre = "Completado"
            self.color = Color(red: 255/255, green: 153/255, blue: 0/255)
            self.Image = "time-orange"
        default:
            self.nombre = "Desconocido"
            self.color = .black
            self.Image = "questionmark"
        }
    }

}


struct Detalle {
    var horaFinal: String
    var horaInicio: String
    var idAmbulancia: Int
    var idDetalle: Int
    var idMedico: Int
    var idMedicoSeguro: String
    var idServicio: Int
    var kmFinal: Int
    var kmInicio: Int
    var kmTotales: Int
    var latitudDestino: Double
    var latitudOrigen: Double
    var longitudDestino: Double
    var longitudOrigen: Double
    var tiempoTotal: Int
    var tipoAmbulancia: String
}


struct Servicio2 {
    var apellidoMaternoSocio: String
    var apellidoPaternoSocio: String
    var destino: String
    var fecha: String
    var hora: String
    var idEstatus: Int
    var idNumeroSocio: Int
    var idPersonal: Int
    var idServicio: Int
    var nombreSocio: String
    var origen: String
    var tipoServicio: String
}


extension Servicio2 {
    static let ejemplo = Servicio2(
        apellidoMaternoSocio: "López",
        apellidoPaternoSocio: "García",
        destino: "Clínica del Norte",
        fecha: "2025-11-12",
        hora: "14:30:00",
        idEstatus: 2,
        idNumeroSocio: 1002423,
        idPersonal: 5,
        idServicio: 1,
        nombreSocio: "Juan",
        origen: "Hospital Central",
        tipoServicio: "Sencillo"
    )
}

extension Servicio2 {
    static let ejemplo2 = Servicio2(
        apellidoMaternoSocio: "Ruiz",
        apellidoPaternoSocio: "Fernández",
        destino: "Hospital Ángeles",
        fecha: "2025-11-15",
        hora: "09:45:00",
        idEstatus: 3,
        idNumeroSocio: 12312,
        idPersonal: 7,
        idServicio: 2,
        nombreSocio: "María",
        origen: "Hospital Zambrano",
        tipoServicio: "Urgente"
    )
}

extension Detalle {
    static let ejemplo = Detalle(
        horaFinal: "2025-11-12T19:16:20",
        horaInicio: "2025-11-12T19:00:00",
        idAmbulancia: 3,
        idDetalle: 45,
        idMedico: 0,               
        idMedicoSeguro: "0000",
        idServicio: 11,
        kmFinal: 120345,
        kmInicio: 120300,
        kmTotales: 45,
        latitudDestino: 25.680283,
        latitudOrigen: 25.650381,
        longitudDestino: -100.272460,
        longitudOrigen: -100.292461,
        tiempoTotal: 16,
        tipoAmbulancia: "Ambulancia Tipo II"
    )
}


