//
//  CinemasViewController.swift
//  Movies_Pocket
//
//  Created by Diego Manuel Molina Canedo on 18/3/17.
//  Copyright © 2017 Universidad Pontificia de Salamanca. All rights reserved.
//

import UIKit
import MapKit
class CinemasViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundView.layer.insertSublayer(gradient, at: 0)
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.mapView.setRegion(.init(center: mapView.userLocation.location!.coordinate , span: .init(latitudeDelta: CLLocationDegrees(0.05), longitudeDelta: CLLocationDegrees(0.05))), animated:  true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if(mapView.annotations.count > 50) {
            //To protect mapView performance
            mapView.removeAnnotations(mapView.annotations)
        }
        
        let mapSearchRequest = MKLocalSearchRequest()
        mapSearchRequest.naturalLanguageQuery = "cinema"
        mapSearchRequest.region = mapView.region
        
        let mapSearch = MKLocalSearch(request: mapSearchRequest)
        
        mapSearch.start { (response, error) in
            if error != nil {
                print("Error")
                return
            }
            
            if response?.mapItems.count == 0 {
                print("Error")
                return
            }
            
            for item in response!.mapItems{
               
                let alreadyInAnnotations = self.mapView.annotations.contains(where: { (anotation) -> Bool in
                        return ((anotation.coordinate.latitude == item.placemark.coordinate.latitude)
                            && (anotation.coordinate.longitude == item.placemark.coordinate.longitude))
                    })
                
                if (!alreadyInAnnotations){
                    let cinemaAnnotation = CinemaPin(lat: item.placemark.coordinate.latitude, long: item.placemark.coordinate.longitude)
                    cinemaAnnotation.title = item.placemark.name
                    cinemaAnnotation.subtitle = item.placemark.title
                self.mapView.addAnnotation(cinemaAnnotation)
                }
                
            }
            
            self.mapView.reloadInputViews()
        }
    }
    
    @IBAction func showInMapsAppAction(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"http://maps.apple.com/?q=Cinema")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func showInGoogleMaps(_ sender: UIButton) {
        UIApplication.shared.open(URL(string:"https://www.google.es/maps/search/cinemas/")!, options: [:], completionHandler: nil)
    }
}

class CinemaPin: NSObject, MKAnnotation {
    
    var title : String?
    var subtitle : String?
    var latitude : Double
    var longitude : Double
    
    var coordinate : CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(lat: Double, long: Double){
        self.latitude = lat
        self.longitude = long
    }
    
}
