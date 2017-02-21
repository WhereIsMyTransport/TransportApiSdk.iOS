//
//  TransportApiResult.swift
//  Pods
//
//  Created by Chris on 1/28/17.
//
//

import Foundation

public class TransportApiResult<T>
{
    public var httpStatusCode: Int!
    public var isSuccess: Bool
    public var error: String!
    public var rawJson: String!
    public var data: T!

    public init()
    {
        self.isSuccess = false
    }
}
