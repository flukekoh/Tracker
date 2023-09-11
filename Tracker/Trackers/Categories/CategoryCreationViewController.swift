//
//  CategoryCreationViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 08.09.2023.
//

import UIKit

protocol CategoryCreationViewControllerDelegate: AnyObject {
    func didConfirm(_ data: TrackerCategory.Data)
}

final class CategoryCreationViewController: UIViewController {
    
    private lazy var textField: UITextField = {
        let textField = TextField()
        
        textField.placeholder = "Введите название категории"
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        textField.addTarget(self, action: #selector(didChangedTextField), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.isEnabled = false
        button.backgroundColor = .gray
        button.setTitleColor(.white, for: .normal)
        
        button.setTitle("Готово", for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 24
        return button
    }()
    
    weak var delegate: CategoryCreationViewControllerDelegate?
    private var data: TrackerCategory.Data
    private var isConfirmButtonEnabled: Bool = false {
        willSet {
            if newValue {
                button.backgroundColor = .black
                button.isEnabled = true
            } else {
                button.backgroundColor = .gray
                button.isEnabled = false
            }
        }
    }

    init(data: TrackerCategory.Data = TrackerCategory.Data()) {
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
        
//        textField.text = data.label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    func setupView() {
        title = "Новая категория"
    }
    
    func setupHierarchy() {
        
        view.backgroundColor = .white
        view.addSubview(textField)
        view.addSubview(button)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    @objc
    private func didChangedTextField(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty {
            data.title = text
            isConfirmButtonEnabled = true
        } else {
            isConfirmButtonEnabled = false
        }
    }
    
    @objc
    private func didTapButton() {
        delegate?.didConfirm(data)
    }
}

