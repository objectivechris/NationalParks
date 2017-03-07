//
//  ParkCell.swift
//  National Parks
//
//  Created by Christopher Rene on 3/7/17.
//  Copyright © 2017 Christopher Rene. All rights reserved.
//

import UIKit

class ParkCell: UICollectionViewCell {
    
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet private weak var gradientView: GradientView!
    @IBOutlet private weak var captionLabel: UILabel!
    @IBOutlet weak var checkedImageView: UIImageView!
    
    override func prepareForReuse() {
        parkImageView.image = nil
        captionLabel.text = ""
    }
    
    var park: Park? {
        didSet {
            if let nationalPark = park {
                parkImageView.image = UIImage(named: nationalPark.photo)
                captionLabel.text = nationalPark.photo
            }
        }
    }
    
    var editing: Bool = false {
        didSet {
            captionLabel.isHidden = editing
            checkedImageView.isHidden = !editing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if editing {
                checkedImageView.image = UIImage(named: isSelected ? "Checked" : "Unchecked")
            }
        }
    }
}
