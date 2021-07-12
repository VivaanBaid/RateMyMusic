//
//  addsong_vc.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 13/06/21.
//

import Foundation
import UIKit
import JGProgressHUD
import Firebase
import FirebaseFirestoreSwift
import MediaPlayer
import MobileCoreServices
import UniformTypeIdentifiers

class addsong_vc: UIViewController{
    
    
    let defaults = UserDefaults.standard
    lazy var my_username = defaults.object(forKey: "MY_USER_NAME_1")!
    
    //MARK:- All variables, outlets, actions
    
    var song_URL_Storage: URL?
    var song_Cover_storage_URL: URL?
    
    //firestore ref
    lazy var db = Firestore.firestore().collection("users").document(my_username as! String).collection("songs")

    
    let db_top = Firestore.firestore().collection("top_charts")
    
    
    //firebase storage ref for the song added
    
    let song_storage_ref = Storage.storage().reference().child("songs")
    
    //firebase storage ref for the song cover added
    let song_cover_storage_ref = Storage.storage().reference().child("Song_Covers")
    
    //firebase storage song_cover location
    var cover_download_destination: String?
    
    //firebase storage song location
    var download_destination: String?
    
    //all the properties of a song
    var song_name: String?
    
    @IBOutlet weak var publish_button_outlet: UIButton!
    
    
    @IBOutlet weak var songname_txt_field: UITextField!
    
    
    
    @IBOutlet weak var add_cover_photo_button_outlet: UIButton!
    
    
    
    @IBAction func add_cover_photo_pressed(_ sender: Any)
    {
        showimagepicker()
        
        
    }
    

    
    
