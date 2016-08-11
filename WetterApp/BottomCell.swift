import UIKit

class BottomCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var time: UILabel!
    
    var Uhrzeit: String = "" {
        didSet {
            time.text = Uhrzeit
        }
    }
    
    var Temperatur: String = "" {
        didSet {
            temp.text = "\(Temperatur) °C"
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
