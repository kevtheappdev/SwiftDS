//
//  BTreeNode.swift
//  SwiftDS
//
//  Created by Kevin Turner on 1/7/20.
//

import Foundation

class BTreeListNode<T: Comparable> {
    var next: BTreeListNode<T>? = nil
    var val: T
    
    init(val: T) {
        self.val = val
    }
}

class BTreeNode<T: Comparable> {
    private var pointers: [BTreeNode<T>?]
    private var listBegin: BTreeListNode<T>? = nil
    private var listSize: Int = 0
    private var m: Int
   
    
    init(m: Int) {
        self.pointers = Array(repeating: nil, count: m + 1)
        self.m = m
    }
    
    func add(val: T) -> BTreeListNode<T>? {
        if listBegin == nil { // empty list node
            listBegin = BTreeListNode(val: val)
            listSize += 1
            return nil
        } else {
            var i = 0
            var curr = listBegin
            var prev: BTreeListNode<T>? = nil
            var lessThan = true
            // traverse for spot to insert/child pointer to take
            while i < pointers.count && curr != nil && !lessThan {
                if let currNode = curr {
                    lessThan = val < currNode.val
                } else {
                    prev = curr
                    curr = curr?.next
                    i += 1
                }
            }
            
            if !lessThan && i < pointers.count { i += 1 } // account for the item being larger than anything in the list
            
            if let child = pointers[i] { // recursively add from child node
                let childAdd = child.add(val: val)
                if let childNode = childAdd { // if any child promotes, force add here and promote ourselves if necessary
                    return listAdd(curr: curr, prev: prev, val: childNode.val)
                } else {
                    return nil
                }
            }
            
            
            return listAdd(curr: curr, prev: prev, val: val)
        }
    }
    
    
    private func listAdd(curr: BTreeListNode<T>?, prev: BTreeListNode<T>?, val: T) -> BTreeListNode<T>? {
            listSize += 1
            
            if prev == nil { // item was less than everything in the list
                let newBegin = BTreeListNode<T>(val: val)
                newBegin.next = listBegin
                listBegin = newBegin
            } else { // insert operation
                prev?.next = BTreeListNode<T>(val: val)
                prev?.next?.next = curr
            }
            
            if listSize > m { // check if we've exceeded list size to promote accordingly
                
                // find median
                let medianIndex = listSize / 2
                var prev: BTreeListNode<T>? = nil
                var curr = listBegin
                var i = 0
                while curr != nil && i < medianIndex {
                    prev = curr
                    curr = curr?.next
                    i += 1
                }
                
                if let prevNode = prev {
                    prevNode.next = curr?.next // snip out median
                } else {
                    listBegin = curr?.next
                }
                
                if curr == nil { fatalError("fuck, this shouldn't happen")}
                return curr // pass up median for promotion
            }
        
        return nil
    }
    
    func nodeFull() -> Bool {
        return listSize == m
    }
    
    func split(Node node: BTreeNode<T>) -> (leftNode: BTreeNode<T>, rightNode: BTreeNode<T>) {
        let leftNode = BTreeNode<T>(m: m)
        let rightNode = BTreeNode<T>(m: m)
        
        let splitIndex = listSize / 2
        
        // fill left node
        leftNode.listBegin = listBegin
        var curr = listBegin
        var prev: BTreeListNode<T>? = nil
        var i = 0
        while i < splitIndex && curr != nil {
            leftNode.pointers[i] = pointers[i]
            prev = curr
            curr = curr?.next
            i += 1
        }
        
        // TODO: fail out if the indexes are out of bounds here
        i += 1
        leftNode.pointers[i] = pointers[i]
        prev?.next = nil // sever ties with list
        
        
        // fill in right node
        rightNode.listBegin = curr
        while i < pointers.count {
            rightNode.pointers[i] = pointers[i]
            i += 1
        }
        
        return (leftNode, rightNode)
    }
}
