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
    
    
    let gris1 = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    let gris2 = Color(red: 211/255.0, green: 211/255.0, blue: 211/255.0)
    let gris3 = Color(red: 153/255.0, green: 153/255.0, blue: 153/255.0)
    let gris4 = Color(red: 102/255.0, green: 102/255.0, blue: 102/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let blancoClaro = Color(red: 251/255.0, green: 251/255.0, blue: 251/255.0)
    
    var body: some View {
        VStack{
            //PARTE SUPERIOR
            ZStack(alignment: .topLeading){
                Color(azul)
                    .ignoresSafeArea(edges: .top)
                //RESUMEN STACK
                Text("Finalizar Servicio")
                    .padding(.top, 20)
                    .padding(.leading, 60)
                    .foregroundStyle(Color.white)
                    .bold()
                    .font(.system(size: 30))
                Text ("# ID: 001")
                    .padding(.top, 70)
                    .padding(.leading, 60)
                    .foregroundStyle(Color.white)
                    .font(.system(size: 20))
            }
            
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(.bottom, 40)
            
            //PARTE RESUMEN
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 180)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Hora de inicio:")
                            .padding(.bottom, 10)

                        Text("Hora de finalización:")
                            .padding(.bottom, 8)
                        
                        Divider().frame(width: 320)
                        Text("Tiempo total: ")
                            .padding(.bottom, 8)
                        
                    }
                    .padding(.top, 38)
                    .padding(.leading, 30)
                    .padding(.trailing, 20)

                    Text("RESUMEN")
                        .font(.system(size: 20))
                        .padding(.horizontal, 12)
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
                        .frame(width: 350, height: 280)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("KM Inicial:")
                            .padding(.leading, 30)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("KM Final*")
                                .padding(.leading, 30)
                                .padding(.top, 20)
                                .padding(.bottom, 10)

                            HStack {
                                Spacer()
                                TextField("",value: $kmFinal, format: .number)
                                    .frame(width: 230, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris1)))
                                Spacer()
                                
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(naranja)).opacity(0.7)
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
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color(naranja)))
                        .foregroundStyle(.white)
                        .offset(y: -18)
                }
                .padding(.top, 30)
            }
            //BOTONES
            VStack {
                Button("FINALIZAR") {}
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 10)
                    .tint(azul)
                    .bold()
                
                Button("CANCELAR") {}
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 10)
                    .tint(gris4)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(gris2.opacity(0.3))
    }
}

#Preview {
    FinalizarServicioView()
}
