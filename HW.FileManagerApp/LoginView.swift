//
//  File.swift
//  HW.FileManagerApp
//
//  Created by Роман on 19.01.2022.
//

import UIKit

class LogInView: UIView {
    
     let passwordView = UIView()
     let passwordTextField = UITextField()
    
    private func viewElementsSettings() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.placeholder = "Пароль"
        passwordTextField.returnKeyType = .done

        passwordView.backgroundColor = .systemGray6
        passwordView.layer.cornerRadius = 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(passwordView)
        addSubview(passwordTextField)

        viewElementsSettings()
        
        passwordView.onAutoLayout()
        passwordTextField.onAutoLayout()
        
        NSLayoutConstraint.activate([
            passwordView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .zero),
            passwordView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .zero),
            passwordView.heightAnchor.constraint(equalToConstant: 50),
            passwordView.topAnchor.constraint(equalTo: self.topAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordView.topAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: -10),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: -5),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func onAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
