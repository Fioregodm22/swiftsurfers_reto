
import Foundation
import SwiftUI

func abrirGoogleMaps(latitud: Double, longitud: Double) {
    let urlString = "https://www.google.com/maps?q=\(latitud),\(longitud)"
    if let url = URL(string: urlString) {
        UIApplication.shared.open(url)
    }
}

func obtenerServicios(idPersonal: Int) async throws -> [Servicio] {
    let base = "http://10.14.255.43:10201/servicio"
    var components = URLComponents(string: base)!
    components.queryItems = [
        URLQueryItem(name: "idPersonal", value: String(idPersonal))
    ]
    guard let url = components.url else {
        throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    let decoder = JSONDecoder()
    let servicios = try decoder.decode([Servicio].self, from: data)
    
    return servicios
}

func obtenerDetalle(idServicio: Int) async throws -> Detalle {
    let base = "http://10.14.255.43:10201/detalle"
    var components = URLComponents(string: base)!
    components.queryItems = [
        URLQueryItem(name: "idServicio", value: String(idServicio))
    ]
    guard let url = components.url else {
        throw URLError(.badURL)
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    let decoder = JSONDecoder()
    let detalles = try decoder.decode([Detalle].self, from: data)
    
    guard let primerDetalle = detalles.first else {
        throw URLError(.cannotDecodeContentData)
    }
    return primerDetalle
}



