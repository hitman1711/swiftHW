//
//  ViewController.swift
//  labSwiftHW
//
//  Created by Артур Сагидулин on 05.03.16.
//  Copyright © 2016 Артур Сагидулин. All rights reserved.
//

import UIKit

postfix operator ++ {}
postfix func ++ (inout index: String.CharacterView.Index) {
    index = index.successor()
}
postfix func -- (inout index: String.CharacterView.Index) {
    index = index.predecessor()
}


class ViewController: UIViewController {
    @IBOutlet weak var palindromeAnswerLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var trimmedLabel: UILabel!
    
    var ignoreCase=false
    var ignoreSpaces=false
    
    @IBAction func pFieldChanged(sender: AnyObject) {
        
        let tField: UITextField=sender as! UITextField
        var processingStr: String = tField.text!
        processingStr=ignoreSpaces ? processingStr.stringByReplacingOccurrencesOfString(" ", withString: "") : processingStr
        processingStr=ignoreCase ? processingStr.lowercaseString : processingStr
        
        let unicodeScalarInts: [UInt32] = processingStr.unicodeScalars.map {UInt32($0.value)}
        var timer = RunningTimer.init()
        
        timer.start()
        let simplePalindromeTest = isPalindromeSimple(unicodeScalarInts)
        timer.stop()
        print("\n SIMPLE check: \(simplePalindromeTest)\n  time: \(timer)")
        
        timer.start()
        let recursivePalindromeTest = isPalindromeRecursive(unicodeScalarInts)
        //(Array(processingStr.utf16))
        timer.stop()
        
        print("RECURSIVE : \(recursivePalindromeTest)")
        print("  time: \(timer)")
        
        timer.start()
        let uniFastPalindromeTest = isPalindromeUnicodeFast(unicodeScalarInts)
        timer.stop()
        print("UNICODE FAST check: \(uniFastPalindromeTest)")
        print("  time : \(timer)")

        
        timer.start()
        let uniPalindromeTest = isPalindromeUnicode(processingStr)
        timer.stop()
        print("UNICODE check: \(uniPalindromeTest)")
        print("  time : \(timer)")
        
        
        
        palindromeAnswerLabel.text="is palindrome: \(uniFastPalindromeTest)"
        
    }
    
    @IBAction func ignoreSpacesSwitched(sender: UISwitch) {
        ignoreSpaces=sender.on
    }
    
    @IBAction func ignoreCaseSwitched(sender: UISwitch) {
        ignoreCase=sender.on
    }
    
    @IBAction func RemoveLongestTapped(sender: UIButton) {
        let result = deleteLongestWhitespaceSequence(textField.text)
        trimmedLabel.text = result
    }
    @IBAction func RemoveSpacesTapped(sender: UIButton) {
        let result = removeExtraSpacesFromString(textField.text)
        trimmedLabel.text = result
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let strings: [String] = ["ccg443vs","tsd4","1","5dsgz","ыав","gsgsgdgwwr4"]
        let tree: BSearchTree = BSearchTree<String>()
        for str in strings {
            tree.add(str)
        }
//        tree.search("tsd4")?.remove()
        let sortedArray = tree.toArray()
        print("sortedArray: \(sortedArray.description)")
        
    }
    

    func isPalindromeSimple(unicodeInts: Array<UInt32>)->Bool{
        
        let reversedInts: [UInt32] = unicodeInts.reverse()

        if unicodeInts==reversedInts{
            return true
        }
        return false
    }

    
    //Very Fast!!!
    func isPalindromeRecursive(var unicodeInts: Array<UInt32>) -> Bool{
        if unicodeInts.count<2 {return true}
        if unicodeInts.first == unicodeInts.last {
//            let trimmedString = utfString[startingIndex.successor()..<endIndex.predecessor()]
            unicodeInts.removeFirst()
            unicodeInts.removeLast()
            return self.isPalindromeRecursive(Array(unicodeInts))
        } else {
            return false
        }
    }
    
    func isPalindromeUnicodeFast(var unicodeInts: [UInt32]) -> Bool  {
        if unicodeInts.count<2 {return true}
        
        while (unicodeInts.count>1) {
            if unicodeInts.first != unicodeInts.last {
                return false
            } else {
                unicodeInts.removeFirst()
                unicodeInts.removeLast()
            }
        }
        //        var range = unicodeInts.count
        //        range = unicodeInts.count>4 ? range-1 : range
        //        range = unicodeInts.count > 2 ? range/2 : range
//        for var index = 0 ; index < range; index++  {
//            if unicodeInts[index] != unicodeInts[unicodeInts.count-1 - index]{
//                return false
//            }
//        }
        return true;
    }

    
//    <S: CollectionType where S.SubSlice : CollectionType,
//    S.SubSlice.Generator.Element == S.Generator.Element,
//    S.SubSlice.SubSlice == S.SubSlice,
//    S.Generator.Element : Comparable,  S.Index : IntegerArithmeticType, S.Index : IntegerLiteralConvertible, S.Index : BidirectionalIndexType >
    
    
//    <C: MutableCollectionType where C.Index==Int, C.Generator.Element==UInt>
 
    
    // The Fastest if using utf16, but unsupport emoji!
    func isPalindromeUnicode(string: String) -> Bool  {
        let characters = string.characters//utf16//Array(string.characters);
        if characters.count<2 {return true}
        
        var range = characters.count
        range = characters.count>4 ? range-1 : range
        range = characters.count > 2 ? range/2 : range
        
        
        var endIdx = characters.endIndex.predecessor()
        characters.endIndex
        for var startIdx=characters.startIndex; startIdx < endIdx;startIdx++ {
            if characters[startIdx] != characters[endIdx] {
                return false
            }
            if endIdx != characters.startIndex {
                endIdx--
            }
        }
        return true;
    }
    

   
    
