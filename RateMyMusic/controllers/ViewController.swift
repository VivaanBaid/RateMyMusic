
import UIKit
import Firebase

class ViewController: UIViewController {

    let defaults = UserDefaults.standard
    lazy var my_username = defaults.object(forKey: "MY_USER_NAME_1")!
    
    
    
    //firestore ref
    lazy var db = Firestore.firestore().collection("users").document(my_username as! String).collection("songs")
    let db_top = Firestore.firestore().collection("top_charts")
    
    
    //table view array
    var main_array = [song]()
    var top_array = [song]()
    var top_10 = [song]()
    
    //collection view array(for top charts)
    
    
    var global_index: Int?
    var global_index2: Int?
    
    @objc func addsong(_sender: UIButton){
        performSegue(withIdentifier: K.addsongsegue, sender: self)
        
    }
    
 
    
    
    @IBOutlet weak var users_song_outlets: UILabel!
    
    
    
    @IBOutlet weak var your_music_table: UITableView!
    
    
    @IBOutlet weak var music_collection_view: UICollectionView!
    
    
    @IBOutlet weak var rounded_view: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        fetchalldata(ref: db) { completed in
            self.your_music_table.reloadData()
            print(self.main_array.count)
        }
        fetchalldata(ref: db_top) { completed in
            self.calculatetopcharts { done in
                self.music_collection_view.reloadData()
            }
        }
       
       
    }
    
    
    
    //storager for top_10
    var photo_URL_storage: String?
    var name_storage: String?
    var audio_URL_storage: String?
    
    //sorting function for top charts based on likes
    
    func calculatetopcharts(completion: @escaping (Bool) -> ()){
        db_top.whereField("Likes", isGreaterThan: 0).addSnapshotListener { snapshot, error in
            self.top_10 = []
            if let e = error{
                print(e.localizedDescription)
            }else {
                guard let my_snapshot = snapshot else { return}
                for document in my_snapshot.documents{
                      let my_data = document.data()
                       self.name_storage = my_data["Name"] as? String
                       self.photo_URL_storage = my_data["Photo_URL"] as? String
                       self.audio_URL_storage = my_data["Song_URL"] as? String
                       let my_song = song(name: self.name_storage, cover_photo_URL: self.photo_URL_storage, audio_file_URL: self.audio_URL_storage)
                       self.top_10.append(my_song)
                       completion(true)
            
                }
                
            }
        }
    }
    
    
    func fetchalldata(ref: CollectionReference, completion: @escaping (Bool) -> ()){
        ref.addSnapshotListener { snapshot, error in
            if let e = error{
                print(e.localizedDescription)
                completion(false)
            }else{
                if ref == self.db{
                    self.main_array = []
                }else{
                    self.top_array = []
                }
                guard let my_snapshot = snapshot else {return}
                for document in my_snapshot.documents{
                        let my_data = document.data()
                        let my_name =  my_data["Name"] as? String ?? "No name"
                        let cover_URL =  my_data["Photo_URL"] as? String ?? "No photo"
                        let audio_URL = my_data["Song_URL"] as? String ?? "No audio"
                        
                        let my_song = song(name: my_name, cover_photo_URL: cover_URL, audio_file_URL: audio_URL)
                            if ref == self.db{
                                self.main_array.append(my_song)
                            }else{
                                self.top_array.append(my_song)
                            }
                            print("fetched data")
                            completion(true)
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        users_song_outlets.text = "\(my_username)'s songs"
        
        
        
        //hides navigation bar here
        let navbar = UINavigationBar()
        navbar.isHidden = true
        
        
        //registering tableview XIB
        let nib = UINib.init(nibName: "your_music-cell", bundle: nil)
        your_music_table.register(nib, forCellReuseIdentifier: K.usermusiccell)
        
        print(main_array.count)
        print(top_array.count)
        //delegates and data sources
        music_collection_view.delegate = self
        music_collection_view.dataSource = self
        your_music_table.dataSource = self
        your_music_table.delegate = self
        // Do any additional setup after loading the view.
        rounded_view.layer.cornerRadius = 60.0
        rounded_view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        music_collection_view.backgroundColor = UIColor.clear
        
     
        
    }
    
    //MARK:- Sets Up Middle Button
    
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 50
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame
        
        menuButton.backgroundColor = UIColor(named: "myorange")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        
        menuButton.tintColor = UIColor.white
        
        menuButton.setImage(UIImage(systemName: "plus"), for: .normal)
        menuButton.addTarget(self, action: #selector(self.addsong(_sender:)), for: .touchUpInside)
        view.layoutIfNeeded()
    }
    
    
    

    
    
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(top_10.count)
        return top_10.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectcell = collectionView.dequeueReusableCell(withReuseIdentifier: K.mymusiccellidentifier, for: indexPath) as! music_cell
        if top_10.isEmpty{
            print("empty right now")
            return collectcell
        }else{
            collectcell.music_title_label.text = top_10[indexPath.row].name
            collectcell.cell_background_image.sd_setImage(with: URL(string: top_10[indexPath.row].cover_photo_URL!))
            return collectcell
        }
    }
    
    
    
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        global_index2 = indexPath.row
        self.performSegue(withIdentifier: K.collectiontoplaysong, sender: self)
    }
    
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return main_array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.usermusiccell) as! your_music_cell
        if main_array.isEmpty {
            print("empty right now")
            return cell
        }else{
           cell.song_name.text = main_array[indexPath.row].name
           cell.cover_image.sd_setImage(with: URL(string: main_array[indexPath.row].cover_photo_URL!))
           return cell
        }
        
       
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        global_index = indexPath.row
        self.performSegue(withIdentifier: K.hometoplaysongsegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.hometoplaysongsegue{
            let upcoming_vc = segue.destination as! play_song_vc
            upcoming_vc.getdata(for: main_array[global_index!]) { completed in
                upcoming_vc.setupUI()
            }
        }
        if segue.identifier == K.collectiontoplaysong{
            let upcoming_vc = segue.destination as! play_song_vc
            upcoming_vc.getdata(for: top_10[global_index2!]) { completed in
                upcoming_vc.setupUI()
            }
        }
        
        
    }
    
}





