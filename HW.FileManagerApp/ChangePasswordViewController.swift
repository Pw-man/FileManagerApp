//
//  ChangePasswordViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 22.01.2022.
//

import UIKit
import KeychainAccess
import CryptoKit

class ChangePasswordViewController: AuthorizationViewController {
    
    override func userLogin() {
        guard let changedPass = logInView.passwordTextField.text else { return }
        if changedPass.count < 5 {
            let alertController = UIAlertController(title: "Пароль не может быть короче 4 символов", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Изменить", style: .default)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        } else {
            do {
                try keychain
                    .accessibility(.whenUnlocked)
                    .set("\(changedPass)", key: "user")
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
        logInButton.setTitle("Изменить пароль", for: .normal)
    }
}
