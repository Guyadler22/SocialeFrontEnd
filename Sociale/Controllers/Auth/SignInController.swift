//
//  ViewController.swift
//  Sociale
//
//  Created by Guy Adler on 27/09/2023.
//

import UIKit


protocol AuthDelegate : AnyObject {
    func authenticate(token: String) async throws
}

class SignInController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
  
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var createAccountLabel: UILabel!
    
    
    weak var delegate: AuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        signInBtn.isUserInteractionEnabled = true
        signInBtn.addAction(UIAction { btn in
            self.signInBtn(btn)
        }, for: .touchUpInside)
           
    }
    
    func setupUI(){
        
        //Background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        self.appTitle.text = "Please sign in to your account"
        self.appTitle.font = .systemFont(ofSize: 14, weight: .medium)
        self.appTitle.textColor = UIColor.black
        
        self.emailTextField.becomeFirstResponder()
        self.emailTextField.layer.borderWidth = 2
        self.emailTextField.layer.cornerRadius = 8
        self.emailTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor
        
        self.passwordTextField.layer.borderWidth = 2
        self.passwordTextField.layer.cornerRadius = 8
        self.passwordTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor

        self.createAccountLabel.text = "Dont have account? Sign Up"
        self.createAccountLabel.textColor = UIColor.blue
        self.createAccountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        self.createAccountLabel.isUserInteractionEnabled = true
        
        // Initialize Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpTapped) )

        // Add Tap Gesture Recognizer
        self.createAccountLabel.addGestureRecognizer(tapGestureRecognizer)
    

    }
    
    @objc func SignUpTapped(){
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignupController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func signInBtn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
    
        
        let user_object = LoginForm(email: email, password: password)
    
        Task {
            [weak self] in
            guard let strongSelf = self else { return }
            do {
                let token = try await SocialeAPI.post(endpoint: "users/sign-in", data: user_object, responseBodyType: String.self)
                strongSelf.navigationController?.popViewController(animated: true)
                try await strongSelf.delegate?.authenticate(token: token)
            } catch {
                strongSelf.handleApiError(error)
            }
        }

    }
    
}


