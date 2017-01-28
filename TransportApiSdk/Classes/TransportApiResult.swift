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
    public var Data: T!

    public init()
    {
        self.isSuccess = false
    }
}
