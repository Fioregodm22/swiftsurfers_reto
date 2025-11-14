import SwiftUI

struct ContentView: View {
    @Binding var isLoggedIn: Bool
    @State private var tabSelection = 2
    @State private var hideTabBar = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabSelection) {
                HistorialView().tag(1)
                
                NavigationStack {
                    AgendaView(hideTabBar: $hideTabBar)
                }
                .tag(2)
                
                PerfilView(isLoggedIn: $isLoggedIn).tag(3)
            }
            
            if !hideTabBar {
                CustomTabView(tabSelection: $tabSelection)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
// -chava agregue el preview wrapper, como login esta en un navigation separado no se podria conectar desde el preview de content view osea irrelevante para simulador, pero evita tener que hacer login en loginview
#Preview {
    PreviewWrapper()
}


struct PreviewWrapper: View {
    @State private var isLoggedIn = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn)
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear {
            let savedId = UserDefaults.standard.integer(forKey: "idworker")
            if savedId != 0 {
                isLoggedIn = true
            }
        }
    }
}
