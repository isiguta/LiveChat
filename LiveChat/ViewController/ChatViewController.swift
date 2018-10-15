//
//  ChatTableViewController.swift
//  LiveChat
//
//  Created by Ihor Sihuta on 9/24/18.
//  Copyright © 2018 hustlehard. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messages: UITableView!
    @IBOutlet weak var messageVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let fbAuth = Auth.auth()
    let fbDatabase = Database.database()
    
    var messageArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.dataSource = self
        messages.delegate = self
        
        messages.register(UINib(nibName: "UserMessageCell", bundle: nil), forCellReuseIdentifier: "userMessageCell")
        messages.register(UINib(nibName: "PartnersMessageCell", bundle: nil), forCellReuseIdentifier: "partnersMessageCell")
        
        messageTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messages.addGestureRecognizer(tapGesture)
        
        retrieveMessages()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = messageArray[indexPath.row]
        let cellResourceName = currentMessage.sender == fbAuth.currentUser?.email ? "userMessageCell" : "partnersMessageCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellResourceName) as! CustomMessageCell
        
        prepare(cell: cell, currentMessage)
        
        return cell
    }
    
    func prepare(cell: CustomMessageCell, _ message: Message) {
        cell.messageBody.text = message.messageBody
        cell.avatarImageView.image = UIImage(named: "egg")
        cell.senderUsername.text = message.sender
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
    
    @IBAction func sendMessage(_ sender: Any) {
        messageTextField.endEditing(true)
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = fbDatabase.reference().child("Messages")
        
        let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                                 "MessageBody": messageTextField.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            }
            else {
                print("Message saved successfully!")
            }
            
            self.messageTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextField.text = ""
        }
    }
    
    func retrieveMessages() {
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            self.messages.reloadData()
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
