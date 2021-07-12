//
//  song.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 13/06/21.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import FirebaseUI

struct song: Codable {
    @DocumentID var id = UUID().uuidString
    var name: String?
    var cover_photo_URL: String?
    var likes: Int = 0
    var audio_file_URL: String?
    var Username: String?
    
    
    
}
