//
//  SplashSignupViewController.swift
//  AllegiancePractise
//
//  Created by John Pitts on 8/20/19.
//  Copyright © 2019 johnpitts. All rights reserved.
//

import UIKit
import Auth0


class SplashSignupViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    var isAuthenticated: Bool = false
    var groupController = GroupController()
    var userController = UserController()
    public let icon: String = "FansRejoice"
    var credentialsManager = CredentialsManager(authentication: Auth0.authentication())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Allegiance Background")!)  // "
        signInButton.isHidden = false
        
        // This will only occur if the back-end goes bad or its the first time ever the app is run and there are no groups to populate the app initially.
        if groupController.fetch().isEmpty {
            let image = (UIImage(named: icon)?.pngData())!  //The icon comes with the app
            let group = Group(groupName: "Allegiance Enthusiasts Unite!", slogan: "Bring'em Back!", timestamp: Date(), privacySetting: "public", location: 18925, id: UUID(), image: image, creatorId: "johnpittsisyouroverlord")
            groupController.put(group: group)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // TO DO:
    // we will need to implement some logic in getStartedButtonTapped, whereas right now it just segues quickly to the intro pages starting with "Support Teams"
    //        but getStarted should first check to see if credentials are authentic, otherwise deny entry to intro pages.
    
    
    
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        // This Login call is performed with a background thread, so you must DispatchMain for UI actions directly afterwards
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://dev-uzdmt05n.auth0.com/userinfo")
            .start {                                              // background que (closure)
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                    self.isAuthenticated = false
                case .success(let credentials):
                    
                    self.isAuthenticated = true
                    
                    if self.credentialsManager.store(credentials: credentials) {
                        
                        
                        guard let id = credentials.idToken else { return }
                        let user = User(id: id)
                        self.userController.put(user: user)
                        
                        // you will need to add the network call to Postman PostgreSQL back-end here, and possibly erase the CoreData code as it really won't be needed to be stored locally.
                        
                        
                    }
                    
//                    let defaults = UserDefaults.standard
//                    defaults.set(credentials, forKey: "credentials")
                    print("F'G AUTH0 Credentials: \(String(describing: credentials.idToken))")
                    
                    if self.isAuthenticated {
                        DispatchQueue.main.async {    // i don't think i need to call main here as it's outside the closure, experiement with this later.
                            
                            self.signInButton.isHidden = true
                            // we will want to segue to Groups or Feed when user isn't a new-register, after logging in
                            //self.performSegue(withIdentifier: "UserAlreadyHasLoginCredentials", sender: self)
                        }
                    }     // else, encourage Registration? or does Auth0 do that for me automatically?
                    
                    // Auth0 will automatically dismiss the login page; write code to direct app to advanced view with which the user would interact if he wasn't a newb to the app.
                  }
              }
    }
    
    
    // this was changed to the logout button, but didn't change the name bc eventually it should go back to being an invite-code button.   See the original FIGMA design to understand better
    @IBAction func inviteCodeButtonPressed(_ sender: Any) {
        print("Have an invite code will be implemented in a later release, and be in place of this button")
        
        if credentialsManager.clear() {
            
            DispatchQueue.main.async {
                self.signInButton.isHidden = false
                self.isAuthenticated = false
            }
        }
        
    }
    
}
