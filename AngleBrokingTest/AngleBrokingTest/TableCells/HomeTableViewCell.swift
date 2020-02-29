//
//  HomeTableViewCell.swift
//  AngleBrokingTest
//
//  Created by A1Technology on 2/29/20.
//  Copyright © 2020 vinit.somani. All rights reserved.
//

import UIKit
import SDWebImage


class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var userImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func populateData(item: User) {
        self.titleLabel.text = item.display_name
        
        guard let urlString = item.avatar_url else {
            return
        }
        if let url = URL.init(string: urlString) {
            userImage.sd_setImage(with: url) { (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
            }
        }
    }
}

