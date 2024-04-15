//
//  MessageInputView.swift
//  Kkugy
//
//  Created by 신승재 on 4/15/24.
//

import UIKit

class MessageInputView: UIView {
    
    let textField = UITextField()
    let sendButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        configureLayout()
    }
    
    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 25
        
        // 텍스트 필드 설정
        textField.borderStyle = .none
        textField.placeholder = "메시지를 입력해주세요."
        textField.backgroundColor = .clear
        addSubview(textField)
        
        // 버튼 설정
        sendButton.setTitle("", for: .normal)
        sendButton.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        sendButton.tintColor = .white
        sendButton.backgroundColor = .accent
        sendButton.layer.cornerRadius = 20  // 버튼을 동그랗게
        addSubview(sendButton)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            // 텍스트 필드 제약 조건
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -16),
            
            // 버튼 제약 조건
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
