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
    private var checked: Bool = false
    
    //MARK: UI
    private let customView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white
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
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.font = UIFont.systemFont(ofSize: 14, weight: .thin)
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        return $0
    }(UILabel())
    
    private let separator: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray6
        $0.heightAnchor.constraint(equalToConstant: 2).isActive = true
        return $0
    }(UIView())
    
    private let labelSeparator: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .black
        $0.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return $0
    }(UIView())
    
    
    private let vStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .leading
        return $0
    }(UIStackView())
    
    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemGray6
        layoutElements()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    func setupCell(title: String, date: Date, description: String, bool: Bool) {
        titleLabel.text = title
        setupDescriptionLabel(description: description)
        descriptionLabel.text = description
        checked = bool
        setupDateLabel(date: date)
        setupcheckmarkImageView()
    }
    
    private func setupDateLabel(date: Date) {
        let currentDate = date
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy\nHH:mm:ss"
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: currentDate)
        dateLabel.text = dateString
    }
    
    private func setupDescriptionLabel(description: String) {
        guard description.isEmpty else {
            descriptionLabel.isHidden = false
            return
        }
        descriptionLabel.isHidden = true
    }
    
    private func setupcheckmarkImageView() {
        let checkmarkImage = UIImage(systemName: AppAssets.checkmarkImage)
        let circleImage = UIImage(systemName: AppAssets.sircleImage)
        checkmarkImageView.image = checked ? checkmarkImage : circleImage
        labelSeparator.isHidden = !checked
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkmarkImageViewTapped))
        checkmarkImageView.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutCustomView()
        layoutVStack()
        layoutCheckmarkImageView()
        layoutSeparator()
        layoutDateLabel()
        layout()
    }
    
    private func layoutCustomView() {
        contentView.addSubview(customView)
    
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutVStack() {
        customView.addSubview(vStack)
        [titleLabel, descriptionLabel].forEach { vStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
        ])
    }
    
    private func layoutCheckmarkImageView() {
        customView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 30),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 30),
            
            checkmarkImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
            checkmarkImageView.centerYAnchor.constraint(equalTo: vStack.centerYAnchor),
            checkmarkImageView.leadingAnchor.constraint(equalTo: vStack.trailingAnchor),
        ])
    }
    
    private func layoutSeparator() {
        customView.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 10),
            separator.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
        ])
    }
    
    private func layoutDateLabel() {
        customView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -20),
        ])
    }
    
    private func layout() {
        titleLabel.addSubview(labelSeparator)
        
        NSLayoutConstraint.activate([
            labelSeparator.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            labelSeparator.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            labelSeparator.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }
}
//MARK: OBJC
extension ToDoCell {
    @objc private func checkmarkImageViewTapped() {
        checked.toggle()
        setupcheckmarkImageView()
        checkmarkImageViewAction?(checked)
    }
}
