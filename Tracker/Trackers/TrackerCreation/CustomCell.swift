//
//  CustomCell.swift
//  Tracker
//
//  Created by Артем Кохан on 11.09.2023.
//

import UIKit

final class CustomCell: UITableViewCell {
    
    private lazy var customItem = CustomItem()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 2
        stack.axis = .vertical
        return stack
    }()
    private let chooseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    static let identifier = "CustomCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(label: String, value: String?, position: CustomItem.Position) {
        customItem.configure(with: position)
        titleLabel.text = label
        
        if let value {
            valueLabel.text = value
        }
    }
}

private extension CustomCell {
    func setupHierarchy() {
        selectionStyle = .none
        contentView.addSubview(customItem)
        contentView.addSubview(labelStack)
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(valueLabel)
        contentView.addSubview(chooseButton)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            customItem.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customItem.topAnchor.constraint(equalTo: contentView.topAnchor),
            customItem.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            customItem.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            labelStack.leadingAnchor.constraint(equalTo: customItem.leadingAnchor, constant: 16),
            labelStack.centerYAnchor.constraint(equalTo: customItem.centerYAnchor),
            labelStack.trailingAnchor.constraint(equalTo: customItem.trailingAnchor, constant: -56),
            
            chooseButton.centerYAnchor.constraint(equalTo: customItem.centerYAnchor),
            chooseButton.trailingAnchor.constraint(equalTo: customItem.trailingAnchor, constant: -24),
            chooseButton.widthAnchor.constraint(equalToConstant: 8),
            chooseButton.heightAnchor.constraint(equalToConstant: 12),
        ])
    }
}

