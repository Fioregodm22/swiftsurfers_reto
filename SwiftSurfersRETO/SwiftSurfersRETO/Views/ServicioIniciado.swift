import SwiftUI

struct ServicioIniciado: View {
    @Binding var hideTabBar: Bool
    @Binding var shouldDismissToRoot: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            ZStack{
                ZStack{
                    Color(red: 1/255, green: 104/255, blue: 138/255)
                    Color.white
                        .frame(width: 280, height: 550)
                        .cornerRadius(20)
                }
                Text("Servicio iniciado correctamente")
                    .padding(.top, 40)
                    .foregroundStyle(Color.black.opacity(0.7))
                    .fontWeight(.bold)
                    .font(.system(size: 22))
                    .multilineTextAlignment(.center)
                    .padding(60)
                
                Image("check")
                    .padding(.top, -210)
                
                Button(action: {
                    dismiss()
                    shouldDismissToRoot = true
                }){
                    Text("ACEPTAR")
                        .font(.system(size: 20))
                        .bold(true)
                }
                .padding()
                .fontWeight(.bold)
                .padding(.horizontal, 50)
                .background(Color(red: 1/255, green:104/255, blue:138/255))
                .font(.system(size: 20))
                .foregroundStyle(Color.white)
                .cornerRadius(20)
                .padding(.top, 300)
            }
            .ignoresSafeArea(edges: .all)
            .toolbar(.hidden, for: .tabBar)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    NavigationStack {
        ServicioIniciado(hideTabBar: .constant(false), shouldDismissToRoot: .constant(false))
    }
}
