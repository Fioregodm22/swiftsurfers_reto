//
//  AgendaView.swift
//  SwiftSurfersRETO
//
//  Created by Maria Cavada on 14/10/25.
//

import SwiftUI

struct AgendaView: View {
    // -------- FORMATEO DE FECHA --------
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
            // PARTE SUPERIOR
            ZStack(alignment: .topLeading) {
                Color(red: 1/255, green: 104/255, blue: 138/255)
                    .ignoresSafeArea(edges: .top)
                
                // RESUMEN STACK
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
                            .font(.system(size: 18))
                    }
                }
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .padding(.bottom, 10)
            
            HStack {
                Button("Hoy") {}
                    .padding(.vertical, 13)
                    .padding(.horizontal, 40)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(red: 255/255, green: 153/255, blue: 0/255))
                    )
                    .bold()
                    .font(.system(size: 20))
                
                Button("Mañana") {}
                    .padding(.vertical, 13)
                    .padding(.horizontal, 40)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.gray)
                    )
                    .bold()
                    .font(.system(size: 20))
            }
            
            Spacer()
            ScrollView{
                VStack{
                    ReCuadro(servicio: .ejemplo)
                    ReCuadro(servicio: .ejemplo2)
                    ReCuadro(servicio: .ejemplo)
                    Spacer()
                }
            }
        }
        .toolbar(.hidden)
    }
}

#Preview {
    AgendaView()
}
