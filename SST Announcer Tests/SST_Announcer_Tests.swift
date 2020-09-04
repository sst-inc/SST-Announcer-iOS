//
//  SST_Announcer_Tests.swift
//  SST Announcer Tests
//
//  Created by JiaChen(: on 4/9/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import XCTest
import URL_Previews

class SST_Announcer_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPresenceAVC() throws {
        let nvc = UIApplication.shared.windows.first?.rootViewController as? UINavigationController
        let avc: UIViewController? = { () -> UIViewController? in
            if I.phone {
                return nvc?.presentingViewController as? AnnouncementsViewController
            } else {
                return nvc?.presentingViewController as? SplitViewController
            }
        }()
        
        XCTAssertNil(avc)
    }
    
    func testRegexSquareBrackets() throws {
        let regex = try! NSRegularExpression(pattern: GlobalIdentifier.regexSquarePattern, options: [])
        
        let testCases = """
        [This is a test test test test test]
        (this is another test)
        HAHAHAHAHAHAHHAHAHA
        What if the [square brackets] are not at the start?
        [multiple] brackets in [one]
        ([)*] because why not
        [a]bcd
        a[b]cd
        ab[*]cd
        abc[0]lets see how this breaks with emojis
        hahahahaha[.q]characters
        wait escapes[\\]
        unicode... [📢]asdnusyfgwer
        unterminated [ brackets
        """
        
        let matches = regex.matches(in: testCases, options: [], range: NSRange(location: 0, length: testCases.count))
        
        XCTAssertEqual(matches.count, 11, accuracy: 0)
    }
    
    func testRegexRoundedBrackets() throws {
        let regex = try! NSRegularExpression(pattern: GlobalIdentifier.regexRoundedPattern, options: [])
        
        let testCases = """
        (This is a test test test test test)
        [this is another test]
        HAHAHAHAHAHAHHAHAHA
        wait escapes(\\)
        round brackets((in)round (brackets))
        unicode... (📢)asdnusyfgwer
        unterminated ( brackets
        abc(a)a
        dus(**)
        (*@)uiq
        this is ([:test])
        how many matches
        this is a failed one because this bracket doesnt start nor end )
        exrcdftvgybhjn:][
        )(
        """
        
        let matches = regex.matches(in: testCases, options: [], range: NSRange(location: 0, length: testCases.count))
        
        XCTAssertEqual(matches.count, 8, accuracy: 0)
    }
    
    // Testing the URL Preview framework
    func testURLPreviews() throws {
        // Replace this with any URL you want
        let url = URL(string: "https://google.com/")!

        // Fetching the page information
        url.fetchPageInfo { (title, description, previewImage) -> Void in
            
            XCTAssertNil(title)
            XCTAssertNil(description)
            XCTAssertNil(previewImage)
            
        } failure: { (message) in
            XCTAssert(false, message)
        }
    }
}
