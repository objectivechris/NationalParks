//
//  DetailViewController.swift
//  National Parks
//
//  Created by Christopher Rene on 3/7/17.
//  Copyright © 2017 Christopher Rene. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate weak var nameLabel: UILabel!
    @IBOutlet fileprivate weak var stateLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    
    var park: Park?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let nationalPark = park {
            navigationItem.title = nationalPark.name
            imageView.image = UIImage(named: nationalPark.photo)
            nameLabel.text = nationalPark.name
            stateLabel.text = nationalPark.state
            dateLabel.text = nationalPark.date
        }
    }
}
