//
//  CalendarioView.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 23/10/25.
//

import SwiftUI


struct CalendarioView: View {
    @State private var mesActual = Date()
    @State private var diaSeleccionado: Int?
    @State private var viajes: [Viaje] = []
    @State private var viajesFiltrados: [Viaje] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showError = false
    @State public var idworker: Int? = nil
    
    // ID del usuario desde el State
    var idUsuario: Int {
        idworker ?? 0
    }
    
    // Año actual del mes seleccionado
    var yearActual: Int {
        Calendar.current.component(.year, from: mesActual)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack(alignment: .topLeading) {
                Color(red: 1/255, green: 104/255, blue: 138/255)
                    .ignoresSafeArea(edges: .top)
                
                HStack(alignment: .center, spacing: 16) {
                    Image("novaLogo1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80)
                        .padding(.leading, 20)
                    
                    Text("Calendario")
                        .foregroundStyle(Color.white)
                        .bold()
                        .font(.system(size: 28))
                    
                    Spacer()
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            
            // Calendario
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Meses (Nav)
                    HStack(spacing: 12) {
                        Button(action: { cambiarMes(-1) }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color(red: 255/255, green: 153/255, blue: 0/255))
                                .clipShape(Circle())
                        }
                        
                        VStack(spacing: 4) {
                            Text(nombreMes().uppercased())
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("\(yearActual)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .frame(width: 250)
                        .padding(.vertical, 8)
                        .background(Color(red: 255/255, green: 153/255, blue: 0/255))
                        .cornerRadius(25)
                        
                        Button(action: { cambiarMes(1) }) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color(red: 255/255, green: 153/255, blue: 0/255))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Botón para ir al mes actual (solo si no estamos en el mes actual)
                    if !esMesActual() {
                        Button(action: {
                            mesActual = Date()
                            diaSeleccionado = nil
                            viajesFiltrados = []
                            Task { await cargarViajesDelMes() }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar.circle.fill")
                                Text("Ir al mes actual")
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(red: 1/255, green: 104/255, blue: 138/255))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(red: 1/255, green: 104/255, blue: 138/255).opacity(0.1))
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Grid Calendar
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color(white: 0.95))
                        
                        VStack(spacing: 12) {
                            // Dias de la semana
                            HStack(spacing: 0) {
                                ForEach(["Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"], id: \.self) { dia in
                                    Text(dia)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color(white: 0.4))
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 15)
                            
                            // Dias
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
                                ForEach(obtenerDiasDelMes(), id: \.self) { dia in
                                    if dia > 0 {
                                        let tieneViajes = verificarViajesEnDia(dia)
                                        
                                        ZStack {
                                            Text("\(dia)")
                                                .font(.system(size: 16, weight: dia == diaSeleccionado ? .bold : .regular))
                                                .foregroundColor(dia == diaSeleccionado ? .white : Color(white: 0.3))
                                                .frame(width: 44, height: 44)
                                                .background(dia == diaSeleccionado ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color.white)
                                                .clipShape(Circle())
                                            
                                            if tieneViajes {
                                                Circle()
                                                    .fill(Color(red: 1/255, green: 104/255, blue: 138/255))
                                                    .frame(width: 6, height: 6)
                                                    .offset(y: 18)
                                            }
                                        }
                                        .onTapGesture {
                                            diaSeleccionado = dia
                                            filtrarViajesPorDia(dia)
                                        }
                                    } else {
                                        Text("")
                                            .frame(width: 44, height: 44)
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 15)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Divider().padding(.horizontal, 20)
                    
                    // Sección de información de fecha seleccionada
                    if let diaSelec = diaSeleccionado {
                        HStack {
                            Text("Viajes del \(diaSelec) de \(nombreMes()) \(yearActual)")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                            Spacer()
                            Text("(\(viajesFiltrados.count))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Viajes
                    ZStack {
                        if isLoading {
                            ProgressView("Cargando viajes...")
                                .padding()
                        } else if diaSeleccionado == nil {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                                Text("Selecciona un día para ver los viajes")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 200)
                        } else if viajesFiltrados.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "car.circle")
                                    .font(.system(size: 40))
                                    .foregroundColor(Color(red: 1/255, green: 104/255, blue: 138/255))
                                Text("No hay viajes en esta fecha")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 200)
                        } else {
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(Array(viajesFiltrados.enumerated()), id: \.element.id) { index, viaje in
                                        ViajeRow(viaje: viaje, colorIndex: index)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                            }
                            .frame(height: 200)
                        }
                    }
                }
            }
        }
        .background(Color.white)
        .onAppear {
            Task {
                // Para testing rápido: descomenta la línea siguiente y pon el id que quieras
                // self.idworker = 5

                // Si no hay id asignado, intenta leerlo de UserDefaults
                
                if idworker == nil || idworker == 0 {
                    let savedId = UserDefaults.standard.integer(forKey: "idworker")
                    if savedId != 0 { self.idworker = savedId }
                }
                 
                await cargarViajesDelMes()

                // Auto-seleccionar día actual si estamos en el mes actual
                let calendar = Calendar.current
                let hoy = Date()
                let mesHoy = calendar.component(.month, from: hoy)
                let yearHoy = calendar.component(.year, from: hoy)
                let mesVista = calendar.component(.month, from: mesActual)
                let yearVista = calendar.component(.year, from: mesActual)

                if mesHoy == mesVista && yearHoy == yearVista {
                    let diaHoy = calendar.component(.day, from: hoy)
                    diaSeleccionado = diaHoy
                    filtrarViajesPorDia(diaHoy)
                }
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("Reintentar") {
                Task { await cargarViajesDelMes() }
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "Error desconocido al cargar viajes")
        }
    }
    
    // MARK: - API Function
    func cargarViajesDelMes() async {
        guard let id = idworker, id != 0 else {
            errorMessage = "No se encontró ID de usuario"
            showError = true
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let base = "http://10.14.255.43:10202/getviaje"
        let idUsuarioString = String(id)
        
        var urlComponents = URLComponents(string: base)!
        urlComponents.queryItems = [
            URLQueryItem(name: "id_usuario", value: idUsuarioString)
        ]
        
        guard let url = urlComponents.url else {
            errorMessage = "Error: No se pudo construir la URL."
            showError = true
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Error HTTP. No se pudieron cargar los viajes."
                showError = true
                isLoading = false
                return
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(ViajeAPIResponse.self, from: data)
            
            // Convertir los datos del API al formato de Viaje
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
            
            viajes = result.Info.compactMap { viajeData -> Viaje? in
                guard let fecha = dateFormatter.date(from: viajeData.fecha) else { return nil }
                
                let distanciaTexto = viajeData.kmTotales != nil ?
                    String(format: "%.2f km", viajeData.kmTotales!) : "Sin registro"
                
                return Viaje(
                    nombre: "Servicio #\(viajeData.idServicio)",
                    distancia: distanciaTexto,
                    idServicio: viajeData.idServicio,
                    fecha: fecha,
                    estatus: viajeData.estatus
                )
            }
            
        } catch {
            errorMessage = "Error al cargar los viajes: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
    
    func verificarViajesEnDia(_ dia: Int) -> Bool {
        let calendar = Calendar.current
        return viajes.contains { viaje in
            let diaViaje = calendar.component(.day, from: viaje.fecha)
            let mesViaje = calendar.component(.month, from: viaje.fecha)
            let yearViaje = calendar.component(.year, from: viaje.fecha)
            
            let mesActualNum = calendar.component(.month, from: mesActual)
            let yearActual = calendar.component(.year, from: mesActual)
            
            return diaViaje == dia && mesViaje == mesActualNum && yearViaje == yearActual
        }
    }
    
    func filtrarViajesPorDia(_ dia: Int) {
        let calendar = Calendar.current
        let mesActualNum = calendar.component(.month, from: mesActual)
        let yearActual = calendar.component(.year, from: mesActual)
        
        viajesFiltrados = viajes.filter { viaje in
            let diaViaje = calendar.component(.day, from: viaje.fecha)
            let mesViaje = calendar.component(.month, from: viaje.fecha)
            let yearViaje = calendar.component(.year, from: viaje.fecha)
            
            return diaViaje == dia && mesViaje == mesActualNum && yearViaje == yearActual
        }
    }
    
    func nombreMes() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: mesActual)
    }
    
    func cambiarMes(_ offset: Int) {
        if let nuevoMes = Calendar.current.date(byAdding: .month, value: offset, to: mesActual) {
            mesActual = nuevoMes
            diaSeleccionado = nil
            viajesFiltrados = []
            Task { await cargarViajesDelMes() }
        }
    }
    
    func esMesActual() -> Bool {
        let calendar = Calendar.current
        let mesActualNum = calendar.component(.month, from: mesActual)
        let yearActualNum = calendar.component(.year, from: mesActual)
        let mesHoy = calendar.component(.month, from: Date())
        let yearHoy = calendar.component(.year, from: Date())
        return mesActualNum == mesHoy && yearActualNum == yearHoy
    }
    
    func obtenerDiasDelMes() -> [Int] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: mesActual)!
        let numDias = range.count
        
        var componentes = calendar.dateComponents([.year, .month], from: mesActual)
        componentes.day = 1
        let primerDia = calendar.date(from: componentes)!
        
        var diaSemana = calendar.component(.weekday, from: primerDia)
        diaSemana = diaSemana == 1 ? 7 : diaSemana - 1
        
        var dias: [Int] = Array(repeating: 0, count: diaSemana - 1)
        dias.append(contentsOf: 1...numDias)
        
        return dias
    }
}

struct ViajeRow: View {
    let viaje: Viaje
    let colorIndex: Int
    
    var backgroundColor: Color {
        colorIndex % 2 == 0 ?
        Color(red: 255/255, green: 217/255, blue: 179/255) :
        Color(red: 179/255, green: 204/255, blue: 217/255)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viaje.nombre)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(white: 0.2))
                
                if let estatus = viaje.estatus {
                    Text(estatus)
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.4))
                        .italic()
                }
            }
            
            Spacer()
            
            Text(viaje.distancia)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(white: 0.2))
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(18)
    }
}

#Preview {
    CalendarioView()
}
