//
//  ChatViewController.swift
//  Kkugy
//
//  Created by 신승재 on 4/11/24.
//

import UIKit
import CoreData

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView!
    private var messageTextField: UITextField!
    private var bottomTextFieldConstraint: NSLayoutConstraint!
    
    var messages: [Message] = []
    var context: NSManagedObjectContext! = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - IBOutlets
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupKeyboardNotifications()
        loadMessages()
    }
    
    // MARK: - Function
    func setupUI() {
        view.setGradientBackground()
        view.setTranslucentBackground()
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
 
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        
        messageTextField = UITextField()
        messageTextField.delegate = self
        messageTextField.placeholder = "메시지를 입력해주세요."
        messageTextField.borderStyle = .roundedRect
        messageTextField.autocorrectionType = .no
        messageTextField.spellCheckingType = .no
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            messageTextField.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            messageTextField.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        bottomTextFieldConstraint = messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        bottomTextFieldConstraint.isActive = true
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func loadMessages() {
        let request: NSFetchRequest<Message> = Message.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        do {
            messages = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
    
    func scrollToBottom(animated: Bool) {
        let lastRow = tableView.numberOfRows(inSection: 0) - 1
        if lastRow >= 0 {
            let indexPath = IndexPath(row: lastRow, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func adjustForKeyboard(notification: Notification, show: Bool) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if show {
            bottomTextFieldConstraint.constant = -keyboardSize.height + view.safeAreaInsets.bottom - 10
        } else {
            bottomTextFieldConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - @obj Function
    @objc func keyboardWillShow(notification: Notification) {
        adjustForKeyboard(notification: notification, show: true)
        scrollToBottom(animated: true)
        
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        adjustForKeyboard(notification: notification, show: false)
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Extension
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = messageTextField.text, !text.isEmpty else { return true }
        
        let newMessage = Message(context: context)
        newMessage.text = text
        newMessage.date = Date()
        newMessage.isSender = true
        //newMessage.isSender = false
        
        do {
            try context.save()
            messages.append(newMessage)
            tableView.reloadData()
            messageTextField.text = ""
        } catch {
            print("Failed to save message: \(error)")
        }
        //textField.resignFirstResponder()
        
        scrollToBottom(animated: true)
        return true
    }
}


extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        let nextMssageSameMinute = indexPath.row < messages.count - 1 && Calendar.current.isDate(messages[indexPath.row].date!, equalTo: messages[indexPath.row + 1].date!, toGranularity: .minute)
        
        cell.configure(with: message.text ?? "", date: message.date!, isSender: message.isSender, showTime: !nextMssageSameMinute)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
    }
}
