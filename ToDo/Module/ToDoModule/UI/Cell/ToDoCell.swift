//
//  ToDoCell.swift
//  ToDo
//
//  Created by Vlad on 30.08.24.
//

import UIKit

final class ToDoCell: UITableViewCell {
    
    //MARK: Public
    var checkmarkImageViewAction: ((Bool) -> Void)?
    
    //MARK: Private
    private var checked: Bool = true {
        didSet {
            checked ? (checkmarkImageView.image = UIImage(systemName: AppAssets.checkmarkImage)) : (checkmarkImageView.image = UIImage(systemName: AppAssets.imageSquare))
        }
    }
    
    //MARK: UI
    private let customView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .systemGray6
        return $0
    }(UIView())
    
    private let checkmarkImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 18)
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 2
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12)
        return $0
    }(UILabel())
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 10
        return $0
    }(UIStackView())
    
    private let hStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 5
        return $0
    }(UIStackView())
        
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        layoutElements()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setupCell(title: String, date: Date, description: String, bool: Bool) {
        titleLabel.text = title
        descriptionLabel.text = description
        checked = bool
        let currentDate = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy\nHH:mm:ss"
        let dateString = dateFormatter.string(from: currentDate)
        dateLabel.text = dateString
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkmarkImageViewTapped))
        checkmarkImageView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutCustomView()
        layoutCheckmarkImageView()
        layoutStackView()
    }
    
    private func layoutCustomView() {
        contentView.addSubview(customView)
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    private func layoutCheckmarkImageView() {
        customView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 50),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 50),
            
            checkmarkImageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -10),
        ])
    }
    
    private func layoutStackView() {
        [dateLabel, descriptionLabel].forEach { hStack.addArrangedSubview($0) }
        [titleLabel, hStack].forEach { vStack.addArrangedSubview($0) }
        customView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            dateLabel.widthAnchor.constraint(equalToConstant: 70),
            
            vStack.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -10),
            vStack.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 10),
            vStack.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: -10),
        ])
    }
}

//MARK: OBJC
extension ToDoCell {
    @objc private func checkmarkImageViewTapped() {
        checked.toggle()
        checkmarkImageViewAction?(checked)
    }
}
