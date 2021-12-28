//
//  QuestionTableViewCell.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 24/12/21.
//

import UIKit
import SwiftyJSON
class QuestionTableViewCell: UITableViewCell {


    @IBOutlet weak var singerLabel: UILabel!
    var artistData = JSON()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
