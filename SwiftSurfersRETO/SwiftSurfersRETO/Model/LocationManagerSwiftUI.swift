//
//  LocationManager.swift
//  Ejemplo1Oct
//  Basado en: https://medium.com/@desilio/getting-user-location-with-swiftui-1f79d23c2321
//  Created by Cristina Gonzalez Cordova on 01/10/24.
//
import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    
    
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Ubicacion restringida")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Ubicacion denegada")
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Ubicacion autorizada")
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Ubicacion autorizada al usar")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Servicio de ubicacion deshabilitada")
        
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
