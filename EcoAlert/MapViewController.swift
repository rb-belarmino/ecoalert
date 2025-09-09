import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var addressTextView: UITextView!
	
	let locationManager = CLLocationManager()
	let geocoder = CLGeocoder()
	let weatherAPIKey = "4e71bb9338f9f50d40bd0ccc4bc2fecf"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		mapView.showsUserLocation = true
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
		mapView.addGestureRecognizer(tapGesture)
		addressTextView.isHidden = true
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
			mapView.setRegion(region, animated: true)
			locationManager.stopUpdatingLocation()
		}
	}
	
	@objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
		let point = gestureRecognizer.location(in: mapView)
		let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
		let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
		
		geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
			guard let self = self, let placemark = placemarks?.first else { return }
			let address = [
				placemark.thoroughfare,
				placemark.subThoroughfare,
				placemark.locality,
				placemark.administrativeArea,
			].compactMap{$0}.joined(separator: ",")
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = address.isEmpty ? "Local Desconhecido" : address
			self.mapView.addAnnotation(annotation)
			
			self.fetchWeather(lat: coordinate.latitude, lon: coordinate.longitude) { weatherText in
				DispatchQueue.main.async {
					let attachment = NSTextAttachment()
					attachment.image = UIImage(named: "mapPin")
					attachment.bounds = CGRect(x: 0, y: -4, width: 20, height: 20)
					
					let attachedString = NSMutableAttributedString(attachment: attachment)
					let addressString = NSMutableAttributedString(string: " " + (address.isEmpty ? "Endereço Desconhecido" : address))
					let weatherString = NSMutableAttributedString(string: "\n\(weatherText)")
					
					let completeText = NSMutableAttributedString()
					completeText.append(attachedString)
					completeText.append(addressString)
					completeText.append(weatherString)
					
					self.addressTextView.attributedText = completeText
					self.addressTextView.isHidden = false
				}
			}
		}
	}
	
	func fetchWeather(lat: Double, lon: Double, completion: @escaping (String) -> Void) {
		let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(weatherAPIKey)&units=metric&lang=pt_br"
		guard let url = URL(string: urlString) else {
			completion("Clima indisponível")
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data,
				  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				  let main = json["main"] as? [String: Any],
				  let temp = main["temp"] as? Double,
				  let weatherArray = json["weather"] as? [[String: Any]],
				  let weather = weatherArray.first,
				  let description = weather["description"] as? String else {
				completion("Clima indisponível")
				return
			}
			
			let weatherText = "Clima: \(description.capitalized), \(Int(temp))°C"
			completion(weatherText)
		}
		task.resume()
	}
	
	func addMakers(){
		let locations = [
			("Ponto de Coleta 1", CLLocationCoordinate2D(latitude: -23.55052, longitude: -46.633308)),
			("Ponto de Coleta 2", CLLocationCoordinate2D(latitude: -23.55152, longitude: -46.634308)),
			("Ponto de Coleta 3", CLLocationCoordinate2D(latitude: -23.55252, longitude: -46.635308))
		]
		
		for (title, coordinate) in locations {
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = title
			mapView.addAnnotation(annotation)
		}
	}
	
	@IBAction func forwardButton(_ sender: UIBarButtonItem) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let datasVC = storyboard.instantiateViewController(withIdentifier: "DatasViewController") as? DatasViewController {
			datasVC.receivedTextFromMaps = addressTextView.attributedText
			self.navigationController?.pushViewController(datasVC, animated: true)
		}
	}
}
