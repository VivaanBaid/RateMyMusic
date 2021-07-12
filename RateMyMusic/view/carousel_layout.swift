//
//  carousel_layout.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 13/06/21.
//

import UIKit

class carousel_layout: UICollectionViewFlowLayout {

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup(){
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 206, height: 317)
        layout.minimumInteritemSpacing = 40
        layout.minimumLineSpacing = 70
        layout.scrollDirection = .horizontal
    }
}
