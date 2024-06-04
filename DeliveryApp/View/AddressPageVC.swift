//
//  AddressPageVC.swift
//  DeliveryApp
//
//  Created by Rabia Abdioğlu on 4.06.2024.
//
import Foundation
import UIKit
import SnapKit
import MapKit

class AddressPageVC: UIViewController {

    private var backButton: UIButton!
    private var pageTitleLabel: UILabel!
    private var headerLabel: UILabel!
    private var mapView: MKMapView!
    
    var viewModel = BasketViewModel()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupHeader()
        setupMap()
        checkLocationServices()
    }
    
    
    private func setupHeader() {
        pageTitleLabel = UILabel()
        pageTitleLabel.text = "Address"
        pageTitleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        pageTitleLabel.textColor = .clrDarkGray
        
        view.addSubview(pageTitleLabel)
        pageTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            
        }
        backButton = UIButton()
        backButton.setImage(UIImage(systemName: "chevron.left")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        backButton.backgroundColor = .lightGray.withAlphaComponent(0.4)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 10
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(pageTitleLabel.snp.centerY)
            make.width.height.equalTo(40)
        }
        

    }
    
    private func setupMap() {
        mapView = MKMapView()
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.top.equalTo(pageTitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                mapView.showsUserLocation = true
            default:
                // Handle case where location authorization is denied
                print("Location services are denied")
            }
        } else {
            // Handle case where location services are disabled
            print("Location services are disabled")
        }
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
//        if gestureRecognizer.state == .began {
//            let locationPoint = gestureRecognizer.location(in: mapView)
//            let coordinates = mapView.convert(locationPoint, toCoordinateSpace: MKCoordinateSpace.world)
//
//            // Add an annotation (optional)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinates
//            annotation.title = "Selected Location"
//            mapView.addAnnotation(annotation)
//            
//            // Print the coordinates
//            print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
//        }
    }
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension AddressPageVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
}
