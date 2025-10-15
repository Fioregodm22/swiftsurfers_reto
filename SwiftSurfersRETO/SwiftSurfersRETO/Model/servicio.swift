//
//  servicio.swift
//  SwiftSurfersRETO
//
//  Created by Maria Cavada on 14/10/25.
//

import Foundation
import SwiftUI

struct EstadoServicio {
    let nombre: String
    let color: Color
    let Image: String
    
    static let agendado   = EstadoServicio(nombre: "Agendado",   color: .gray, Image: "time-gray")
    static let enProceso  = EstadoServicio(nombre: "En Proceso", color: Color(red: 1/255, green: 104/255, blue: 138/255), Image: "time-blue")
    static let completado = EstadoServicio(nombre: "Completado", color: Color(red: 255/255, green: 153/255, blue: 0/255), Image: "time-orange")
}

struct Servicio{
    public var id = UUID()
    public var paciente: String
    public var origen: String
    public var destino: String
    public var hora: Date
    public var status: EstadoServicio
    public var paramedico : String

    
}

extension Servicio {
    static let ejemplo = Servicio(
        paciente: "Sofia Papaya",
        origen: "Hospital Central",
        destino: "Clínica del Norte",
        hora: Date(),
        status: .completado,
        paramedico: "Juan"
    )
}

extension Servicio {
    static let ejemplo2 = Servicio(
        paciente: "Maria Cavada",
        origen: "Hospital Zambrano",
        destino: "Hospital Angeles",
        hora: Date(),
        status: .enProceso,
        paramedico: "Juan"
    )
}


