//
//  PerfilView.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 10/11/25.
//

import SwiftUI

struct PerfilView: View {
    @State private var username = ""
    @State private var nombre = ""
    @State private var telefono : Int = 0
    @State private var idusuario : Int = 0
    @State private var estatus = ""
    var body: some View {
        VStack{
            EncabezadoView(mensaje: "Perfil")
            Text("¡Hola, Juan!")
                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                .fontWeight(.bold)
                .font(.system(size: 35))
                .multilineTextAlignment(.center)
            ZStack {
              
                RoundedRectangle(cornerRadius: 20.0)
                    .frame(width: 325, height: 300)
                    .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                
                
                VStack(spacing: 0) {
                    
                                        VStack(alignment: .leading, spacing: 12) {
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                           
                            Text("Contacto:")
                                .font(.title3)
                                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                .fontWeight(.bold)
                                .padding(.top, 35)
                            Text("Usuario: juanreyes@nova")
                                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                .padding(.top, 3)
                            
                            Text("Teléfono: +528145689022")
                                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                .padding(.top, 3)
                            
                            Text("Id: 51222")
                                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                .padding(.top, 3)
                            
                           
                            Divider()
                                .frame(width: 300)
                            
                            
                            Text("Estatus actual:")
                                .font(.title3)
                                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                .fontWeight(.bold)
                            Text("No disponible")
                                .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                .padding(.top, 3)
                            
                            Button(action: {
                                // Aquí va la acción para iniciar la jornada
                            }) {
                                HStack {
                                    Image(systemName: "checkmark.circle") // Icono de paloma
                                    Text("Iniciar jornada")
                                }
                            }
                            
                            .frame(width: 239, height: 45)
                            .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal, 25)
                            .padding(.top, 10)
                            .padding(.bottom, 40)
                        }
                    }
                    .padding(.leading, 10)
                }
                
            }
            Button("CERRAR SESIÓN"){
            
            }
            
            .frame(width: 239, height: 45)
            .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
            .cornerRadius(20)
            .foregroundColor(.white)
            .font(.title2)
            .bold()
            .padding(.horizontal, 30)
            .padding(.top, 10)
            .padding(.bottom, 10)
            
            Button(action: {
                // Aquí va la acción que se ejecuta al presionar el botón
            }) {
                HStack {
                    Image(systemName: "phone.fill") // Icono de teléfono
                    Text("EMERGENCIA")
                }
            }
            
            .frame(width: 239, height: 45)
            .background(Color(red: 230/255, green: 229/255, blue: 229/255))
            .cornerRadius(20)
            .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
            .font(.title2)
            .bold()
            .padding(.horizontal, 15)
            .padding(.top, 10)
            
            Spacer()
            
        }
    }}

#Preview {
    PerfilView()
}
