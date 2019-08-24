//
//  AuthenticationViewController.swift
//  AllegiancePractise
//
//  Created by John Pitts on 8/23/19.
//  Copyright © 2019 johnpitts. All rights reserved.

// NOTES:
//OpenID Connect (OIDC**) is an authentication layer on top of OAuth 2.0, an authorization framework. The standard is controlled by the OpenID Foundation


// Auth0 clientID =  mZFvU0TMKMpEi6lUkNTCxUuz986y4luR called "Default App" GENERIC

import UIKit
import Auth0

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerLoginButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var signInType: SignInType = .login

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This code was copied and pasted to display Auth0's HOSTED login page, not sure it's in the right spot actually
        Auth0
            .webAuth()
            .audience("https://dev-iunfzciz.auth0.com/userinfo")
            .start { result in
                switch result {
                case .success(let credentials):
                    print("Obtained credentials: \(credentials)")
                case .failure(let error):
                    print("Failed with \(error)")
                }
                // snipped above "sets the audience to ensure OIDC** responses.
                
        }
        //var credentialsManager = CredentialsManager(authentication: Auth0.authentication())
        //credentialsManager.enableBiometrics(withTitle: "Touch to Login")
        //credentialsManager.store(credentials: credentials)

        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BaseballNight")!)
    }
    
    
    @IBAction func registerOrLoginSelected(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            signInType = .register
            registerLoginButton.setTitle("Register", for: .normal)
        } else {
            signInType = .login
            registerLoginButton.setTitle("Log In", for: .normal)
        }
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    enum SignInType {
        case register
        case login
    }

}
