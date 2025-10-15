//
//  FinalizarServicioView.swift
//  SprintReto1
//
//  Created by Perla Reyes on 11/10/25.
//

import SwiftUI

struct FinalizarServicioView: View {
    
    @State public var kmFinal: Double? = nil
    @State public var distanciaRecorrida: Double? = nil
    @State private var errorKMFinal : Bool = false
    
    @State var calendario = Calendar.current
    @State var horaInicio = Date()
    
    @State var kmPrueba: Int = 1800
    
    
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
                        .padding(.top, 10)
                    
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Finalizar Servicio")
                            .padding(.top, 25)
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
            
            //PARTE RESUMEN
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 160)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hora de inicio:")
                            .padding(.bottom, 7)
                            .padding(.horizontal, 2)
                            .foregroundStyle(gris4)

                        HStack(alignment: .firstTextBaseline) {
                                Text("Hora de finalización:")
                                    .foregroundStyle(gris4)
                                    .padding(.horizontal, 2)

                                Spacer()

                                Text(String(format: "%02d:%02d", hora, minuto))
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundStyle(gris4)
                                    }

                                Divider()

                        Text("Tiempo total: ")
                                        .foregroundStyle(gris4)
                        }
                            .padding(.top, 28)
                            .padding(.horizontal, 45)

                        Text("RESUMEN")
                            .font(.system(size: 20))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color(naranja)))
                                    .foregroundStyle(.white)
                                    .offset(y: -18)
                        }
                        .padding(.top, 1)
                    }

            //PARTE KILOMETRAJE
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 255)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("KM Inicial:")
                            .padding(.leading, 30)
                            .foregroundStyle(gris4)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("KM Final*")
                                .padding(.leading, 30)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                                .foregroundStyle(gris4)

                            HStack {
                                Spacer()
                                TextField("",value: $kmFinal, format: .number)
                                    .padding(.horizontal, 16)
                                    .frame(width: 230, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris1)))
                                    .foregroundStyle(gris4)
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(naranja)).opacity(0.8)
                                    Text("Distancia recorrida: \(distanciaRecorrida.map { $0.formatted() } ?? "") km")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                }
                                .fixedSize()
                                .offset(y: -18)
                                Spacer()
                            }
                            .padding(.top, 30)
                        }
                        Spacer()
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
                .padding(.top, 25)
            }
            //BOTONES
            VStack {
                Button("FINALIZAR") {
                    if (kmFinal == nil){
                        errorKMFinal.toggle( )
                    }
                    
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal, 110)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(azul)))
                .bold(true)
                    .alert("Error", isPresented: $errorKMFinal){
                        Button("Aceptar"){}
                    }message: {
                        Text("Debes de ingresar un kilometraje válido")
                    }
                   
                
                Button("CANCELAR") {}
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 110)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris4)))
                    .bold(true)
            }
            //.padding(.top, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(gris2.opacity(0.3))
    }
}

#Preview {
    FinalizarServicioView()
}
