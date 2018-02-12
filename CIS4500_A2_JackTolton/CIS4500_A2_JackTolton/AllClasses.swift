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
    var itemExplain = ""
    var foundItem = [String]()
    
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
        return newArray
    }
    func getRoomInfoItem() -> Array<String>{
        var newArray = [String]()
        newArray.append(self.roomExplain + "\n")
        newArray.append(self.itemExplain + "\n")
        for row in self.options {
            newArray.append(row.getChoice())
        }
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
    func addItems(_ parse:String) {
        var newStr = parse.components(separatedBy: "\"")
        for num in 1..<newStr.count {
            var index = newStr.index(newStr.startIndex, offsetBy: num)
            if num == 1 {
                self.itemExplain = newStr[index]
            } else {
                self.foundItem.append(newStr[index])
            }
        }
    }
    /* returns true if there is an item the player does not have, false otherwise*/
    func checkInvy(_ invy:Array<String>) -> Bool {
        var count = 0
        if self.foundItem.count > invy.count {
            return true
        }
        for item in self.foundItem {
            if invy.contains(item) {
                count = count + 1
            }
            if count == self.foundItem.count {
                return false
            }
        }
        if count < self.foundItem.count {
            return true
        }
        return false
    }
    func newItemToInvy() -> Array<String> {
        return self.foundItem
    }
    //func addRoomInteraction(_ newAct:)
}
