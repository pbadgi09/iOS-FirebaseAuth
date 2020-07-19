//
//  AuthenticationViewModel.swift
//  Gymmy
//
//  Created by Pranav Badgi on 17/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit

//creating a protocol which is used in login,registration,resetpassword
//protocol tells the crontroller that the things in them are necessary once
//conformed to them...updateform is necessary for eg.
protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var shouldEnableButton: Bool { get }
    var buttonTitleColor: UIColor { get }
    var buttonBackgroundColor: UIColor { get }
}


//this structure will be used to check is the email & password fields are empty or not
//in the LoginController
//if they are empty button will not be clickable
struct LoginViewModel: AuthenticationViewModel {    
    var email: String?
    var password: String?
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
    var shouldEnableButton: Bool {
        return formIsValid
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    var buttonBackgroundColor: UIColor {
        let enablePurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        let disabelPurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        return formIsValid ? enablePurple : disabelPurple

    }
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
            && fullname?.isEmpty == false
    }
    var shouldEnableButton: Bool {
        return formIsValid
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    var buttonBackgroundColor: UIColor{
        let enablePurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        let disabelPurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        return formIsValid ? enablePurple : disabelPurple
    }
}

struct ResetPasswordViewModel: AuthenticationViewModel {
    var email: String?
    var formIsValid: Bool {
        return email?.isEmpty == false
    }
    var shouldEnableButton: Bool {
        return formIsValid
    }
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    var buttonBackgroundColor: UIColor {
        let enablePurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        let disabelPurple = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        return formIsValid ? enablePurple : disabelPurple
    }
}
