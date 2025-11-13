//
//  CalendarioView.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 23/10/25.
//

import SwiftUI

struct Viaje: Identifiable {
    let id = UUID()
    let nombre: String
    let distancia: String
}

struct CalendarioView: View {
    @State private var mesActual = Date()
    @State private var diaSeleccionado = 23
    @State private var viajes: [Viaje] = [
        Viaje(nombre: "Viaje 1", distancia: "35km"),
        Viaje(nombre: "Viaje 4", distancia: "35km"),
        Viaje(nombre: "Viaje 11", distancia: "35km"),
        Viaje(nombre: "Viaje 15", distancia: "35km"),
        Viaje(nombre: "Viaje 20", distancia: "35km")
    ]
    
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
                        
                        Text(nombreMes().uppercased())
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 250)
                            .padding(.vertical, 12)
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
                                        Text("\(dia)")
                                            .font(.system(size: 16, weight: dia == diaSeleccionado ? .bold : .regular))
                                            .foregroundColor(dia == diaSeleccionado ? .white : Color(white: 0.3))
                                            .frame(width: 44, height: 44)
                                            .background(dia == diaSeleccionado ? Color(red: 255/255, green: 153/255, blue: 0/255) : Color.white)
                                            .clipShape(Circle())
                                            .onTapGesture {
                                                diaSeleccionado = dia
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
                    
                    // Viajes
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(viajes.enumerated()), id: \.element.id) { index, viaje in
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
        .background(Color.white)
    }
    
    // MARK: - Helper Methods
    func nombreMes() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: mesActual)
    }
    
    func cambiarMes(_ offset: Int) {
        if let nuevoMes = Calendar.current.date(byAdding: .month, value: offset, to: mesActual) {
            mesActual = nuevoMes
        }
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

// MARK: - Viaje Row Component
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
            Text(viaje.nombre)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color(white: 0.2))
            
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
