//
//  LoginViewController.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/17/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var backgroundImageView: UIImageView!
    
    var infoView: UIView!
    var loginRegisterSegmentedControl: UISegmentedControl!
    var messengerLabel: UILabel!
    var nameTextField: UITextField!
    var emailTextField: UITextField!
    var passwordTextField: UITextField!
    var loginRegisterButton: UIButton!
    var chooseProfileImageView: UIImageView!
    var importPhotoButton: UIButton!
    
    
    var loggingInView: UIView!
    var indicator: UIActivityIndicatorView!
    var loggingInLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    func loginRegisterToggle() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            
            // Login Segment selected
            nameTextField.removeFromSuperview()
            chooseProfileImageView.removeFromSuperview()
            importPhotoButton.removeFromSuperview()
            emailTextField.frame = CGRect(x: emailTextField.frame.origin.x, y: 0, width: emailTextField.frame.width, height: emailTextField.frame.height)
            passwordTextField.frame = CGRect(x: passwordTextField.frame.origin.x, y: emailTextField.frame.origin.y + emailTextField.frame.height, width: passwordTextField.frame.width, height: passwordTextField.frame.height)
            infoView.frame = CGRect(x: infoView.frame.origin.x, y: infoView.frame.origin.y, width: infoView.frame.width, height: 100)
            loginRegisterButton.frame = CGRect(x: loginRegisterButton.frame.origin.x, y: infoView.frame.origin.y + infoView.frame.height + 12, width: loginRegisterButton.frame.width, height: loginRegisterButton.frame.height)
            loginRegisterButton.setTitle("Login", for: .normal)
        } else if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            
            // Register Segment selected
            infoView.frame = CGRect(x: infoView.frame.origin.x, y: infoView.frame.origin.y, width: infoView.frame.width, height: 150)
            emailTextField.frame = CGRect(x: emailTextField.frame.origin.x, y: infoView.frame.height/3, width: emailTextField.frame.width, height: emailTextField.frame.height)
            passwordTextField.frame = CGRect(x: passwordTextField.frame.origin.x, y: emailTextField.frame.origin.y + emailTextField.frame.height, width: passwordTextField.frame.width, height: passwordTextField.frame.height)
            infoView.addSubview(nameTextField)
            view.addSubview(chooseProfileImageView)
            view.addSubview(importPhotoButton)
            loginRegisterButton.frame = CGRect(x: loginRegisterButton.frame.origin.x, y: chooseProfileImageView.frame.origin.y + chooseProfileImageView.frame.height + 12, width: loginRegisterButton.frame.width, height: loginRegisterButton.frame.height)
            loginRegisterButton.setTitle("Register", for: .normal)
        }
    }
    
    func importPhoto() {
        //access photo album
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // finished selecting picture
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            chooseProfileImageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            chooseProfileImageView.image = image
        } else {
            print("Photo selection failed")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            // in register segment
            if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let image = chooseProfileImageView.image {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if (error != nil) {
                        Global.createAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
                        print(error)
                        return
                    }
                    
                    self.view.addSubview(self.loggingInView)
                    self.view.bringSubview(toFront: self.loggingInView)
                    self.indicator.startAnimating()
                    
                    
                    var imageURLString: String = ""

                    if let imageData = UIImagePNGRepresentation(image) {
                        let savedImageName = UUID().uuidString
                        let storageRef = Storage.storage().reference().child("\(savedImageName).png")
                        storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                            if (error != nil) {
                                Global.createAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
                                print(error)
                                return
                            }
                            if let urlString = metadata?.downloadURL()?.absoluteString {
                                imageURLString = urlString
                            }
                            
                            let ref = Database.database().reference(fromURL: "https://my-fbmessenger.firebaseio.com/")
                            if let userId = user?.uid {
                                let userRef = ref.child("users").child(userId)
                                let values = ["name": name, "email": email, "profileImageURL": imageURLString]
                                userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                    if (err != nil) {
                                        Global.createAlert(title: "Error", message: (err?.localizedDescription)!, viewController: self)
                                        print(error)
                                        return
                                    }
                                })
                            }
                            
                            self.nameTextField.text = ""
                            self.emailTextField.text = ""
                            self.passwordTextField.text = ""
                            self.chooseProfileImageView.image = nil
                            
//                            let userModelObject = User(name: name, email: email, profileImageURL: imageURLString)
                            
                            self.indicator.stopAnimating()
                            self.loggingInView.removeFromSuperview()
                            
                            let layout = UICollectionViewFlowLayout()
                            let messagesViewController = MessagesViewController(collectionViewLayout: layout)
                            messagesViewController.userId = user?.uid
                            self.navigationController?.pushViewController(messagesViewController, animated: true)
                            
                        })
                        
                    }
                    
                    
                    
                })
            } else {
                Global.createAlert(title: "Login failed", message: "Is your password more than 6 characters? Did you import a photo?", viewController: self)
                return
            }
        } else {
            // in login segment
            if let email = emailTextField.text, let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if (error != nil) {
                        print(error)
                        Global.createAlert(title: "Error", message: (error?.localizedDescription)!, viewController: self)
                        return
                    }
                    
                    self.view.addSubview(self.loggingInView)
                    self.view.bringSubview(toFront: self.loggingInView)
                    self.indicator.startAnimating()
                    
                    self.indicator.stopAnimating()
                    self.loggingInView.removeFromSuperview()
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                    let layout = UICollectionViewFlowLayout()
                    let messagesViewController = MessagesViewController(collectionViewLayout: layout)
                    messagesViewController.userId = user?.uid
                    self.navigationController?.pushViewController(messagesViewController, animated: true)
                })
            } else {
                Global.createAlert(title: "Login failed", message: "Please enter email and password", viewController: self)
                return
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden =  false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    


}
