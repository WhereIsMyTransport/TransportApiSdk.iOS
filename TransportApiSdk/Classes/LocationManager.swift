//
//  LocationManager.swift
//  Pods
//
//  Created by Chris on 3/14/17.
//
//
// TODO Delegates to allow dev to listen for notificaitons
// TODO Make notifications optional if dev wants to handle them rather
// TODO More accurate check of when to get off. It's quite optimistic atm.
// TODO What if the itinerary is running late? Location will cut off 15min after scheduled arrival time.
// TODO Crowd sourcing at stops only if dev requests it. Currently does every 125m no matter what.

import CoreLocation
import AudioToolbox
import UserNotifications
import SwiftyJSON

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    private var getOffPoints: [GetOffPoint]!
    private var itinerary: Itinerary!
    private var itinereryArrivalTimePlus15: Date!
    private var crowdSourceFrequency: CrowdSourceFrequency!
    private var lastSourced = Date()
    private var tokenComponent: TokenComponent!
    
    private let calendar = Calendar.current
    
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.activityType = .automotiveNavigation
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.distanceFilter = 125.0
        return manager
    }()
    
    public override init()
    {
        super.init()
    }
    
    public func startMonitoringWhenToGetOff(
        tokenComponent: TokenComponent,
        itinerary: Itinerary,
        crowdSourceFrequency: CrowdSourceFrequency) -> TransportApiNotificationStatus
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){(granted, error) in}
        
        let currentDateTime = Date()
        
        let itineraryDepartureTimeLess15 = calendar.date(byAdding: .minute, value: -15, to: itinerary.departureTime!.dateFromISO8601!, wrappingComponents: false)
        self.itinereryArrivalTimePlus15 = calendar.date(byAdding: .minute, value: 15, to: itinerary.arrivalTime!.dateFromISO8601!, wrappingComponents: false)
    
        if (currentDateTime < itineraryDepartureTimeLess15!)
        {
            // Too early!
            
            return TransportApiNotificationStatus.TooEarly
        }
        else if (currentDateTime > self.itinereryArrivalTimePlus15!)
        {
            // Too late!
            
            return TransportApiNotificationStatus.TooLate
        }
        
        self.itinerary = itinerary
        
        self.tokenComponent = tokenComponent
        
        self.crowdSourceFrequency = crowdSourceFrequency
        
        self.getOffPoints = determineGetOffPoints(itinerary: itinerary)
        
        DispatchQueue.main.async
        {
            self.locationManager.startUpdatingLocation()
        }
        
        return TransportApiNotificationStatus.Created
    }
    
    public func stopMonitoringWhenToGetOff()
    {
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let mostRecentLocation = locations.last else {
            return
        }
        
        if let getOffPoint = getOffPointToNotify(location: mostRecentLocation)
        {
            notify(getOffPoint: getOffPoint)
            
            if (!hasMoreGetOffPoints())
            {
                self.locationManager.stopUpdatingLocation()
            }
        }
        
        if (Date() > self.itinereryArrivalTimePlus15)
        {
            // Stop monitoring as the trip is likely over.
            
            self.locationManager.stopUpdatingLocation()
        }
        
        DispatchQueue.main.async
        {
            let timeLess1 = self.calendar.date(byAdding: .minute, value: -1, to:  mostRecentLocation.timestamp, wrappingComponents: false)!
            
            // Only sample every minute for now.
            if (timeLess1 > self.lastSourced)
            {
                self.sampleUserCoordinates(latitude: String(mostRecentLocation.coordinate.latitude),
                                           longitude: String(mostRecentLocation.coordinate.longitude))
            }
        }
    }
    
    private func notify(getOffPoint: GetOffPoint)
    {
        getOffPoint.isNotified = true
        
        // Try create a location notification.
        self.createLocalNotification(getOffPointName: getOffPoint.name)
        
        // Vibrate 5 times.
        for _ in 1...5 {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            sleep(1)
        }
    }
    
    private func createLocalNotification(getOffPointName: String)
    {
        let title = "Time to get off!"
        let body = "Approaching " + getOffPointName + " in less than 500 meters"
        

        var isSoundEnabled = false
        var isAlertEndabled = false
        
        UNUserNotificationCenter.current().getNotificationSettings() { (setttings) in
            
            switch setttings.soundSetting
            {
                case .enabled:
                    isSoundEnabled = true
                case .disabled:
                    isSoundEnabled = false
                case .notSupported:
                    isSoundEnabled = false
            }
            
            switch setttings.alertSetting
            {
                case .enabled:
                    isAlertEndabled = true
                case .disabled:
                    isAlertEndabled = false
                case .notSupported:
                    isAlertEndabled = false
            }
            
            if (isSoundEnabled && isAlertEndabled)
            {
                let content = UNMutableNotificationContent()
                
                content.title = title
                content.body = body
                content.sound = UNNotificationSound.default()
                content.categoryIdentifier = "timeToGetOff"
                
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest.init(identifier: "ReminderToGetOff", content: content, trigger: trigger)
                
                // Allow notification to fire while app is in the foreground.
                let category = UNNotificationCategory(identifier: "timeToGetOff", actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
                
                // Schedule the notification.
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error) in
                    
                }
            }
        }
    }
    
    private func hasMoreGetOffPoints() -> Bool
    {
        if (self.getOffPoints.last?.isNotified)!
        {
            return false
        }
        
        for getOffPoint in self.getOffPoints
        {
            if (!getOffPoint.isNotified)
            {
                return true
            }
        }
        
        return false
    }
    
    private func getOffPointToNotify(location: CLLocation) -> GetOffPoint?
    {
        for getOffPoint in self.getOffPoints
        {
            if (!getOffPoint.isNotified)
            {
                let distance = getOffPoint.location.distance(from: location)
                
                if (distance < 500)
                {
                    return getOffPoint
                }
            }
        }
        
        return nil
    }
    
    private func determineGetOffPoints(itinerary: Itinerary) -> [GetOffPoint]
    {
        var getOffPoints = [GetOffPoint]()
        
        guard let legs = itinerary.legs else {
            return getOffPoints
        }
        
        for leg in legs
        {
            if (leg.type == "Transit")
            {
                guard let waypoints = leg.waypoints else {
                    continue
                }
                
                guard let lastWayPoint = waypoints.last else {
                    continue
                }
                
                let arrivalTime = lastWayPoint.arrivalTime?.dateFromISO8601
                
                if (lastWayPoint.hail != nil)
                {
                    let latitude = lastWayPoint.hail?.geometry?.coordinates?[0].coordinates?[1]
                    let longitude = lastWayPoint.hail?.geometry?.coordinates?[0].coordinates?[0]
                    let location = CLLocation(latitude: latitude!, longitude: longitude!)
                    
                    let getOffPoint = GetOffPoint(location: location, name: "your stop", expectedArrivalTime: arrivalTime!)
                
                    getOffPoints.append(getOffPoint)
                }
                else if (lastWayPoint.location != nil)
                {
                    let latitude = lastWayPoint.location?.geometry?.coordinates?[0].coordinates?[1]
                    let longitude = lastWayPoint.location?.geometry?.coordinates?[0].coordinates?[0]
                    let location = CLLocation(latitude: latitude!, longitude: longitude!)
                    let name = lastWayPoint.location?.address?.components(separatedBy: ",")[0]
                    
                    let getOffPoint = GetOffPoint(location: location, name: name!, expectedArrivalTime: arrivalTime!)
                
                    getOffPoints.append(getOffPoint)
                }
                else if (lastWayPoint.stop != nil)
                {
                    let latitude = lastWayPoint.stop?.geometry?.coordinates?[0].coordinates?[1]
                    let longitude = lastWayPoint.stop?.geometry?.coordinates?[0].coordinates?[0]
                    let location = CLLocation(latitude: latitude!, longitude: longitude!)
                    let name = lastWayPoint.stop?.name
                    
                    let getOffPoint = GetOffPoint(location: location, name: name!, expectedArrivalTime: arrivalTime!)
                    
                    getOffPoints.append(getOffPoint)
                }
            }
        }
        
        return getOffPoints
    }
    
    private func sampleUserCoordinates(latitude: String, longitude: String)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            self.lastSourced = Date()

            let path = "https://prometheus.whereismytransport.com/streams/e67e676f-cd33-4e77-aa85-b46b33baa3f9/updates"
            let date = String(Date().timeIntervalSince1970)
            let id = self.itinerary.id!
            let deviceId = UIDevice.current.identifierForVendor!.uuidString
            
            let input = "{\"deviceId\": " + deviceId + "," +
            "\"confidence\": " +
            "[{\"confidence\": 1.0," +
            "\"type\": \"itineraryId\"," +
            "\"id\": \"" + id + "\"}]," +
            "\"longitude\": " + longitude + "," +
            "\"latitude\": " + latitude + "," +
            "\"coordinateDate\": \"" + date + "\"," +
            "\"version\": 2}"

            let json:JSON = JSON(parseJSON: input)
            
            RestApiManager.sharedInstance.makeHTTPPostRequest(path: path,
                                                              accessToken : accessToken.accessToken!,
                                                              timeout: 30.0,
                                                              query: nil,
                                                              json: json,
                                                              onCompletion: { json, err, response in })
        }
    }
}
