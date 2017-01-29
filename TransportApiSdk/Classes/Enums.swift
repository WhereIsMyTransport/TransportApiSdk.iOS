//
//  Enums.swift
//  Pods
//
//  Created by Chris on 1/28/17.
//
//

import Foundation

public enum Profile : String
{
    case ClosestToTime
    case FewestTransfers
}

public enum TimeType : String
{
    case ArriveBefore
    case DepartAfter
    
}

public enum TransportMode: String
{
    case LightRail
    case Subway
    case Rail
    case Bus
    case Ferry
    case GroundCableCar
    case Gondola
    case Funicular
    case Coach
    case Air
    case ShareTaxi
}
