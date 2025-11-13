//
//  ContentView.swift
//  RETO
//
//  Created by Salvador Ancer on 13/10/25.
//

import SwiftUI

struct ServicioIniciado: View {
    @State private var navegarADetalle = false
    
    var body: some View {
        VStack{
            ZStack{
                ZStack{
                    Color(red: 1/255, green: 104/255, blue: 138/255)
                    Color.white
                        .frame(width: 280, height: 550)
                        .cornerRadius(20)
                }
                Text("Servicio iniciado correctamente")
                    .padding(.top, 40)
                    .foregroundStyle(Color.black.opacity(0.7))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .multilineTextAlignment(.center)
                    .padding(60)
                
                Image("check")
                    .padding(.top, -210)
                
                Button(action: {
                    navegarADetalle = true
                }){
                    Text("ACEPTAR")
                        .font(.system(size: 20))
                        .bold(true)
                }
                .padding()
                .fontWeight(.bold)
                .padding(.horizontal, 50)
                .background(Color(red: 1/255, green:104/255, blue:138/255))
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
                .cornerRadius(20)
                .padding(.top, 300)
                .navigationDestination(isPresented: $navegarADetalle) {
                    ContentView()
                }
            }
            .ignoresSafeArea(edges: .all)
            .toolbar(.hidden)
            
            
        
        }
    }
    
}

#Preview {
    NavigationStack {
        ServicioIniciado()
    }
}
