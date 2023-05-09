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

protocol TrackerFormViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapConfirmButton(categoryLabel: String, trackerToAdd: Tracker)
}

final class TrackerCreationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    private let choice: Choice
    
    private var tableData: [String]? {
        switch choice {
        case .regular:
            return ["Категория", "Расписание"]
        case .unregular:
            return ["Категория"]
        }
    }
    
    private var schedule = [Weekday]()
    
    private var category = TrackerCategoryData.shared.array[0]
    
    weak var delegate: TrackerFormViewControllerDelegate?
    // MARK: - UI
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        tableView.layer.cornerRadius = 16
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var textField: UITextField = {
        let textField = TextField()
        
        textField.placeholder = "Введите название трекера"
        textField.delegate = self
        textField.layer.cornerRadius = 16
        textField.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
       
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let cancelButton = UIButton()
        
        cancelButton.setTitleColor(.red, for: .normal)
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.setTitle("Отменить", for: .normal)
        
        cancelButton.setTitleColor(UIColor.red, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.cornerRadius = 24
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return cancelButton
    }()
    
    private lazy var confirmButton: UIButton = {
        let confirmButton = UIButton(type: .system)
        
        confirmButton.backgroundColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        confirmButton.setTitleColor(.white, for: .normal)
        
        confirmButton.setTitle("Создать", for: .normal)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.layer.cornerRadius = 24
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        return confirmButton
    }()
    
    private let buttonsStack: UIStackView = {
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
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(integerLiteral: (tableData?.count ?? 0) * 75)),
            
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
        
        let data = tableData?[indexPath.row]
        
        guard let data = data else { return UITableViewCell() }
        
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)
        
        cell.textLabel?.text = "\(data)"
        cell.accessoryType = .disclosureIndicator
        
        if (tableData?.count == 2 && indexPath.row == 1) || (tableData?.count == 1 && indexPath.row == 0) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
        }
        
        let button = UIButton(type: .system)
        button.setTitle("Подробнее", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        //        cell.accessoryView = button
        
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
            scheduleViewController.delegate = self
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
        delegate?.didTapCancelButton()
    }
    
    @objc
    func categoryUIButtonTapped() {
        
    }
    
    @objc
    func didTapConfirmButton() {
        let newTracker = Tracker(
            id: UUID(),
            name: textField.text ?? "ERROR",
            color: .systemTeal,
            emoji: "😇",
            schedule: schedule
        )
        
        delegate?.didTapConfirmButton(categoryLabel: category.title, trackerToAdd: newTracker)
        dismiss(animated: true)
    }
    
    @objc
    func scheduleUIButtonTapped() {
        let scheduleViewController = ScheduleViewController()
        
        scheduleViewController.modalPresentationStyle = .fullScreen
        
        scheduleViewController.delegate = self
        //        self.navigationController?.present(scheduleViewController, animated: true)
        self.present(scheduleViewController, animated: true, completion: nil)
        
    }
}

extension TrackerCreationViewController {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TrackerCreationViewController: ScheduleViewControllerDelegate {
    func didConfirm(_ schedule: [Weekday]) {
        self.schedule = schedule
    }
}

class TextField: UITextField {
    private let textPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
