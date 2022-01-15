//
//  ViewController.swift
//  HW.FileManagerApp
//
//  Created by Роман on 14.01.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        let userDefaults = UserDefaults.standard
//        userDefaults.set(0, forKey: "ImageSaving")
//    }
    
    private let reuseID = "cell"
    let fileManager = FileManager.default
    private var contentArray: [URL] = []
    private let tableView = UITableView()
    
    @objc func addImage() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .photoLibrary
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let documentsUrl = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            if let data = editedImage.jpegData(compressionQuality: 1.0) {
//                do {
//                    try data.write(to: imagePath)
                let imageStoragePath = documentsUrl.appendingPathComponent("PickedEditedImage\(UserDefaults.standard.integer(forKey:"ImageSaving")).jpg")
                fileManager.createFile(atPath: imageStoragePath.path , contents: data, attributes: nil)
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "ImageSaving") + 1, forKey: "ImageSaving")
                print(UserDefaults.standard.integer(forKey: "ImageSaving"))
                let content = try! fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
                self.contentArray = content
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
        }
        self.dismiss(animated: true) {
            self.tableView.reloadData()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        
        let documentsUrl = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let content = try! fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
        self.contentArray = content
        print("Images saved in total: \(UserDefaults.standard.integer(forKey: "ImageSaving"))")
        print("Content: \(content)")
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: view.frame.size.width, height: 44))
        view.addSubview(navBar)
        let navItem = UINavigationItem(title: "Добавить фотографию")
        navItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addImage))

        navBar.setItems([navItem], animated: false)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try fileManager.removeItem(at: contentArray[indexPath.row])
            } catch {
                print(error.localizedDescription)
            }
            self.contentArray.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(300)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        if let loaded = UIImage(contentsOfFile: contentArray[indexPath.row].path) {
            content.image = loaded
        }
        cell.contentConfiguration = content
        return cell
    }
}

