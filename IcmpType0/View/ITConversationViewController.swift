//
//  ITConversationViewController.swift
//  IcmpType0
//
//  Created by Franco Risma on 19/07/2018.
//  Copyright © 2018 FRisma. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ITConversationViewController: UIViewController, ITConversationViewControllerProtocol, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var presenter: ITConversationPresenterProtocol!
    private var scrollView =  UIScrollView()
    private var stackView = UIStackView()
    private var textField: UITextField!
    private var imagePicker: UIImagePickerController!
    private var attachmentButton: UIAlertController!
    
    // MARK: Initialization
    init(withPresenter pres: ITConversationPresenterProtocol) {
        presenter = pres
        super.init(nibName: nil, bundle: nil)
        presenter.setViewDelegate(delegate: self)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "BotChat"
        view.backgroundColor = Utils.UIColorFromRGB(rgbValue: 0xeaeaea)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.setupAttachmentButton()
        self.setupImagePicker()
        self.setupScrollAndStackView()
        self.setupTextField()
        
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        textField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).inset(10)
            make.bottom.equalTo(view)
            make.height.equalTo(30)
        }
        
        self.view.bringSubview(toFront: textField)
        
//        for i in 1...150 {
//            self.addMessage(text: "Line \(i)")
//        }
//        for _ in 1 ..< 100 {
//            let vw = UIButton(type: .system)
//            vw.setTitle("Button", for: .normal)
//            stackView.addArrangedSubview(vw)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = stackView.frame.size
    }
    
    // MARK: ITConversationViewControllerProtocol
    func messageSent(message: String) {
        self.addMessage(text: message,
                        color: Utils.UIColorFromRGB(rgbValue: 0x28602a),
                        backgroundColor: Utils.UIColorFromRGB(rgbValue: 0xe2ffe3),
                        alignment: .right)
    }
    
    func messageReceived(message: String) {
        self.addMessage(text: message,
                        color: Utils.UIColorFromRGB(rgbValue: 0x7a7a7a),
                        backgroundColor: Utils.UIColorFromRGB(rgbValue: 0xc4c4c4),
                        alignment: .left)
    }
    
    func messageSent(message: UIImage) {
        let imageView = UIImageView(frame: .zero)
        imageView.image = message
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.addArrangedSubview(imageView)
        self.stackView.layoutIfNeeded()
        scrollView.contentSize = stackView.frame.size
    }
    
    func messageReceived(message: UIImage) {
        let imageView = UIImageView(frame: .zero)
        imageView.image = message
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 70)
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        stackView.addArrangedSubview(imageView)
        self.stackView.layoutIfNeeded()
        scrollView.contentSize = stackView.frame.size
    }
    
    func showError(info: String?) {
        let alert = UIAlertController(title: "Error", message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func showAttachmentOptions() {
        self.navigationController?.present(attachmentButton, animated: true, completion: nil)
    }
    
    func goToDetails() {
        
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.sendText(text: textField.text)
        textField.text=""
        return false
    }
    
    // MARK: Internal
    private func setupImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    private func setupScrollAndStackView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.isUserInteractionEnabled = false
        scrollView.addSubview(stackView)
    }
    
    private func setupAttachmentButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showAttachmentOptions))
        attachmentButton = UIAlertController(title: "Send attachment", message: "Select an option", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            //No-op
        }
        attachmentButton.addAction(cancelActionButton)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default) { _ in
            self.imagePicker.sourceType = .camera
            self.openPhotoLibrary()
        }
        attachmentButton.addAction(cameraButton)
        
        let albumButton = UIAlertAction(title: "Album", style: .default) { _ in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.openPhotoLibrary()
        }
        attachmentButton.addAction(albumButton)
        
    }
    
    private func setupTextField() {
        textField = UITextField()
        textField.delegate = self
        textField.layer.cornerRadius = 10.0
        textField.layer.borderWidth = 0.5
        textField.placeholder = "Type a message";
        textField.backgroundColor = .white
        textField.returnKeyType = .send
        view.addSubview(textField)
    }
    
    private func sendText(text: String?) {
        if text != nil {
            self.presenter.sendMessage(text: text!)
        }
    }
    
    private func sendImage(image: UIImage) {
        self.presenter.sendMessage(image: image)
    }
    
    private func addMessage(text: String?, color: UIColor, backgroundColor: UIColor, alignment: NSTextAlignment) {
        //let message = UIImageView(image: UIImage(named: "chat_bubble_sent"))
        //imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let message = UILabel(frame: .zero)
        message.numberOfLines = 0
        message.lineBreakMode = .byWordWrapping
        message.text = text
        message.font = .systemFont(ofSize: 20, weight: .light)
        message.textColor = color
        message.textAlignment = alignment
        message.backgroundColor = backgroundColor
        message.translatesAutoresizingMaskIntoConstraints = false
        message.isUserInteractionEnabled = true
        message.layer.cornerRadius = 10.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageTapped(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1
        stackView.addArrangedSubview(message)
    }
    
    @objc func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        presenter.sendMessage(image: image)
        dismiss(animated:true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func messageTapped(_ sender: UITapGestureRecognizer) {
        self.presenter.messageDetails()
    }
    
}

//    private func addMessage(/*text: String*/) {
//        //let message = UIImageView(image: UIImage(named: "chat_bubble_sent"))
//        let message = UILabel(frame: .zero)
//        message.text = "Algun mensaje"
//        message.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(message)
//
//        message.snp.makeConstraints { (make) in
//            if latestmessage == nil { // First conversation message
//                make.top.equalTo(self.contentView)
//            } else { // Already talking
//                make.top.equalTo(latestmessage!.snp.bottom).offset(20)
//            }
//            make.left.right.equalTo(contentView).inset(20)
//            //make.width.equalTo(100)
//            make.height.equalTo(50)
//        }
//        latestmessage = message
//    }
//

//    func changeImage(_ name: String) {
//        guard let image = UIImage(named: name) else { return }
//        bubbleImageView.image = image
//            .resizableImage(withCapInsets:
//                UIEdgeInsetsMake(17, 21, 17, 21),
//                            resizingMode: .stretch)
//            .withRenderingMode(.alwaysTemplate)
//    }
//
