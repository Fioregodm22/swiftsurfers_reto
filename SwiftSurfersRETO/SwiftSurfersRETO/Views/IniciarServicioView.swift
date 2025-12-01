//
//  IniciarServicioView.swift
//  SwiftSurfersRETO
//

import SwiftUI

struct IniciarServicioView: View {
    @State public var idServicio: Int
    
    @Environment(\.dismiss) var dismiss
    @State private var navegarAConfirmarInicio = false
    @State private var shouldDismissToRoot = false
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
            ZStack(alignment: .topLeading){
                Color(azul)
                    .ignoresSafeArea(edges: .top)
                
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
                        Text ("# ID: \(idServicio)")
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

            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 160)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("KM Inicial*")
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
            
            VStack {
                Button(action: {
                    if kmInicial == nil {
                            errorKMInicial.toggle()
                    }
                    else {
                        Task {
                            do {
                                let api = AleAPI()

                                try await api.iniciarServicio(
                                    idServicio: idServicio,
                                    kmInicio: kmInicial!
                                )
                                
                                print("Servicio iniciado con éxito.")
                                
                                horaInicio = Date()
                                navegarAConfirmarInicio = true
                                
                            } catch {
                                print("Error al iniciar servicio")
                            }
                        }
                    }
                }) {
                    Text("INICIAR")
                        .font(.system(size: 20))
                        .bold(true)
                }
                    .frame(width: 300)
                    .frame(height: 60)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(azul)))
                    .bold(true)
                    .navigationDestination(isPresented: $navegarAConfirmarInicio) {
                        ServicioIniciado(shouldDismissToRoot: $shouldDismissToRoot)
                    }
                    .alert("Error", isPresented: $errorKMInicial) {
                        Button("Aceptar") {}
                    } message : {
                        Text("Debes ingresar un kilometraje válido")
                    }
                Spacer()
                    .frame(height:40)
                
                Button(action: {
                    dismiss()
                })  {
                        Text("CANCELAR")
                            .font(.system(size: 20))
                            .bold(true)
                }
                    .frame(width: 300)
                    .frame(height: 60)
                    .foregroundStyle(.white)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris4)))
                    .bold(true)
            }
            .padding(.top, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(gris2.opacity(0.3))
        .toolbar(.hidden)
        .onChange(of: shouldDismissToRoot) { oldValue, newValue in
            if newValue {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    dismiss()
                }
            }
        }
    }
}
    
#Preview {
    NavigationStack {
        IniciarServicioView(idServicio: 5)
    }
}
