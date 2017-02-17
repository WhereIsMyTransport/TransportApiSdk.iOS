# TransportApiSdk - WhereIsMyTransport API Client Library for iOS

[![Version](https://img.shields.io/cocoapods/v/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)
[![License](https://img.shields.io/cocoapods/l/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)
[![Platform](https://img.shields.io/cocoapods/p/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)

The unofficial iOS SDK for the [WhereIsMyTransport](https://www.whereismytransport.com) API. 

## Usage

```swift
import TransportApiSdk

// Setup your credentials.
let transportApiClientSettings = TransportApiClientSettings(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")

// Define the api client.
let transportApiClient = TransportApiClient(transportApiClientSettings: transportApiClientSettings)

// Make an api call.
transportApiClient.GetAgencies
{
(result: TransportApiResult<[Agency]>) in

    // Do fancy things with the results.
    print(result.Data.rawJson)
}
```

## Features

The following end-points are available:

* POST api/journeys
* GET api/journeys/{id}
* GET api/agencies
* GET api/agencies/{id}
* GET api/stops
* GET api/stops/{id}
* GET api/lines
* GET api/lines/{id}
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

## Documentation

Access to the platform is completely free, so for more information and to get credentials, just visit the [developer portal](https://developer.whereismytransport.com).

## Author

Chris King - https://twitter.com/crkingza

## License

TransportApiSdk is available under the MIT license. See the LICENSE file for more info.
