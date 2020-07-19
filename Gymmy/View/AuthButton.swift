//
//  AuthButton.swift
//  Gymmy
//
//  Created by Pranav Badgi on 16/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit

//creating a custom button view for login and registration button and is used
//in LoginController and RegistrationController
class AuthButton: UIButton {
    var title: String? {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.3668544842, green: 0.2300799963, blue: 0.6446313389, alpha: 1)
        layer.cornerRadius = 5
        backgroundColor = .clear
        //backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
        setHeight(height: 50)
        isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
