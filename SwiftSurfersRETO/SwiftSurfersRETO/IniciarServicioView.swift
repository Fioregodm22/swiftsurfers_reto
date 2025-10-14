//
//  IniciarServicioView.swift
//  SwiftSurfersRETO
//
//  Created by Alejandra on 13/10/25.
//

import SwiftUI

struct IniciarServicioView: View {
    
    @State public var kmInicial: Int? = nil
    @State public var distanciaRecorrida: Double? = nil
    @State var calendario = Calendar.current
    @State var horaInicio = Date()
    
    @State private var errorKMInicial: Bool = false
    
    let gris1 = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    let gris2 = Color(red: 211/255.0, green: 211/255.0, blue: 211/255.0)
    let gris3 = Color(red: 153/255.0, green: 153/255.0, blue: 153/255.0)
    let gris4 = Color(red: 102/255.0, green: 102/255.0, blue: 102/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let blancoClaro = Color(red: 251/255.0, green: 251/255.0, blue: 251/255.0)
    
    var body: some View {
        
        let hora = calendario.component(.hour, from: horaInicio)
        let minuto = calendario.component(.minute, from: horaInicio)
        
        VStack{
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
                        Text("Iniciar Servicio")
                            .padding(.top, 15)
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 25))
                        Text ("# ID: 001")
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                    }
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(.bottom, 40)
            
            //PARTE HORA
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 120)

                    VStack (alignment: .leading, spacing: 16) {
                        Text(String(format: "%02d:%02d", hora, minuto))
                            .font(.system(size: 60))
                            .bold(true)
                            .foregroundStyle(gris4)
                    }
                    .padding(.top, 30)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)

                    Text("HORA DE INICIO")
                        .font(.system(size: 20))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color(naranja)))
                        .foregroundStyle(.white)
                        .offset(y: -18)
                }
                .padding(.top, 2)
            }

            //PARTE KILOMETRAJE
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 160)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("KM Inicial:")
                            .padding(.leading, 30)
                            .foregroundStyle(gris4)

                            HStack {
                                Spacer()
                                TextField("",value: $kmInicial, format: .number)
                                    .padding(.horizontal, 16)
                                    .frame(width: 230, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris1)))
                                    .foregroundStyle(gris4)
                                Spacer()
                            }
                            .padding(.top, 10)
                   }
                    .padding(.top, 38)
                    .padding(.horizontal, 16)

                    Text("KILOMETRAJE")
                        .font(.system(size: 20))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color(naranja)))
                        .foregroundStyle(.white)
                        .offset(y: -18)
                }
                .padding(.top, 15)
            }
            //BOTONES
            VStack {
                Button("INICIAR") {
                    if (kmInicial == nil) {
                        errorKMInicial.toggle()
                    }
                    else {
                        horaInicio = Date()
                        // redirigir a ConfirmarInicioView
                    }
                }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 110)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(azul)))
                    .bold(true)
                    .alert("Error", isPresented: $errorKMInicial) {
                        Button("Aceptar") {}
                    } message : {
                        Text("Debes ingresar un kilometraje válido")
                    }
                Spacer()
                    .frame(height:40)
                
                Button("CANCELAR") {
                    // redirigir a DetalleServicioView
                }
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 100)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris4)))
                    .bold(true)
            }
            .padding(.top, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(gris2.opacity(0.3))
    }
}

#Preview {
    IniciarServicioView()
}
