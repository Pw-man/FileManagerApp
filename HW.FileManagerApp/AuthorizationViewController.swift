//
//  AuthorizationViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 19.01.2022.
//

import UIKit
import KeychainAccess
import CryptoKit

class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    let keychain = Keychain(service: "com.myApp")
    
    let logInView = LogInView()
    
    let logInButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(userLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func userLogin() {
        do {
            if let token = try keychain.get("user") {
                guard let password = logInView.passwordTextField.text else { return }
                guard token.isEmpty else {
                    guard token == password else {
                        let alertController = UIAlertController(title: "Неправильный пароль", message: nil, preferredStyle: .alert)
                        let action = UIAlertAction(title: "Изменить", style: .default)
                        alertController.addAction(action)
                        self.present(alertController, animated: true, completion: nil)
                        logInView.passwordTextField.text = ""
                        return
                    }
                    let tabBarController = TabBarController()
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                    logInView.passwordTextField.text = ""
                    return
                }
                if password.count < 5 {
                    let alertController = UIAlertController(title: "Пароль не может быть короче 4 символов", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Изменить", style: .default)
                    alertController.addAction(action)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let inputData = Data(password.utf8)
                    let hashed = SHA256.hash(data: inputData)
                    let confirmPassVC = ConfirmPasswordViewController()
                    confirmPassVC.unconfirmedPassword = hashed
                    self.navigationController?.pushViewController(confirmPassVC, animated: true)
                    logInView.passwordTextField.text = ""
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func UIElementsSettings() {
        logInView.backgroundColor = .systemGray6
        logInView.layer.borderColor = UIColor.lightGray.cgColor
        logInView.layer.borderWidth = 0.5
        logInView.layer.cornerRadius = 10
        
        logInButton.layer.cornerRadius = 10
        logInButton.layer.masksToBounds = true
    }
    
    private func setupConstraints() {
        
        logInView.onAutoLayout()
        logInButton.onAutoLayout()

        NSLayoutConstraint.activate([
            
            logInView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 340),
            logInView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logInView.heightAnchor.constraint(equalToConstant: 50),
            
            logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.topAnchor.constraint(equalTo: logInView.bottomAnchor, constant: 16),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInView.passwordTextField.delegate = self
        
        view.addSubview(logInView)
        view.addSubview(logInButton)
        UIElementsSettings()
        setupConstraints()
        
//                try! keychain
//                    .accessibility(.whenUnlocked)
//                    .set("", key: "user")

        do {
            if let token = try keychain.get("user") {
                guard token.isEmpty else {
                    print("Пароль уже создан пользователем")
                    print("Пароль: \(token)")
                    logInButton.setTitle("Введите пароль", for: .normal)
                    return
                }
                print("Пароль не создан")
                logInButton.setTitle("Создать пароль", for: .normal)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
