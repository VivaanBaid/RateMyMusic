//
//  profile_picture.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 13/06/21.
//

import UIKit

class profile_picture: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        makecircular()
        
    }
    
    func makecircular(){
        self.layer.cornerRadius = self.frame.width/2
    }

}
