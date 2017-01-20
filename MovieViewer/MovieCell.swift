//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Chengjiu Hong on 1/16/17.
//  Copyright © 2017 Chengjiu Hong. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
