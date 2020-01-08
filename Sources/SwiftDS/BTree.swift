//
//  BTree.swift
//  SwiftDS
//
//  Created by Kevin Turner on 1/7/20.
//

import Foundation


class BTree<T: Comparable> {
    let m: Int
    var rootNode: BTreeNode<T>?
    
    init(m: Int) {
        self.m = m
    }
    
    func add(val: T) {
        if rootNode == nil {
            rootNode = BTreeNode(m: m)
        }
        
        if let promotedNode = rootNode?.add(val: val) {
            
        }
        
    }

}
