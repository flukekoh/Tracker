//
//  TrackerCell.swift
//  Tracker
//
//  Created by Артем Кохан on 06.04.2023.
//

import Foundation
import UIKit

final class TrackerCell: UICollectionViewCell {
    static let identifier = "TrackerCell"
    
    var model: Tracker? {
        didSet {
            mainContentView.backgroundColor = model?.color
            emojiContentView.backgroundColor = .white
            taskLabel.text = model?.name
            emojiLabel.text = model?.emoji
            button.backgroundColor = model?.color
        }
    }
    
    private var counter = 0
    
    // MARK: - UI
    
    private lazy var mainContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiContentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daysCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(counter) дней"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.titleLabel?.textColor = .white
        button.layer.cornerRadius = 23
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LC
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setups
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        addSubview(mainContentView)
        addSubview(daysCountLabel)
        addSubview(button)
        emojiContentView.addSubview(emojiLabel)
        mainContentView.addSubview(emojiContentView)
        mainContentView.addSubview(taskLabel)
        
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiContentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiContentView.centerYAnchor),
            
            emojiContentView.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8),
            emojiContentView.topAnchor.constraint(equalTo: mainContentView.topAnchor, constant: 8),
            emojiContentView.widthAnchor.constraint(equalToConstant: 30),
            emojiContentView.heightAnchor.constraint(equalToConstant: 30),
            
            taskLabel.leadingAnchor.constraint(equalTo: mainContentView.leadingAnchor, constant: 8),
            taskLabel.bottomAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: -8),
            
            mainContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainContentView.topAnchor.constraint(equalTo: topAnchor),
            mainContentView.heightAnchor.constraint(equalToConstant: 150),
            
            daysCountLabel.topAnchor.constraint(equalTo: mainContentView.bottomAnchor, constant: 10),
            daysCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            daysCountLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            button.centerYAnchor.constraint(equalTo: daysCountLabel.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped() {
        counter += 1
    }
}
