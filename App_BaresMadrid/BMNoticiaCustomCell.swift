//
//  BMNoticiaCustomCell.swift
//  App_BaresMadrid
//
//  Created by formador on 6/3/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

class BMNoticiaCustomCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet weak var myIMagenNoticia: UIImageView!
    @IBOutlet weak var myTituloNoticiaLBL: UILabel!
    @IBOutlet weak var myThumbnailNoticia: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
