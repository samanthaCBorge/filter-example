//
//  Failure.swift
//  FilterExample
//
//  Created by Samantha Cruz on 18/4/24.
//

import Foundation

enum Failure: Error {
    case decodingError
    case urlConstructError
    case APIError(Error)
    case statusCode
}

