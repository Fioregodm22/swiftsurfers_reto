//
//  ContentView.swift
//  ElementosReutilizables
//
//  Created by Maria Cavada on 10/10/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var tabSelection = 2
    
    var body: some View {
        TabView(selection: $tabSelection) {
            Text("Tab Content 2").tag(1)
            
            AgendaView().tag(2)
            
            PerfilView().tag(3)

        }
        .overlay(alignment: .bottom){
            CustomTabView(tabSelection: $tabSelection)
        }
    }
}

#Preview {
    ContentView()
}
