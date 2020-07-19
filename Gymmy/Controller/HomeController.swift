//
//  HomeController.swift
//  Gymmy
//
//  Created by Pranav Badgi on 18/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    //Pranav:- Properties
    private var user: User? {
        didSet {
            presentOnBoardingIfNecessary()
            showWelcomeLabel()
        }
    }
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome User"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28)
        label.alpha = 0
        return label
    }()

    //Pranav:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        configureUI()
    }
    
    //Pranav:- API
    
    //if the user is not authenticated when app is started login page will be shown
    func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                self.presentLoginController()
            }
        } else {
                //fetchUser()
            fetchuserWithFirestore()
        }
    }
    
    //fetchUsers here
    func fetchUser() {
        Service.fetchUser { user in
            self.user = user
        }
    }
    
    
    //fetch user with firestore
    func fetchuserWithFirestore() {
        Service.feetchUserWithFirestore { user in
            self.user = user
        }
    }
    
    
    
    //creating a logout func and calling the logout in the Selector handleLogout
    func logout() {
        do {
            try Auth.auth().signOut()
            self.presentLoginController()
            }
            catch {
            print("DEBUG: Error signing out...")
        }
    }
    
    //Pranav:- Helpers
    func configureUI() {
        //setting the gradient background
        configureGradientbackground()
        //setting the navigationbar
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationItem.title = "Welcome to Gymmy"
        //creating a button to handleLogout
        let image = UIImage(systemName: "arrow.left")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        view.addSubview(welcomeLabel)
        welcomeLabel.centerX(inView: view)
        welcomeLabel.centerY(inView: view)
        
    }
    
    //get user name and show welcome label
    fileprivate func showWelcomeLabel() {
        guard let user = user else { return }
        guard user.hasSeenOnboarding else { return }
        welcomeLabel.text = "Welcome, \(user.fullname)"
        UIView.animate(withDuration: 1) {
            self.welcomeLabel.alpha = 1
        }
    }
    
    
    //this part will  bring up the loginController
    fileprivate func presentLoginController() {
        let controller = LoginController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    
    //this will show the onBoardingController
    fileprivate func presentOnBoardingIfNecessary() {
        guard let user = user else { return }
        guard !user.hasSeenOnboarding else { return }
        let controller = OnboardingController()
        controller.modalPresentationStyle = .fullScreen
        //conforming to self
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    //Pranav:- Selectors
    //selector of leftBarButton to handle Logout and calling the logout() here
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to Log Out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.logout()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert,animated: true, completion: nil)
    }
}


//conforming to the delegate created in OnboardingController to toggle true to false
//remeber to confrom to self in presentOnBoardingController
extension HomeController: OnboardingControllerDelegate {
    func controllerWantsToDismiss(_ controller: OnboardingController) {
        controller.dismiss(animated: true, completion: nil)
//        Service.updateUserHasSeenOnboarding { (error, ref) in
//            self.user?.hasSeenOnboarding = true
//            print("DEBUG: Did set has seen onboarding")
//        }
        Service.updateUserHasSeenOnboardingFirestore { error in
            self.user?.hasSeenOnboarding = true
        }
    }
}


extension HomeController: AuthenticationDelegate {
    func authenticationComplete() {
        dismiss(animated: true, completion: nil)
        //fetchUser()
        fetchuserWithFirestore()
    }
}
