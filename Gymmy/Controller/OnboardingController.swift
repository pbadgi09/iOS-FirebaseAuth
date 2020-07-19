//
//  OnboardingController.swift
//  Gymmy
//
//  Created by Pranav Badgi on 22/04/20.
//  Copyright © 2020 Pranav Badgi. All rights reserved.
//

import UIKit
import paper_onboarding

//creating a protocol to dismiss onboarding once seen
protocol OnboardingControllerDelegate: class {
    //this protocol is class beacuse weak var should be bound to class protocols only
    func controllerWantsToDismiss(_ controller: OnboardingController)
}

class OnboardingController: UIViewController {
    //Pranav:- Properties
    //properties of paperOnboarding
    
    //this is a weak var beacause it prevents memory leaks
    weak var delegate: OnboardingControllerDelegate?
    private var onboardingItems = [OnboardingItemInfo]()
    private var onboardingView = PaperOnboarding()
    private let getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(dismissOnboarding), for: .touchUpInside)
        return button
    }()
    
    //Pranav:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureOnboardingDataSource()
    }
    
    //this works if we are not embedded in navigationbar! else use navigationbar attributes
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Pranav:- Helpers
    func configureUI() {
        view.addSubview(onboardingView)
        //fillsuperView is in the extensions
        onboardingView.fillSuperview()
        //this line makes sure that the extension executes
        onboardingView.delegate = self
        
        view.addSubview(getStartedButton)
        getStartedButton.alpha = 0
        getStartedButton.centerX(inView: view)
        getStartedButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 128)
    }
    
    
    //function to show and hide get started button
    func animateGetStartedButton(_ shouldShow: Bool) {
        let alpha: CGFloat = shouldShow ? 1 : 0
        UIView.animate(withDuration: 0.5) {
            self.getStartedButton.alpha = alpha
        }
    }
    
    //creating dataSource that will be shown in the onBoarding
    func configureOnboardingDataSource() {
        //we'll append this item to the dataSource
        let item1 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "baseline_insert_chart_white_48pt").withRenderingMode(.alwaysOriginal), title: MSG_MERTICS, description: MSG_ONBOARDING_METRICS, pageIcon: UIImage(), color: .systemPurple, titleColor: .white, descriptionColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 16))
        
        let item2 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "baseline_dashboard_white_48pt").withRenderingMode(.alwaysOriginal), title: MSG_DASHBOARD, description: MSG_ONBOARDING_DASHBOARD, pageIcon: UIImage(), color: .systemBlue, titleColor: .white, descriptionColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 16))
        
        let item3 = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "baseline_notifications_active_white_48pt").withRenderingMode(.alwaysOriginal), title: MSG_NOTIFICATIONS, description: MSG_ONBOARDING_NOTIFICATIONS, pageIcon: UIImage(), color: .systemTeal, titleColor: .white, descriptionColor: .white, titleFont: UIFont.boldSystemFont(ofSize: 24), descriptionFont: UIFont.systemFont(ofSize: 16))
        
        onboardingItems.append(item1)
        onboardingItems.append(item2)
        onboardingItems.append(item3)
        onboardingView.dataSource = self
        onboardingView.reloadInputViews()

    }
    
    //Pranav:- Selectors
    
    //selector of getStartedButton
    @objc func dismissOnboarding() {
        delegate?.controllerWantsToDismiss(self)
        print("DEBUG: Dismiss onboarding here...")
    }
}

//conforming to configureOnboardingDataSource
extension OnboardingController: PaperOnboardingDataSource {
    //this tells how many pages we are going to have
    func onboardingItemsCount() -> Int {
        return onboardingItems.count
    }
    
    //this tells how to setup each page
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return onboardingItems[index]
    }
}

//conforming to this extenstion so the button shows up
//only on the last page
extension OnboardingController: PaperOnboardingDelegate {
    func onboardingDidTransitonToIndex(_ index: Int) {
        //created a viewModel to calculate the page and show button
        let viewModel = OnboardingViewModel(itemCount: onboardingItems.count)
        let shouldShow = viewModel.shouldShowGetStartedButton(forIndex: index)
        animateGetStartedButton(shouldShow)
    }
}
