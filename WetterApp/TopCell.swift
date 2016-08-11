import UIKit

class TopCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var ort: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var discrip: UILabel!
    
    var Temperatur: String = "" {
        didSet {
            temp.text = "\(Temperatur) ° C"
        }
    }
    
    var AktuellerOrt: String = "" {
        didSet {
            ort.text = AktuellerOrt
        }
    }
    
    var Beschreibung: String = "" {
        didSet {
            discrip.text = Beschreibung
        }
    }
    
    var Bild: UIImage = UIImage(named: "01d")! {
        didSet {
            img.image = Bild
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
