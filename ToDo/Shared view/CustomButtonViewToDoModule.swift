//
//  CustomButtonViewToDoModule.swift
//  ToDo
//
//  Created by Vlad on 4.09.24.
//

import UIKit

final class CustomButtonViewToDoModule: UIView {
    
    private let countLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let countLabelView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .systemBlue
        return $0
    }(UILabel())
    
    private let hStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setQuantity(quantity: Int) {
        countLabel.text = String(quantity)
    }
    
    func setColor(color: UIColor) {
        countLabelView.backgroundColor = color
        titleLabel.textColor = color
    }
    
    private func layout() {
        addSubview(hStack)
        hStack.addArrangedSubview(titleLabel)
        hStack.addArrangedSubview(countLabelView)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        countLabelView.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 35),
            countLabel.topAnchor.constraint(equalTo: countLabelView.topAnchor, constant: 1),
            countLabel.bottomAnchor.constraint(equalTo: countLabelView.bottomAnchor, constant: -1),
            countLabel.leadingAnchor.constraint(equalTo: countLabelView.leadingAnchor, constant: 5),
            countLabel.trailingAnchor.constraint(equalTo: countLabelView.trailingAnchor, constant: -5),
        ])
    }
}
