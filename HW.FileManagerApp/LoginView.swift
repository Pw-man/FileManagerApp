//
//  File.swift
//  HW.FileManagerApp
//
//  Created by Роман on 19.01.2022.
//

import UIKit

class LogInView: UIView {
    
    let nameView = UIView()
    let passwordView = UIView()
    let laneView = UIView()
    let nameTextField = UITextField()
    let passwordTextField = UITextField()
    
    private func viewElementsSettings() {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        passwordTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passwordTextField.autocapitalizationType = .none
        passwordTextField.backgroundColor = .systemGray6
        passwordTextField.placeholder = "Пароль"
        passwordTextField.returnKeyType = .done
        
        nameTextField.textColor = .black
        nameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameTextField.autocapitalizationType = .none
        nameTextField.backgroundColor = .systemGray6
        nameTextField.placeholder = "Email or phone number"
        nameTextField.returnKeyType = .done
        
        nameView.backgroundColor = .systemGray6
        nameView.layer.cornerRadius = 10

        passwordView.backgroundColor = .systemGray6
        passwordView.layer.cornerRadius = 10
        
        laneView.backgroundColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(nameView)
        addSubview(passwordView)
        addSubview(nameTextField)
        addSubview(passwordTextField)
        addSubview(laneView)
        
        viewElementsSettings()
        
        nameView.onAutoLayout()
        passwordView.onAutoLayout()
        laneView.onAutoLayout()
        nameTextField.onAutoLayout()
        passwordTextField.onAutoLayout()
        
        NSLayoutConstraint.activate([
            nameView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .zero),
            nameView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .zero),
            nameView.heightAnchor.constraint(equalToConstant: 50),
            nameView.topAnchor.constraint(equalTo: self.topAnchor),
            
            passwordView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .zero),
            passwordView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .zero),
            passwordView.heightAnchor.constraint(equalToConstant: 50),
            passwordView.topAnchor.constraint(equalTo: nameView.bottomAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: nameView.topAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: nameView.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: nameView.trailingAnchor, constant: -10),
            nameTextField.bottomAnchor.constraint(equalTo: nameView.bottomAnchor, constant: -5),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordView.topAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: passwordView.trailingAnchor, constant: -10),
            passwordTextField.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: -5),
            
            laneView.heightAnchor.constraint(equalToConstant: 0.5),
            laneView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: .zero),
            laneView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .zero),
            laneView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: -0.25)
            
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
