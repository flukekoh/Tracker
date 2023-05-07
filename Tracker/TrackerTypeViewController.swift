//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 06.04.2023.
//

import Foundation
import UIKit

typealias EmptyClosure = () -> ()

class TrackerTypeViewController: UIViewController {
    
    var onDone: EmptyClosure?
    weak var delegate: TrackerViewController?
    // MARK: - UI
    private let habitUIButton: UIButton = {
        let habitUIButton = UIButton()
        habitUIButton.backgroundColor = .black
        habitUIButton.setTitle("Привычка", for: .normal)
        habitUIButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        habitUIButton.titleLabel?.textColor = .white
        habitUIButton.layer.cornerRadius = 24
        habitUIButton.addTarget(self, action: #selector(habitUIButtonTapped), for: .touchUpInside)
        
        habitUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        return habitUIButton
    }()
    
    private let unregularEventUIButton: UIButton = {
        let unregularEventUIButton = UIButton()
        unregularEventUIButton.backgroundColor = .black
        unregularEventUIButton.setTitle("Нерегулярное событие", for: .normal)
        unregularEventUIButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        unregularEventUIButton.titleLabel?.textColor = .white
        unregularEventUIButton.layer.cornerRadius = 24
        unregularEventUIButton.addTarget(self, action: #selector(unregularButtonTapped), for: .touchUpInside)
        
        unregularEventUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        return unregularEventUIButton
    }()
    
    private let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.axis = .vertical
        buttonsStack.spacing = 16
        
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        
        return buttonsStack
    }()
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        onDone?()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Создание трекера"
    }
    
    private func setupHierarchy() {
        buttonsStack.addArrangedSubview(habitUIButton)
        buttonsStack.addArrangedSubview(unregularEventUIButton)
        
        view.addSubview(buttonsStack)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            habitUIButton.heightAnchor.constraint(equalToConstant: 60),
            
            unregularEventUIButton.heightAnchor.constraint(equalToConstant: 60),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    @objc
    private func habitUIButtonTapped() {
        let trackerCreationViewController = TrackerCreationViewController(choice: .regular)
        let navController = UINavigationController(rootViewController: trackerCreationViewController)
        trackerCreationViewController.navigationItem.hidesBackButton = true
        trackerCreationViewController.delegate = delegate
        self.navigationController?.pushViewController(trackerCreationViewController, animated: true)
    }
    
    @objc private func unregularButtonTapped() {
        let trackerCreationViewController = TrackerCreationViewController(choice: .unregular)
        let navController = UINavigationController(rootViewController: trackerCreationViewController)
        trackerCreationViewController.navigationItem.hidesBackButton = true
        trackerCreationViewController.delegate = delegate
        self.navigationController?.pushViewController(trackerCreationViewController, animated: true)
    }
    
}
