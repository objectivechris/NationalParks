//
//  MasterViewController.swift
//  National Parks
//
//  Created by Christopher Rene on 3/7/17.
//  Copyright © 2017 Christopher Rene. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {
    fileprivate var parksDataSource = ParksDataSource()
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = collectionView!.frame.width / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionHeadersPinToVisibleBounds = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MasterViewController.refreshControlDidFire), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        navigationItem.leftBarButtonItem = editButtonItem
        
        navigationController!.isToolbarHidden = true
        self.installsStandardGestureForInteractiveMovement = true
    }
    
    func refreshControlDidFire() {
        addButtonTapped(nil)
        collectionView?.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.park =  sender as? Park
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem?) {
        let indexPath = parksDataSource.indexPathForNewRandomPark()
        let layout = collectionViewLayout as! ParksViewFlowLayout
        layout.appearingIndexPath = indexPath
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations: {
            self.collectionView!.insertItems(at: [indexPath])
        }, completion: { (finished: Bool) -> Void in
            layout.appearingIndexPath = nil
        })
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIBarButtonItem) {
        let indexPaths = collectionView!.indexPathsForSelectedItems!
        let layout = collectionViewLayout as! ParksViewFlowLayout
        layout.disappearingItemsIndexPaths = indexPaths
        parksDataSource.deleteItemsAtIndexPaths(indexPaths)
        
        UIView.animate(withDuration: 0.65, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.collectionView!.deleteItems(at: indexPaths)
        }) { (finished: Bool) in
            layout.disappearingItemsIndexPaths = nil
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        addButton.isEnabled = !editing
        collectionView!.allowsMultipleSelection = editing
        let indexPaths = collectionView!.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            collectionView!.deselectItem(at: indexPath, animated: false)
            let cell = collectionView!.cellForItem(at: indexPath) as? ParkCell
            cell!.editing = editing
        }
        
        if !editing {
            navigationController!.setToolbarHidden(true, animated: animated)
        }
    }
}

extension MasterViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return parksDataSource.numberOfSections
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parksDataSource.numberOfParksInSection(section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderView
        
        if let title = parksDataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeaderView.title = title
            sectionHeaderView.icon = UIImage(named: title)
        }
        
        return sectionHeaderView
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParkCell", for: indexPath) as! ParkCell
        
        if let park = parksDataSource.parkForItemAtIndexPath(indexPath) {
            cell.park = park
            cell.editing = isEditing
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            if let nationalPark = parksDataSource.parkForItemAtIndexPath(indexPath) {
                performSegue(withIdentifier: "MasterToDetail", sender: nationalPark)
            }
        } else {
            navigationController!.setToolbarHidden(false, animated: true)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if collectionView.indexPathsForSelectedItems!.count == 0 {
                navigationController?.setToolbarHidden(true, animated: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        parksDataSource.moveParkAtIndexPath(sourceIndexPath, toIndexPath: destinationIndexPath)
    }
}
