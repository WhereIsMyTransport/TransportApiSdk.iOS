//
//  CrowdSourceFrequency.swift
//  Pods
//
//  Created by Chris on 3/17/17.
//
//

import Foundation

public enum CrowdSourceFrequency: Int
{
    // Submits a location when the device is near a stop.
    case atStops
    // Submits the device location at regular intervals.
    case continuous
}
