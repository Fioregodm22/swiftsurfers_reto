//
//  DetalleView.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 15/10/25.
//a

import SwiftUI

struct DetalleView: View {
    @State private var navegarAIniciar = false
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    
    let servicio: Servicio2
    let detalle : Detalle

    var estado: EstadoServicio2 {
        EstadoServicio2(id: servicio.idEstatus)
    }
    
    @State var marcadorList: [Marcador]
        
        init(servicio: Servicio2, detalle: Detalle) {
            self.servicio = servicio
            self.detalle = detalle
            
            _marcadorList = State(initialValue: [
                Marcador(
                    nombre: servicio.destino,
                    coordinate: .init(
                        latitude: detalle.latitudDestino,
                        longitude: detalle.longitudDestino
                    ),
                    colorMark: azul
                ),
                Marcador(
                    nombre: servicio.origen,
                    coordinate: .init(
                        latitude: detalle.latitudOrigen,
                        longitude: detalle.longitudOrigen
                    ),
                    colorMark: naranja
                )
            ])
        }
    
    var body: some View {
        VStack(spacing: 15){
            ZStack(alignment: .topLeading){
                Color(azul)
                    //.ignoresSafeArea(edges: .top)
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

        
            
            VStack {
                HStack{
                    Text("Estatus del Servicio")
                        .font(.system(size: 14).bold())
                    Spacer()
                    Text(estado.nombre)
                        .font(.caption).bold()
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(estado.color.opacity(0.15))
                        .foregroundStyle(estado.color)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
            MapaView(latitud: 25.67507, longitud: -100.31847, customMark: marcadorList, showPosicion: true)
                    .frame(height: 200)
                
            }
            .padding(10)
            .background(Color.gray.opacity(0.15))
            .frame(width: 370)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            VStack {
                HStack{
                    Image(estado.Image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    

                    Text(servicio.hora)
                        .font(.system(size: 22))
                    Spacer()
                    
                }
                HStack{
                    Text("Tipo de Traslado")
                        .font(.system(size: 18).bold())
                    Spacer()
                    Text(servicio.tipoServicio)
                        .font(.system(size: 18))
                }
                .padding(3)
                HStack{
                    Text("Tipo de Ambulanica")
                        .font(.system(size: 18).bold())
                    Spacer()
                    Text(detalle.tipoAmbulancia)
                        .font(.system(size: 18))
                }
                .padding(3)
                
            }
            .padding(15)
            .background(Color.gray.opacity(0.15))
            .frame(width: 370)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            VStack {
                HStack{
                    Image(systemName: "person")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .foregroundColor(.gray)
                    

                    Text("\(servicio.nombreSocio) \(servicio.apellidoPaternoSocio) \(servicio.apellidoMaternoSocio)")
                        .font(.system(size: 20))
                    Spacer()
                    
                }
                HStack {
                    Text("Numero de Socio")
                        .font(.system(size: 18).bold())
                    Spacer()
                    Text(String(servicio.idNumeroSocio))
                        .font(.system(size: 18))
                }
                .padding(3)
                HStack{
                    Text("ID Medico")
                        .font(.system(size: 18).bold())
                    Spacer()
                    Text(String(detalle.idMedico))
                        .font(.system(size: 18))
                }
                .padding(3)
                
            }
            .padding(15)
            .background(Color.gray.opacity(0.15))
            .frame(width: 370)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
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
            
            Spacer()
        }
        .padding(.top, -100)
    }
}
    

#Preview {
    NavigationStack {
        DetalleView(servicio: .ejemplo, detalle: .ejemplo)
    }
}
