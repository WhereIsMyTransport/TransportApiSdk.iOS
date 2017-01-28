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

public enum TransportMode: Int
{
    case LightRail = 1
    case Subway = 2
    case Rail = 3
    case Bus = 4
    case Ferry = 5
    case GroundCableCar = 6
    case Gondola = 7
    case Funicular = 8
    case Coach = 9
    case Air = 10
    case ShareTaxi = 11
}
