//
//  ServicioFinalizado.swift
//  SwiftSurfersRETO
//

import SwiftUI

struct ServicioFinalizado: View {
    @Binding var shouldDismissToRoot: Bool
    
    let azul = Color(red: 1/255.0, green: 104/255.0, blue: 138/255.0)
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(azul)
            
            Text("Servicio Finalizado")
                .font(.system(size: 30))
                .bold()
                .padding(.top, 20)
            
            Text("El servicio ha sido finalizado exitosamente")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 10)
            
            Spacer()
            
            Button(action: {
                shouldDismissToRoot = true
            }) {
                Text("VOLVER A AGENDA")
                    .font(.system(size: 20))
                    .bold()
            }
            .frame(width: 300)
            .frame(height: 60)
            .foregroundStyle(.white)
            .background(RoundedRectangle(cornerRadius: 20).fill(azul))
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .navigationBarHidden(true)
    }
}

#Preview {
    ServicioFinalizado(shouldDismissToRoot: .constant(false))
}
