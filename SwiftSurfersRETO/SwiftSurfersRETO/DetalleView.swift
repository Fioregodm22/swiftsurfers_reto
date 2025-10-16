//
//  DetalleView.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 15/10/25.
//

import SwiftUI

struct DetalleView: View {
    @State private var navegarAIniciar = false
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    
    var body: some View {
        Text("DETALLE VIEW")
        Text("SE VA A DESARROLLAR EN LOS SIGUIENTES SPRINTS")
        Spacer()
        
        Button(action: {
            navegarAIniciar = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                
                Text("Iniciar Servicio")
                    .font(.system(size: 20))
                    .bold(true)
            }
            .frame(width: 300)
            .frame(height: 60)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(naranja)
            )
        }
        .navigationDestination(isPresented: $navegarAIniciar) {
            IniciarServicioView()
        }
        .padding(.horizontal)
    }}
    

#Preview {
    NavigationStack {
        DetalleView()
    }
}
