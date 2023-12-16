//
//  ViewController.swift
//  Sociale
//
//  Created by Guy Adler on 27/09/2023.
//

import UIKit



class SignupController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    @IBOutlet weak var haveAcoountLabel: UILabel!
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    
    weak var delegate: AuthDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.addAction(UIAction { btn in
            self.signUp(btn)
        }, for: .touchUpInside)
        
        setupButtons()
        setupUI()
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.nameTextField.delegate = self
    }
    
    func setupUI(){
        //Background image
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "backgroundImage")
        backgroundImage.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        self.appTitleLabel.text = "Welcome to Sociale, please sign up"
        self.appTitleLabel.textColor = UIColor.black
        self.appTitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        self.haveAcoountLabel.text = "Already have an account? Sign in"
        self.haveAcoountLabel.textColor = UIColor.blue
        self.haveAcoountLabel.font = .systemFont(ofSize: 14, weight: .medium)
        
        self.haveAcoountLabel.isUserInteractionEnabled = true
        
        // Initialize Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(accLabelTapped) )

        // Add Tap Gesture Recognizer
        self.haveAcoountLabel.addGestureRecognizer(tapGestureRecognizer)
    

    }
    
    @objc func accLabelTapped(){
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignInController")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    
    func setupButtons() {
        
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor
        emailTextField.layer.borderWidth = 2
        
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor
        passwordTextField.layer.borderWidth = 2
        
        nameTextField.layer.cornerRadius = 8
        nameTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor
        nameTextField.layer.borderWidth = 2
        
    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.emailTextField {
            self.emailTextField.layer.cornerRadius = 8
            self.emailTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor

        }
        else if textField == self.passwordTextField {
            self.passwordTextField.layer.cornerRadius = 8
            self.passwordTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor


        } else if textField == self.nameTextField {
            self.nameTextField.layer.cornerRadius = 8
            self.nameTextField.layer.borderColor = UIColor.secondarySystemFill.cgColor

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nameTextField.text != nil {
            nameTextField.resignFirstResponder()
            return true
        }
        return false
    }
    
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    func signUp(_ sender: Any) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let date = birthdayPicker.date.formatted()
        
        let user_object = RegistrationForm(email: email, name: name, password: password, birthday: date)
        
        validationCheck()
        
        Task {
            [weak self] in
            guard let strongSelf = self else { return }
             
            do {
                let token = try await SocialeAPI.post(endpoint: "users/sign-up", data: user_object, responseBodyType: String.self)
                strongSelf.navigationController?.popViewController(animated: true)
                try await strongSelf.delegate?.authenticate(token: token)
            } catch {
                strongSelf.handleApiError(error)
            }
        }
        
    }
    
    func validationCheck(){
        if let email = emailTextField.text {
            if !email.isValidEmail(email) {
                emailTextField.layer.borderWidth = 2
                emailTextField.layer.borderColor = UIColor.red.cgColor
                emailTextField.layer.cornerRadius = 8
                showAlert(content: "Email invalid")
            }
        }
        
        if let password = passwordTextField.text {
            if !password.isPasswordValid(for: password) {
                passwordTextField.layer.borderWidth = 2
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                passwordTextField.layer.cornerRadius = 8
                showAlert(content: "Password Invalid")
            }
        }
        
        if let name = nameTextField.text {
            if name.isEmpty {
                nameTextField.layer.borderWidth = 2
                nameTextField.layer.borderColor = UIColor.red.cgColor
                nameTextField.layer.cornerRadius = 8
                showAlert(content: "Name Invalid")
            }
           
        }
    }

}


extension String {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isPasswordValid(for password:String) -> Bool {
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
        
        /*   At least one lower case (?=.*?[a-z])
         At least one upper case(?=.*?[A-Z])
         At least one digit, (?=.*?[0-9])
         Minimum eight in length .{8,} (with the anchors)
         */
        
    }
}
