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
    private var attachmentButton: UIAlertController!
    private let scrollView  =  UIScrollView(frame: .zero)
    private let contentView = UIView(frame: .zero)
    private let imagePicker = UIImagePickerController()
    private let textField   = UITextField()
    
    private var lastBottomConstraint: Constraint?
    private var lastView : UIView?
    
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
        self.setupScrollView()
        self.setupTextField()
        
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-3)
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        textField.snp.makeConstraints { (make) in
            make.left.right.equalTo(view).inset(10)
            make.bottom.equalTo(view).offset(-2)
            make.height.equalTo(30)
        }
    }
    
    // MARK: ITConversationViewControllerProtocol
    func messageSent(message: String) {
        let messageView = self.createTextMessageView(text: message, isSending: true)
        self.addDynamicView(view: messageView, isSending: true)
    }
    
    func messageReceived(message: String) {
        let messageView = self.createTextMessageView(text: message, isSending: false)
        self.addDynamicView(view: messageView, isSending: false)
    }
    
    func messageSent(message: UIImage) {
        let messageView = self.createImageMessageView(image: message, isSending: true)
        self.addDynamicView(view: messageView, isSending: true)
    }
    
    func messageReceived(message: UIImage) {
        let messageView = self.createImageMessageView(image: message, isSending: false)
        self.addDynamicView(view: messageView, isSending: false)
    }
    
    func showError(info: String?) {
        let alert = UIAlertController(title: "Error", message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func goToDetails(forMessage message: Message) {
        let textVC = ITTextMessageDetailsViewController(withMessage: message)
        self.navigationController?.pushViewController(textVC, animated: true)
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
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isUserInteractionEnabled = true
        
        contentView.isUserInteractionEnabled = true
        
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
    }
    
    private func setupAttachmentButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showAttachmentOptions))
        
        attachmentButton = UIAlertController(title: "Send attachment", message: "Select an option", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
    
    private func createImageMessageView(image: UIImage?, isSending: Bool) -> UIView {
        let imageView = UIImageView(frame: .zero)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 40)
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = isSending ? Utils.UIColorFromRGB(rgbValue: 0xe2ffe3) : Utils.UIColorFromRGB(rgbValue: 0xc4c4c4)
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.addGestureRecognizer(self.singleTapGestureForDetails())
        return imageView
    }
    
    private func createTextMessageView(text: String?, isSending: Bool) -> UIView {
        let message = UILabel(frame: .zero)
        message.numberOfLines = 0
        message.lineBreakMode = .byWordWrapping
        message.text = text
        message.font = .systemFont(ofSize: 20, weight: .light)
        message.textColor = isSending ? Utils.UIColorFromRGB(rgbValue: 0x28602a) : Utils.UIColorFromRGB(rgbValue: 0x7a7a7a)
        message.textAlignment = .center
        message.backgroundColor = isSending ? Utils.UIColorFromRGB(rgbValue: 0xe2ffe3) : Utils.UIColorFromRGB(rgbValue: 0xc4c4c4)
        message.isUserInteractionEnabled = true
        message.layer.masksToBounds = true;
        message.layer.cornerRadius = 10.0;
        message.addGestureRecognizer(self.singleTapGestureForDetails())
        
        return message
    }
    
    private func addDynamicView(view: UIView, isSending: Bool) {
        contentView.addSubview(view)
        
        lastBottomConstraint?.deactivate()
        view.snp.makeConstraints { (make) in
            if lastView != nil {
                make.top.equalTo(lastView!.snp.bottom).offset(10)
            } else {
                make.top.equalTo(contentView)
            }
            
            if isSending { // Sending messages are right sided
                make.left.equalTo(contentView.snp.centerX).offset(2)
                make.right.equalTo(contentView).offset(-5)
            } else { // Receiving messages are left sided
                make.left.equalTo(contentView).offset(5)
                make.right.equalTo(contentView.snp.centerX).offset(-2)
            }
            
            lastBottomConstraint = make.bottom.equalTo(scrollView).constraint
            lastBottomConstraint?.activate()
            
            if view.isKind(of: UIImageView.self) {
                make.size.equalTo(100)
            }
        }
        lastView = view
    
        // Animate new added view
        lastView!.frame.size.width -= 30
        lastView!.frame.size.height -= 30
        UIView.animate(withDuration: 0.6, animations: {
            self.lastView!.frame.size.width += 30
            self.lastView!.frame.size.height += 30
        })
    }
    
    
    private func singleTapGestureForDetails() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(messageTapped(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1;
        tapGestureRecognizer.numberOfTouchesRequired = 1
        
        return tapGestureRecognizer
    }
    
    @objc func messageTapped(_ sender: UITapGestureRecognizer) {
        if let viewLabel = sender.view as? UILabel {
            self.presenter.messageDetails(messageId: "ID:4 bytes20519871")
        } else if let viewImage = sender.view as? UIImageView {
            self.presenter.messageDetails(messageId: "test")
        }
    }
    
    @objc func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated:true, completion: nil)
        presenter.sendMessage(image: image)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }*/
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        /*if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }*/
    }
    
    @objc func showAttachmentOptions() {
        self.navigationController?.present(attachmentButton, animated: true, completion: nil)
    }
    
}
