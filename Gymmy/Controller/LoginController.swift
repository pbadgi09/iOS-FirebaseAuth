//
//  LoginController.swift
//  Gymmy
//
//  Created by Pranav Badgi on 16/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

protocol AuthenticationDelegate: class {
    func authenticationComplete()
}


class LoginController: UIViewController {
    
    
    //Pranav:- Properties
    weak var delegate: AuthenticationDelegate?
    //using the struct in AuthenticationViewModel here to validate form
    private var viewModel = LoginViewModel()
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "gymmyicon"))
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField: CustomTextField = {
       let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let loginButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Log In"
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 15)]
        let attributedTitle = NSMutableAttributedString(string: "Forgot your Password? ",attributes: atts)
        let boldatts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 15)]
        attributedTitle.append(NSAttributedString(string: "Get help Signing In.", attributes: boldatts))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showForgotPassword), for: .touchUpInside)
        return button
    }()
    
    
    private let dividerView = DividerView()
    
    
    private let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "btn_google_light_pressed_ios").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle("  Log In with Google", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleGooglelogin), for: .touchUpInside)
        return button
    }()
    
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let atts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.systemFont(ofSize: 16)]
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ",attributes: atts)
        let boldatts: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87), .font: UIFont.boldSystemFont(ofSize: 16)]
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: boldatts))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(showRegistrationController), for: .touchUpInside)
        return button
    }()
    
    
    //Pranav:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        configureGoogleSignIn()
    }
    
    
    
    
    //Pranav:- Selectors
    //selector of LoginButton
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        showLoader(true)
        //Service is in API and logUserIn is a func in that.
        Service.logUserIn(withEmail: email, password: password) { (result, error) in
            self.showLoader(false)
            if let error = error {
                //to show the error to the user
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            //since loginController is on top of homecontroller we can just dismiss
            //the loginController
            self.delegate?.authenticationComplete()
        }
    }
    
    //selector of showForgotPasswordButton
    @objc func showForgotPassword() {
        let controller = ResetPasswordController()
        controller.email = emailTextField.text
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //selector of googleLoginButton
    @objc func handleGooglelogin() {
        //this will call the extension GIDSignInDelegate which handle login
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    
    //selector of donthaveaccountButton
    @objc func showRegistrationController() {
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    //selector of configureNotificationObserver
    @objc func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        updateForm()
    }
    
    //Pranav:- Helpers
    func configureUI() {
        //setting background to the screen
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        configureGradientbackground()
        //adding image icon in the center
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 140, width: 140)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        //creating stackView to add emailTextField, passwordtextField, loginButton
        let stack = UIStackView(arrangedSubviews: [emailTextField,
                                                   passwordTextField,
                                                   loginButton
                                                   ])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        //creating stackView to add ForgotpasswordButton, DividerButton, GoogleloginButton
        let secondStack = UIStackView(arrangedSubviews: [forgotPasswordButton,
                                                         dividerView,
                                                         googleLoginButton])
        secondStack.axis = .vertical
        secondStack.spacing = 28
        view.addSubview(secondStack)
        secondStack.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        //adding dontHaveAccountButton to the bottom
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    //creating a function to form validate the viewModel here
    //remember to call this function in viewdidload.
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
    //creating a func to configure google sign in
    //since it is a delegate it requires to conform to a protocol
    //so we will create an extension
    func configureGoogleSignIn() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
}

//creating an extension since updateform is used in 3 controllers..login,registration and reset
//same thing is done in registration
extension LoginController: FormViewModel {
    //creating a function to enable login button if the form is valid
    func updateForm() {
        loginButton.isEnabled = viewModel.shouldEnableButton
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
}

//extension for google signin
extension LoginController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("DEBUG: Failed to sign in with Google: ", error.localizedDescription)
            return
        }
        Service.signInWithGoogle(didSignInFor: user) { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to sign in with Google: ", error.localizedDescription)
                return
            }
            self.delegate?.authenticationComplete() 
        }
    }
}

extension LoginController: ResetPasswordControllerDelegate {
    func didSendResetPasswordLink() {
        navigationController?.popViewController(animated: true)
        self.showMessage(withTitle: "Success", message: MSG_RESET_LINK_SENT)
        print("DEBUG: Show success msg here")
    }
}
