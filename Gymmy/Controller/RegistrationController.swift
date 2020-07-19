//
//  RegistrationController.swift
//  Gymmy
//
//  Created by Pranav Badgi on 16/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    //Pranav:- Properties
    weak var delegate: AuthenticationDelegate?
    //using the struct in AuthenticationViewModel here to validate form
    private var viewModel = RegistrationViewModel()
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "gymmyicon"))
    private let emailTextField = CustomTextField(placeholder: "Email")
    private let fullnameTextField = CustomTextField(placeholder: "Full Name")
    private let passwordTextField: CustomTextField = {
       let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let signUpButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Sign Up"
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ",attributes: atts)
        let boldatts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: boldatts))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showLoginController), for: .touchUpInside)
        return button
    }()
    
    //Pranav:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    //Pranav:- Selectors
    //selector of signUpButton
    @objc func handleSignup() {
        //grabbing values from textfields
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        showLoader(true)
        //creating a user in firebase
        //Service is in API and registeruserWithFirebase is a func in that
//        Service.registerUserWithFirebase(withEmail: email, password: password, fullname: fullname) { (error, ref) in
//                self.showLoader(false)
//                if let error = error {
//                        //to show the error to the user
//                        self.showMessage(withTitle: "Error", message: error.localizedDescription)
//                        return
//                    }
//                   self.delegate?.authenticationComplete()
//            }
        
        //register user with firestore
        Service.registerUserWithFirestore(withEmail: email, password: password, fullname: fullname) { error in
            if let error = error {
                //to show the error to the user
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            self.delegate?.authenticationComplete()
        }
    }
    
    
    //selector of alreadyhaveAccountButton
    @objc func showLoginController() {
        navigationController?.popViewController(animated: true)
    }
    
    
    //selector of configureNotificationObserver
    @objc func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else {
            viewModel.fullname = sender.text
        }
            updateForm()
        }
    
    //Pranav:- Helpers
    
    func configureUI() {
        configureGradientbackground()
        //adding image icon in the center
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 140, width: 140)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        //creating stackView to add emailTextField, passwordtextField and others
        let stack = UIStackView(arrangedSubviews: [fullnameTextField,
                                                   emailTextField,
                                                   passwordTextField,
                                                   signUpButton
                                                   ])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        //adding alreadyHaveAccountButton to the bottom
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    //creating a function to form validate the viewModel here
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

extension RegistrationController: FormViewModel {
    //creating a function to enable login button if the form is valid
    func updateForm() {
        signUpButton.isEnabled = viewModel.shouldEnableButton
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
}
