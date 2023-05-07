//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 08.04.2023.
//

import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didConfirm(_ schedule: [Weekday])
}

final class ScheduleViewController: UIViewController  {
    private let daysOfTheWeek: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    private var switchStates: [Bool] = [false, false, false, false, false, false, false]

    private var resultArray = [Weekday]()
    weak var delegate: ScheduleViewControllerDelegate?
    // MARK: - UI
    private var weekdaysTableView: UITableView = {
        let weekdaysTableView = UITableView(frame: .zero, style: .insetGrouped)
 
        weekdaysTableView.isScrollEnabled = false
        weekdaysTableView.rowHeight = 75
        weekdaysTableView.layoutMargins = UIEdgeInsets.zero
        weekdaysTableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        weekdaysTableView.layer.cornerRadius = 16

        weekdaysTableView.separatorInset = UIEdgeInsets.zero

        weekdaysTableView.backgroundColor = .white
        weekdaysTableView.translatesAutoresizingMaskIntoConstraints = false
        return weekdaysTableView
    }()
    
    private lazy var confirmButton: UIButton = {
        var confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Готово", for: .normal)
        confirmButton.backgroundColor = .black
        
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.layer.cornerRadius = 24
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        return confirmButton
    }()
    
    // MARK: - LC
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
    }
    
    // MARK: - Setups
    
    private func setupView() {
        title = "Расписание"
        view.backgroundColor = .white
    }
    private func setupHierarchy() {
        view.addSubview(confirmButton)
        
        setupWeekSchedule()
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
            weekdaysTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekdaysTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekdaysTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weekdaysTableView.heightAnchor.constraint(equalToConstant: 525),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupWeekSchedule() {
        
        weekdaysTableView.delegate = self
        weekdaysTableView.dataSource = self
        weekdaysTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(weekdaysTableView)
    }
    
    @objc
    private func didTapConfirmButton() {
        let weekdays = self.resultArray
        delegate?.didConfirm(weekdays)
        dismiss(animated: true) 
    }

    @objc
    private func switchChanged(_ sender: UISwitch) {
        let row = sender.tag
        switchStates[row] = sender.isOn
        
        if sender.isOn {
            resultArray.append(daysOfTheWeek[row])
        } else {
            resultArray.removeAll(where: { $0 == daysOfTheWeek[row] })
        }
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfTheWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text = daysOfTheWeek[indexPath.row].description
        cell.backgroundColor = UIColor(red: 0.902, green: 0.91, blue: 0.922, alpha: 0.3)

        let switchView = UISwitch(frame: .zero)
        
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchView.tag = indexPath.row
        
        cell.accessoryView = switchView
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


