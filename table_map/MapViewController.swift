//
//  MapViewController.swift
//  table_map
//
//  Created by Sultan Kubentayev on 08/09/2024.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let button = UIButton(type: .system)
    let locationManager = CLLocationManager()
    var userLocation = CLLocation() //latitude: 43.242664, longitude: 76.955664
    var followMe = false
    var previousRoute: MKPolyline?  // Переменная для хранения текущего маршрута
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    // Создаем лейбл для отображения расстояния
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Distance: 0 km" // Начальное значение
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7) // Полупрозрачный черный фон
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1)
        
        // Добавляем карту на экран
        view.addSubview(mapView)
        
        // Настраиваем ограничения
        setupViews()
        setupConstraints()
        
        // Дополнительные настройки карты
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        
        // Устанавливаем делегаты
        mapView.delegate = self
        locationManager.delegate = self
        
        // Отображаем местоположение
        displayLocationOnMap()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // Добавляем обработчик для кнопки
        button.addTarget(self, action: #selector(showMyLocation(_:)), for: .touchUpInside)
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        
        longPress.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPress)
        mapView.delegate = self

    }
    
    func setupViews(){
        view.backgroundColor = UIColor(red: 55/255, green: 55/255, blue: 55/255, alpha: 1)
        view.addSubview(mapView)
        
        // Настройка кнопки
        button.setTitle("My Location", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10

        // Добавляем кнопку на view
        view.addSubview(button)
        view.addSubview(distanceLabel)
    }
    
    func setupConstraints(){
        mapView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(30)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }   
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(30)
            make.left.equalToSuperview().inset(30)
        }
    }
    
    func displayLocationOnMap() {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        print(userLocation)

    }
    
    @objc func showMyLocation(_ sender: UIButton){
        followMe.toggle()
        
        if followMe{
            let latDelta : CLLocationDegrees = 0.01
            let longDelta : CLLocationDegrees = 0.01
            
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            
            let region = MKCoordinateRegion(center: userLocation.coordinate, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func longPressAction (gestureRecognizer: UIGestureRecognizer) {
        print("gestureRecognizer")
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        
        let newCoor: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = newCoor
        
        anotation.title = "Title"
        anotation.subtitle = "subtitle"
        
        mapView.addAnnotation(anotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.title)
        
        let location: CLLocation = CLLocation(
            latitude: (view.annotation?.coordinate.latitude)!,
            longitude: (view.annotation?.coordinate.longitude)!
        )
        
        let meters : CLLocationDistance = location.distance(from: userLocation)
        distanceLabel.text = String(format: "Distance: %.2f m", meters)
        
        let sourceLocation = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        
        let destinationLocation = CLLocationCoordinate2D(
            latitude: (view.annotation?.coordinate.latitude)!,
            longitude: (view.annotation?.coordinate.longitude)!
        )
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate{
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            // Удаляем предыдущий маршрут перед добавлением нового
            if let previousRoute = self.previousRoute {
                self.mapView.removeOverlay(previousRoute)
            }
            
            
            let route = response.routes[0]
            self.previousRoute = route.polyline  // Сохраняем новый маршрут
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.systemGreen
        renderer.lineWidth = 4.0
        
        return renderer
    }
}
