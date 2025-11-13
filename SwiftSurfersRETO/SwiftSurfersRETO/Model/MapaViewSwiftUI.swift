//
//  MapaView.swift
//
//  Created by Cristina Gonzalez Cordova on 01/10/23.
//
import SwiftUI
import MapKit
import CoreLocation

struct MapaView: View {
                       
    //Propiedades para inicializar el Mapa
    @State var latitud: Double = 0.0 //25.67507
    @State var longitud: Double = 0.0 //-100.31847
    @State var customMark: [Marcador] = []
    @State var showPosicion: Bool = false
    
    //Zoom definido para el Mapa: valores mas chicos hacen zoom in
    @State private var latZoom:Double = 0.1
    @State private var lonZoom:Double = 0.1
    
    //Valores iniciales pero que sobreescribe al iniciar
    @State private var cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ))
                
    //Variable para mostrar ubicación actual
    @StateObject private var locationManagerCurrent = LocationManager()
    
    var body: some View {
        VStack{
            Map(position: $cameraPosition){
                //Si quiere mostrar la posicion actual la marca en azul
                if (showPosicion){
                    UserAnnotation()
                }
                // Si hay Marcas las pinta en el mapa
                ForEach(customMark) { location in
                    Marker(location.nombre, coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                        .tint(location.colorMark)
                }
            }
            .mapControls {
                MapScaleView()
                MapUserLocationButton()
            }
            .onAppear(){
                   // Marca el punto de la posicion actual
                   if (showPosicion){
                       locationManagerCurrent.checkLocationAuthorization()
                   }
                   // Si lat y lon son 0.0 centra el mapa en la posicion actual
                   if(latitud == 0.0 && longitud == 0.0){
                        locationManagerCurrent.checkLocationAuthorization()
                        if let coordinateCurrent = locationManagerCurrent.lastKnownLocation {
                            latitud = coordinateCurrent.latitude
                            longitud = coordinateCurrent.longitude
                        }
                   }
                   //Ajusta el centro del mapa y el zoom
                   cameraPosition = MapCameraPosition.region(MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: latitud, longitude: longitud),
                            span: MKCoordinateSpan(latitudeDelta: latZoom, longitudeDelta: lonZoom)
                    ))
                    
                }
        }.ignoresSafeArea()
    }
}

struct Marcador: Identifiable {
    let id = UUID()
    let nombre: String
    let coordinate: CLLocationCoordinate2D
    var colorMark: Color = .red
}

#Preview {
    MapaView()
}

