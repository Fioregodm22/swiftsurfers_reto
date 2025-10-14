//
//  LoginView.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 14/10/25.
//


//  LoginView.swift
//  sp2_A01285851
//
//  Created by Alumno on 13/10/25.
//

import SwiftUI

struct LoginView: View {
    @State public var idworker : Int? = nil
    @State public var password : String = ""
    @State public var alertnotid = false
    @State public var alertnotpass = false
    @State public var warningid : String = ""
    var body: some View {
        ZStack{
            Color(red: 1/255, green: 104/255 ,blue: 138/255)
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 20.0)
                        .frame(width: 325 ,height: 500)
                        .foregroundStyle(Color.white)
                    
                    VStack(alignment: .leading, spacing: 30){
                        VStack{
                            
                            Image("novaclinica2")
                                .resizable(resizingMode: .stretch)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 120)
                                .padding(.top, -130)
                                .padding(.horizontal, 60)
                        }
                        
                        
                        Text("ID de Empleado:")
                            .font(.title3)
                            .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                            .fontWeight(.bold)
                        TextField("", value: $idworker, format: .number)
                            .padding(.horizontal, 12)
                            .frame(width: 260, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                            )
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 102/255, green: 102/255, blue: 102/255), lineWidth: 1)
                            )
                        Text("Contraseña:")
                            .font(.title3)
                            .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                            .fontWeight(.bold)
                        SecureField("", text: $password)
                            .padding(.horizontal, 12)
                            .frame(width: 260, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                            )
                            
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color(red: 102/255, green: 102/255, blue: 102/255), lineWidth: 1)
                            )
                    
                            Button("INGRESAR"){
                                if(idworker == nil){
                                    alertnotid = true
                                }
                                else if(password != "1234" ){
                                    alertnotpass = true
                                }
                                else {
                                    alertnotid = false
                                    alertnotpass = false
                                }
                                
                                
                            }

                            .frame(width: 160, height: 54)

                            .frame(width: 160, height: 50)
                            .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .font(.title3)
                            .bold()
                            .padding(.horizontal, 50)
                            .alert("Pon tu ID por favor", isPresented: $alertnotid){
                                Button("Ok"){
                                    
                                }
                            }
                            .alert("Error en la contraseña o usuario", isPresented: $alertnotpass){
                                Button("Ok"){
                                    
                                }
                            }
                            
                        
                       
                        
                        
                    }
                 
                    
                    Spacer()
                }
        }
        .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
        
        
    }
}

#Preview {
    LoginView()
}

