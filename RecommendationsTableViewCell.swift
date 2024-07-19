//
//  RecommendationsTableViewCell.swift
//  BitcampA
//
//  Created by Chiraag Nadig on 4/20/24.
//

import UIKit

class RecommendationsTableViewCell: UITableViewCell {

    @IBOutlet var headerText: UILabel!
    
    @IBOutlet var subText: UILabel!
    
    
    @IBOutlet var imageView1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
