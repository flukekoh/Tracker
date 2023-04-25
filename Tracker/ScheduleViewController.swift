//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 08.04.2023.
//

import Foundation
import UIKit

typealias Closure<T> = (T) -> ()

final class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    let daysOfTheWeek: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    
    var switchStates: [Bool] = [false, false, false, false, false, false, false]
    
    var onChoosed: Closure<[Weekday]>?
    private var resultArray = [Weekday]()
    
    // MARK: - UI
    var weekdaysTableView: UITableView = {
        let weekdaysTableView = UITableView(frame: .zero, style: .insetGrouped)
        
        weekdaysTableView.translatesAutoresizingMaskIntoConstraints = false
        return weekdaysTableView
    }()
    
    var confirmButton: UIButton = {
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
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 60),
            
            weekdaysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weekdaysTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            weekdaysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            weekdaysTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor)
        ])
    }
    
    func setupWeekSchedule() {
        
        weekdaysTableView.delegate = self
        weekdaysTableView.dataSource = self
        weekdaysTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(weekdaysTableView)
    }
    
    @objc
    func didTapConfirmButton() {
        print("make smth")
        dismiss(animated: true) {
            self.onChoosed?(self.resultArray)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfTheWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Устанавливаем текст для ячейки с названием дня недели
        cell.textLabel?.text = daysOfTheWeek[indexPath.row].description
        
        // Создаем переключатель (switch)
        let switchView = UISwitch(frame: .zero)
        
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        switchView.tag = indexPath.row
        
        // Устанавливаем переключатель в качестве accessory view для ячейки
        cell.accessoryView = switchView
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    // MARK: - Private methods
    
    // Обработчик события изменения состояния переключателя
    @objc
    func switchChanged(_ sender: UISwitch) {
        // Получите индекс строки, в которой находится UISwitch
        let row = sender.tag
        // Обновите массив switchValues с новым значением UISwitch
        switchStates[row] = sender.isOn
        
        if sender.isOn {
            resultArray.append(daysOfTheWeek[row])
            
        } else {
            resultArray.removeAll(where: { $0 == daysOfTheWeek[row] })
        }
    }
}
