//
//  LoginViewControllerExtension.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/18/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit

extension LoginViewController {
    
    func setupViews() {
        
        backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImageView.image = #imageLiteral(resourceName: "mountain")
        backgroundImageView.contentMode = .center
        backgroundImageView.alpha = 0.7
        view.addSubview(backgroundImageView)
        
        messengerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.75, height: view.frame.height*0.1))
        messengerLabel.text = "messenger"
        messengerLabel.font = UIFont.systemFont(ofSize: 30)
        messengerLabel.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
        messengerLabel.layer.cornerRadius = 10
        messengerLabel.layer.masksToBounds = true
        messengerLabel.textAlignment = .center
        messengerLabel.center = CGPoint(x: view.frame.width/2, y: view.frame.height*0.15)
        messengerLabel.textColor = .white
        view.addSubview(messengerLabel)
        
        loginRegisterSegmentedControl = UISegmentedControl(items: ["Login", "Register"])
        loginRegisterSegmentedControl.frame = CGRect(x: 0, y: messengerLabel.frame.origin.y + messengerLabel.frame.height + view.frame.width * 0.07, width: view.frame.width*0.8, height: view.frame.height*0.05)
        loginRegisterSegmentedControl.center = CGPoint(x: view.frame.width/2, y: loginRegisterSegmentedControl.center.y)
        loginRegisterSegmentedControl.layer.cornerRadius = 5
        loginRegisterSegmentedControl.layer.borderColor = UIColor.white.cgColor
        let font = UIFont.systemFont(ofSize: 16)
        loginRegisterSegmentedControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
        loginRegisterSegmentedControl.selectedSegmentIndex = 1
        loginRegisterSegmentedControl.tintColor = .white
        loginRegisterSegmentedControl.addTarget(self, action: #selector(loginRegisterToggle), for: UIControlEvents.valueChanged)
        view.addSubview(loginRegisterSegmentedControl)
        
        
        infoView = UIView(frame: CGRect(x: 0, y: loginRegisterSegmentedControl.frame.origin.y + loginRegisterSegmentedControl.frame.height + 32, width: view.frame.width*0.8, height: 150))
        infoView.center = CGPoint(x: view.frame.width/2, y: infoView.center.y)
        infoView.layer.cornerRadius = 5
        infoView.backgroundColor = .white
        view.addSubview(infoView)
        
        nameTextField = UITextField(frame: CGRect(x: 12, y: 0, width: infoView.frame.width-24, height: infoView.frame.height/3))
        nameTextField.placeholder = "Name"
        nameTextField.backgroundColor = .white
        infoView.addSubview(nameTextField)
        
        emailTextField = UITextField(frame: CGRect(x: 12, y: infoView.frame.height/3, width: infoView.frame.width-24, height: infoView.frame.height/3))
        emailTextField.placeholder = "Email"
        emailTextField.backgroundColor = .white
        infoView.addSubview(emailTextField)
        
        passwordTextField = UITextField(frame: CGRect(x: 12, y: emailTextField.frame.origin.y + emailTextField.frame.height, width: infoView.frame.width-24, height: infoView.frame.height/3))
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        infoView.addSubview(passwordTextField)
        
        importPhotoButton = UIButton(frame: CGRect(x: 0, y: infoView.frame.origin.y + infoView.frame.height + 12, width: view.frame.width*0.5, height: view.frame.height*0.05))
        importPhotoButton.center = CGPoint(x: view.frame.width/2, y: importPhotoButton.center.y)
        importPhotoButton.setTitle("Import Photo", for: .normal)
        importPhotoButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        importPhotoButton.setTitleColor(.white, for: .normal)
        importPhotoButton.layer.cornerRadius = 5
        importPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        importPhotoButton.addTarget(self, action: #selector(importPhoto), for: .touchUpInside)
        view.addSubview(importPhotoButton)
        
        chooseProfileImageView = UIImageView(frame: CGRect(x: 0, y: importPhotoButton.frame.origin.y + importPhotoButton.frame.height + 12, width: view.frame.width*0.4, height: view.frame.width*0.4))
        chooseProfileImageView.center = CGPoint(x: view.frame.width/2, y: chooseProfileImageView.center.y)
        chooseProfileImageView.layer.cornerRadius = chooseProfileImageView.frame.width/2
        chooseProfileImageView.backgroundColor = .white
        chooseProfileImageView.layer.masksToBounds = true
        view.addSubview(chooseProfileImageView)
        
        
        
        loginRegisterButton = UIButton(frame: CGRect(x: 0, y: chooseProfileImageView.frame.origin.y + chooseProfileImageView.frame.height + 12, width: infoView.frame.width, height: view.frame.height*0.07))
        loginRegisterButton.center = CGPoint(x: view.frame.width/2, y: loginRegisterButton.center.y)
        loginRegisterButton.setTitle("Register", for: .normal)
        loginRegisterButton.backgroundColor = UIColor(red: 80/255, green: 101/255, blue: 161/255, alpha: 1)
        loginRegisterButton.setTitleColor(.white, for: .normal)
        loginRegisterButton.layer.cornerRadius = 5
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        view.addSubview(loginRegisterButton)
        
        loggingInView = UIView(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        loggingInView.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        loggingInView.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 0.7)
        loggingInView.layer.cornerRadius = 10
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        indicator.center = CGPoint(x: loggingInView.frame.width/2, y: loggingInView.frame.height/2)
        loggingInView.addSubview(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        loggingInLabel = UILabel(frame: CGRect(x: 0, y: 20, width: loggingInView.frame.width*0.9, height: 20))
        loggingInLabel.center = CGPoint(x: loggingInView.frame.width/2, y: loggingInLabel.center.y)
        loggingInLabel.text = "Logging In"
        loggingInLabel.textAlignment = .center
        loggingInLabel.textColor = .black
        loggingInView.addSubview(loggingInLabel)
    }
    
}
