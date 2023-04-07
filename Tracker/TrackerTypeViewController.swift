//
//  TrackerCreationViewController.swift
//  Tracker
//
//  Created by Артем Кохан on 06.04.2023.
//

import Foundation
import UIKit

class TrackerTypeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addHeader()
        addHabit()
        addUnregularEvent()
    }
    
    func addHeader(){
        let headerLabel = UILabel()
        headerLabel.text = "Создание трекера"
        
        view.addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
    }
    
    func addHabit(){
        let habitUIButton = UIButton()
        habitUIButton.titleLabel?.text = "Привычка"
        habitUIButton.backgroundColor = .black
        habitUIButton.titleLabel?.textColor = .white
        view.addSubview(habitUIButton)
        
        habitUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        habitUIButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        habitUIButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        habitUIButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        habitUIButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func addUnregularEvent(){
        
        let unregularEventUIButton = UIButton()
        unregularEventUIButton.titleLabel?.text = "Нерегулярное событие"
        unregularEventUIButton.backgroundColor = .black
        unregularEventUIButton.titleLabel?.textColor = .white
        
        view.addSubview(unregularEventUIButton)
        
        unregularEventUIButton.translatesAutoresizingMaskIntoConstraints = false
        
        unregularEventUIButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        unregularEventUIButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        unregularEventUIButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        unregularEventUIButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
}
