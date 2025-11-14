//
//  DetalleView.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 15/10/25.
//a

import SwiftUI

struct DetalleView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hideTabBar: Bool
    @State private var navegarAIniciar = false
    @State private var navegarAFinalizar = false
    @State private var isLoading = true
    @State var marcadorList: [Marcador] = []
    
    @State private var detalle: Detalle?
    let servicio: Servicio
    var estado: EstadoServicio {
        EstadoServicio(id: servicio.idEstatus)
    }

    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    
    
    var body: some View {
        Group {
            if isLoading {
                VStack {
                    ProgressView("Cargando detalles")
                        .padding()
                    Spacer()
                }
            } else if let detalle = detalle {
                contenidoDetalle(detalle: detalle)
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.red)
                    
                    Text("Error al cargar los detalles")
                        .font(.title2)
                        .foregroundColor(.red)
                        .bold()
                    
                    Text("No se pudieron obtener los datos del servicio")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        dismiss() 
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 20))
                            
                            Text("Volver a Agenda")
                                .font(.system(size: 18))
                                .bold()
                        }
                        .frame(width: 280)
                        .frame(height: 50)
                        .foregroundColor(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(azul)
                        )
                    }
                    .padding(.top, 20)
                    
                    // Botón secundario para reintentar
                    Button(action: {
                        Task {
                            await cargarDetalle()
                        }
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 18))
                            
                            Text("Reintentar")
                                .font(.system(size: 16))
                        }
                        .frame(width: 280)
                        .frame(height: 45)
                        .foregroundColor(azul)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(azul, lineWidth: 2)
                        )
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar = true
            Task {
                await cargarDetalle()
            }
        }
        .onDisappear{
            hideTabBar = false
        }
    }
    
    func cargarDetalle() async {
        isLoading = true
        
        do {
            let detalleObtenido = try await obtenerDetalle(idServicio: servicio.idServicio)
            self.detalle = detalleObtenido
            
            marcadorList = [
                Marcador(
                    nombre: servicio.destino,
                    coordinate: .init(
                        latitude: detalleObtenido.latitudDestino,
                        longitude: detalleObtenido.longitudDestino
                    ),
                    colorMark: azul
                ),
                Marcador(
                    nombre: servicio.origen,
                    coordinate: .init(
                        latitude: detalleObtenido.latitudOrigen,
                        longitude: detalleObtenido.longitudOrigen
                    ),
                    colorMark: naranja
                )
            ]
        } catch {
            print("Error al cargar detalle: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    
    func contenidoDetalle(detalle: Detalle) -> some View {
        VStack(spacing: servicio.idEstatus == 3 ? 25 : 15){
            ZStack(alignment: .topLeading){
                Color(azul)
                    .ignoresSafeArea(edges: .top)
                
                VStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Atrás")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                            .padding(.top, 30)
                        }
                        Spacer()
                    }
    
                
                HStack (alignment: .center, spacing: 16) {
                    Image("novaLogo1")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width:80)
                        .padding(.leading, 20)
                    
                    VStack (alignment: .leading, spacing: 8) {
                        Text("Detalle Servicio")
                            .padding(.top, 15)
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 25))
                        Text ("# ID: \(servicio.idServicio)")
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 20))
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 10)
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
                
                MapaView(
                    latitud: calcularLatitudMedia(
                        latitudOrigen: detalle.latitudOrigen,
                        latitudDestino: detalle.latitudDestino
                    ),
                    longitud: calcularLongitudMedia(
                        longitudOrigen: detalle.longitudOrigen,
                        longitudDestino: detalle.longitudDestino
                    ),
                    customMark: marcadorList,
                    showPosicion: true
                )
                    .frame(height: 200)
                    .clipped()
                    .onTapGesture {
                        abrirGoogleMaps(latitud: detalle.latitudDestino, longitud: detalle.longitudDestino)
                    }
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
                    Text("Tipo de Ambulancia")
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
                    Text(detalle.idMedico != nil ? String(detalle.idMedico!) : "No asignado")
                        .font(.system(size: 18))
                }
                .padding(3)
            }
            .padding(15)
            .background(Color.gray.opacity(0.15))
            .frame(width: 370)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            
            
            if servicio.idEstatus == 1 {  
                Button(action: {
                    navegarAIniciar = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 20))
                        
                        Text("Iniciar Servicio")
                            .font(.system(size: 20))
                            .bold(true)
                    }
                    .frame(width: 360)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(naranja)
                    )
                }
                .navigationDestination(isPresented: $navegarAIniciar) {
                    IniciarServicioView(idServicio: servicio.idServicio)
                }
            } else if servicio.idEstatus == 2 {
                Button(action: {
                    navegarAFinalizar = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "stop.circle.fill")
                            .font(.system(size: 20))
                        
                        Text("Finalizar Servicio")
                            .font(.system(size: 20))
                            .bold(true)
                    }
                    .frame(width: 360)
                    .frame(height: 60)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(azul)
                    )
                }
                .navigationDestination(isPresented: $navegarAFinalizar) {
                    FinalizarServicioView()
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        DetalleView(hideTabBar: .constant(false), servicio: .ejemplo)
    }
}