    @IBAction func cancel_pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
//        let alert = UIAlertController(title: "Attention!", message: "Changes will not be saved", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Okay", style: .cancel) { myalert in
//            alert.dismiss(animated: true, completion: nil)
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- When Published is pressed
    @IBAction func publish_pressed(_ sender: Any) {
        if song_uploaded_progress.progress == 1.0 && songname_txt_field.text != nil {
            
            print("Published")
            self.savedataToDataBase()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
         
            
        }else{
            let alert = UIAlertController(title: "oops", message: "Please Fill in all the required fields first!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default) { myalertaction in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
    @IBAction func upload_song_pressed(_ sender: Any) {
        //enables you to pick MP3 files only
        showdocumentpicker()
        
    }
    
    
    
    @IBOutlet weak var song_uploaded_progress: UIProgressView!
    
    @IBOutlet weak var upload_song_outlet: UIButton!
    
    
    @IBOutlet weak var cover_photo_display: UIImageView!
    
    
    
    //MARK:- ViewWillDisappear
    
    


    
    
    
    //MARK:- ViewDidLoad
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates and data sources
        songname_txt_field.delegate = self
        
        
        //gives corner radius etc.
        setupUi()
        
        //shows user alert, the first time this VC is opened up
        presentalert()
        song_uploaded_progress.progress = 0.0
    }
    
    
    
    func setupUi(){
        cover_photo_display.layer.cornerRadius = 15.0
        upload_song_outlet.layer.cornerRadius = 15.0
    }
    
    //presents alert
    func presentalert(){
        let alert = UIAlertController(title: "Welcome!", message: "You can publish your song to be heard by all our users here", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default) { myalertaction in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //shows success progress Bar
    func showprogressHUD(){
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self.view)
        hud.tintColor = UIColor(named: "myorange")
        //hud.setProgress(value, animated: true)
        hud.detailTextLabel.text = "Uploaded"
        hud.dismiss(afterDelay: 1.0)
        reloadInputViews()
    }
    func showHUD(){
        let hud = JGProgressHUD()
        hud.indicatorView = JGProgressHUDIndeterminateIndicatorView()
        hud.show(in: self.view)
        hud.tintColor = UIColor(named: "myorange")
        hud.dismiss(afterDelay: 0.5)
        reloadInputViews()
    }
    
    
    
}

//MARK:- Image PickerController for song cover

extension addsong_vc: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func showimagepicker(){
        let imagepicker = UIImagePickerController()
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        present(imagepicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picked_image = info[UIImagePickerController.InfoKey.editedImage]{
            
            cover_photo_display.image = picked_image as? UIImage
            
            //send the picked image to cloud storage
            add_cover_photo_button_outlet.isHidden = true
            //unique ID for each picture
            
            let id = UUID().uuidString
            
            let picked_image_URl = info[UIImagePickerController.InfoKey.imageURL] as! URL
            
            let uploadmetadata = StorageMetadata()
            uploadmetadata.contentType = "image/jpeg"
            
            song_cover_storage_ref.child(id).putFile(from: picked_image_URl, metadata: nil) { my_storagemetadata, error in
                if let e = error{
                    print(e.localizedDescription)
                }else{
                    self.cover_download_destination = id
                    self.showprogressHUD()
                }
            }
            
            dismiss(animated: true, completion: nil)
        }else{
            print("no image picked")
            return
        }
        
    }
}

//MARK:- TextfieldDelegate

extension addsong_vc: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}
//MARK:- Document Picker Controller
extension addsong_vc: UIDocumentPickerDelegate{
    
    func showdocumentpicker(){
        
        let media_picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.mp3], asCopy: true)
        media_picker.delegate = self
        media_picker.allowsMultipleSelection = false
        present(media_picker, animated: true, completion: nil)
        
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        
        let taskref = song_storage_ref.child((urls.first?.deletingPathExtension().lastPathComponent)!).putFile(from: urls.first!, metadata: nil) { [self] (_, myerror) in
            if let e = myerror{
                print(e.localizedDescription)
                
            }else{
                //takes the name of the song stored in the DB, doing this to load the URL later
                self.download_destination = urls.first?.deletingPathExtension().lastPathComponent
                
                print("success")
                
            }
            
            
            
            
        }
        
        //MARK:- Observes progress
        
        
        taskref.observe(.progress) { snapshot in
            if let pctthere = snapshot.progress?.fractionCompleted{
                self.song_uploaded_progress.progress = Float(pctthere)
                if self.song_uploaded_progress.progress == 1.0{
                        self.publish_button_outlet.isHidden = false
                }else{
                    self.publish_button_outlet.isHidden = true
                }
            }else{
                print("error ")
                
            }
        }

        
    }
    
    
    //MARK:- Fetching the Link of the song and image
    func fetchURL(_ reftype: StorageReference, _ destination: String ,completion: @escaping (URL) -> ()) {
        reftype.child(destination).downloadURL {  myurl, error in
            if let e = error {
                print(e.localizedDescription)
            }else{
                //store URL to mysong
                DispatchQueue.main.async {
                    completion(myurl!)
                }
    
            }
        }
        
    }
    
    
    
    
    
    //saves data to both top charts and user collection
    func savedataToDataBase()  {
        //unique ID for each song
        let id = UUID().uuidString
        //saves everything to firestore together
        self.db.document(id).setData(["Name" : songname_txt_field.text ?? "no name", "ID": id, "Likes": 0, "Username": my_username as! String]) { [self] my_error in
            if let e = my_error{
                print(e.localizedDescription)
            }else{
                self.db_top.document(id).setData(["Name" : songname_txt_field.text ?? "no name", "ID": id, "Likes": 0, "Username": my_username as! String])
                print("name added")
            }
        }
        
        fetchURL(song_storage_ref, download_destination!) { myurl in
            self.db.document(id).setData(["Song_URL" : "\(myurl)"], merge: true) { myerror in
                if let e = myerror{
                    print(e.localizedDescription)
                }else{
                    self.db_top.document(id).setData(["Song_URL" : "\(myurl)"], merge: true)
                    print(myurl)
                }
            }
            
        }
        //Need a default photo
        fetchURL(song_cover_storage_ref, cover_download_destination!) { myurl in
            self.db.document(id).setData(["Photo_URL" : "\(myurl)"], merge: true) { myerror in
                if let e = myerror{
                    print(e.localizedDescription)
                }else{
                    self.db_top.document(id).setData(["Photo_URL" : "\(myurl)"], merge: true)
                    print(myurl)
                }
            }
        }
        
        
    }
    
  
    
    
    
}


