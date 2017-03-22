# TransportApiSdk - WhereIsMyTransport API Client Library for iOS

[![Version](https://img.shields.io/cocoapods/v/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)
[![License](https://img.shields.io/cocoapods/l/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)
[![Platform](https://img.shields.io/cocoapods/p/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)

The official iOS SDK for the [WhereIsMyTransport](https://www.whereismytransport.com) API.

Access to the platform is completely free, so for more information and to get credentials, just visit the [developer portal](https://developer.whereismytransport.com).

## Usage

In your application delegate, import TransportApiSdk and inside `applicationDidFinishLaunching:` add:

```swift
import TransportApiSdk

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    TransportApiClient.loadCredentials(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")

    return true
}
```

Now you can make calls anywhere in your application:

```swift
import TransportApiSdk

TransportApiClient.getAgencies
{
(result: TransportApiResult<[Agency]>) in

    // Do fancy things with the results.
    print(result.Data.rawJson)
}
```

## Features

*NEW* on-device feature available:

### WhenToGetOff (Beta)

Notifies the user with vibrations and a banner when they are approaching a stop they need to disembark at.

* The function stops monitoring when: the user has no more stops to disembark at or the itinerary time has elapsed.
* Calling the function again will over-write any existing function.
* The function samples the user location for crowd-sourcing with minimal data usage.

Before using this feature, please do the following:
* Add the `NSLocationAlwaysUsageDescription` description in your app's `Info.plist`
* Turn on `Background Fetch` and `Location Updates` checkbox in `Project Settings > Capabilities > Background Modes`
* Request authorization for notifications

#### iOS 10 Example

```swift
import TransportApiSdk

// Grant access to notifications.
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]){(granted, error) in}

// Call WhenToGetOff.
TransportApiClient.startMonitoringWhenToGetOff(itinerary: USER_SELECTED_ITINERARY)
```

### Wrapper Functions

The following API end-points are available:

* POST api/journeys
* GET api/journeys/{id}
* GET api/journeys/{id}/itineraries/{id}
* GET api/agencies
* GET api/agencies/{id}
* GET api/stops
* GET api/stops/{id}
* GET api/stops/{id}/timetables
* GET api/lines
* GET api/lines/{id}
* GET api/lines/{id}/timetables
* GET api/fareproducts
* GET api/fareproducts/{id}

## Installation
### CocoaPods
Install [CocoaPods](http://cocoapods.org) with the following command:

```bash
gem install cocoapods
```

Integrate TransportApiSdk into your Xcode project by creating a `Podfile`:

```ruby
platform :ios, '8.1'
use_frameworks!

target '<Your Target Name>' do
pod 'TransportApiSdk'
end
```

Run `pod install` to build your dependencies.

### Carthage
TODO

## Author

Chris King - https://twitter.com/crkingza

## License

TransportApiSdk is available under the MIT license. See the LICENSE file for more info.
