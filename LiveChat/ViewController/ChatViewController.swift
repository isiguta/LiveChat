//
//  ChatTableViewController.swift
//  LiveChat
//
//  Created by Ihor Sihuta on 9/24/18.
//  Copyright © 2018 hustlehard. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messages: UITableView!
    @IBOutlet weak var messageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let fbAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.dataSource = self
        messages.delegate = self
        messages.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        messageTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messages.addGestureRecognizer(tapGesture)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell") as! CustomMessageCell
        cell.messageBody.text = "lol"
        return cell
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.messageVerticalConstraint.constant = 308
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.messageVerticalConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    @IBAction func logUserOut(_ sender: Any) {
        do {
            try fbAuth.signOut()
        } catch {
            print("Something went wrong with loging out")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
