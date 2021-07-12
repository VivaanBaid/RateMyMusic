//
//  your_music-cell.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 13/06/21.
//

import UIKit

class your_music_cell: UITableViewCell {

    
    
    @IBOutlet weak var cover_image: UIImageView!
    
    @IBOutlet weak var song_name: UILabel!
    
    
    @IBOutlet weak var artist_name: UILabel!
    
    
    @IBOutlet weak var song_time: UILabel!
    
  
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    
    override func layoutSubviews() {
        cover_image.layer.cornerRadius = 15.0
        
    }
    
}
