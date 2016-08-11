import Foundation

class WetterVorhersage: NSObject {
    
    
    class func VorhersageByCityID(City_ID id: String)-> [Wetter] {
        
        //Bitte für den API_Key EUREN Key einfügen
        //Sonst functioniert das Programm nicht!!!
        let API_Key: String = "Hier euren Key einfügen!"
        let today_url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?id=\(id)&lang=de&APPID=\(API_Key)")
        let forecast_url = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?id=\(id)&lang=de&APPID=\(API_Key)")
        
        var wetter: [Wetter] = []
        wetter.append(WetterHeute(today_url!))
        WetterVorhersage(forecast_url!, wetter: &wetter)
        
        return wetter
    }
    
    
    
    
    
    
    
    
    //Heute
    private class func WetterHeute(url: NSURL)->Wetter {
        var wetter: Wetter = Wetter()
        
        do {
            let data = NSData(contentsOfURL: url)!
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSMutableDictionary
            
            if let coo = json["coord"] as? NSMutableDictionary {
                if let r = coo["lat"] as? Double {
                    wetter.City_Latitude = r
                }
                if let r = coo["lon"] as? Double {
                    wetter.City_Longitude = r
                }
            }
            
            if let name = json["name"] as? String {
                wetter.CityName = name
            }
            
            wetter.UhrZeit = "Heute"
            
            if let weth = json["weather"] as? NSMutableArray {
                if let wet = weth[0] as? NSMutableDictionary {
                    if let r = wet["description"] as? String {
                        wetter.Beschreibung = r
                    }
                    if let r = wet["icon"] as? String {
                        wetter.WetterGruppe = r
                    }
                }
            }
            
            if let main = json["main"] as? NSMutableDictionary {
                if let r = main["humidity"] as? Int {
                    wetter.Feuchtigkeit = r
                }
                if let r = main["pressure"] as? Int {
                    wetter.Luftdruck = r
                }
                if let r = main["temp"] as? Double {
                    wetter.Temp_Mean = K_zu_C(r)
                }
                if let r = main["temp_min"] as? Double {
                    wetter.Temp_Min = K_zu_C(r)
                }
                if let r = main["temp_max"] as? Double {
                    wetter.Temp_Max = K_zu_C(r)
                }
            }
            
            if let wind = json["wind"] as? NSMutableDictionary {
                if let r = wind["deg"] as? Int {
                    wetter.Wind_Dir = Deg_zu_String(r)
                }
                if let r = wind["speed"] as? Double {
                    wetter.Wind_kmh = Rnd(r)
                }
            }
            
            if let rain = json["rain"] as? NSMutableDictionary {
                if let r = rain["1h"] as? Double {
                    wetter.Regen = Percent_From_Ratio(r)
                }
            }
        }
        
        catch {
            print("Failed loading Wether Today")
        }
        
        return wetter
    }
    
    
    
    
    
    
    
    
    
    
    
    //Vorhersage
    private class func WetterVorhersage(url: NSURL, inout wetter: [Wetter]){
        do {
            var name: String = ""
            var lat: Double = 0
            var lon: Double = 0
            
            let data = NSData(contentsOfURL: url)!
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! NSMutableDictionary
            
            //Get general Infos
            if let city = json["city"] as? NSMutableDictionary {
                if let r = city["name"] as? String {
                    name = r
                }
                if let coo = city["coord"] as? NSMutableDictionary {
                    if let r = coo["lat"] as? Double {
                        lat = r
                    }
                    if let r = coo["lon"] as? Double {
                        lon = r
                    }
                }
            }
            
            //Loop through Forecast-Items
            if let list = json["list"] as? NSMutableArray {
                for item in list {
                    
                    if item is NSMutableDictionary {
                        
                        var w: Wetter = Wetter()
                        w.City_Latitude = lat
                        w.City_Longitude = lon
                        w.CityName = name
                        
                        if let dt = item["dt_txt"] as? String {
                            w.UhrZeit = GetDateFormat(dt)
                        }
                        
                        if let main = item["main"] as? NSMutableDictionary {
                            if let r = main["humidity"] as? Int {
                                w.Feuchtigkeit = r
                            }
                            if let r = main["pressure"] as? Int {
                                w.Luftdruck = r
                            }
                            if let r = main["temp"] as? Double {
                                w.Temp_Mean = K_zu_C(r)
                            }
                            if let r = main["temp_min"] as? Double {
                                w.Temp_Min = K_zu_C(r)
                            }
                            if let r = main["temp_max"] as? Double {
                                w.Temp_Max = K_zu_C(r)
                            }
                        }
                        
                        if let weth = item["weather"] as? NSMutableArray {
                            if let wet = weth[0] as? NSMutableDictionary {
                                if let r = wet["description"] as? String {
                                    w.Beschreibung = r
                                }
                                if let r = wet["icon"] as? String {
                                    w.WetterGruppe = r
                                }
                            }
                        }
                        
                        if let wind = item["wind"] as? NSMutableDictionary {
                            if let r = wind["deg"] as? Int {
                                w.Wind_Dir = Deg_zu_String(r)
                            }
                            if let r = wind["speed"] as? Double {
                                w.Wind_kmh = Rnd(r)
                            }
                        }
                        
                        if let rain = item["rain"] as? NSMutableDictionary {
                            if let r = rain["3h"] as? Double {
                                w.Regen = Percent_From_Ratio(r)
                            }
                        }
                        wetter.append(w)
                    }
                }
            }

        }
        catch {
            print("Failed Loading WetherForecast")
        }
    }
    
    
    
    
    
    
    
    
    
    private class func GetDateFormat(s: String)->String {
        let dF = NSDateFormatter()
        //2016-08-13 21:00:00
        dF.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dF.dateFromString(s)
        let df_Reward = NSDateFormatter()
        df_Reward.dateFormat = "HH:mm (dd.MM)"
        if date != nil {
            return df_Reward.stringFromDate(date!)
        }
        else {
            return ""
        }
    }
    
    
    
    
    
    
    
    
    private class func K_zu_C(k: Double)->Double {
        return Rnd(k - 273.15)
    }
    
    private class func Deg_zu_String(w: Int)->String {
        var s: String = ""
        
        if w >= 338 && w < 22 {
            s = "N"
        }
        else if w >= 22 && w < 67 {
            s = "NO"
        }
        else if w >= 67 && w < 112 {
            s = "O"
        }
        else if w >= 112 && w < 157 {
            s = "SO"
        }
        else if w >= 157 && w < 202 {
            s = "S"
        }
        else if w >= 202 && w < 247 {
            s = "SW"
        }
        else if w >= 247 && w < 292 {
            s = "W"
        }
        else if w >= 292 && w < 338 {
            s = "NW"
        }
   
        return s
    }
    
    private class func Rnd(d: Double)->Double {
        return Double(round(10*d) / 10)
    }
    
    private class func Percent_From_Ratio(r: Double)->Int {
        var res = round(r*100)
        res = Rnd(res)
        return Int(res)
    }
    
    
    
    
}