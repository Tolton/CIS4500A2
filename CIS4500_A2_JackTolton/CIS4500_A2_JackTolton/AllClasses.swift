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
    func getStr() -> String {
        return self.nextRoomID
    }
    
}

class RoomAction {
    var itemReq = ""
    var itemObtained = ""
    var description = ""
    init(_ require:String, _ obtain:String, _ description:String) {
        self.itemReq = require
        self.itemObtained = obtain
        self.description = description
    }
}

class Room {
    var roomID = ""
    var roomExplain = ""
    var options = [Choice]()
    var action = [RoomAction]()
    
    init(_ parse:String) {
        var index = parse.index(parse.startIndex, offsetBy: 1)
        self.roomID = String(parse[index])
        index = parse.index(parse.startIndex, offsetBy: 3)
        self.roomExplain = String(parse[index..<parse.endIndex])

    }
    func addChoice(_ options:Choice) {
        self.options[self.options.count] = options
    }
    func getStr() -> String {
        return self.roomID + self.roomExplain
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
        for i in 1...newStr.count {
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
            addInvy(newItem)
            removeInvy(oldItem)
        }
        
    }
}












