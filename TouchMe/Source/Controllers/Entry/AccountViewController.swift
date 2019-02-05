//
//  AccountViewController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import Hero
import TouchMeKit

class AccountViewController: ViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    private var isEnteredDataValid: Bool {
        var isEnteredDataValid = false
        
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            !email.isEmpty &&
                !password.isEmpty {
            
            isEnteredDataValid = true
        }
        
        return isEnteredDataValid
    }
    
    // MARK: - Configuration
    
    private func resignFirstResponders() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    // MARK: - Actions
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        createAccount()
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        Hero.shared.defaultAnimation = .fade
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Work With Account
    
    private func createAccount() {
        if isEnteredDataValid {
            resignFirstResponders()
            createKeychainPasswordItem()
            createSession()
            createGamerInDatabase()
            signUpWithFirebase()
        }
    }

    // MARK: - Work With Keychain
    
    private func createKeychainPasswordItem() {
        let item = KeychainPasswordItem(service: "TouchMe", account: emailTextField.text!)
        try! item.savePassword(passwordTextField.text!)
    }

    // MARK: - Work With Session
    
    private func createSession() {
        SessionService.setEmail(emailTextField.text!)
    }

    // MARK: - Work With Database
    
    private func createGamerInDatabase() {
        let gamer = Gamer()
        gamer.email = emailTextField.text!
        
        DatabaseManager.shared.add(gamer)
    }

    // MARK: - Work With Firebase
    
    private func signUpWithFirebase() {
        ActivityView.show() { [unowned self] in
            FirebaseService.signUp(withEmail: self.emailTextField.text!,
                                   password: self.passwordTextField.text!) {
                                    
                                    ActivityView.hide() { [unowned self] in
                                        self.presentMain()
                                    }
            }
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            createAccount()
        }
        
        return true
    }
}
