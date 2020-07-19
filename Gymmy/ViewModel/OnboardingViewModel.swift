//
//  OnboardingViewModel.swift
//  Gymmy
//
//  Created by Pranav Badgi on 23/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import Foundation

struct OnboardingViewModel {
    private let itemCount: Int
    
    init(itemCount: Int) {
        self.itemCount = itemCount
    }
    
    func shouldShowGetStartedButton(forIndex index: Int) -> Bool {
        return index == itemCount - 1 ? true : false
    }
    
}
