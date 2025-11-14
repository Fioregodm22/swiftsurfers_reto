//
//  LoginView.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 14/10/25.
//

import SwiftUI

struct LoginView: View {
    @State private var navigate = false
    @State public var idworker : Int? = nil
    @State public var password : String = ""
    @State public var alertnotid = false
    @State public var alertnotpass = false
    @State public var warningid : String = ""
    @State public var mostrarContrasena : Bool = false
    
    
    // funcion para validar el login
    func attemptLogin() async {
        if idworker == nil {
            alertnotid = true
            return
        }
        let idWorkerValue = idworker ?? 0
        let idworkerString = String(idWorkerValue)
        let base = "https://toll-open-undertake-climb.trycloudflare.com/validaruser"
        
        var components = URLComponents(string: base)!
        components.queryItems = [
           
            URLQueryItem(name: "id_usuario", value: idworkerString),
            URLQueryItem(name: "contrasena", value: password)
        ]
        
        guard let url = components.url else {
            
            print("Error: No se pudo construir la URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
           
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error HTTP.")
                alertnotpass = true
                return
            }


            let decoder = JSONDecoder()
            let result = try decoder.decode(LoginResponse.self, from: data)
            

            if result.valido == true {
                print("Login exitoso. Usuario valido: \(result.id_usuario)")
                UserDefaults.standard.set(idworker, forKey: "idworker")
                navigate = true
                alertnotid = false
                alertnotpass = false
            } else {
                print("Login fallido. Mensaje: \(result.mensaje)")
                alertnotpass = true
            }
            
        } catch {
            print("Error general: \(error.localizedDescription)")
            alertnotpass = true
        }
    }

    
    var body: some View {
    NavigationStack{
        ZStack{
            Color(red: 1/255, green: 104/255 ,blue: 138/255)
            
            
            RoundedRectangle(cornerRadius: 20.0)
                .frame(width: 325 ,height: 480)
                .foregroundStyle(Color.white)
            
            VStack(spacing: 0){
                
                Image("novaclinica2")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 120)
                    .padding(.top, -140)
                    .padding(.horizontal, 60)
                
                VStack(alignment: .leading, spacing: 24){
                    VStack(alignment: .leading, spacing: 8){
                        Text("ID de Empleado:")
                            .font(.title3)
                            .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                            .fontWeight(.bold)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                        TextField("", value: $idworker, format: .number)
                            .padding(.horizontal, 12)
                            .frame(width: 260, height: 50)
                        
                        
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                            )
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Contraseña:")
                            .font(.title3)
                            .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        HStack{
                            if mostrarContrasena{
                                TextField("", text: $password)
                            }else{
                                SecureField("", text: $password)
                            }
                            
                            Button(action: {
                                mostrarContrasena.toggle()
                            }){
                                Image(systemName: mostrarContrasena ? "eye.slash.fill": "eye.fill")
                                    .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                            }
                            
                        }
                        .padding(.horizontal, 12)
                        .frame(width: 260, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(red: 242/255, green: 242/255, blue: 242/255))
                        )
                    }
                }
                
                NavigationLink(destination: ContentView(), isActive:$navigate){
                    EmptyView()
                }
                
                
                Button("INGRESAR"){
                    Task {
                            await attemptLogin()
                        }
                    
                    
                    
                }
                
                .frame(width: 160, height: 54)
                .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
                .cornerRadius(20)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .padding(.horizontal, 50)
                .padding(.top, 40)
                
                
                .alert("Ingresar ID", isPresented: $alertnotid){
                    Button("Ok"){ }
                }
                .alert("Error en la contraseña o usuario", isPresented: $alertnotpass){
                    Button("Ok"){ }
                    
                }
            }
            Spacer()
            
        }
        .onAppear(){
            idworker = UserDefaults.standard.integer(forKey: "idworker")
        }
        .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
       
        .navigationBarTitle("")
    }
        
    }
}

#Preview {
    LoginView()
}
