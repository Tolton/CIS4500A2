//
//  ViewController.swift
//  CIS4500_A2_JackTolton
//
//  Created by Jack on 2018-02-06.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var StoryView: UITextView!
    
    @IBOutlet weak var StoryField: UITextField!
    @IBOutlet weak var ExecuteChoice: UIButton!
    @IBOutlet weak var InventoryView: UITextView!
    private var roomArray = [Room]()
    private var currRoom = ""
    private var inventory = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileURLProject = Bundle.main.path(forResource: "input", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        do {
            self.view.backgroundColor = UIColor.blue
            StoryView.isEditable = false
            InventoryView.isEditable = false
            
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            
            
            parseContent(readStringProject)
            loadFirstRoom()
            
        } catch _ as NSError {
            //print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    @IBAction func ExecuteChoice(_ sender: Any) {
        let action = StoryField.text!
        StoryField.text = ""
        InventoryView.text = "Type i to view your inventory."
        if action > "0" && action <= "9" {
            for row in self.roomArray {
                if self.currRoom == row.getRoomID() {
                    if row.getEnd() == 1 {
                        if action == "1" {
                            //start over
                            selfDestruct()
                            self.viewDidLoad()
                        }
                        if action == "2" {
                            exit(0)
                        }
                    }
                    if action <= String(row.options.count) {
                        var reqArray = row.checkForReqs(Int(action)!)
                        reqArray = reqArray.filter{$0 != ""}
                        if reqArray.count > 0 {
                            var index = reqArray.index(reqArray.startIndex, offsetBy: 0)
                            if self.inventory.contains(reqArray[index]) {
                                index = reqArray.index(reqArray.startIndex, offsetBy: 1)
                                let nextRoom = reqArray[index]
                                
                                loadRoom(nextRoom)
                                break
                            } else {
                                index = reqArray.index(reqArray.startIndex, offsetBy: 2)
                                StoryView.text = StoryView.text + reqArray[index] + "\n"
                            }
                        } else {
                            let nextRoom = row.getChoice(Int(action)!)
                            loadRoom(nextRoom)
                            break
                        }
                    }
                }
            }
            // if user tries to access inventory
        } else if action == "i" || action == "I" {
            InventoryView.text = "Inventory:\n"
            for row in self.inventory {
                
                InventoryView.text = InventoryView.text + row + "\n"
            }
        }
    }
    
    //clear arrays and reset
    func selfDestruct() {
        self.roomArray.removeAll()
        self.currRoom = ""
        self.inventory.removeAll()
    }
    
    //give ending text
    func askEnd() {
        StoryView.text = StoryView.text + "1. Start again.\n"
        StoryView.text = StoryView.text + "2. Exit.\n"
    }
    
    //load the current room into the view
    func loadRoom(_ nextRoom:String) {
        var nextStory = [String]()
        StoryView.text = ""
        var count = 0
        var ending = 0
        for row in self.roomArray {
            if nextRoom == row.getRoomID() {
                count = 0
                if row.getEnd() == 1 {
                    ending = 1
                }
                    if row.checkInvy(self.inventory) {
                        self.inventory = self.inventory + row.newItemToInvy()
                        self.inventory = Array(Set(self.inventory))
                        self.inventory = self.inventory.filter{$0 != " "}
                        self.inventory = self.inventory.filter{$0 != ""}
                        count = 1
                    }
                    var newArray = row.checkReqs(self.inventory)
                    if newArray.count > 0 {
                        if newArray.count == 3 {
                            var index = newArray.index(newArray.startIndex, offsetBy: 0)
                            self.inventory = self.inventory.filter{$0 != newArray[index]}
                            index = newArray.index(newArray.startIndex, offsetBy: 1)
                            self.inventory.append(newArray[index])
                            self.inventory = Array(Set(self.inventory))
                            index = newArray.index(newArray.startIndex, offsetBy: 2)
                            nextStory.append(newArray[index])
                            
                            if count > 0 {
                                count = 3
                            } else {
                                count = 2
                            }
                        }
                        
                    }
                    nextStory = row.getRoomInfo(count)
                
            }
        }
        
        for row in nextStory {
            StoryView.text = StoryView.text + row + "\n"
        }
        self.currRoom = nextRoom
        if ending == 1 {
            askEnd()
            StoryView.text = StoryView.text + "\n"
        }
        InventoryView.text = "Type i to view your inventory."
    }
    
    //load the first room into the view
    func loadFirstRoom() {
        var count = 0
        let index = self.roomArray.index(self.roomArray.startIndex, offsetBy: 0)
        if self.roomArray[index].checkInvy(self.inventory) {
            count = 1
        }
        let firstInfo = self.roomArray[index].getRoomInfo(count)
        self.currRoom = self.roomArray[index].getRoomID()
        for row in firstInfo {
            StoryView.text = StoryView.text + row + "\n"
        }
        InventoryView.text = "Type i to view your inventory."
    }
    
    //parse the content of the file into classes and arrays
    func parseContent(_ story:String) {
        StoryView.text = ""
        var lineArray = [String]()
        var currLine = ""
        for line in story {
            if line != "\n" && line != "\0" {
                currLine += String(line)
            } else {
                lineArray.append(currLine)
                currLine = ""
            }
        }
        if currLine != "" {
            lineArray.append(currLine)
        }
        var newRoom = Room()
        for line in lineArray {
            let charIndex = line[line.startIndex]
            
            switch charIndex {
                case "<":
                //new room
                    newRoom = Room(line)
                    self.roomArray.append(newRoom)
                case "-":
                    let prefixLine = line.prefix(3)
                    if prefixLine == "-if" {
                        newRoom.addRequirement(line)
                    } else if prefixLine == "-in" {
                        newRoom.addItems(line)
                    } else if prefixLine == "-en" {
                        newRoom.setEnd()
                    }
                case "0"..."9":
                    let newChoice = Choice(line)
                    newRoom.addChoice(newChoice)
            default:
                let _ = ""
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

