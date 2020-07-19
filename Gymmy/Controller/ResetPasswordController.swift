//
//  ResetPasswordController.swift
//  Gymmy
//
//  Created by Pranav Badgi on 16/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit


protocol ResetPasswordControllerDelegate: class {
    func didSendResetPasswordLink()
}

class ResetPasswordController: UIViewController {
    //Pranav:- Properties
    weak var delegate: ResetPasswordControllerDelegate?
    //using the struct in AuthenticationViewModel here to validate form
    private var viewModel = ResetPasswordViewModel()
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "gymmyicon"))
    private let emailTextField = CustomTextField(placeholder: "Email")
    //creating this to get email from login page if user types and click reset
    var email: String?
    
    private let resetPasswordButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.title = "Send Reset Link"
        button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return button
    }()
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    //Pranav:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        loadEmail()
    }
    
    //Pranav:- Helpers
    func configureUI() {
        configureGradientbackground()
        //adding image icon in the center
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 140, width: 140)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        //adding backbutton
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 16, paddingLeft: 16)
        //creating stackView to add emailTextField, resetPasswordButton
        let stack = UIStackView(arrangedSubviews: [emailTextField,
                                                   resetPasswordButton
                                                   ])
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
    }
    
    //Pranav:- Selectors
    //selectors of resetpasswordbutton
    @objc func handleResetPassword() {
        print("DEBUG: Handle reset password link here..")
        guard let email = viewModel.email else { return }
        showLoader(true)
        Service.resetPassword(forEmail: email) { error in
            self.showLoader(false)
            if let error = error {
                self.showMessage(withTitle: "Error", message: error.localizedDescription)
                return
            }
            self.delegate?.didSendResetPasswordLink()
        }
    }
    
    //selector of backButton
    @objc func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        updateForm()
    }
    
    //creating a function to form validate the viewModel here
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func loadEmail() {
        guard let email = email else { return }
        viewModel.email = email
        emailTextField.text = email
        updateForm()
    }
    
}

extension ResetPasswordController: FormViewModel {
    //creating a function to enable login button if the form is valid
    func updateForm() {
        resetPasswordButton.isEnabled = viewModel.shouldEnableButton
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
    }
}
