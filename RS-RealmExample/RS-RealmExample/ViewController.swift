//
//  ViewController.swift
//  RealmExample
//
//  Created by Raphael Silva on 7/4/15.
//  Copyright (c) 2015 Raphael Silva. All rights reserved.
//

import UIKit
import Realm

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var todos: RLMResults {
        return ToDoItem.objectsWithPredicate(NSPredicate(format: "finished == false", argumentArray: nil))
    }
    
    var finished: RLMResults {
        return ToDoItem.objectsWithPredicate(NSPredicate(format: "finished == true", argumentArray: nil))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.estimatedRowHeight = 44
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }

    // MARK: - UITableViewDelegate & UITableviewDataSource
    // MARK: > DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return Int(todos.count)
            
        case 1:
            return Int(finished.count)
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        switch indexPath.section {
        case 0:
            let todoItem = todos.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
            
            cell.textLabel?.text = todoItem?.name
            
            cell.textLabel?.enabled = true
            cell.detailTextLabel?.enabled = true
            
            if let date = todoItem?.created {
                var dateFormatter: NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy"
                
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
            }
            
        case 1:
            let todoItem = finished.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
            
            cell.textLabel?.text = todoItem?.name
            
            cell.textLabel?.enabled = false
            cell.detailTextLabel?.enabled = false
            
            if let date = todoItem?.created {
                var dateFormatter: NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy"
                
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(date)
            }
            
        default:
            fatalError("Section not found!")
        }
        
        return cell
    }
    
    // MARK: > Configuring
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "To Do"
            
        case 1:
            if Int(finished.count) > 0 {
                return "Finished"
            } else {
                return ""
            }
            
        default:
            return ""
        }
    }
    
    // MARK: > Managing Selections
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var todoItem: ToDoItem?
        
        let realm = RLMRealm.defaultRealm()
        
        switch indexPath.section {
        case 0:
            todoItem = todos.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
            
            realm.beginWriteTransaction()
            todoItem?.finished = !todoItem!.finished
            realm.commitWriteTransaction()
            
        case 1:
            todoItem = finished.objectAtIndex(UInt(indexPath.row)) as? ToDoItem
            
            realm.transactionWithBlock() {
                realm.deleteObject(todoItem)
            }
            
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        default:
            fatalError("What?")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func addNewToDo(sender: AnyObject) {
        
        let vc = NewItemViewController()
        
        let navController = UINavigationController(rootViewController: vc)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
}

