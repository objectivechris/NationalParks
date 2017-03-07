//
//  SectionHeaderView.swift
//  National Parks
//
//  Created by Christopher Rene on 3/7/17.
//  Copyright © 2017 Christopher Rene. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }
}
