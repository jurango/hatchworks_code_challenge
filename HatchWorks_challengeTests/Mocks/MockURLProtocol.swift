//
//  MockURLProtocol.swift
//  HatchWorks_challengeTests
//
//  Created by Juan Pablo Urango Vitola on 3/10/25.
//

import Foundation

class MockURLProtocol: URLProtocol {

    // MARK: - Mock Response Configuration

    static var mockResponseData: Data?
    static var mockResponse: HTTPURLResponse?
    static var mockError: Error?

    // MARK: - URLProtocol Override

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = MockURLProtocol.mockResponseData {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    // MARK: - Helper Methods

    static func reset() {
        mockResponseData = nil
        mockResponse = nil
        mockError = nil
    }

    static func mockSuccess(data: Data, statusCode: Int = 200, url: URL) {
        mockResponseData = data
        mockResponse = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        mockError = nil
    }

    static func mockFailure(error: Error) {
        mockError = error
        mockResponseData = nil
        mockResponse = nil
    }
}
