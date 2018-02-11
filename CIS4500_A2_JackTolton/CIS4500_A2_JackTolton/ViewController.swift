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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileURLProject = Bundle.main.path(forResource: "input", ofType: "txt")
        // Read from the file
        var readStringProject = ""
        do {
            readStringProject = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
            //StoryView.text = readStringProject
            parseContent(readStringProject)
        } catch let error as NSError {
            //print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
    }
    
    func parseContent(_ story:String) {
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
        var myInventory = Inventory()
        var lastLine = 0
        //var roomArray = [Room]()
        for line in lineArray {
            var charIndex = line[line.startIndex]
            switch charIndex {
                case "<":
                //new room
                    let newRoom = Room(line)
                    //StoryView.text = StoryView.text + newRoom.getStr() + "\n"
                case "-":
                    var index = line.index(line.startIndex, offsetBy: 2)
                    if line[index] == "n" {
                        myInventory.addInvy(line)
                    }
                
                case "0"..."9":
                //new invy or if
                //case 0...9:
                    let newChoice = Choice(line)
                    StoryView.text = StoryView.text + newChoice.getStr() + "\n"
                //new decision
            default:
                let nope = ""
            }
            //StoryView.text = StoryView.text + line + "\n"
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

