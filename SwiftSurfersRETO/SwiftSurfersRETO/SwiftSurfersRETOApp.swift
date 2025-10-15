//
//  SwiftSurfersRETOApp.swift
//  SwiftSurfersRETO
//
//  Created by Salvador Ancer on 14/10/25.
//

import SwiftUI

@main
struct SwiftSurfersRETOApp: App {
    @State private var isLoggedIn: Bool = false
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !isLoggedIn {
                    AgendaView()
                }else{
                    LoginView()
                }
            }
        }
    }
}
