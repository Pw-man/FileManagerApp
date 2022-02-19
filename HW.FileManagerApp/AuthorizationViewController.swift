//
//  AuthorizationViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 19.01.2022.
//

import UIKit
import RealmSwift
import KeychainAccess

class AuthorizationViewController: UIViewController, UITextFieldDelegate {
    
    let logInView = LogInView()
    
    let logInButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Создать пароль", for: .normal)
        button.addTarget(self, action: #selector(userLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func userLogin() {
        let realm = try! Realm(configuration: RealmConfiguration.config)
        guard let password = logInView.passwordTextField.text else { return }
        guard let login = logInView.nameTextField.text else { return }
        let user = realm.objects(UserData.self).first
        print(realm.objects(UserData.self))
        guard let realmLogin = user?.login, let realmPassword = user?.password else { return }
        guard realmLogin.isEmpty || realmPassword.isEmpty else {
            guard realmPassword == password && realmLogin == login else {
                print("login: \(realmLogin), password: \(realmPassword)")
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
            UserDefaults.standard.set(true, forKey: "authorized")
            return
        }
        if password.count < 5 {
            let alertController = UIAlertController(title: "Пароль не может быть короче 4 символов", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Изменить", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            let confirmPassVC = ConfirmPasswordViewController()
            confirmPassVC.unconfirmedPassword = password
            confirmPassVC.enteredLogin = login
            self.navigationController?.pushViewController(confirmPassVC, animated: true)
            logInView.passwordTextField.text = ""
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
            logInView.heightAnchor.constraint(equalToConstant: 100),
            
            logInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            logInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.topAnchor.constraint(equalTo: logInView.bottomAnchor, constant: 16),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInView.passwordTextField.delegate = self
        do {
            let realm = try Realm(configuration: RealmConfiguration.config)
            let user = realm.objects(UserData.self).first
            
            print("Objects: \(realm.objects(UserData.self))")
            guard let realmLogin = user?.login, let realmPassword = user?.password else { return }
            
            if realmLogin.isEmpty || realmPassword.isEmpty {
            } else {
                logInButton.setTitle("Введите пароль", for: .normal)
            }
        } catch {
            print(error.localizedDescription)
        }
        print(UserDefaults.standard.bool(forKey: "authorized"))
        
        if UserDefaults.standard.bool(forKey: "authorized") {
            let tabBarController = TabBarController()
            self.navigationController?.pushViewController(tabBarController, animated: true)
        } else {
            
            view.addSubview(logInView)
            view.addSubview(logInButton)
            UIElementsSettings()
            setupConstraints()
            
        }
    }
}
