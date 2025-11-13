//
//  PerfilView.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 10/11/25.
//

import SwiftUI

struct PerfilView: View {
    @State private var showingLoginScreen = false
    @State public var idworker : Int? = nil
    @State public var userData : UserData = usuarioprueba
    @State private var textjornada: String = "Iniciar jornada"
    @State private var newStatus: String = "Desactivado"
    @State private var errorMessage: String? = nil
    @State private var terminarjornada : Bool = false
    @State public var alertemerg = false
    func getUser() async {
        if idworker == nil {
            return
        }
        let idWorkerValue = idworker ?? 0
        let idworkerString = String(idWorkerValue)
        let base = "http://10.14.255.43:10205/getuser"
        
        var components = URLComponents(string: base)!
        components.queryItems = [
            URLQueryItem(name: "id_usuario", value: idworkerString)
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
                let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                DispatchQueue.main.async {
                    self.errorMessage = "Respuesta de servidor inválida. Código: \(status)"
                }
                return
            }
            
            
            let decodedResponse = try JSONDecoder().decode(APIResponse.self, from: data)
            
            
            guard let fetchedUser = decodedResponse.Info.first else {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: La clave 'Info' no contiene elementos."
                }
                return
            }
            
            
            DispatchQueue.main.async {
                self.userData = fetchedUser
            }
            
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error de conexión/decodificación: \(error.localizedDescription)"
                
            }
        }
    }
    
    func updateUserStatus(newStatus: String) async {
        
        guard let id = idworker else {
            DispatchQueue.main.async {
                self.errorMessage = "ID de trabajador no disponible."
            }
            return
        }
        
        
        let url = URL(string: "http://10.14.255.43:10205/updatestatus")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let body: [String: Any] = [
            "id_usuario": id,
            "status": newStatus
        ]
        
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: body) else {
            DispatchQueue.main.async {
                self.errorMessage = "Error al serializar datos para PUT."
            }
            return
        }
        
        request.httpBody = bodyData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // estado hhtp
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                DispatchQueue.main.async {
                    self.errorMessage = "PUT Fallido. Código HTTP: \(status)"
                }
                return
            }
            
            // respuesta
            let decodedResponse = try JSONDecoder().decode(StatusUpdateResponse.self, from: data)
            
            // comprobacion de exito
            guard decodedResponse.success else {
                DispatchQueue.main.async {
                    self.errorMessage = decodedResponse.message
                }
                return
            }
            
            DispatchQueue.main.async {
                self.errorMessage = nil // limpiar errores si tuvo éxito
                
                // actualizar estatus
                self.userData = UserData(
                    idPersonal: decodedResponse.id_usuario,
                    nombre: self.userData.nombre,
                    apellidoPaterno: self.userData.apellidoPaterno,
                    codigoUsuario: self.userData.codigoUsuario,
                    correoElectronico: self.userData.correoElectronico,
                    telefono: self.userData.telefono,
                    estatus: decodedResponse.nuevo_status //nuevo estatus
                )
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error de conexión/decodificación PUT: \(error.localizedDescription)"
            }
        }
    }
    
    func toggleJornada() {
        
        
        if (terminarjornada == false ){
            newStatus = "Activo"
            terminarjornada = true
        }
        else {
            newStatus = "Desactivado"
            terminarjornada = false
        }
        
        Task {
            await updateUserStatus(newStatus: newStatus)
        }
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                EncabezadoView(mensaje: "Perfil")
                Text("¡Hola, \(userData.nombre)!")
                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 20.0)
                        .frame(width: 350, height: 320)
                        .foregroundStyle(Color(red: 242/255, green: 242/255, blue: 242/255))
                    
                    
                    VStack(spacing: 0) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                
                                Text("Contacto:")
                                    .font(.title3)
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                    .fontWeight(.bold)
                                    .padding(.top, 35)
                                Text("Usuario: \(userData.correoElectronico)")
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                    .padding(.top, 3)
                                
                                Text("Teléfono: + \(userData.telefono)")
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                    .padding(.top, 3)
                                
                                Text("Id:" + String(userData.idPersonal))
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                    .padding(.top, 3)
                                
                                
                                Divider()
                                    .frame(width: 300)
                                
                                
                                Text("Estatus actual:")
                                    .font(.title3)
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                    .fontWeight(.bold)
                                Text("\(userData.estatus)")
                                    .foregroundStyle(Color(red: 102/255, green: 102/255, blue: 102/255))
                                    .padding(.top, 3)
                                
                                Button(action: {
                                    toggleJornada()
                                    if (terminarjornada == false){
                                        textjornada = "Iniciar jornada"
                                        
                                    }
                                    else {
                                        textjornada = "Terminar jornada"
                                    }
                                    
                                }) {
                                    HStack {
                                        Image(systemName: "checkmark.circle")
                                        Text(textjornada)
                                    }
                                }
                                
                                .frame(width: 239, height: 45)
                                .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
                                .cornerRadius(20)
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal, 25)
                                .padding(.top, 10)
                                .padding(.bottom, 20)
                            }
                        }
                        .padding(.leading, 10)
                    }
                    
                }
                .padding(.bottom, 10)
                
                
                Button("CERRAR SESIÓN"){
                    showingLoginScreen =  true
                    
                }
                
                
                .frame(width: 239, height: 45)
                .background(Color(red: 1/255, green: 104/255 ,blue: 138/255))
                .cornerRadius(20)
                .foregroundColor(.white)
                .font(.title2)
                .bold()
                .padding(.horizontal, 30)
                .padding(.bottom, 6)
                
                
                .fullScreenCover(isPresented: $showingLoginScreen) { LoginView() }
                
                Button(action: {
                    alertemerg = true
                }) {
                    HStack {
                        Image(systemName: "phone.fill")
                        Text("EMERGENCIA")
                    }
                }
                .alert("La ayuda está en camino,te estamos comunicando", isPresented: $alertemerg){
                    Button("Ok"){ }
                    
                }
                
                .frame(width: 239, height: 45)
                .background(Color(red: 230/255, green: 229/255, blue: 229/255))
                .cornerRadius(20)
                .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                .font(.title2)
                .bold()
                .padding(.horizontal, 15)
                .padding(.top, 2)
                
                Spacer()
                
            }
           
        }
        .onAppear(){
            Task {
                
                let savedId = UserDefaults.standard.integer(forKey: "idworker")
                
                
                if savedId != 0 {
                    self.idworker = savedId
                }
                
                
                await getUser()
            }
        }
    }
}


#Preview {
    PerfilView()
}
