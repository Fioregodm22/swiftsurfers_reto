//
//  SwiftSurfersRETOApp.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 14/10/25.
//

import SwiftUI

@main
struct SwiftSurfersRETOApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

// Nueva vista root que maneja el estado de login
struct RootView: View {
    @AppStorage("idworker") private var idworker: Int = 0
    @State private var isLoggedIn = false
    
    var body: some View {
        Group {
            if isLoggedIn {
                ContentView(isLoggedIn: $isLoggedIn) //Pasa el binding
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear {
            // Verifica si ya hay una sesión activa
            if idworker != 0 {
                isLoggedIn = true
            }
        }
    }
}
