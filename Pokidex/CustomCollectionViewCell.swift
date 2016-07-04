//
//  CustomCollectionViewCell.swift
//  Pokidex
//
//  Created by Ali Akkawi on 7/1/16.
//  Copyright © 2016 Ali Akkawi. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var pokimonImage: UIImageView!
    
    @IBOutlet weak var pokimonNameLabel: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // make rounded corneres.
        
        layer.cornerRadius = 5.0
    }
}
