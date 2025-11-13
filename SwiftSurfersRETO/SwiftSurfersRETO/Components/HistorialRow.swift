//
//  HistorialRow.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 11/11/25.
//

import SwiftUI

struct HistorialRow: View {
    let servicio: Servicio2
    
    var estado: EstadoServicio2 {
        EstadoServicio2(id: servicio.idEstatus)
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
                    Text("30/10/2025")
                        .font(.system(size: 16))
                }
                
                Spacer()
                
                Text(estado.nombre)
                    .font(.caption.weight(.semibold))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(estado.color.opacity(0.15))
                    .foregroundStyle(estado.color)
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
                    Text("Redondo")
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
                    Text("1234")
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
    HistorialRow(servicio: .ejemplo)
}
