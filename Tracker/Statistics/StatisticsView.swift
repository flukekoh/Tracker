//
//  StatisticsView.swift
//  Tracker
//
//  Created by Артем Кохан on 17.09.2023.
//

import UIKit

final class StatisticsView: UIView {
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 34)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private var number: Int {
        didSet {
            numberLabel.text = "\(number)"
        }
    }
    private var name: String {
        didSet {
            nameLabel.text = name
        }
    }
    
    required init(number: Int = 0, name: String) {
        self.number = number
        self.name = name
        
        super.init(frame: .zero)
        setNumber(number)
        setName(name)
        setupContent()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorder()
    }
    
    func setNumber(_ number: Int) {
        self.number = number
    }
    
    func setName(_ name: String) {
        self.name = name
    }
}


private extension StatisticsView {
    
    func setupContent() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(numberLabel)
        addSubview(nameLabel)
    }
    
    func setupBorder() {
        gradientBorder(
            width: 1,
            colors: UIColor.gradient,
            startPoint: CGPointMake(1.0, 0.5),
            endPoint: CGPointMake(0.0, 0.5),
            andRoundCornersWithRadius: 12
        )
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            numberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            
            nameLabel.leadingAnchor.constraint(equalTo: numberLabel.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: numberLabel.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
    
}

extension UIView {
    private static let kLayerNameGradientBorder = "GradientBorderLayer"

    func gradientBorder(
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = .init(x: 0.5, y: 0),
        endPoint: CGPoint = .init(x: 0.5, y: 1),
        andRoundCornersWithRadius cornerRadius: CGFloat = 0
    ) {
        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? .init()
        border.frame = CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.size.width + width,
            height: bounds.size.height + width
        )
        border.colors = colors.map { $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint

        let mask = CAShapeLayer()
        let maskRect = CGRect(
            x: bounds.origin.x + width/2,
            y: bounds.origin.y + width/2,
            width: bounds.size.width - width,
            height: bounds.size.height - width
        )
        mask.path = UIBezierPath(
            roundedRect: maskRect,
            cornerRadius: cornerRadius
        ).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width

        border.mask = mask

        let isAlreadyAdded = (existingBorder != nil)
        if !isAlreadyAdded {
            layer.addSublayer(border)
        }
    }

    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter {
            $0.name == UIView.kLayerNameGradientBorder
        }
        if borderLayers?.count ?? 0 > 1 {
            assertionFailure()
        }
        return borderLayers?.first as? CAGradientLayer
    }
}


