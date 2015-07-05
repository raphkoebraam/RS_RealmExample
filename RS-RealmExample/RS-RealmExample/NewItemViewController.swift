//
//  NewItemViewController.swift
//  RealmExample
//
//  Created by Raphael Silva on 7/4/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import Foundation
import UIKit
import Realm

class NewItemViewController: UIViewController, UITextFieldDelegate {
    
    var textField: UITextField?
    var newItemText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.layoutSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textField?.becomeFirstResponder()
    }
    
    // MARK: - Setups
    
    func setupTextField() {
        
        self.textField = UITextField(frame: CGRectZero)
        self.textField?.placeholder = "Tell me: what do you have To-Do?"
        self.textField?.delegate = self
        
        self.view.addSubview(textField!)
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "New To-Do"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneAction")
    }
    
    // MARK: - Layout

    func layoutSubviews() {
        self.setupTextField()
        
        self.setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.textField?.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let viewsDictionary = ["textField": self.textField!, "topLayoutGuide": self.topLayoutGuide] as [NSObject : AnyObject];
        
        let textFieldConstraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-16-[textField]-16-|", options: nil, metrics: nil, views: viewsDictionary)
        let textFieldTopConstraint_H = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide]-30-[textField(100)]-(>=30)-|", options: nil, metrics: nil, views: viewsDictionary)
        
        
        self.view.addConstraints(textFieldConstraint_H)
        self.view.addConstraints(textFieldTopConstraint_H)
    }
    
    // MARK: - Actions
    
    func doneAction() {
        let realm = RLMRealm.defaultRealm()
        
        if count(self.textField!.text.utf16) > 0 {
        
            let newTodoItem = ToDoItem()
            newTodoItem.name = self.textField!.text
            
            realm.transactionWithBlock() {
                realm.addObject(newTodoItem)
            }
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneAction()
        
        textField.resignFirstResponder()
        
        return true
    }
}