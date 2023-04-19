//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 06.04.2023.
//

import Foundation
import UIKit

class TrackerTypeViewController: UIViewController {
    
    let habitUIButton = UIButton()
    let unregularEventUIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Создание трекера"
        
        setupHabit()
        setupUnregularEvent()
        setupStack()
    }
    
    func setupStack(){
        
        let buttonsStack = UIStackView()
        
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 16
        
        view.addSubview(buttonsStack)
        
        buttonsStack.addArrangedSubview(habitUIButton)
        buttonsStack.addArrangedSubview(unregularEventUIButton)
        
        buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
    }
    
    func setupHabit(){
        
        habitUIButton.backgroundColor = .black
        habitUIButton.setTitle("Привычка", for: .normal)
        habitUIButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitUIButton.titleLabel?.textColor = .white
        habitUIButton.layer.cornerRadius = 24
        habitUIButton.addTarget(self, action: #selector(habitUIButtonTapped), for: .touchUpInside)
        
        view.addSubview(habitUIButton)
        
        habitUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        habitUIButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func setupUnregularEvent(){
        
        unregularEventUIButton.backgroundColor = .black
        unregularEventUIButton.setTitle("Нерегулярное событие", for: .normal)
        unregularEventUIButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        unregularEventUIButton.titleLabel?.textColor = .white
        unregularEventUIButton.layer.cornerRadius = 24
        unregularEventUIButton.addTarget(self, action: #selector(unregularButtonTapped), for: .touchUpInside)
        
        view.addSubview(unregularEventUIButton)
        
        unregularEventUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        unregularEventUIButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc
    func habitUIButtonTapped() {
        let trackerCreationViewController = TrackerCreationViewController(choice: .regular)
        let navController = UINavigationController(rootViewController: trackerCreationViewController)
        self.navigationController?.pushViewController(trackerCreationViewController, animated: true)
    }
    
    @objc private func unregularButtonTapped() {
        let trackerCreationViewController = TrackerCreationViewController(choice: .unregular)
        let navController = UINavigationController(rootViewController: trackerCreationViewController)
        self.navigationController?.pushViewController(trackerCreationViewController, animated: true)
    }
    
}
