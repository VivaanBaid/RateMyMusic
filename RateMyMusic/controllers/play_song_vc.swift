//
//  play_song_vc.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 18/06/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseUI
import AVFoundation
import JGProgressHUD


class play_song_vc: UIViewController{
    
    let defaults = UserDefaults.standard
    //used lazy var because the intilization of this variable depends on another one
    lazy var my_username = defaults.object(forKey: "MY_USER_NAME_1")!
    lazy var db = Firestore.firestore().collection("users").document(my_username as! String).collection("songs")
    let db_top = Firestore.firestore().collection("top_charts")
    
    
    //audio player
    var player: AVAudioPlayer?
    
    
    @IBOutlet weak var cover_outlet: UIImageView!
    
    
    @IBOutlet weak var song_name_outlet: UILabel!
    
    
    @IBOutlet weak var singer_name_outlet: UILabel!
    
    
    @IBOutlet weak var song_progress_Slider: UISlider!{
        didSet{
            song_progress_Slider.addTarget(self, action: #selector(didBeginDraggingSlider), for: .touchDown)
            song_progress_Slider.addTarget(self, action: #selector(didEndDraggingSlider), for: .valueChanged)
            song_progress_Slider.isContinuous = false
        }
    }
    
    @objc
    func didBeginDraggingSlider() {
        displaylink.isPaused = true
    }
    
    @objc
    func didEndDraggingSlider() {
        guard let player = player else {return}
        let newPosition = player.duration * Double(song_progress_Slider.value)
        player.currentTime = newPosition
        
        displaylink.isPaused = false
    }
    
    
    lazy var displaylink = CADisplayLink(target: self, selector: #selector(self.updateplaybackstatus))
    
    
    @IBOutlet weak var play_button_outlet: UIButton!
    
    @IBOutlet weak var seconds_back_pressed_outlet: UIButton!
    
    
    @IBAction func _seconds_back_pressed(_ sender: Any) {
        DispatchQueue.global().async {
            if self.song_progress_Slider.value != 0.0 {
                
                self.player!.currentTime = self.player!.currentTime-TimeInterval(10)
                self.displaylink.isPaused = false
                    self.seconds_back_pressed_outlet.isEnabled = true
            }else{
                    self.seconds_back_pressed_outlet.isEnabled = false
            }
        }
        
        
    }
    
    @IBAction func seconds_ahead_pressed(_ sender: Any) {
        DispatchQueue.global().async {
            self.player!.currentTime = self.player!.currentTime+TimeInterval(10)
            self.displaylink.isPaused = false
        }
        
    }
    
    
    
    
    @IBAction func play_button_pressed(_ sender: Any) {
        if let player = player, player.isPlaying{
            //stop playback
            play_button_outlet.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            player.pause()
        }else{
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.play_button_outlet.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
                }
                if self.player?.pause() != nil {
                    print("not paused")
                    self.player?.play()
                }else {
                    do{
                        let my_audio = try Data(contentsOf: URL(string: self.audio_URL!)!)
                        try AVAudioSession.sharedInstance().setMode(.default)
                        try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                        self.player = try AVAudioPlayer(data: my_audio)
                        guard let player = self.player else {return}
                        player.play()
                        DispatchQueue.main.async {
                            self.startUpdatingPlaybackStatus()
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                    
                }
            }
            
        }
    }
    
    func startUpdatingPlaybackStatus() {
        displaylink.add(to: .main, forMode: .common)
    }
    
    func stopUpdatingPlaybackStatus() {
        displaylink.invalidate()
    }
    
    @objc
    func updateplaybackstatus(){
        let total_time = self.player!.duration
        let song_time = self.player!.currentTime
        let song_progress_value = Float(song_time/total_time)
        song_progress_Slider.setValue(song_progress_value, animated: true)
    }
    
    
    
    
    
    
    
    @IBOutlet weak var like_button_outlet: UIButton!
    
    
    override func viewDidDisappear(_ animated: Bool) {
        player?.setVolume(0.0, fadeDuration: 2.0)
        
    }
    
    
    
    @IBAction func like_button_pressed(_ sender: Any) {
        if singer_name_outlet.text == my_username as? String{
            let alert = UIAlertController(title: "Oops", message: "You can't like your own songs, someone else will", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { myaction in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }else {
            //writes everything to database
            if like_button_outlet.isSelected == true{
                unliked(likes!, ref: db)
                unliked(likes!, ref: db_top)
                like_button_outlet.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
                
            }else{
                liked(likes!, ref: db)
                liked(likes!, ref: db_top)
                like_button_outlet.setBackgroundImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            }
            
            like_button_outlet.isSelected = !like_button_outlet.isSelected
        }
        
        

    }
    

    
    func liked(_ input: Int, ref: CollectionReference){
        ref.document(id!).updateData(["Likes" :input+1]) { error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                print("Liked")
            }
        }
    }
    
    func unliked(_ input: Int, ref: CollectionReference){
        ref.document(id!).updateData(["Likes" :input-1]) { error in
            if let e = error{
                print(e.localizedDescription)
            }else{
                print("unliked")
            }
        }
    }
    
    //storage
    var id: String?
    var my_name: String?
    var cover_URL: String?
    var audio_URL: String?
    var likes: Int?
    
    override func viewWillAppear(_ animated: Bool) {
      print("appeared")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showHUD()
        
        print("loaded")
        cover_outlet.layer.cornerRadius = 15.0
    }
    
    func getdata(for song: song, completion: @escaping (Bool) -> ()){
        db.whereField("Name", isEqualTo: song.name!).addSnapshotListener { snapshot, error in
            if let e = error {
                print(e.localizedDescription)
                completion(false)
            }else{
                guard let my_data = snapshot?.documents[0].data() else{return}
                self.my_name =  my_data["Name"] as? String ?? "No name"
                self.cover_URL =  my_data["Photo_URL"] as? String ?? "No photo"
                self.audio_URL = my_data["Song_URL"] as? String ?? "No audio"
                self.id = my_data["ID"] as? String ?? "No ID"
                self.likes = my_data["Likes"] as? Int
                if self.likes == 0 {
                    self.likes = 1
                }
                completion(true)
            }
        }
    }
    
    func showHUD(){
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.show(in: self.view)
        hud.tintColor = UIColor(named: "myorange")
        hud.dismiss(afterDelay: 0.5)
        reloadInputViews()
    }
    
    func setupUI(){
        //basically what the username is
        singer_name_outlet.text = self.my_username as? String
        song_name_outlet.text = self.my_name
        cover_outlet.sd_setImage(with: URL(string: self.cover_URL ?? ""))
        
    }
    
}
