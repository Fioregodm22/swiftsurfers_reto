//
//  FinalizarServicioView.swift
//  SprintReto1
//
//  Created by Perla Reyes on 09/11/25.
//

import SwiftUI

struct FinalizarServicioView: View {
    
    //servicio a finalizar
    let idDetalle: Int
    
    @State private var detalleInicial: GetInicio? = nil
    @State private var kmFinal: Double? = nil
    @State private var distanciaRecorrida: Double? = nil
    @State private var errorKMFinal: Bool = false
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var navegarAServicioFinalizado = false
    @State private var shouldDismissToRoot = false
    
    @Environment(\.dismiss) var dismiss
    
    @State private var horaActual = Date()
    @State private var horaInicio = Date()
    
    let gris1 = Color(red: 242/255.0, green: 242/255.0, blue: 242/255.0)
    let gris2 = Color(red: 211/255.0, green: 211/255.0, blue: 211/255.0)
    let gris3 = Color(red: 153/255.0, green: 153/255.0, blue: 153/255.0)
    let gris4 = Color(red: 102/255.0, green: 102/255.0, blue: 102/255.0)
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    let naranja = Color(red: 255/255.0, green: 153/255.0, blue: 0/255.0)
    let blancoClaro = Color(red: 251/255.0, green: 251/255.0, blue: 251/255.0)
    
