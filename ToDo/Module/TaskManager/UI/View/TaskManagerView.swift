//
//  TaskManagerView.swift
//  ToDo
//
//  Created by Vlad on 31.08.24.
//

import UIKit

final class TaskManagerView: UIView {
    
    private var lastContentOffset: CGFloat = 0
    private var titleTask: String = ""
    private var descriptionTask: String = ""
    
    //MARK: UI
    private lazy var doneButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Done", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 15
        $0.isEnabled = false
        $0.layer.opacity = 0.4
        $0.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    private lazy var titleTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        $0.placeholder = "Title"
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftView = padding
        $0.leftViewMode = .always
        $0.rightView = padding
        $0.rightViewMode = .always
        $0.delegate = self
        return $0
    }(UITextField())
    
    private lazy var descriptionTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .natural
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 15
        $0.layer.borderColor = UIColor.systemBlue.cgColor
        $0.font = UIFont.systemFont(ofSize: 24)
        
        $0.delegate = self
        return $0
    }(UITextView())
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layoutElements()
        scrollingWhenOpeningKeyboard()
        setupPanGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configuration
    func configuration(title: String, description: String) {
        titleTextField.text = title
        descriptionTextView.text = description
        titleTask = title
        descriptionTask = title
    }
    
    //MARK: Setup
    private func scrollingWhenOpeningKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        descriptionTextView.addGestureRecognizer(panGesture)
    }
    
    //MARK: Layout
    private func layoutElements() {
        layoutDoneButton()
        layoutTitleTextField()
        layoutDescriptionTextView()
    }
    
    private func layoutDoneButton() {
        addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            doneButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            doneButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func layoutTitleTextField() {
        addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            titleTextField.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 5),
            titleTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            titleTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    private func layoutDescriptionTextView() {
        addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 5),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
    
    //MARK: Deinit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: OBJC
extension TaskManagerView {
    
    @objc private func doneButtonTapped() {
        endEditing(true)
        print(titleTextField.text)
        print(descriptionTextView.text)
        print(1)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 20, right: 0)
            descriptionTextView.contentInset = contentInset
            descriptionTextView.scrollIndicatorInsets = contentInset
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        descriptionTextView.contentInset = .zero
        descriptionTextView.contentInset = .zero
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: descriptionTextView)
        if gesture.state == .changed {
            if translation.y > 0 && lastContentOffset <= 0 {
                descriptionTextView.resignFirstResponder()
            }
        }
        lastContentOffset = translation.y
    }
}

//MARK: UITextFieldDelegate
extension TaskManagerView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleTextField {
            guard let text = textField.text else {
                return
            }
            guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                textField.text = ""
                return
            }
            textField.text = text.trimmingCharacters(in: .whitespaces)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

//MARK: UITextViewDelegate
extension TaskManagerView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == descriptionTextView {
            guard let text = descriptionTextView.text else {
                return
            }
            guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                descriptionTextView.text = ""
                return
            }
            descriptionTextView.text = text.trimmingCharacters(in: .whitespaces)
        }
    }
}

//MARK: UIGestureRecognizerDelegate
extension TaskManagerView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
