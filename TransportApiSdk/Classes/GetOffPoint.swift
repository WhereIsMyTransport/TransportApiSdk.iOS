//
//  GetOffPoint.swift
//  Pods
//
//  Created by Chris on 3/16/17.
//
//

import Foundation
import CoreLocation

class GetOffPoint
{
    public var location: CLLocation
    public var name: String
    public var expectedArrivalTime: Date
    public var isNotified: Bool
    
    public init(location: CLLocation,
                name: String,
                expectedArrivalTime: Date)
    {
        self.location = location
        self.name = name
        self.expectedArrivalTime = expectedArrivalTime
        self.isNotified = false
    }
    
}
