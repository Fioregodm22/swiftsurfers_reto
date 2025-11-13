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
        NavigationStack{
            
            TabView(selection: $tabSelection) {
                CalendarioView().tag(1)
                
                AgendaView().tag(2)
                
                PerfilView().tag(3)
                
            }
            .overlay(alignment: .bottom){
                CustomTabView(tabSelection: $tabSelection)
            }
        }
    }
}

#Preview {
    ContentView()
}
