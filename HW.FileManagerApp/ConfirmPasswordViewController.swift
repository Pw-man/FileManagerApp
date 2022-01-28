//
//  VerifyPasswordViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 22.01.2022.
//

import UIKit
import KeychainAccess
import CryptoKit
import RealmSwift

class ConfirmPasswordViewController: AuthorizationViewController {
    
    var unconfirmedPassword: SHA256.Digest?
    var enteredLogin: String!
    
    override func userLogin() {
        guard let confirmedPass = logInView.passwordTextField.text else { return }
        let inputData = Data(confirmedPass.utf8)
        let hashed = SHA256.hash(data: inputData)
        guard unconfirmedPassword == hashed else {
            let alertController = UIAlertController(title: "Пароли не совпадают", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Изменить", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        guard let realm = localRealm else { return }
        guard let user = realm.objects(UserData.self).first else { return }
        do {
            try realm.write({
                user.login = enteredLogin
                user.password = confirmedPass
            })
            let tabBarController = TabBarController()
            self.navigationController?.pushViewController(tabBarController, animated: true)
            logInView.passwordTextField.text = ""
            UserDefaults.standard.set(true, forKey: "authorized")
        } catch {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLayoutConstraint.deactivate([
            logInView.passwordView.topAnchor.constraint(equalTo: logInView.nameView.bottomAnchor),
            logInView.nameView.heightAnchor.constraint(equalToConstant: 50),
            logInView.heightAnchor.constraint(equalToConstant: 100)
        ])
        NSLayoutConstraint.activate([
            logInView.nameView.heightAnchor.constraint(equalToConstant: 0),
            logInView.passwordView.topAnchor.constraint(equalTo: logInView.self.topAnchor),
            logInView.heightAnchor.constraint(equalToConstant: 50)
        ])
        logInView.layoutIfNeeded()
        
        logInView.nameTextField.alpha = 0
        logInView.laneView.alpha = 0
        logInView.nameView.alpha = 0
        view.backgroundColor = .white
        logInButton.setTitle("Повторите пароль", for: .normal)
    }
    
}
