//
//  AllClasses.swift
//  CIS4500_A2_JackTolton
//
//  Created by Jack on 2018-02-06.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

class Choice {
    var choiceID = ""
    var choiceExplain = ""
    var nextRoomID = ""
    var reqItem = ""
    var reqDoor = ""
    var reqExplain = ""
    
    //need to add if has a require
    init(_ parse:String) {
        var count = 0
        var newStr = ""
        var index = parse.index(parse.startIndex, offsetBy: 0)
        self.choiceID = String(parse[index])
        for char in parse {
            if char == "\"" {
                count = count + 1
            } else {
                if count == 1 {
                    newStr = newStr + String(char)
                }
            }
            if count == 2 {
                self.choiceExplain = newStr
                break
            }
        }
        index = parse.index(parse.endIndex, offsetBy: -2)
        self.nextRoomID = String(parse[index])
    }
    func addRequirement(_ parse:String) {
        var count = 0
        var newStr = parse.components(separatedBy: "\"")
        var index = newStr.index(newStr.startIndex, offsetBy: 1)
        self.reqItem = newStr[index]
        index = newStr.index(newStr.startIndex, offsetBy: 2)
        let roomHold = newStr[index]
        for c in roomHold {
            if count == 1 {
                self.reqDoor = String(c)
                self.nextRoomID = String(c)
            } else if c == "<" {
                count = 1
            }
        }
        index = newStr.index(newStr.startIndex, offsetBy: 3)
        self.reqExplain = newStr[index]
        
    }
    func retRoomID() -> String {
        if self.nextRoomID == "" {
            return self.reqDoor
        }
        return self.nextRoomID
    }
    func getChoice() -> String {
        return self.choiceID + ". " + self.choiceExplain + self.nextRoomID
    }
    
}
class Room {
    var roomID = ""
    var roomExplain = ""
    var options = [Choice]()
    var reqItem = ""
    var newItem = ""
    var reqExplain = ""
    
    init(_ parse:String) {
        var index = parse.index(parse.startIndex, offsetBy: 1)
        self.roomID = String(parse[index])
        index = parse.index(parse.startIndex, offsetBy: 3)
        self.roomExplain = String(parse[index..<parse.endIndex]).replacingOccurrences(of: "\"", with: "")
    }
    init() {
        
    }
    func getChoice(_ newChoice:Int) -> String {
        let index = self.options.index(self.options.startIndex, offsetBy: newChoice-1)
        return self.options[index].retRoomID()
    }
    func addChoice(_ options:Choice) {
        self.options.append(options)
    }
    func getRoomInfo() -> Array<String>{
        var newArray = [String]()
        newArray.append(self.roomExplain + "\n")
        for row in self.options {
            newArray.append(row.getChoice())
        }
        //newArray.append(self.options.getChoice())
        return newArray
        
    }
    func getRoomID() -> String {
        return self.roomID
    }
    //addRequirement just calls Choices addRequirement function in order to add the specific requirements to that room choice.
    func addRequirement(_ parse: String) {
        if self.options.count == 0 {
            var newStr = parse.components(separatedBy: "\"")
            var index = newStr.index(newStr.startIndex, offsetBy: 1)
            self.reqItem = newStr[index]
            index = newStr.index(newStr.startIndex, offsetBy: 2)
            self.newItem = newStr[index]
            index = newStr.index(newStr.startIndex, offsetBy: 3)
            self.reqExplain = newStr[index]
        } else  {
            let index = self.options.index(options.startIndex, offsetBy: self.options.count-1)
            self.options[index].addRequirement(parse)
        }
    }
    //func addRoomInteraction(_ newAct:)
}

class Inventory {
    var items = [String]()

    init() {
        self.items = [""]
    }
    func addInvy(_ invyStr:String) -> String{
        var newItem = ""
        
        var newStr = invyStr.components(separatedBy: "\"")
        let retStr = newStr[newStr.startIndex]
        for i in 1..<newStr.count {
            let index = newStr.index(newStr.startIndex, offsetBy: i)
            newItem = newStr[index]
            if !self.items.contains(newItem) {
                self.items.append(newItem)
            }
        }
        return retStr
    }
    func removeInvy(_ remove:String) {
        if self.items.contains(remove) {
            if let location = self.items.index(of: remove) {
                self.items.remove(at: location)
            }
        }
    }
    func replaceInvy(_ oldItem:String, _ newItem:String) {
        if self.items.contains(oldItem) && self.items.contains(newItem) {
            //addInvy(newItem)
            removeInvy(oldItem)
        }
        
    }
}












