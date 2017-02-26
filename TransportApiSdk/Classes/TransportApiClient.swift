//
//  TransportApi.swift
//  Pods
//
//  Created by Chris on 1/24/17.
//
//

import Foundation
import SwiftyJSON
import CoreLocation

public class TransportApiClient
{
    private let platformURL = "https://platform.whereismytransport.com/api/"
    
    private var transportApiClientSettings: TransportApiClientSettings
    private var tokenComponent: TokenComponent!
    
    public init(transportApiClientSettings: TransportApiClientSettings)
    {
        self.transportApiClientSettings = transportApiClientSettings
        self.tokenComponent = TokenComponent(transportApiClientSettings: transportApiClientSettings)
    }
    
    public func PostJourney(fareProducts: [String]! = nil,
                            onlyAgencies: [String]! = nil,
                            omitAgencies: [String]! = nil,
                            onlyModes: [TransportMode]! = nil,
                            omitModes: [TransportMode]! = nil,
                            exclude: String! = nil,
                            startLocation: CLLocationCoordinate2D,
                            endLocation: CLLocationCoordinate2D,
                            time: Date = Date(),
                            timeType: TimeType = TimeType.DepartAfter,
                            profile: Profile = Profile.ClosestToTime,
                            maxItineraries: Int = 3,
                            completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        TransportApiCalls.PostJourney(tokenComponent: self.tokenComponent,
                                      transportApiClientSettings: self.transportApiClientSettings,
                                      fareProducts: fareProducts,
                                      onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      onlyModes: onlyModes,
                                      omitModes: omitModes,
                                      exclude: exclude,
                                      startLocation: startLocation,
                                      endLocation: endLocation,
                                      time: time,
                                      timeType: timeType,
                                      profile: profile,
                                      maxItineraries: maxItineraries)
        {
            (result: TransportApiResult<Journey>) in
            completion (result)
        }
    }
    
    public func GetJourney(
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        TransportApiCalls.GetJourney(tokenComponent: self.tokenComponent,
                                     transportApiClientSettings: self.transportApiClientSettings,
                                     id: id,
                                    exclude: exclude)
        {
            (result: TransportApiResult<Journey>) in
            completion (result)
        }
    }
    
