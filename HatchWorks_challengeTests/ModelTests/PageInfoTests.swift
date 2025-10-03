//
//  PageInfoTests.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import XCTest
@testable import HatchWorks_challenge

final class PageInfoTests: XCTestCase {

    // MARK: - Decoding Tests

    func testPageInfoDecoding_WithNextAndPrev() throws {
        let jsonString = """
        {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character?page=3",
            "prev": "https://rickandmortyapi.com/api/character?page=1"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let pageInfo = try JSONDecoder().decode(PageInfo.self, from: data)

        XCTAssertEqual(pageInfo.count, 826)
        XCTAssertEqual(pageInfo.pages, 42)
        XCTAssertEqual(pageInfo.next, "https://rickandmortyapi.com/api/character?page=3")
        XCTAssertEqual(pageInfo.prev, "https://rickandmortyapi.com/api/character?page=1")
    }

    func testPageInfoDecoding_FirstPage_NoPrev() throws {
        let jsonString = """
        {
            "count": 826,
            "pages": 42,
            "next": "https://rickandmortyapi.com/api/character?page=2",
            "prev": null
        }
        """

        let data = jsonString.data(using: .utf8)!
        let pageInfo = try JSONDecoder().decode(PageInfo.self, from: data)

        XCTAssertEqual(pageInfo.next, "https://rickandmortyapi.com/api/character?page=2")
        XCTAssertNil(pageInfo.prev)
    }

    func testPageInfoDecoding_LastPage_NoNext() throws {
        let jsonString = """
        {
            "count": 826,
            "pages": 42,
            "next": null,
            "prev": "https://rickandmortyapi.com/api/character?page=41"
        }
        """

        let data = jsonString.data(using: .utf8)!
        let pageInfo = try JSONDecoder().decode(PageInfo.self, from: data)

        XCTAssertNil(pageInfo.next)
        XCTAssertEqual(pageInfo.prev, "https://rickandmortyapi.com/api/character?page=41")
    }

    func testPageInfoDecoding_InvalidJSON_ThrowsError() {
        let invalidJSON = """
        {
            "count": "not a number",
            "pages": 42
        }
        """

        let data = invalidJSON.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(PageInfo.self, from: data))
    }
}
