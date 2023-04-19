//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 07.04.2023.
//

import Foundation
import UIKit

enum Choice {
    case regular
    case unregular
}

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let choice: Choice
    
    var tableData: [String]? {
        switch choice {
        case .regular:
            return ["Категория", "Расписание"]
        case .unregular:
            return ["Категория"]
        }
    }
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Введите название трекера"
        textField.delegate = self
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let cancelButton: UIButton = {
        let cancelButton = UIButton()
        
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle("Отменить", for: .normal)
        //        button.backgroundColor = color
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.cornerRadius = 24
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return cancelButton
    }()
    
    let confirmButton: UIButton = {
        let confirmButton = UIButton()
        
        confirmButton.backgroundColor = .gray
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.borderColor = UIColor.red.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.setTitle("Создать", for: .normal)
        //        button.backgroundColor = color
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.layer.cornerRadius = 24
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        confirmButton.isEnabled = false
        
        return confirmButton
    }()
    
    let buttonsStack: UIStackView = {
        let buttonsStack = UIStackView()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fillEqually
        
        return buttonsStack
    }()
    
    // MARK: - LC
    init(choice: Choice) {
        self.choice = choice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
        setupEmojis()
        setupColors()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @objc
    private func didChangedLabelTextField(_ sender: UITextField) {
        //        guard let text = sender.text else { return }
        //        data.label = text
        //        if text.count > Constants.labelLimit {
        //            isValidationMessageVisible = true
        //        } else {
        //            isValidationMessageVisible = false
        //        }
    }
    // MARK: - Setups
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Новая привычка"
    }
    
    private func setupHierarchy() {
        view.addSubview(textField)
        view.addSubview(tableView)
        
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(cancelButton)
        buttonsStack.addArrangedSubview(confirmButton)
    }
    
    private func setupLayout() {
        //        textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        //        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        //        textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        //        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Получаем данные для текущей ячейки
        let data = tableData?[indexPath.row]
        
        // Устанавливаем текст для ячейки с названием категории и расписанием
        guard let data = data else { return UITableViewCell() }
        cell.textLabel?.text = "\(data)"
        
        // Создаем кнопку "Подробнее"
        let button = UIButton(type: .system)
        button.setTitle("Подробнее", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        cell.accessoryView = button
        
        return cell
    }
    
    @objc
    func buttonTapped() {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            //            guard let schedule = data.schedule else { return }
            let scheduleViewController = ScheduleViewController()
            //            scheduleViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func setupEmojis(){
        
    }
    func setupColors(){
        
    }
    
    @objc
    func didTapCancelButton() {
        
    }
    
    @objc
    func categoryUIButtonTapped() {
        
    }
    
    @objc
    func didTapConfirmButton() {
        
    }
    
    @objc
    func scheduleUIButtonTapped() {
        let scheduleViewController = ScheduleViewController()
        let navController = UINavigationController(rootViewController: scheduleViewController)
        self.navigationController?.pushViewController(scheduleViewController, animated: true)
        
    }
}

extension TrackerCreationViewController {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
