//
//  LocationManager.swift
//  Pods
//
//  Created by Chris on 3/14/17.
//
//

import CoreLocation
import AudioToolbox
import UserNotifications

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    
    private var deferringUpdates = false
    private var getOffPoints: [GetOffPoint]?
    private var itinerary: Itinerary?
    private var itinereryArrivalTimePlus15: Date?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.activityType = .automotiveNavigation
        manager.delegate = self
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    public override init()
    {
        super.init()
    }
    
    public func startMonitoringWhenToGetOff(
        itinerary: Itinerary,
        crowdSourceFrequency: CrowdSourceFrequency) -> TransportApiNotificationStatus
    {
        let calendar = Calendar.current
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
        
        self.getOffPoints = determineGetOffPoints(itinerary: itinerary)
        
        self.locationManager.startUpdatingLocation()
        
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
        
        if (Date() > self.itinereryArrivalTimePlus15!)
        {
            // Stop monitoring as the trip is likely over.
            
            self.locationManager.stopUpdatingLocation()
        }
        
        // Defer updates until the user moves a certain distance or a period of time has passed
        if (!self.deferringUpdates)
        {
            // Defer for 100m or 30seconds
            self.locationManager.allowDeferredLocationUpdates(untilTraveled: 100, timeout:30000.0)
            
            self.deferringUpdates = true;
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError!) {
        // Stop deferring updates
        self.deferringUpdates = false
    }
    
    private func notify(getOffPoint: GetOffPoint)
    {
        getOffPoint.isNotified = true
        
        let notificationText = "Time to get off at " + getOffPoint.name
        
        // Try create a location notification.
        self.createLocalNotification(getOffPointName: getOffPoint.name)
        
        // Vibrate 5 times.
        for _ in 1...5 {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            sleep(1)
        }
    }
    
    private func createLocalNotification(getOffPointName: String)
    {
        if #available(iOS 10.0, *) {
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
            }
            
            if (isSoundEnabled && isAlertEndabled)
            {
                let content = UNMutableNotificationContent()
                
                content.title = "Time to get off!"
                content.body = "Approaching " + getOffPointName + " in less than 500 meters"
                content.sound = UNNotificationSound.default()
            
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest.init(identifier: "ReminderToGetOff", content: content, trigger: trigger)
                
                // Schedule the notification.
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error) in
                    
                }
            }
        }
        else
        {
            // TODO Fallback on earlier versions
        }
    }
    
    private func hasMoreGetOffPoints() -> Bool
    {
        for getOffPoint in self.getOffPoints!
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
        for getOffPoint in self.getOffPoints!
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
    
    
}
