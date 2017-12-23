//
//  SignupViewController.swift
//  instagramLike
//
//  Created by 笹倉 一也 on 2017/12/23.
//  Copyright © 2017年 笹倉 一也. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var comPwField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let picker = UIImagePickerController()
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let storage = Storage.storage().reference(forURL: "gs://instagram-1384a.appspot.com/")
        
        ref = Database.database().reference()
        userStorage = storage.child("users")

    }
    
    
    @IBAction func selectImagePressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
            nextBtn.isHidden = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        guard nameField.text != "", emailField.text != "", password.text != "", comPwField.text != "" else { return }
        
        if password.text == comPwField.text {
            Auth.auth().createUser(withEmail: emailField.text!, password: password.text!, completion: { (user, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                if let user = user {
                    
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    changeRequest.displayName = self.nameField.text!
                    changeRequest.commitChanges(completion: nil)
                    
                    let imageRef = self.userStorage.child("\(user.uid).jpg")
                
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                        
                        imageRef.downloadURL(completion: { (url, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                            
                            if let url = url {
                                
                                let userInfo:[String : Any] = ["uid" : user.uid,
                                                               "fullname" : self.nameField.text!,
                                                               "urlToImage" : url.absoluteString ]
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                                
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                            
                        })
                        
                    })
                    
                    uploadTask.resume()
                    
                }
                
            })
            
        } else {
            print("Password does not match")
        }
        
        
        
        
        
        
        
    }
    

    
    
    
    
    
    
    
}
