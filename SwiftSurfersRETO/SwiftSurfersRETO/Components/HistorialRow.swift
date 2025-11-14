//
//  HistorialRow.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 11/11/25.
//

import SwiftUI

struct HistorialRow: View {
    let servicio: ServicioHistorial
    
    var estatus: String {
        servicio.estatusDescripcion!
    }
    
    var color: Color {
        switch estatus {
        case "Agendado":
            return .gray
            
        case "En Proceso":
            return Color(red: 1/255, green: 104/255, blue: 138/255)
            
        case "Completado":
            return Color(red: 255/255, green: 153/255, blue: 0/255)
            
        default:
            return .black
        }
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("Fecha")
                        .font(.system(size: 18)).bold()
                    Text(servicio.fecha)
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Text(servicio.estatusDescripcion!)
                    .font(.caption.weight(.semibold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(color.opacity(0.15))
                    .foregroundStyle(color)
                    .clipShape(Capsule())
            }
            
            HStack {
                Image(systemName: "truck.box")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("Tipo de Viaje")
                        .font(.system(size: 18)).bold()
                    Text(servicio.tipoServicio!)
                        .font(.system(size: 16))
                }
                Spacer()
            }
            
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading) {
                    Text("ID Paciente")
                        .font(.system(size: 18)).bold()
                    Text(String(servicio.idNumeroSocio))
                        .font(.system(size: 16))
                }
                Spacer()
            }
        }
        .padding(15)
        .background(RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray.opacity(0.08)))
    }
}

#Preview {
    HistorialRow(servicio: ServicioHistorial(
        idServicio: 101,
        idNumeroSocio: 202345,
        fecha: "2025-11-13",
        hora: "14:30",
        origen: "Av. Reforma 123, Ciudad de México",
        destino: "Aeropuerto Internacional CDMX",
        tipoServicio: "Traslado Ejecutivo",
        nombreAsociado: "Carlos Ramírez",
        estatusDescripcion: "Completado",
        estatusColor: ".gray",
        tiempoTotal: 45,
        kmTotales: 23,
        placas: "ABC-1234"
    ))
}
