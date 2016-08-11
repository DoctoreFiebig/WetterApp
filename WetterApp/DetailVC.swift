import UIKit
import MapKit

class DetailVC: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var labTime: UILabel!
    @IBOutlet weak var labTemp_max: UILabel!
    @IBOutlet weak var labTemp_min: UILabel!
    @IBOutlet weak var labTemp: UILabel!
    @IBOutlet weak var labBeschreibung: UILabel!
    @IBOutlet weak var labWind: UILabel!
    @IBOutlet weak var labRegen: UILabel!
    @IBOutlet weak var labLuftfeuchte: UILabel!
    @IBOutlet weak var labLuftdruck: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var effectStoringView: UIView!
    
    var wetter: Wetter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effectStoringView.layer.cornerRadius = 20
        effectStoringView.clipsToBounds = true
        map.layer.cornerRadius = 20

        if wetter != nil {
            self.title = wetter!.CityName
            
            var s = (wetter!.UhrZeit).stringByReplacingOccurrencesOfString("(", withString: "Uhr am: ")
            s = s.stringByReplacingOccurrencesOfString(")", withString: "")
            labTime.text = s
            labTemp_min.text = "\(wetter!.Temp_Min) °C"
            labTemp.text = "\(wetter!.Temp_Mean) °C"
            labTemp_max.text = "\(wetter!.Temp_Max) °C"
            labBeschreibung.text = "\(wetter!.Beschreibung)"
            labWind.text = "Wind: \(wetter!.Wind_kmh) km/h (\(wetter!.Wind_Dir))"
            labRegen.text = "Regen: \((wetter!.Regen / 100)) l"
            labLuftfeuchte.text = "Luftfeuchtigkeit: \(wetter!.Feuchtigkeit) %"
            labLuftdruck.text = "Luftdruck: \(wetter!.Luftdruck) kPa"
            
            if let img = UIImage(named: wetter!.WetterGruppe) {
                imgView.image = img
            }
            else {
                imgView.image = UIImage(named: "01d")
            }
            SetMap()
        }
    }
    
    func SetMap() {
        let radius: CLLocationDistance = 25000
        let coordinates = CLLocationCoordinate2D(latitude: wetter!.City_Latitude, longitude: wetter!.City_Longitude)
        let region = MKCoordinateRegionMakeWithDistance(coordinates, radius, radius)
        map.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        pin.title = wetter!.CityName
        map.addAnnotation(pin)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}
