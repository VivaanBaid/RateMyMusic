//
//  music_cell.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 13/06/21.
//

import UIKit

class music_cell: UICollectionViewCell {
    
    
    @IBOutlet weak var play_button: UIButton!
    
    
    
    
    @IBOutlet weak var music_title_label: UILabel!
    
    
    @IBOutlet weak var cell_background_image: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupcell()
    }
    
    func setupcell(){
        self.layer.cornerRadius = 15.0
        self.backgroundColor = UIColor.white
    }
    
}
