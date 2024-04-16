//
//  MessageInputView.swift
//  Kkugy
//
//  Created by 신승재 on 4/15/24.
//

import UIKit

class MessageInputView: UIView {
    
    var onSend: ((String) -> Void)?
    
    let textField = UITextField()
    let sendButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        configureLayout()
        setupActions()
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 20
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.1
        
        textField.becomeFirstResponder()
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = .none
        textField.placeholder = "메시지를 입력해주세요."
        textField.backgroundColor = .clear
        textField.returnKeyType = .send
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        addSubview(textField)
        
        sendButton.setTitle("", for: .normal)
        sendButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = .accent
        sendButton.layer.cornerRadius = 17.5
        addSubview(sendButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
            
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 35),
            sendButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupActions() {
        textField.delegate = self
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sendButtonTapped() {
        if let text = textField.text, !text.isEmpty {
            onSend?(text)
            textField.text = ""
        }
    }
}

extension MessageInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, !text.isEmpty {
            onSend?(text)
            textField.text = ""
            return true
        }
        return false
    }
}
