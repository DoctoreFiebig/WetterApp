import Foundation


struct City {
    var name: String = ""
    var id: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
}

struct Country {
    var name: String = ""
    var cities: [City] = []
}

struct Wetter {
    var CityName: String = ""
    var City_Latitude: Double = 0
    var City_Longitude: Double = 0
    var UhrZeit: String = ""
    var Temp_Mean: Double = 0
    var Temp_Min: Double = 0
    var Temp_Max: Double = 0
    var Feuchtigkeit: Int = 0
    var Luftdruck: Int = 0
    var Wind_kmh: Double = 0
    var Wind_Dir: String = ""
    var Regen: Int = 0
    var Beschreibung: String = ""
    var WetterGruppe: String = ""
}
