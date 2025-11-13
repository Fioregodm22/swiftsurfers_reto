import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 2
    @State private var hideTabBar = false  // CAMBIA ESTO - ya no es @Binding
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabSelection) {
                Text("Tab Content 2").tag(1)
                
                NavigationStack {
                    AgendaView(hideTabBar: $hideTabBar)
                }
                .tag(2)
                
                Text("Tab Content 3").tag(3)
            }
            
            if !hideTabBar {
                CustomTabView(tabSelection: $tabSelection)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    ContentView()  // Ahora ya no necesita parámetros
}
