import SwiftUI

struct AgendaView: View {
    @Binding var hideTabBar: Bool
    @State private var servicios: [Servicio] = []
    @State private var isLoading = false
    @State private var filtroFecha: String = "hoy"
    @State private var navegarACalendario = false
    let idPersonal = 5
    
    
    var serviciosFiltrados: [Servicio] {
        let hoy = Calendar.current.startOfDay(for: Date())
        let manana = Calendar.current.date(byAdding: .day, value: 1, to: hoy)!
        
        let filtradosPorFecha = servicios.filter { servicio in
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            guard let fechaServicio = formatter.date(from: servicio.fecha) else {
                return false
            }
            
            let fechaServicioSinHora = Calendar.current.startOfDay(for: fechaServicio)
            
            if filtroFecha == "hoy" {
                return fechaServicioSinHora == hoy
            } else {
                return fechaServicioSinHora == manana
            }
        }
        
        return filtradosPorFecha.sorted(by: { servicio1, servicio2 in
            
            func prioridad(estatus: Int) -> Int {
                switch estatus {
                case 2: return 1
                case 1: return 2
                case 3: return 3
                default: return 4 
                }
            }
            
            let prioridad1 = prioridad(estatus: servicio1.idEstatus)
            let prioridad2 = prioridad(estatus: servicio2.idEstatus)
            

            if prioridad1 != prioridad2 {
                return prioridad1 < prioridad2
            }
            
            return servicio1.hora > servicio2.hora
        })
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "EEEE, d 'de' MMMM yyyy"
        
        var date = formatter.string(from: Date())
        date = date.prefix(1).capitalized + date.dropFirst()
        
        let words = date.split(separator: " ")
        if words.count >= 4 {
            var components = words.map { String($0) }
            let mes = components[3]
            components[3] = mes.prefix(1).capitalized + mes.dropFirst()
            date = components.joined(separator: " ")
        }
        return date
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                Color(red: 1/255, green: 104/255, blue: 138/255)
                    .ignoresSafeArea(edges: .top)
                
                HStack(alignment: .center, spacing: 16) {
                    Image("novaLogo1")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Agenda de Servicios")
                            .padding(.top, 15)
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .bold()
                            .font(.system(size: 25))
                        
                        Text(formattedDate)
                            .padding(.leading, 5)
                            .foregroundStyle(Color.white)
                            .font(.system(size: 16))
                    }
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(.bottom, 10)
            

            HStack(spacing: 12) {
                Button("Hoy") {
                    filtroFecha = "hoy"
                }
                .padding(.vertical, 13)
                .padding(.horizontal, 40)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(filtroFecha == "hoy" ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color.gray)
                )
                .bold()
                .font(.system(size: 20))
                
                Button("Mañana") {
                    filtroFecha = "manana"
                }
                .padding(.vertical, 13)
                .padding(.horizontal, 40)
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(filtroFecha == "manana" ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color.gray)
                )
                .bold()
                .font(.system(size: 20))
                
                Button(action: {
                    navegarACalendario = true
                }) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 46)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 1/255, green: 104/255, blue: 138/255).opacity(0.8))
                        )
                }
            }
            .padding(.top, -5)
            .padding(.bottom, -5)
            
            Spacer()
            
            if isLoading {
                ProgressView("Cargando servicios...")
                    .padding()
                Spacer()
            } else if serviciosFiltrados.isEmpty {
                Text("No hay servicios disponibles para \(filtroFecha == "hoy" ? "hoy" : "mañana")")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(serviciosFiltrados, id: \.idServicio) { servicio in
                            NavigationLink(destination: DetalleView(hideTabBar: $hideTabBar, servicio: servicio)) {
                                ReCuadro(servicio: servicio)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                }
            }
        }
        .navigationBarHidden(true)

        .navigationDestination(isPresented: $navegarACalendario) {
                    CalendarioView(idworker: UserDefaults.standard.integer(forKey: "idworker"))
                }
        .onAppear {
            Task {
                await cargarServicios()
            }
        }
    }
    
    func cargarServicios() async {
        isLoading = true
        
        do {
            let idPersonal = UserDefaults.standard.integer(forKey: "idworker")
            servicios = try await obtenerServicios(idPersonal: idPersonal)
        } catch {
            print("Error al cargar servicios: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
}

#Preview {
    NavigationStack {
        AgendaView(hideTabBar: .constant(false))
    }
}
