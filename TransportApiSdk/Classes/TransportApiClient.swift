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
    private static let platformURL = "https://platform.whereismytransport.com/api/"
    
    private static var transportApiClientSettings: TransportApiClientSettings?
    private static var tokenComponent: TokenComponent?
    
    /// Entry point to the SDK.
    open class func loadCredentials(clientId: String, clientSecret: String)
    {
        self.transportApiClientSettings = TransportApiClientSettings(clientId: clientId, clientSecret: clientSecret)
        self.tokenComponent = TokenComponent(transportApiClientSettings: transportApiClientSettings!)
    }
    
    open class func postJourney(fareProducts: [String]? = nil,
                            onlyAgencies: [String]? = nil,
                            omitAgencies: [String]? = nil,
                            onlyModes: [String]? = nil,
                            omitModes: [String]? = nil,
                            exclude: String? = nil,
                            startLocation: CLLocationCoordinate2D,
                            endLocation: CLLocationCoordinate2D,
                            time: Date = Date(),
                            timeType: String = "DepartAfter",
                            profile: String = "ClosestToTime",
                            maxItineraries: Int = 3,
                            completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<Journey>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.PostJourney(tokenComponent: tokenComponent,
                                      transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getJourney(
        id: String,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<Journey>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetJourney(tokenComponent: tokenComponent,
                                     transportApiClientSettings: transportApiClientSettings,
                                     id: id,
                                    exclude: exclude)
        {
            (result: TransportApiResult<Journey>) in
            completion (result)
        }
    }
    
    open class func getItinerary(
        journeyId: String,
        itineraryId: String,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<Itinerary>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<Itinerary>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetItinerary(tokenComponent: tokenComponent,
                                     transportApiClientSettings: transportApiClientSettings,
                                     journeyId: journeyId,
                                     itineraryId : itineraryId,
                                     exclude: exclude)
        {
            (result: TransportApiResult<Itinerary>) in
            completion (result)
        }
    }
    
    open class func getAgencies(onlyAgencies: [String]? = nil,
                                  omitAgencies: [String]? = nil,
                                  exclude: String? = nil,
                                  limit: Int = 100,
                                  offset: Int = 0,
                                  completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Agency]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetAgencies(tokenComponent: tokenComponent,
                                      transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getAgenciesNearby(onlyAgencies: [String]? = nil,
                            omitAgencies: [String]? = nil,
                            location: CLLocationCoordinate2D? = nil,
                            boundingBox: String? = nil,
                            exclude: String? = nil,
                            radiusInMeters: Int = -1,
                            limit: Int = 100,
                            offset: Int = 0,
                            completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Agency]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetAgencies(tokenComponent: tokenComponent,
                                      transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getAgenciesByBoundingBox(onlyAgencies: [String]? = nil,
                                  omitAgencies: [String]? = nil,
                                  boundingBox: String? = nil,
                                  exclude: String? = nil,
                                  limit: Int = 100,
                                  offset: Int = 0,
                                  completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Agency]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetAgencies(tokenComponent: tokenComponent,
                                      transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getAgency(
        id: String,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<Agency>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<Agency>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetAgency(tokenComponent: tokenComponent,
                                    transportApiClientSettings: transportApiClientSettings,
                                    id: id,
                                      exclude: exclude)
        {
            (result: TransportApiResult<Agency>) in
            completion (result)
        }
    }
    
    open class func getStops(onlyAgencies: [String]? = nil,
                            omitAgencies: [String]? = nil,
                            limitModes: [String]? = nil,
                            servesLines: [String]? = nil,
                            showChildren: Bool = false,
                            exclude: String? = nil,
                            limit: Int = 100,
                            offset: Int = 0,
                            completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Stop]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetStops(tokenComponent: tokenComponent,
                                   transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getStopsNearby(onlyAgencies: [String]? = nil,
                                  omitAgencies: [String]? = nil,
                                  limitModes: [String]? = nil,
                                  servesLines: [String]? = nil,
                                  showChildren: Bool = false,
                                  location: CLLocationCoordinate2D? = nil,
                                  boundingBox: String? = nil,
                                  exclude: String? = nil,
                                  radiusInMeters: Int = -1,
                                  limit: Int = 100,
                                  offset: Int = 0,
                                  completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Stop]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetStops(tokenComponent: tokenComponent,
                                   transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getStopsByBoundingBox(onlyAgencies: [String]? = nil,
                                         omitAgencies: [String]? = nil,
                                         limitModes: [String]? = nil,
                                         servesLines: [String]? = nil,
                                         showChildren: Bool = false,
                                         boundingBox: String? = nil,
                                         exclude: String? = nil,
                                         limit: Int = 100,
                                         offset: Int = 0,
                                         completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Stop]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetStops(tokenComponent: tokenComponent,
                                   transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getStop(
        id: String,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<Stop>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<Stop>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetStop(tokenComponent: tokenComponent,
                                  transportApiClientSettings: transportApiClientSettings,
                                  id: id,
                                    exclude: exclude)
        {
            (result: TransportApiResult<Stop>) in
            completion (result)
        }
    }
    
    open class func getLines(onlyAgencies: [String]? = nil,
                         omitAgencies: [String]? = nil,
                         limitModes: [String]? = nil,
                         servesStops: [String]? = nil,
                         exclude: String? = nil,
                         limit: Int = 100,
                         offset: Int = 0,
                         completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Line]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetLines(tokenComponent: tokenComponent,
                                   transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getLinesNearby(onlyAgencies: [String]? = nil,
                               omitAgencies: [String]? = nil,
                               limitModes: [String]? = nil,
                               servesStops: [String]? = nil,
                               location: CLLocationCoordinate2D? = nil,
                               boundingBox: String? = nil,
                               exclude: String? = nil,
                               radiusInMeters: Int = -1,
                               limit: Int = 100,
                               offset: Int = 0,
                               completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Line]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetLines(tokenComponent: tokenComponent,
                                   transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getLinesByBoundingBox(onlyAgencies: [String]? = nil,
                                      omitAgencies: [String]? = nil,
                                      limitModes: [String]? = nil,
                                      servesStops: [String]? = nil,
                                      boundingBox: String? = nil,
                                      exclude: String? = nil,
                                      limit: Int = 100,
                                      offset: Int = 0,
                                      completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[Line]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetLines(tokenComponent: tokenComponent,
                                   transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getLine(
        id: String,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<Line>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<Line>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetLine(tokenComponent: tokenComponent,
                                  transportApiClientSettings: transportApiClientSettings,
                                  id: id,
                                  exclude: exclude)
        {
            (result: TransportApiResult<Line>) in
            completion (result)
        }
    }
    
    open class func getFareProducts(onlyAgencies: [String]? = nil,
                                      omitAgencies: [String]? = nil,
                                      exclude: String? = nil,
                                      limit: Int = 100,
                                      offset: Int = 0,
                                      completion: @escaping (_ result: TransportApiResult<[FareProduct]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[FareProduct]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetFareProducts(tokenComponent: tokenComponent,
                                          transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getFareProduct(
        id: String,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<FareProduct>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<FareProduct>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetFareProduct(tokenComponent: tokenComponent,
                                         transportApiClientSettings: transportApiClientSettings,
                                         id: id,
                                  exclude: exclude)
        {
            (result: TransportApiResult<FareProduct>) in
            completion (result)
        }
    }
    
    open class func getStopTimetable(
        id: String,
        earliestArrivalTime: Date? = nil,
        latestArrivalTime: Date? = nil,
        limit: Int = 100,
        offset: Int = 0,
        exclude: String? = nil,
        completion: @escaping (_ result: TransportApiResult<[StopTimetable]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[StopTimetable]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetStopTimetable(tokenComponent: tokenComponent,
                                           transportApiClientSettings: transportApiClientSettings,
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
    
    open class func getLineTimetable(
       id: String,
       departureStopIdFilter: String? = nil,
       arrivalStopIdFilter: String? = nil,
       earliestDepartureTime: Date? = nil,
       latestDepartureTime: Date? = nil,
       limit: Int = 100,
       offset: Int = 0,
       exclude: String? = nil,
       completion: @escaping (_ result: TransportApiResult<[LineTimetable]>) -> Void)
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {
            let transportApiResult = TransportApiResult<[LineTimetable]>()
            
            transportApiResult.error = "Credentials not set, please call loadCredntials and provide your clientId and clientSecret.";
            
            completion(transportApiResult)
            
            return
        }
        
        TransportApiCalls.GetLineTimetable(tokenComponent: tokenComponent,
                                           transportApiClientSettings: transportApiClientSettings,
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
    }

    open class func startMonitoringWhenToGetOff(
        itinerary: Itinerary,
        crowdSourceFrequency: CrowdSourceFrequency = CrowdSourceFrequency.continuous)
        -> TransportApiNotificationStatus
    {
        guard let tokenComponent = self.tokenComponent, let transportApiClientSettings = self.transportApiClientSettings else {

            return TransportApiNotificationStatus.FailedNoCredentials
        }
        
        return LocationManager.sharedInstance.startMonitoringWhenToGetOff(tokenComponent: tokenComponent,
                                                                          itinerary: itinerary,
                                                                          crowdSourceFrequency: crowdSourceFrequency)
    }
    
    open class func stopMonitoringWhenToGetOff()
    {
        LocationManager.sharedInstance.stopMonitoringWhenToGetOff()
    }
    
    
}
