//
//  HistorialView.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 11/11/25.
//

import SwiftUI

struct HistorialView: View {
    
    let gris1 = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    let gris2 = Color(red: 211/255.0, green: 211/255.0, blue: 211/255.0)
    let gris3 = Color(red: 153/255.0, green: 153/255.0, blue: 153/255.0)
    let gris4 = Color(red: 102/255.0, green: 102/255.0, blue: 102/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let blancoClaro = Color(red: 251/255.0, green: 251/255.0, blue: 251/255.0)
    
    var body: some View {
        VStack{
            ZStack(alignment: .topLeading){
                Color(azul)
                    .ignoresSafeArea(edges: .top)
                HStack (alignment: .center, spacing: 14) {
                    Image("novaLogo1")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:80)
                        .padding(.top, 8)
                        .padding(.leading, 20)
                    
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Historial de Servicios")
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
            
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 100)

                    HStack (spacing: 30) {
                        VStack(spacing: 4) {
                            Text("560 km")
                                .font(.system(size: 20))
                                .bold(true)
                                .foregroundStyle(azul)
                            Text("Recorridos")
                                .font(.system(size: 15))
                                .foregroundStyle(gris4)
                        }
                        VStack(spacing: 4) {
                            Text("4:12 hrs")
                                .font(.system(size: 20))
                                .bold(true)
                                .foregroundStyle(azul)
                            Text("Tiempo")
                                .font(.system(size: 15))
                                .foregroundStyle(gris4)
                        }
                        VStack(spacing: 4) {
                            Text("5")
                                .font(.system(size: 20))
                                .bold(true)
                                .foregroundStyle(azul)
                            Text("Servicios")
                                .font(.system(size: 15))
                                .foregroundStyle(gris4)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)

                    Text("HOY")
                        .font(.system(size: 20))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color(naranja)))
                        .foregroundStyle(.white)
                        .offset(y: -18)
                }
                .padding(.top, 2)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .padding(.bottom, 40)
                
                VStack {
                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(blancoClaro))
                            .frame(width: 350, height: 450)
                      
                        ScrollView {
                            VStack (alignment: .leading, spacing: 16) {
                                HistorialRow(servicio: .ejemplo)
                            }
                            .padding(.top, 30)
                            .padding(.leading, 30)
                            .padding(.trailing, 30)
                        }

                        Text("TODA TU ACTIVIDAD")
                            .font(.system(size: 20))
                            .padding(.horizontal, 40)
                            .padding(.vertical, 6)
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color(naranja)))
                            .foregroundStyle(.white)
                            .offset(y: -18)
                    }
                    .padding(.top, 2)
                }
                .padding(.top, 2)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(gris2.opacity(0.3))
        .toolbar(.hidden)
    }
}

#Preview {
    HistorialView()
}
