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
                break
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
        return self.choiceID + ". " + self.choiceExplain
    }
    func retReqs() -> Array<String> {
        var newArray = [String]()
        newArray.append(reqItem)
        newArray.append(reqDoor)
        newArray.append(reqExplain)
        return newArray
    }
    //returns true if there is a requirement for the choice
    func checkForReqs() -> Bool {
        if reqItem == "" {
            return false
        }
        return true
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
    var end = 0
    
    init(_ parse:String) {
        var index = parse.index(parse.startIndex, offsetBy: 1)
        self.roomID = String(parse[index])
        index = parse.index(parse.startIndex, offsetBy: 3)
        self.roomExplain = String(parse[index..<parse.endIndex]).replacingOccurrences(of: "\"", with: "")
        //remove whitespace at start of string
        if self.roomExplain.prefix(1) == " " {
            self.roomExplain.remove(at: self.roomExplain.startIndex)
        }
    }
    init() {
        
    }
    // get the room ID of the choice chosen
    func getChoice(_ newChoice:Int) -> String {
        let index = self.options.index(self.options.startIndex, offsetBy: newChoice-1)
        return self.options[index].retRoomID()
    }
    // check if there are requirements for the particular choice
    func checkForReqs(_ newChoice:Int) -> Array<String> {
        let index = self.options.index(self.options.startIndex, offsetBy: newChoice-1)
        return self.options[index].retReqs()
    }
    //add a choice to the array
    func addChoice(_ options:Choice) {
        self.options.append(options)
    }
    //set the ending variable
    func setEnd() {
        self.end = 1
    }
    //get the ending variable
    func getEnd() -> Int {
        return self.end
    }
    /* num is 0 for just a regular room
        1 if you picked up an item
        2 if you are using an item and receiving another
        3 i you are doing both */
    func getRoomInfo(_ num:Int) -> Array<String>{
        var newArray = [String]()
        newArray.append(self.roomExplain)
        if num == 1 {
            newArray.append(self.itemExplain)
        } else if num == 2 {
            newArray.append(self.reqExplain)
        } else if num == 3 {
            newArray.append(self.itemExplain)
            newArray.append(self.reqExplain)
        }
        for row in self.options {
            newArray.append(row.getChoice())
        }
        return newArray
    }
    //get the room ID name  eg A B C
    func getRoomID() -> String {
        return self.roomID
    }
    //parse the requirement string, options.count if the requirement is part of the room or else it will be part of a choice
    func addRequirement(_ parse: String) {
        if self.options.count == 0 {
            var newStr = parse.components(separatedBy: "\"")
            newStr = newStr.filter{$0 != " "}
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
    //add items to the room, and clean up the array after
    func addItems(_ parse:String) {
        var newStr = parse.components(separatedBy: "\"")
        for num in 1..<newStr.count {
            let index = newStr.index(newStr.startIndex, offsetBy: num)
            if num == 1 {
                self.itemExplain = newStr[index]
            } else {
                self.foundItem.append(newStr[index])
            }
        }
        self.foundItem = self.foundItem.filter{$0 != ", "}
        self.foundItem = self.foundItem.filter{$0 != ","}
        self.foundItem = self.foundItem.filter{$0 != ""}
        self.foundItem = self.foundItem.filter{$0 != " "}
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
    //add an item to the inverntory
    func newItemToInvy() -> Array<String> {
        return self.foundItem
    }
    //check requirements for moving to a new location
    func checkReqs(_ invy:Array<String>) -> Array<String> {
        var newArray = [String]()
        if reqItem != "" {
            if invy.contains(self.reqItem) {
                newArray.append(self.reqItem)
                newArray.append(self.newItem)
                newArray.append(self.reqExplain)
            }
        }
        return newArray
    }
}
