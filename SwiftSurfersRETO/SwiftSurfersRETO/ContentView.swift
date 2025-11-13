import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 2
    @State private var hideTabBar = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $tabSelection) {
                CalendarioView().tag(1)
                
                NavigationStack {
                    AgendaView(hideTabBar: $hideTabBar)
                }
                .tag(2)
                
                PerfilView().tag(3)
            }
            
            if !hideTabBar {
                CustomTabView(tabSelection: $tabSelection)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}

#Preview {
    ContentView()
}
