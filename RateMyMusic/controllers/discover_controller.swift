//
//  discover_controller.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 23/06/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI

class discover_controller: UIViewController{
    
    //reference to the top_charts collection which stores all the songs
    let db_top = Firestore.firestore().collection("top_charts")
    
    var my_display_array = [song]()
    var global_index: Int = 0
    
    
    //storage
    var Photo_URL: String?
    var song_URL: String?
    var Username: String?
    var song_name: String?
    
    
    @IBOutlet weak var display_music_collection_view: UICollectionView!
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        searchbar.showsCancelButton = true
        searchbar.placeholder = "Search by Singer Name"
        display_music_collection_view.dataSource = self
        display_music_collection_view.delegate = self
        
    }
}

extension discover_controller: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchbar.text != nil{
            fetchdata(for: searchbar.text ?? "No text")
            searchbar.resignFirstResponder()
        }else {
            my_display_array = []
            searchbar.resignFirstResponder()
        }
  
    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        fetchdata(for: searchbar.text ?? "No text")
//    }
    
}

extension discover_controller: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        global_index = indexPath.row
        self.performSegue(withIdentifier: K.discovetoplaysegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.discovetoplaysegue{
            let upcoming_vc = segue.destination as! play_song_vc
            upcoming_vc.getdata(for: my_display_array[global_index]) { finished in
                upcoming_vc.setupUI()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("clicked")
        self.my_display_array = []
        display_music_collection_view.reloadData()
        searchbar.resignFirstResponder()
    }
}

extension discover_controller: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return my_display_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "generalcollection", for: indexPath) as! Display_music_cell
        cell.setupcell()
        cell.cover_page_photo.sd_setImage(with: URL(string: my_display_array[indexPath.row].cover_photo_URL!), completed: nil)
        cell.title.text = my_display_array[indexPath.row].name
        return cell
    }
    
    
    func fetchdata(for searchmaterial: String){
        db_top.whereField("Username", isEqualTo: searchmaterial).addSnapshotListener { snapshot, error in
            self.my_display_array = []
            if let e = error {
                print(e.localizedDescription)
            }else{
                DispatchQueue.global(qos: .userInteractive).async {
                    
                    guard let snapshot = snapshot else {return}
                    for document in snapshot.documents{
                        let my_data = document.data()
                        if my_data["Song_URL"] != nil {
                            self.Photo_URL = my_data["Photo_URL"] as? String
                            self.song_URL = my_data["Song_URL"] as? String
                            self.Username = my_data["Username"] as? String
                            self.song_name = my_data["Name"] as? String
                            let my_song = song(name: self.song_name, cover_photo_URL: self.Photo_URL, audio_file_URL: self.song_URL, Username: self.Username)
                            self.my_display_array.append(my_song)
                            DispatchQueue.main.async {
                                self.display_music_collection_view.reloadData()
                            }
                        }else {
                            self.my_display_array = []
                            self.display_music_collection_view.reloadData()
                        }
                       
                        
                    }
                }
            }
        }
    }
    
    
}
