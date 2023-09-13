//
//  RootViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 11.09.2023.
//

import UIKit

@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String
    let storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            storage.value(forKey: key) as? Value
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }
}

final class RootViewController: UIViewController {
    
    @UserDefaultsBacked<Bool>(key: "is_onboarding_completed") private var isOnboardingCompleted
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarController = TabBarController()
        
        guard let _ = isOnboardingCompleted else {
            let onboardingViewController = OnboardingViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
            
            onboardingViewController.onConfirm = { [weak self] in
                guard let self else { return }
                
                self.isOnboardingCompleted = true
                
                self.removeController(onboardingViewController)
                self.addController(tabBarController)
            }
            
            addController(onboardingViewController)
            return
        }
        
        addController(tabBarController)
        
    }
    
    private func addController(_ viewController: UIViewController) {
        
        addChild(viewController)
        view.addSubview(viewController.view)
        
        guard let tabBarView = viewController.view else { return }
        
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.topAnchor.constraint(equalTo: view.topAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        viewController.didMove(toParent: self)
    }
    
    private func removeController(_ viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}
