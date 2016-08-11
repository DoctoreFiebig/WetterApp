import UIKit

class MainTVC: UITableViewController {

    var wetter: [Wetter] = []
    var city_id: String = ""
    var defaults = NSUserDefaults.standardUserDefaults()
    var updater = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        updater.attributedTitle = NSAttributedString(string: "Aktuelles Wetter Laden")
        updater.tintColor = self.navigationController?.navigationBar.barTintColor
        updater.addTarget(self, action: #selector(loadWeather), forControlEvents: .ValueChanged)
        self.tableView.addSubview(updater)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ID = defaults.objectForKey("CITY_ID") as? String {
            city_id = ID
        }
        else {
            defaults.setObject("2950159", forKey: "CITY_ID")
            city_id = "2950159"
        }
        loadWeather()
    }
    
    func loadWeather(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            self.wetter = WetterVorhersage.VorhersageByCityID(City_ID: self.city_id)
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
                if self.updater.refreshing {
                    self.updater.endRefreshing()
                }
            })
        }
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wetter.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Wetter heute
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("top_cell", forIndexPath: indexPath) as! TopCell
            
            cell.Temperatur = "\(wetter[indexPath.row].Temp_Mean)"
            if let image = UIImage(named: wetter[indexPath.row].WetterGruppe) {
                cell.Bild = image
            }
            else {
                cell.Bild = UIImage(named: "01d")!
            }
            cell.AktuellerOrt = wetter[indexPath.row].CityName
            cell.Beschreibung = wetter[indexPath.row].Beschreibung
            
            return cell
        }
        
        //WetterVorhersage
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("under_cell", forIndexPath: indexPath) as! BottomCell
            
            cell.Temperatur = "\(wetter[indexPath.row].Temp_Mean)"
            cell.Uhrzeit = "\(wetter[indexPath.row].UhrZeit)"
            if let image = UIImage(named: wetter[indexPath.row].WetterGruppe) {
                cell.Bild = image
            }
            else {
                cell.Bild = UIImage(named: "01d")!
            }

            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 115
        }
            
        //WetterVorhersage
        else {
            return 80
        }

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "show_detail1" || segue.identifier == "show_detail2" {
            let vc = segue.destinationViewController as! DetailVC
            if let cell = sender as? UITableViewCell {
                if let indexPath = self.tableView.indexPathForCell(cell) {
                    vc.wetter = wetter[(indexPath.row)]
                }
            }
            
        }
    }
    

    
}
