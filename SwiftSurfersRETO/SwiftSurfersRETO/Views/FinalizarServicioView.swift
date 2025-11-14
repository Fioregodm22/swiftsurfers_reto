//
//  FinalizarServicioView.swift
//  SprintReto1
//
//  Created by Perla Reyes on 09/11/25.
//

import SwiftUI

struct FinalizarServicioView: View {
    
    @State public var idDetalle: Int // ID del detalle a finalizar
    
    @State public var detalleInicial: GetInicio? = nil
    @State public var kmFinal: Double? = nil
    @State public var distanciaRecorrida: Double? = nil
    @State private var errorKMFinal: Bool = false
    @State private var errorMessage: String? = nil
    @State private var successMessage: Bool = false
    @State private var isLoading: Bool = false
    @State private var navegarAServicioFinalizado = false
    
    @Environment(\.dismiss) var dismiss
    
    @State var calendario = Calendar.current
    @State var horaActual = Date()
    @State var horaInicio = Date()
    
    let gris1 = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    let gris2 = Color(red: 211/255.0, green: 211/255.0, blue: 211/255.0)
    let gris3 = Color(red: 153/255.0, green: 153/255.0, blue: 153/255.0)
    let gris4 = Color(red: 102/255.0, green: 102/255.0, blue: 102/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let blancoClaro = Color(red: 251/255.0, green: 251/255.0, blue: 251/255.0)
    
    //GET -  datos iniciales del servicio
    func getDetalleInicial() async {
        //let base = "http://10.14.255.43:10204/hora_km_inicial/\(idDetalle)"
        
        let base = "http://10.14.255.43:10204/hora_km_inicial/\(idDetalle)"
        
        guard let url = URL(string: base) else {
            print("Error: No se pudo construir la URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                DispatchQueue.main.async {
                    self.errorMessage = "Respuesta de servidor inválida. Código: \(status)"
                }
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(GetInicio.self, from: data)
            
            DispatchQueue.main.async {
                self.detalleInicial = decodedResponse
                // convertir la hora de inicio de string a Date
                if let horaInicioDate = convertirHoraStringADate(decodedResponse.horaInicio) {
                    self.horaInicio = horaInicioDate
                }
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error de conexión/decodificación: \(error.localizedDescription)"
            }
        }
    }
    
    // PUT - Finalizar servicio
    func finalizarServicio() async {
        guard let kmFinalValue = kmFinal else {
            DispatchQueue.main.async {
                self.errorKMFinal = true
            }
            return
        }
        
        // checar que el km final sea mayor al km inicial
        if let kmInicio = detalleInicial?.kmInicio {
            if kmFinalValue < Double(kmInicio) {
                DispatchQueue.main.async {
                    self.errorMessage = "El kilometraje final debe ser mayor al inicial (\(kmInicio) km)"
                    self.errorKMFinal = true
                }
                return
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        
        
        let url = URL(string: "http://10.14.255.43:10204/hora_km_final/\(idDetalle)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // obtener hora actual en formato HH:mm:ss
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let horaFinalString = formatter.string(from: horaActual)
        
        let body: [String: Any] = [
            "horaFinal": horaFinalString,
            "kmFinal": Int(kmFinalValue)
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                self.errorMessage = "Error para los datos para PUT."
                self.isLoading = false
            }
            return
        }
        
        request.httpBody = bodyData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                DispatchQueue.main.async {
                    self.errorMessage = "PUT Fallido. Código HTTP: \(status)"
                    self.isLoading = false
                }
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(PutFinalizar.self, from: data)
            
            DispatchQueue.main.async {
                self.errorMessage = nil
                self.isLoading = false
                self.navegarAServicioFinalizado = true
                print("Servicio finalizado exitosamente: \(decodedResponse)")
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error de conexión/decodificación PUT: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    //convertir string de hora a Date
    func convertirHoraStringADate(_ horaString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        if let hora = formatter.date(from: horaString) {
            // Combinar con la fecha actual
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: hora)
            return calendar.date(bySettingHour: components.hour ?? 0,
                               minute: components.minute ?? 0,
                               second: components.second ?? 0,
                               of: Date())
        }
        return nil
    }
    
    // calcular la distancia recorrida
    func calcularDistancia() {
        if let kmF = kmFinal, let kmI = detalleInicial?.kmInicio {
            distanciaRecorrida = kmF - Double(kmI)
        }
    }
    
    //FRONT
    var body: some View {
        let horaActualFormateada = calendario.component(.hour, from: horaActual)
        let minutoActualFormateado = calendario.component(.minute, from: horaActual)
        
        let horaInicioFormateada = calendario.component(.hour, from: horaInicio)
        let minutoInicioFormateado = calendario.component(.minute, from: horaInicio)
        
        VStack {
            // PARTE SUPERIOR
            ZStack(alignment: .topLeading) {
                Color(azul)
                    .ignoresSafeArea(edges: .top)
                
                HStack(alignment: .center, spacing: 16) {
                    Image("novaLogo1")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .padding(.leading, 20)
                        .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Finalizar Servicio")
                            .padding(.top, 25)
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 25))
                        Text("# ID: \(detalleInicial?.idDetalle ?? idDetalle)")
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
            
            if isLoading {
                ProgressView("Finalizando servicio...")
                    .padding()
            }
            
            // PARTE RESUMEN
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 160)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Hora de inicio:")
                                .foregroundStyle(gris4)
                                .padding(.horizontal, 2)
                            
                            Spacer()
                            
                            Text(String(format: "%02d:%02d", horaInicioFormateada, minutoInicioFormateado))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(gris4)
                        }
                        .padding(.bottom, 7)
                        
                        HStack(alignment: .firstTextBaseline) {
                            Text("Hora de finalización:")
                                .foregroundStyle(gris4)
                                .padding(.horizontal, 2)
                            
                            Spacer()
                            
                            Text(String(format: "%02d:%02d", horaActualFormateada, minutoActualFormateado))
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(gris4)
                        }
                        
                        Divider()
                        
                        Text("Tiempo total: Se calculará automáticamente")
                            .foregroundStyle(gris4)
                            .font(.system(size: 12))
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
            
            // PARTE KILOMETRAJE
            VStack {
                ZStack(alignment: .top) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(blancoClaro))
                        .frame(width: 350, height: 255)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("KM Inicial:")
                                .padding(.leading, 30)
                                .foregroundStyle(gris4)
                            
                            Spacer()
                            
                            Text("\(detalleInicial?.kmInicio ?? 0) km")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundStyle(gris4)
                                .padding(.trailing, 30)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("KM Final*")
                                .padding(.leading, 30)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                                .foregroundStyle(gris4)
                            
                            HStack {
                                Spacer()
                                TextField("", value: $kmFinal, format: .number)
                                    .padding(.horizontal, 16)
                                    .frame(width: 230, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris1)))
                                    .foregroundStyle(gris4)
                                    .onChange(of: kmFinal) {
                                        calcularDistancia()
                                    }
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(naranja)).opacity(0.8)
                                    Text("Distancia recorrida: \(distanciaRecorrida.map { String(format: "%.0f", $0) } ?? "0") km")
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
            
            // Mensaje de error
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.system(size: 14))
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            
            // BOTONES
            VStack {
                Button(action: {
                    if kmFinal == nil {
                        errorKMFinal = true
                    } else {
                        Task {
                            await finalizarServicio()
                        }
                    }
                }) {
                    Text("FINALIZAR")
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal, 110)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(azul)))
                .bold(true)
                .disabled(isLoading)
                .navigationDestination(isPresented: $navegarAServicioFinalizado) {
                    ServicioFinalizado()
                        .navigationBarBackButtonHidden(true)
                }
                .alert("Error", isPresented: $errorKMFinal) {
                    Button("Aceptar") {}
                } message: {
                    Text("Debes ingresar un kilometraje válido mayor al kilometraje inicial")
                }
                
                Button(action: {
                    dismiss()
                }) {
                    Text("CANCELAR")
                }
                .padding(.top, 20)
                .padding(.bottom, 20)
                .padding(.horizontal, 110)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris4)))
                .bold(true)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(gris2.opacity(0.3))
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await getDetalleInicial()
            }
        }
    }
}

#Preview {
    FinalizarServicioView(idDetalle: 9)
}
