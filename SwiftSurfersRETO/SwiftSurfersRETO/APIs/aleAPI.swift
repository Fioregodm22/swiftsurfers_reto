//
//  aleAPI.swift
//  SwiftSurfersRETO
//
//  Created by Alumno on 12/11/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
}

struct ErrorResponse: Codable {
    let error: String
}

class AleAPI {
    static let shared = AleAPI()
    private let baseURL = "http://10.14.255.43:10203"
    
    func getHistorialParamedico(idPersonal: Int) async throws -> [ServicioHistorial] {
        let url = URL(string: "\(baseURL)/historialServicios/paramedico/\(idPersonal)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return try JSONDecoder().decode([ServicioHistorial].self, from: data)
    }
    
    func crearServicio(request: CrearServicioRequest) async throws -> CrearServicioResponse {
        let url = URL(string: "\(baseURL)/crearServicio")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 201 else {
            throw APIError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse<CrearServicioResponse>.self, from: data)
        guard let responseData = apiResponse.data else {
            throw APIError.noData
        }
        
        return responseData
    }

    func iniciarServicio(idServicio: Int, kmInicio: Int) async throws -> IniciarServicioResponse {
        let url = URL(string: "\(baseURL)/iniciarServicio/\(idServicio)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = IniciarServicioRequest(kmInicio: kmInicio)
        urlRequest.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse<IniciarServicioResponse>.self, from: data)
        guard let responseData = apiResponse.data else {
            throw APIError.noData
        }
        
        return responseData
    }

    func actualizarEstatus(idServicio: Int, idEstatus: Int) async throws -> Bool {
        let url = URL(string: "\(baseURL)/updateEstatusServicio/\(idServicio)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ActualizarEstatusRequest(idEstatusTraslado: idEstatus)
        urlRequest.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(APIResponse<String>.self, from: data)
        return apiResponse.success
    }
}

enum APIError: Error{
    case invalidResponse
    case noData
    case decodingError
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Respuesta Invalida"
        case .noData:
            return "No se recibieron datos"
        case .decodingError:
            return "Error al procesar los datos"
        case .invalidURL:
            return "URL inválida"
        }
    }
}

