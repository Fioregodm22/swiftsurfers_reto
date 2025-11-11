//
//  EncabezadoView.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 10/11/25.
//

import SwiftUI

struct EncabezadoView: View {
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    @State var mensaje : String = ""
    var body: some View {
        //PARTE SUPERIOR
        ZStack(alignment: .topLeading){
            Color(azul)
                .ignoresSafeArea(edges: .top)
            //RESUMEN STACK
            HStack (alignment: .center, spacing: 16) {
                Image("novaLogo1")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width:80)
                    .padding(.leading, 20)
                
                VStack (alignment: .leading, spacing: 8) {
                    Text(mensaje)
                        .padding(.top, 15)
                        .padding(.leading, 5)
                        .foregroundStyle(Color.white)
                        .bold()
                        .font(.system(size: 25))
                }
            }
            .padding(.top, 5)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .padding(.bottom, 40)
    }
}

#Preview {
    EncabezadoView(mensaje: "Iniciar Servicio")
}
