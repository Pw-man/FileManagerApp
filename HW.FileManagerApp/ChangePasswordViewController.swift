//
//  ChangePasswordViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 22.01.2022.
//

import UIKit
import KeychainAccess
import CryptoKit
import RealmSwift

class ChangePasswordViewController: AuthorizationViewController {
    
    override func userLogin() {
        guard let changedPass = logInView.passwordTextField.text else { return }
        if changedPass.count < 5 {
            let alertController = UIAlertController(title: "Пароль не может быть короче 4 символов", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Изменить", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            guard let realm = localRealm else { return }
            guard let user = realm.objects(UserData.self).first else { return }
            do {
                try realm.write({
                    user.password = changedPass
                })
                let alertController = UIAlertController(title: "Пароль успешно изменён!", message: nil, preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.dismiss(animated: true) {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        logInButton.setTitle("Изменить пароль", for: .normal)
        
        UserDefaults.standard.set(true, forKey: "authorized")
    }
}
