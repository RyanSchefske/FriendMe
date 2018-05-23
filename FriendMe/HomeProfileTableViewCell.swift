//
//  HomeProfileTableViewCell.swift
//  FriendHub
//
//  Created by Ryan Schefske on 3/13/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit

class HomeProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// Allows CollectionView to be handled in HomeTableViewController

extension HomeProfileTableViewCell {
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDelegate & UICollectionViewDataSource>
        (_ dataSourceDelegate: D, forRow row: Int)
    {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        
        collectionView.reloadData()
    }
}




