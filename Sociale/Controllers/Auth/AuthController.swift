//
//  AuthController.swift
//  Sociale
//
//  Created by Guy Adler on 16/10/2023.
//

import UIKit



extension AuthController: AuthDelegate {
    func authenticate(token: String) async throws  {
        // cache the token
        let auth_manager = AuthManager.instance
        auth_manager.saveToken(token)
        do {
            let user = try await SocialeAPI.authenticated_get(endpoint: "users/me", token: token, responseBodyType: User.self)
            auth_manager.setUser(user)
            // move to main screen
            if let router = self.getRouter() {
                let homeNavController = UIStoryboard(name: "Main", bundle: .main)
                router.changeRootViewController(vc: homeNavController.instantiateViewController(withIdentifier: "TabController"))
            }
        } catch {
            // something went wrong with passing the token to server
            // token maybe expired / invalid
            auth_manager.removeToken()
            handleApiError(error)
        }
    }
}


class AuthController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var toSignInbtn: UIButton!
    @IBOutlet weak var toSignOutbtn: UIButton!
    
    var initial_appearance = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let token = AuthManager.instance.getToken() {
            Task { try await authenticate(token: token) }
        }

    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? SignupController {
            dest.delegate = self
        } else if let dest = segue.destination as? SignInController {
            dest.delegate = self
        }
    }
    

}
