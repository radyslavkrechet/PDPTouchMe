//
//  ViewController.swift
//  TouchMe
//
//  Created by Radislav Crechet on 5/22/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit
import LocalAuthentication
import Hero
import TouchMeKit

class EntryViewController: ViewController, UITextFieldDelegate {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var thouchTheButton: UIButton!
    
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
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSession()
        configureAuthentication()
    }
    
    // MARK: - Configuration
    
    private func configureSession() {
        guard SessionService.haveSession else {
            return
        }
        
        emailTextField.text = SessionService.email
        
        if AuthenticationService.canAuthenticateWithBiometrics {
            authenticateWithBiometrics()
        }
    }
    
    private func configureAuthentication() {
        if !AuthenticationService.canAuthenticateWithBiometrics {
            orLabel.isHidden = true
            thouchTheButton.isHidden = true
        }
    }
    
    private func resignFirstResponders() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: - Actions

    @IBAction func enterWithAccountButtonPressed(_ sender: UIButton) {
        enterWithAccount()
    }
    
    @IBAction func touchTheButtonPressed(_ sender: Any) {
        authenticateWithBiometrics()
    }
    
    @IBAction func firstTimeButtonPressed(_ sender: Any) {
        Hero.shared.defaultAnimation = .fade
        performSegue(withIdentifier: Constants.SegueIdentifiers.toAccout, sender: self)
    }

    // MARK: - Work With Authentication
    
    private func authenticateWithBiometrics() {
        guard let email = emailTextField.text,
            !email.isEmpty else {
                
                return
        }
        
        resignFirstResponders()
        
        guard email == SessionService.email else {
            presentErrorAlert(withMessage: "You trying authorize with another email. Please, enter the password.")
            return
        }
        
        AuthenticationService.authenticateWithBiometrics(withLocalizedReason: "to enter") { [unowned self] success,
            policyError, authenticationError in
            
            guard !success else {
                self.signInWithFirebase()
                
                return
            }
            
            var message = policyError?.localizedDescription
            
            if let error = authenticationError,
                error.code != LAError.userFallback &&
                    error.code != LAError.userCancel &&
                    error.code != LAError.systemCancel {
                
                message = error.localizedDescription
            }
            
            if let message = message {
                self.presentErrorAlert(withMessage: message)
            }
        }
    }

    // MARK: - Work With Account
    
    private func enterWithAccount() {
        if isEnteredDataValid {
            resignFirstResponders()
            
            if isKeychainPasswordItemValid() {
                signInWithFirebase()
            }
        }
    }

    // MARK: - Work With Keychain
    
    private func isKeychainPasswordItemValid() -> Bool {
        do {
            let item = KeychainPasswordItem(service: "TouchMe", account: emailTextField.text!)
            let password = try item.readPassword()
            
            if password == passwordTextField.text {
                return true
            } else {
                presentErrorAlert(withMessage: "Invalid password")
                return false
            }
        } catch {
            if let error = error as? KeychainPasswordItem.KeychainError {
                if case .noPassword = error {
                    presentErrorAlert(withMessage: "There is no email-password pair in keychain")
                    return false
                }
            }
            
            presentErrorAlert(withMessage: error.localizedDescription)
        }
        
        return false
    }

    // MARK: - Work With Firebase
    
    private func signInWithFirebase() {
        createSession()
        
        ActivityView.show() { [unowned self] in
            self.createGamerInDatabaseIfNeeded {
                FirebaseService.signIn(withEmail: self.emailTextField.text!,
                                       password: self.passwordTextField.text!) { [unowned self] in
                                        
                                        NetworkService.leaderboard { [unowned self] in
                                            self.updateGamerScoreInDatabase()
                                            
                                            ActivityView.hide() { [unowned self] in
                                                self.presentMain()
                                            }
                                        }
                }
            }
        }
    }

    // MARK: - Work With Session
    
    private func createSession() {
        SessionService.setEmail(emailTextField.text!)
    }

    // MARK: - Work With Database
    
    private func createGamerInDatabaseIfNeeded(_ completion: @escaping Completion) {
        guard DatabaseManager.shared.gamer() == nil else {
            completion()
            return
        }
        
        let gamer = Gamer()
        gamer.email = emailTextField.text!
        
        DatabaseManager.shared.add(gamer)
        
        completion()
    }
    
    private func updateGamerScoreInDatabase() {
        let email = SessionService.email!
        let score = LeaderboardManager.shared.scoreOfGamer(withEmail: email)
        DatabaseManager.shared.updateScore(score)
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            enterWithAccount()
        }
        
        return true
    }
}
