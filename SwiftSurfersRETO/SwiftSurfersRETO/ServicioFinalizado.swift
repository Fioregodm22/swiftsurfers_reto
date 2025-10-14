//
//  ContentView.swift
//  RETO
//
//  Created by Salvador Ancer on 13/10/25.
//

import SwiftUI

struct ServicioFinalizado: View {
    var body: some View {
        VStack{
            ZStack{
                ZStack{
                    Color(red: 1/255, green: 104/255, blue: 138/255)
                    Color.white
                        .frame(width: 280, height: 550)
                        .cornerRadius(40)
                }
                Text("Servicio finalizado correctamente")
                    .padding(.top, 40)
                    .foregroundStyle(Color.black.opacity(0.7))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .multilineTextAlignment(.center)
                    .padding(60)
                
                Image("check")
                    .padding(.top, -210)
                
                Button("ACEPTAR"){
                    
                }
                .padding()
                .fontWeight(.bold)
                .background(Color(red: 1/255, green:104/255, blue:138/255))
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
                .cornerRadius(40)
                .padding(.top, 370)
                
                
            }
            .ignoresSafeArea(edges: .all)
            
            
        
        }
    }
    
}

#Preview {
    ServicioFinalizado()
}
