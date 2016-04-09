//
//  Tree.swift
//  labSwiftHW
//
//  Created by Артур Сагидулин on 13.03.16.
//  Copyright © 2016 Артур Сагидулин. All rights reserved.
//
//BSearchTree.swift
postfix operator ++ {}
//
//postfix func -- (inout index: String.CharacterView.Index) {
//    index = index.predecessor()
//}

class BSearchTree<T: Comparable>{
    private var value: T?
    private var left: BSearchTree<T>?
    private var right: BSearchTree<T>?
    weak private var parent: BSearchTree<T>?
    
    init(){}
    
    internal init(value: T, leftChild: BSearchTree?, rightChild: BSearchTree?, parent: BSearchTree?) {
        
        self.value=value
        self.left=leftChild
        self.left?.parent = self
        self.right=rightChild
        self.right?.parent = self
        self.parent=parent
    }
    
    internal convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for value in array.dropFirst() {
            add(value)
        }
    }
    
    internal convenience init(value: T) {
        self.init(value: value,leftChild: nil,rightChild: nil,parent: nil)
    }
    
    
    internal var isRoot: Bool {
        return parent == nil
    }
    
    internal var isLeaf: Bool {
        return right == nil && left == nil
    }
    
    internal var isLeftChild: Bool {
        return parent?.left === self
    }
    
    internal var isRightChild: Bool {
        return parent?.right === self
    }
    
    internal var hasLeftChild: Bool {
        return left != nil
    }
    
    internal var hasRightChild: Bool {
        return right != nil
    }
    internal func add(value: T) {
        insert(value, parent: self)
    }
    
    internal func insert(value: T, parent: BSearchTree) {
        if self.value == nil {
            self.value = value
            return
        }
        if value < self.value {
            if hasLeftChild {
                left?.insert(value, parent: left!)
            } else {
                left = BSearchTree<T>(value: value)
                left?.parent=parent
            }
        } else if value > self.value {
            if hasRightChild {
                right?.insert(value, parent: right!)
            } else {
                right = BSearchTree<T>(value: value)
                right?.parent=parent
            }
        }
    }
    
    
    internal func remove() {
        if hasLeftChild {
            if hasRightChild {
                // This node has two children. It must be replaced by the smallest
                // child that is larger than this node's value, which is the leftmost
                // descendent of the right child.
                let successor = right!.min()
                
                // Rather than deleting the current node (which is problematic for the
                // root node) we give it the successor's value and remove the successor.
                value = successor.value
                
                // If this in-order successor has a right child of its own (it cannot
                // have a left child by definition), then that must take its place.
                successor.remove()
            } else {
                // This node only has a left child. The left child replaces the node.
                reconnectParentToNode(left)
            }
        } else if hasRightChild {
            // This node only has a right child. The right child replaces the node.
            reconnectParentToNode(right)
        } else {
            // This node has no children. We just disconnect it from its parent.
            reconnectParentToNode(nil)
        }
    }
    
    private func reconnectParentToNode(node: BSearchTree?) {
        if !isRoot {
            if isLeftChild {
                parent!.left = node
            } else {
                parent!.right = node
            }
        }
        node?.parent = parent
    }
    internal func search(value: T) -> BSearchTree? {
        var node: BSearchTree? = self
        while case let n? = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                return node
            }
        }
        return nil
    }

    internal func contains(x: T) -> Bool {
        return search(x) != nil
    }
    
    internal func min() -> BSearchTree {
        var node = self
        while case let next? = node.left {
            node = next
        }
        return node
    }
    
  
    internal func max() -> BSearchTree {
        var node = self
        while case let next? = node.right {
            node = next
        }
        return node
    }
    
    internal func traverse() {
        if self.value == nil {
            return
        }
        if hasLeftChild {
            left!.traverse()
        }
        
        print(" "+String(self.value))
        if hasRightChild {
            right!.traverse()
        }
    }
    internal func traverseInOrder(@noescape process: T -> Void) {
        left?.traverseInOrder(process)
        process(value!)
        right?.traverseInOrder(process)
    }
    
    func map(@noescape formula: T -> T) -> [T] {
        var a = [T]()
        if let left = left { a += left.map(formula) }
        a.append(formula(value!))
        if let right = right { a += right.map(formula) }
        return a
    }
    
    internal func toArray() -> [T] {
        return map { $0 }
    }
    
    func commonDescription()->String {
        var s = "Value:'\(value)'"
        if let parent = parent {
            s += ", Parent:'\(parent.value)'"
        }
        if let left = left {
            s += ", Left = [" + left.debugDescription + "]"
        }
        if let right = right {
            s += ", Right = [" + right.debugDescription + "]"
        }
        s+="\n"
        return s

    }
    
    internal var description: String {
        let s = commonDescription()
        return s
    }
    
    internal var debugDescription: String {
        let s = commonDescription()
        return s
    }



}


