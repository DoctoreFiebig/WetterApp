import UIKit

class CityTVC: UITableViewController, UISearchResultsUpdating {

    var allCities: [Country] = []
    var selCities: [Country] = []
    
    var search = UISearchController(searchResultsController: nil)
    var defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAllCities()
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Suche nach Stadt"
        search.searchBar.keyboardAppearance = .Dark
        search.searchBar.searchBarStyle = .Minimal
        search.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = search.searchBar
        self.tableView.delegate = self
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        selCities.removeAll(keepCapacity: false)
        for countrie in allCities {
            var new_Cities: [City] = []
            for c in countrie.cities {
                if c.name.lowercaseString.containsString((searchController.searchBar.text?.lowercaseString)!) {
                    new_Cities.append(c)
                }
            }
            if new_Cities.count >= 1 {
                var coun = Country()
                coun.name = countrie.name
                coun.cities = new_Cities
                selCities.append(coun)
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
   
    
    func setAllCities(){
        allCities.removeAll(keepCapacity: true)
        allCities.append(Country(name: "Deutschland", cities: []))
        allCities.append(Country(name: "Italien", cities: []))
        allCities.append(Country(name: "Frankreich", cities: []))
        allCities.append(Country(name: "Groß Britanien", cities: []))
        allCities.append(Country(name: "Spanien", cities: []))
        allCities.append(Country(name: "USA", cities: []))
        
        let data = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("city", ofType: ".json")!)
        do {
            let jason_data = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSMutableArray
            
            for json_element in jason_data {
                
                if let city = json_element as? NSMutableDictionary {
                    if city["country"] as! String == "DE" || city["country"] as! String == "IT" || city["country"] as! String == "FR" || city["country"] as! String == "GB" || city["country"] as! String == "ES" || city["country"] as! String == "US" {
                        
                        var new_City: City = City()
                        new_City.id = "\(city["_id"]!)"
                        new_City.name = "\(city["name"]!)"
                        let coos = city["coord"] as! NSMutableDictionary
                        new_City.latitude = coos["lat"] as! Double
                        new_City.longitude = coos["lon"] as! Double
                        
                        switch city["country"] as! String {
                        case "DE":
                            self.allCities[0].cities.append(new_City)
                            break
                        case "IT":
                            self.allCities[1].cities.append(new_City)
                            break
                        case "FR":
                            self.allCities[2].cities.append(new_City)
                            break
                        case "GB":
                            self.allCities[3].cities.append(new_City)
                            break
                        case "ES":
                            self.allCities[4].cities.append(new_City)
                            break
                        case "US":
                            self.allCities[5].cities.append(new_City)
                            break
                        default:
                            break
                        }
                    }
                }
            }
            
            self.allCities[0].cities.sortInPlace{$0.name<$1.name}
            self.allCities[1].cities.sortInPlace{$0.name<$1.name}
            self.allCities[2].cities.sortInPlace{$0.name<$1.name}
            self.allCities[3].cities.sortInPlace{$0.name<$1.name}
            self.allCities[4].cities.sortInPlace{$0.name<$1.name}
            self.allCities[5].cities.sortInPlace{$0.name<$1.name}
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })

        }
        catch {
            print("Error with JSON")
        }
    }
    
    
    
    
    
    
    
    
    
    
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if search.active && search.searchBar.text != "" {
            return selCities.count
        }
        else {
            return allCities.count
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if search.active && search.searchBar.text != "" {
            return selCities[section].cities.count
        }
        else {
            return allCities[section].cities.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if search.active && search.searchBar.text != "" {
            cell.textLabel?.text = selCities[indexPath.section].cities[indexPath.row].name
        }
        else {
            cell.textLabel?.text = allCities[indexPath.section].cities[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if search.active && search.searchBar.text != "" {
            return selCities[section].name
        }
        else {
            return allCities[section].name
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var ID: String = ""
        var city: String = ""
        
        if search.active && search.searchBar.text != "" {
            ID = selCities[indexPath.section].cities[indexPath.row].id
            city = selCities[indexPath.section].cities[indexPath.row].name
        }
        else {
            ID = allCities[indexPath.section].cities[indexPath.row].id
            city = allCities[indexPath.section].cities[indexPath.row].name
        }
        
        if ID != "" {
            defaults.setObject(ID, forKey: "CITY_ID")
            let alert = UIAlertController(title: "Gespeichert", message: "Die Wetterstation \"\(city)\" wurde gespeichert.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Fehler", message: "Die Wetterstation konnte nicht gespeichert werden.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "MIST", style: .Destructive, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
    
 
}
