//
//  VerifyPasswordViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 22.01.2022.
//

import UIKit
import KeychainAccess
import CryptoKit

class ConfirmPasswordViewController: AuthorizationViewController {
    
    var unconfirmedPassword: SHA256.Digest?
    
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
        do {
            try keychain
                .accessibility(.whenUnlocked)
                .set("\(confirmedPass)", key: "user")
            let tabBarController = TabBarController()
            self.navigationController?.pushViewController(tabBarController, animated: true)
            logInView.passwordTextField.text = ""
        } catch {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        logInButton.setTitle("Повторите пароль", for: .normal)
    }
    
}