    func removeExtraSpacesFromString(string: String!)->String{

        var timer = RunningTimer.init()
        
        //Slowest
        timer.start()
        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let filtered = components.filter({!$0.isEmpty})
        let separatedCompsResult = filtered.joinWithSeparator(" ")
        print("  SeparatedCompsResult: <\(separatedCompsResult)> \n time: \(timer)")
        
        timer.start()   // Fastest
        let splitMapResult = string.characters
            .split { $0 == " " }
            .map { String($0) }
            .joinWithSeparator(" ")
        print("  SplitMapResult: <\(splitMapResult)> \n time: \(timer)")
        
        timer.start()
        
        var replacingPatternResult = string.stringByTrimmingCharactersInSet(.whitespaceCharacterSet())
        replacingPatternResult = replacingPatternResult.stringByReplacingOccurrencesOfString(
            "\\s+",
            withString: " ",
            options: .RegularExpressionSearch)
        print("  ReplacingPatternResult: <\(replacingPatternResult)> \n time: \(timer)")
        
        return splitMapResult
    }
    
    func deleteLongestWhitespaceSequence(var string: String!)->String{
        let shouldTrimString = false
        
        var result: String = ""
        var timer = RunningTimer.init()
        
        string = shouldTrimString ? string.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()) : string
        
        var fullRange: Range<String.Index> { return string.startIndex..<string.endIndex }
        
        
        let pattern = "\\s+"
        
        
        do {
            let rOptions = NSRegularExpressionOptions(rawValue: 0)
            //NSRegularExpressionOptions.CaseInsensitive
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: rOptions)
            let nsstr = string as NSString
            let nsFullRange = NSMakeRange(0, nsstr.length)
            
            timer.start()
            var longestRange: NSRange=NSMakeRange(0, 0)
            regex.enumerateMatchesInString(string, options: NSMatchingOptions(rawValue: 0), range: nsFullRange, usingBlock: { (res : NSTextCheckingResult?, flgs :NSMatchingFlags, _) -> Void in
                
                let range = res!.range
                
                longestRange = range.length>longestRange.length ? range : longestRange
            })
            let enumeratedResult: String = nsstr.stringByReplacingCharactersInRange(longestRange, withString: " ")
            print("  EnumeratedResult: <\(enumeratedResult)> \n time: \(timer)")
            
            result = enumeratedResult
            
            
            timer.start()
            let matchesSearchResults = regex.matchesInString(string,
                options: [], range: nsFullRange).filter { (res) -> Bool in
                    res.range.length>1
            }
            let regexMatchingTime = timer.stop()
            
            timer.start()
            let matchesStrings = matchesSearchResults.map { nsstr.substringWithRange($0.range)}
            let longestChoice: String = matchesStrings.reduce(String(),combine: { if $1.characters.count > $0.characters.count { return $1 } else { return $0 } })
            let combineResult = string.stringByReplacingOccurrencesOfString(longestChoice, withString: " ")
            
            let combSumTime = timer.stop()+regexMatchingTime
            
            print("  CombineResult: <\(combineResult)> \n time: \(timer.convertToReadableString(combSumTime))")
            result=combineResult
            
            // var rangePointerWrapper: [NSRange] = [nsFullRange]
            timer.start()
            if matchesSearchResults.count<1 {return result}
            let initial = matchesSearchResults[0]
            let longestResult: NSTextCheckingResult = matchesSearchResults.reduce(initial){(let first,second ) -> NSTextCheckingResult in
                let flength = first.range.length
                let slength = second.range.length
                return flength>slength ? first : second
            }
            let reducedRangesResult: String = nsstr.stringByReplacingCharactersInRange(longestResult.range, withString: " ")
            
            let reducedSumTime = timer.stop()+regexMatchingTime
            print("  ReducedRangesResult: <\(reducedRangesResult)> \n time: \(timer.convertToReadableString(reducedSumTime))")
            
            return result
        } catch let error as NSError {
            let errorStr = "invalid regex: \(error.localizedDescription)"
            print(errorStr)
            return errorStr
        } catch {
            
        }
        return result
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

