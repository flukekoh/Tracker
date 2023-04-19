//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 08.04.2023.
//

import Foundation
import UIKit

final class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    let daysOfTheWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    // Массив для хранения состояний переключателей (включено или выключено)
    var switchStates: [Bool] = [false, false, false, false, false, false, false]
    // Создаем UITableView
    var weekdaysTableView = UITableView()
    var confirmButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .white
        
        addConfirmButton()
        setupWeekSchedule()
    }
    
    
    func setupWeekSchedule() {
        // Массив с названиями дней недели
        weekdaysTableView = UITableView(frame: .zero, style: .insetGrouped)
        // Устанавливаем делегат и источник данных для UITableView
        weekdaysTableView.delegate = self
        weekdaysTableView.dataSource = self
        
        // Регистрируем ячейку для использования в UITableView
        weekdaysTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Добавляем UITableView на экран
        view.addSubview(weekdaysTableView)
        
        // Устанавливаем ограничения с помощью Auto Layout
        weekdaysTableView.translatesAutoresizingMaskIntoConstraints = false
        
        weekdaysTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        weekdaysTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        weekdaysTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        weekdaysTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor).isActive = true
        
        //
    }
    
    func addConfirmButton() {
        
        view.addSubview(confirmButton)
        
        confirmButton.setTitle("Готово", for: .normal)
        confirmButton.backgroundColor = .black
        
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        confirmButton.layer.cornerRadius = 24
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc
    func didTapConfirmButton() {
        print("make smth")
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
        cell.textLabel?.text = daysOfTheWeek[indexPath.row]
        
        // Создаем переключатель (switch)
        let switchView = UISwitch(frame: .zero)
        switchView.isOn = switchStates[indexPath.row]
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        
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
    @objc private func switchChanged(_ sender: UISwitch) {
        //        guard let cell = sender.superview as? UITableViewCell,
        //              let indexPath = tableView.indexPath(for: cell) else {
        //            return
        //        }
        //
        //        // Обновляем состояние переключателя в массиве
        //        switchStates[indexPath.row] = sender.isOn
    }
}



//import UIKit
//
//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Устанавливаем заголовок экрана
//        title = "Дни недели"
//
//
//    }
//
//    // MARK: - UITableViewDataSource
//
//
//}
