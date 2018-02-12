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
    private var roomArray = [Room]()
    private var currRoom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileURLProject = Bundle.main.path(forResource: "input", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            
            //StoryView.text = readStringProject
            var roomArray = parseContent(readStringProject)
            loadFirstRoom()
            
            /*StoryView.text = ""
            for row in self.roomArray {
                var newThing = row.getRoomInfo()
                for line in newThing {
                    StoryView.text = StoryView.text  + line + "\n"
                }
            }*/
        } catch let _ as NSError {
            //print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    @IBAction func ExecuteChoice(_ sender: Any) {
        var action = StoryField.text!
        if action > "0" && action <= "9" {
            for row in self.roomArray {
                
                if self.currRoom == row.getRoomID() {
                    
                    if action <= String(row.options.count) {
                        let nextRoom = row.getChoice(Int(action)!)
                        loadRoom(nextRoom)
                        break
                    }
                }
            }
        } else if action == "i" || action == "I" {
            //open invy
        }
    }
    func loadRoom(_ nextRoom:String) {
        var nextStory = [String]()
        for row in self.roomArray {
            if nextRoom == row.getRoomID() {
                nextStory = row.getRoomInfo()
            }
        }
        StoryView.text = ""
        for row in nextStory {
            StoryView.text = StoryView.text + row + "\n"
        }
        self.currRoom = nextRoom
    }
    func loadFirstRoom() {
        
        var index = self.roomArray.index(self.roomArray.startIndex, offsetBy: 0)
        var firstInfo = self.roomArray[index].getRoomInfo()
        self.currRoom = self.roomArray[index].getRoomID()
        for row in firstInfo {
            StoryView.text = StoryView.text + row + "\n"
        }
    }
    
    func parseContent(_ story:String) -> Array<Room>{
        StoryView.text = ""
        var lineArray = [String]()
        var currLine = ""
        for line in story {
            if line != "\n" {
                currLine += String(line)
            } else {
                lineArray.append(currLine)
                currLine = ""
            }
        }
        let myInventory = Inventory()
       
        
        var newRoom = Room()
        for line in lineArray {
            let charIndex = line[line.startIndex]
            
            switch charIndex {
                case "<":
                //new room
                   
                    newRoom = Room(line)
                    self.roomArray.append(newRoom)
                    //StoryView.text = StoryView.text + newRoom.getStr() + "\n"
                case "-":
                    let index = line.index(line.startIndex, offsetBy: 2)
                    if line[index] == "n" {
                        //myInventory.addInvy(line)
                    } else if line[index] == "f" {
                        //StoryView.text = StoryView.text + String(lastLine) + "\n"
                        
                        newRoom.addRequirement(line)
                        
                        
                        //StoryView.text = StoryView.text + String(myInt) + "\n"
                    }
                
                
                case "0"..."9":
                //new invy or if
                //case 0...9:
                    let newChoice = Choice(line)
                    newRoom.addChoice(newChoice)
                    //StoryView.text = StoryView.text + newChoice.getStr() + "\n"
                //new decision
            default:
                let _ = ""
            }
            
            //StoryView.text = StoryView.text + String(newRoom.numChoices()) + "\n"
        }
        
        return roomArray
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