    public func GetItinerary(
        journeyId: String,
        itineraryId: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Itinerary>) -> Void)
    {
        TransportApiCalls.GetItinerary(tokenComponent: self.tokenComponent,
                                     transportApiClientSettings: self.transportApiClientSettings,
                                     journeyId: journeyId,
                                     itineraryId : itineraryId,
                                     exclude: exclude)
        {
            (result: TransportApiResult<Itinerary>) in
            completion (result)
        }
    }
    
    public func GetAgencies(onlyAgencies: [String]! = nil,
                                  omitAgencies: [String]! = nil,
                                  exclude: String! = nil,
                                  limit: Int = 100,
                                  offset: Int = 0,
                                  completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        TransportApiCalls.GetAgencies(tokenComponent: self.tokenComponent,
                                      transportApiClientSettings: self.transportApiClientSettings,
                                      onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      exclude: exclude,
                                      limit: limit,
                                      offset: offset)
        {
            (result: TransportApiResult<[Agency]>) in
            completion (result)
        }
    }
    
    public func GetAgenciesNearby(onlyAgencies: [String]! = nil,
                            omitAgencies: [String]! = nil,
                            location: CLLocationCoordinate2D! = nil,
                            boundingBox: String! = nil,
                            exclude: String! = nil,
                            radiusInMeters: Int = -1,
                            limit: Int = 100,
                            offset: Int = 0,
                            completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        TransportApiCalls.GetAgencies(tokenComponent: self.tokenComponent,
                                      transportApiClientSettings: self.transportApiClientSettings,
                                      onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      location: location,
                                      exclude: exclude,
                                      radiusInMeters: radiusInMeters,
                                      limit: limit,
                                      offset: offset)
        {
            (result: TransportApiResult<[Agency]>) in
                completion (result)
        }
    }
    
    public func GetAgenciesByBoundingBox(onlyAgencies: [String]! = nil,
                                  omitAgencies: [String]! = nil,
                                  boundingBox: String! = nil,
                                  exclude: String! = nil,
                                  limit: Int = 100,
                                  offset: Int = 0,
                                  completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        TransportApiCalls.GetAgencies(tokenComponent: self.tokenComponent,
                                      transportApiClientSettings: self.transportApiClientSettings,
                                      onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      boundingBox: boundingBox,
                                      exclude: exclude,
                                      limit: limit,
                                      offset: offset)
        {
            (result: TransportApiResult<[Agency]>) in
            completion (result)
        }
    }
    
    public func GetAgency(
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Agency>) -> Void)
    {
        TransportApiCalls.GetAgency(tokenComponent: self.tokenComponent,
                                    transportApiClientSettings: self.transportApiClientSettings,
                                    id: id,
                                      exclude: exclude)
        {
            (result: TransportApiResult<Agency>) in
            completion (result)
        }
    }
    
    public func GetStops(onlyAgencies: [String]! = nil,
                            omitAgencies: [String]! = nil,
                            limitModes: [TransportMode]! = nil,
                            servesLines: [String]! = nil,
                            showChildren: Bool = false,
                            exclude: String! = nil,
                            limit: Int = 100,
                            offset: Int = 0,
                            completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        TransportApiCalls.GetStops(tokenComponent: self.tokenComponent,
                                   transportApiClientSettings: self.transportApiClientSettings,
                                   onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      limitModes: limitModes,
                                      servesLines: servesLines,
                                      showChildren: showChildren,
                                      exclude: exclude,
                                      limit: limit,
                                      offset: offset)
        {
            (result: TransportApiResult<[Stop]>) in
            completion (result)
        }
    }
    
    public func GetStopsNearby(onlyAgencies: [String]! = nil,
                                  omitAgencies: [String]! = nil,
                                  limitModes: [TransportMode]! = nil,
                                  servesLines: [String]! = nil,
                                  showChildren: Bool = false,
                                  location: CLLocationCoordinate2D! = nil,
                                  boundingBox: String! = nil,
                                  exclude: String! = nil,
                                  radiusInMeters: Int = -1,
                                  limit: Int = 100,
                                  offset: Int = 0,
                                  completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        TransportApiCalls.GetStops(tokenComponent: self.tokenComponent,
                                   transportApiClientSettings: self.transportApiClientSettings,
                                   onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      limitModes: limitModes,
                                      servesLines: servesLines,
                                      showChildren: showChildren,
                                      location: location,
                                      exclude: exclude,
                                      radiusInMeters: radiusInMeters,
                                      limit: limit,
                                      offset: offset)
        {
            (result: TransportApiResult<[Stop]>) in
            completion (result)
        }
    }
    
    public func GetStopsByBoundingBox(onlyAgencies: [String]! = nil,
                                         omitAgencies: [String]! = nil,
                                         limitModes: [TransportMode]! = nil,
                                         servesLines: [String]! = nil,
                                         showChildren: Bool = false,
                                         boundingBox: String! = nil,
                                         exclude: String! = nil,
                                         limit: Int = 100,
                                         offset: Int = 0,
                                         completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        TransportApiCalls.GetStops(tokenComponent: self.tokenComponent,
                                   transportApiClientSettings: self.transportApiClientSettings,
                                   onlyAgencies: onlyAgencies,
                                      omitAgencies: omitAgencies,
                                      limitModes: limitModes,
                                      servesLines: servesLines,
                                      showChildren: showChildren,
                                      boundingBox: boundingBox,
                                      exclude: exclude,
                                      limit: limit,
                                      offset: offset)
        {
            (result: TransportApiResult<[Stop]>) in
            completion (result)
        }
    }
    
    public func GetStop(
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Stop>) -> Void)
    {
        TransportApiCalls.GetStop(tokenComponent: self.tokenComponent,
                                  transportApiClientSettings: self.transportApiClientSettings,
                                  id: id,
                                    exclude: exclude)
        {
            (result: TransportApiResult<Stop>) in
            completion (result)
        }
    }
    
    public func GetLines(onlyAgencies: [String]! = nil,
                         omitAgencies: [String]! = nil,
                         limitModes: [TransportMode]! = nil,
                         servesStops: [String]! = nil,
                         exclude: String! = nil,
                         limit: Int = 100,
                         offset: Int = 0,
                         completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        TransportApiCalls.GetLines(tokenComponent: self.tokenComponent,
                                   transportApiClientSettings: self.transportApiClientSettings,
                                   onlyAgencies: onlyAgencies,
                                   omitAgencies: omitAgencies,
                                   limitModes: limitModes,
                                   servesStops: servesStops,
                                   exclude: exclude,
                                   limit: limit,
                                   offset: offset)
        {
            (result: TransportApiResult<[Line]>) in
            completion (result)
        }
    }
    
    public func GetLinesNearby(onlyAgencies: [String]! = nil,
                               omitAgencies: [String]! = nil,
                               limitModes: [TransportMode]! = nil,
                               servesStops: [String]! = nil,
                               location: CLLocationCoordinate2D! = nil,
                               boundingBox: String! = nil,
                               exclude: String! = nil,
                               radiusInMeters: Int = -1,
                               limit: Int = 100,
                               offset: Int = 0,
                               completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        TransportApiCalls.GetLines(tokenComponent: self.tokenComponent,
                                   transportApiClientSettings: self.transportApiClientSettings,
                                   onlyAgencies: onlyAgencies,
                                   omitAgencies: omitAgencies,
                                   limitModes: limitModes,
                                   servesStops: servesStops,
                                   location: location,
                                   exclude: exclude,
                                   radiusInMeters: radiusInMeters,
                                   limit: limit,
                                   offset: offset)
        {
            (result: TransportApiResult<[Line]>) in
            completion (result)
        }
    }
    
    public func GetLinesByBoundingBox(onlyAgencies: [String]! = nil,
                                      omitAgencies: [String]! = nil,
                                      limitModes: [TransportMode]! = nil,
                                      servesStops: [String]! = nil,
                                      boundingBox: String! = nil,
                                      exclude: String! = nil,
                                      limit: Int = 100,
                                      offset: Int = 0,
                                      completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        TransportApiCalls.GetLines(tokenComponent: self.tokenComponent,
                                   transportApiClientSettings: self.transportApiClientSettings,
                                   onlyAgencies: onlyAgencies,
                                   omitAgencies: omitAgencies,
                                   limitModes: limitModes,
                                   servesStops: servesStops,
                                   boundingBox: boundingBox,
                                   exclude: exclude,
                                   limit: limit,
                                   offset: offset)
        {
            (result: TransportApiResult<[Line]>) in
            completion (result)
        }
    }
    
    public func GetLine(
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Line>) -> Void)
    {
        TransportApiCalls.GetLine(tokenComponent: self.tokenComponent,
                                  transportApiClientSettings: self.transportApiClientSettings,
                                  id: id,
                                  exclude: exclude)
        {
            (result: TransportApiResult<Line>) in
            completion (result)
        }
    }
    
    public func GetFareProducts(onlyAgencies: [String]! = nil,
                                      omitAgencies: [String]! = nil,
                                      exclude: String! = nil,
                                      limit: Int = 100,
                                      offset: Int = 0,
                                      completion: @escaping (_ result: TransportApiResult<[FareProduct]>) -> Void)
    {
        TransportApiCalls.GetFareProducts(tokenComponent: self.tokenComponent,
                                          transportApiClientSettings: self.transportApiClientSettings,
                                          onlyAgencies: onlyAgencies,
                                   omitAgencies: omitAgencies,
                                   exclude: exclude,
                                   limit: limit,
                                   offset: offset)
        {
            (result: TransportApiResult<[FareProduct]>) in
            completion (result)
        }
    }
    
    public func GetFareProduct(
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<FareProduct>) -> Void)
    {
        TransportApiCalls.GetFareProduct(tokenComponent: self.tokenComponent,
                                         transportApiClientSettings: self.transportApiClientSettings,
                                         id: id,
                                  exclude: exclude)
        {
            (result: TransportApiResult<FareProduct>) in
            completion (result)
        }
    }
    
    public func GetStopTimetable(
        id: String,
        earliestArrivalTime: Date! = nil,
        latestArrivalTime: Date! = nil,
        limit: Int = 100,
        offset: Int = 0,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<[StopTimetable]>) -> Void)
    {
        TransportApiCalls.GetStopTimetable(tokenComponent: self.tokenComponent,
                                           transportApiClientSettings: self.transportApiClientSettings,
                                           id: id,
                                         earliestArrivalTime: earliestArrivalTime,
                                         latestArrivalTime: latestArrivalTime,
                                         limit: limit,
                                         offset: offset,
                                         exclude: exclude)
        {
            (result: TransportApiResult<[StopTimetable]>) in
            completion (result)
        }
    }
    
    public func GetLineTimetable(
       id: String,
       departureStopIdFilter: String! = nil,
       arrivalStopIdFilter: String! = nil,
       earliestDepartureTime: Date! = nil,
       latestDepartureTime: Date! = nil,
       limit: Int = 100,
       offset: Int = 0,
       exclude: String! = nil,
       completion: @escaping (_ result: TransportApiResult<[LineTimetable]>) -> Void)
    {
        TransportApiCalls.GetLineTimetable(tokenComponent: self.tokenComponent,
                                           transportApiClientSettings: self.transportApiClientSettings,
                                           id: id,
                                           departureStopIdFilter: departureStopIdFilter,
                                           arrivalStopIdFilter: arrivalStopIdFilter,
                                           earliestDepartureTime: earliestDepartureTime,
                                           latestDepartureTime: latestDepartureTime,
                                           limit: limit,
                                           offset: offset,
                                           exclude: exclude)
        {
            (result: TransportApiResult<[LineTimetable]>) in
            completion (result)
        }
    }}