    //GET - datos iniciales del servicio
    func getDetalleInicial() async {
        let base = "https://misc-cedar-beam-colon.trycloudflare.com/hora_km_inicial/\(idDetalle)"
        
        guard let url = URL(string: base) else {
            print("Error: No se pudo construir la URL.")
            DispatchQueue.main.async {
                self.errorMessage = "Error al construir la URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.errorMessage = "Respuesta de servidor invalida"
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error del servidor. Código: \(httpResponse.statusCode)"
                }
                return
            }
            
            // print respuesta
            if let jsonString = String(data: data, encoding: .utf8) {
                print("GET Response: \(jsonString)")
            }
            
            //decodificar json con jsondecoer
            let decodedResponse = try JSONDecoder().decode(GetInicio.self, from: data)
            
            //se guarda en detalleInicial
            DispatchQueue.main.async {
                self.detalleInicial = decodedResponse
                
                //convertir hora de string a date
                if let horaInicioDate = self.convertirHoraStringADate(decodedResponse.horaInicio) {
                    self.horaInicio = horaInicioDate
                } else {
                    print("No se pudo convertir la hora de inicio: \(decodedResponse.horaInicio)")
                }
            }
            
        } catch let decodingError as DecodingError {
            print("Error de decodificacion: \(decodingError)")
            DispatchQueue.main.async {
                self.errorMessage = "Error al procesar los datos del servidor"
            }
        } catch {
            print("Error de conexion: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.errorMessage = "Error de conexion: \(error.localizedDescription)"
            }
        }
    }
    
    // PUT - Finalizar servicio
    func finalizarServicio() async {
        guard let kmFinalValue = kmFinal else {
            DispatchQueue.main.async {
                self.errorKMFinal = true
                self.errorMessage = "Debes ingresar el kilometraje final"
            }
            return
        }
        
        // Checar que el km final sea mayor al km inicial
        if let kmInicio = detalleInicial?.kmInicio {
            if kmFinalValue < Double(kmInicio) {
                DispatchQueue.main.async {
                    self.errorMessage = "El kilometraje final (\(Int(kmFinalValue)) km) debe ser mayor al inicial (\(kmInicio) km)"
                    self.errorKMFinal = true
                }
                return
            }
        }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        // Obtener hora actual
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "es_MX")
        let horaFinalString = formatter.string(from: Date())
        
        do {
            let api = AleAPI()
            
            // ✅ Una sola llamada que hace TODO
            let response = try await api.finalizarServicio(
                idDetalle: idDetalle,
                horaFinal: horaFinalString,
                kmFinal: Int(kmFinalValue)
            )
            
            print("✅ Servicio finalizado exitosamente")
            print("Hora final: \(response.horaFinal ?? "N/A")")
            print("KM finales: \(response.kmFinal ?? 0)")
            print("KM totales: \(response.kmTotales ?? 0)")
            print("Tiempo total: \(response.tiempoTotal ?? 0) minutos")
            print("Estatus: \(response.idEstatus ?? 0)")
            
            DispatchQueue.main.async {
                self.errorMessage = nil
                self.isLoading = false
                self.navegarAServicioFinalizado = true
            }
            
        } catch {
            print("❌ Error al finalizar servicio: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Error de conexión: \(error.localizedDescription)"
                self.isLoading = false
                self.errorKMFinal = true
            }
        }
    }
    
    // convertir string de hora a Date
    func convertirHoraStringADate(_ horaString: String) -> Date? {
        let horaSinMicrosegundos = horaString.components(separatedBy: ".").first ?? horaString
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "es_MX")
        
        guard let hora = formatter.date(from: horaSinMicrosegundos) else {
            print("No se pudo parsear la hora: \(horaString)")
            return nil
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: hora)
        
        guard let fechaCompleta = calendar.date(bySettingHour: components.hour ?? 0,
                                                 minute: components.minute ?? 0,
                                                 second: components.second ?? 0,
                                                 of: Date()) else {
            print("No se pudo crear la fecha completa")
            return nil
        }
        return fechaCompleta
    }
    
    // calcular la distancia recorrida
    func calcularDistancia() {
        if let kmF = kmFinal, let kmI = detalleInicial?.kmInicio {
            distanciaRecorrida = kmF - Double(kmI)
        }
    }
    
    // FRONT
    var body: some View {
        let calendario = Calendar.current
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
                        Text("# ID Servicio: \(idDetalle)")
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
                            
                            if detalleInicial != nil {
                                Text(String(format: "%02d:%02d", horaInicioFormateada, minutoInicioFormateado))
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(gris4)
                            } else {
                                ProgressView()
                                    .scaleEffect(0.8)
                            }
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
                        .frame(width: 350, height: 240)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("KM Inicial:")
                                .padding(.leading, 30)
                                .foregroundStyle(gris4)
                            
                            Spacer()
                            
                            if let kmInicio = detalleInicial?.kmInicio {
                                Text("\(kmInicio) km")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(gris4)
                                    .padding(.trailing, 30)
                            } else {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .padding(.trailing, 30)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("KM Final*")
                                .padding(.leading, 30)
                                .padding(.top, 20)
                                .padding(.bottom, 10)
                                .foregroundStyle(gris4)
                            
                            HStack {
                                Spacer()
                                TextField("Ingresa el kilometraje", value: $kmFinal, format: .number)
                                    .padding(.horizontal, 16)
                                    .frame(width: 230, height: 40)
                                    .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris1)))
                                    .foregroundStyle(gris4)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: kmFinal) { _, _ in
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
                                    Text("Distancia recorrida: \((distanciaRecorrida ?? 0) >= 0 ? String(format: "%.0f", distanciaRecorrida ?? 0) : "0") km")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                }
                                .fixedSize()
                                .offset(y: -18)
                                Spacer()
                            }
                            .padding(.top, 20)
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
                .padding(.top, 50)
            }
            
            // BOTONES
            VStack {
                Button(action: {
                    if kmFinal == nil {
                        errorKMFinal = true
                        errorMessage = "Debes ingresar el kilometraje final"
                    } else {
                        Task {
                            // ✅ Solo llama a finalizarServicio - hace TODO
                            await finalizarServicio()
                        }
                    }
                }) {
                    Text("FINALIZAR")
                        .font(.system(size: 25))
                        .bold(true)
                }
                .frame(width: 250)
                .frame(height: 50)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(azul)))
                .padding(.top, -50)
                .disabled(isLoading || detalleInicial == nil)
                .opacity((isLoading || detalleInicial == nil) ? 0.6 : 1.0)
                .navigationDestination(isPresented: $navegarAServicioFinalizado) {
                    ServicioFinalizado(shouldDismissToRoot: $shouldDismissToRoot)
                }
                .alert("Error", isPresented: $errorKMFinal) {
                    Button("Aceptar") {
                        errorKMFinal = false
                    }
                } message: {
                    Text(errorMessage ?? "Debes ingresar un kilometraje valido mayor al kilometraje inicial")
                }
                
                Spacer()
                    .frame(height: 20)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("CANCELAR")
                        .font(.system(size: 25))
                        .bold(true)
                }
                .frame(width: 250)
                .frame(height: 50)
                .foregroundStyle(.white)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(gris4)))
            }
            .padding(.top, 50)
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
        .navigationBarHidden(true)
        .onAppear {
            print("FinalizarServicioView onAppear - idDetalle: \(idDetalle)")
            Task {
                await getDetalleInicial()
            }
        }
    }
}

#Preview {
    FinalizarServicioView(idDetalle: 10)
}
