//
//  CustomtextField.swift
//  Gymmy
//
//  Created by Pranav Badgi on 16/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit

//creating a custom textField view for login and registration button and is used
//in LoginController and RegistrationController
class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        borderStyle = .none
        textColor = .white
        keyboardAppearance = .dark
        layer.cornerRadius = 5
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        setHeight(height: 50)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1.0, alpha: 0.7)])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
