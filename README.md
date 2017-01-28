# TransportApiSdk

[![CI Status](http://img.shields.io/travis/Bilo/TransportApiSdk.svg?style=flat)](https://travis-ci.org/Bilo/TransportApiSdk)
[![Version](https://img.shields.io/cocoapods/v/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)
[![License](https://img.shields.io/cocoapods/l/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)
[![Platform](https://img.shields.io/cocoapods/p/TransportApiSdk.svg?style=flat)](http://cocoapods.org/pods/TransportApiSdk)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage

// Setup your credentials.
let transportApiClientSettings = TransportApiClientSettings(clientId: "YOUR_CLIENT_ID", clientSecret: "YOUR_CLIENT_SECRET")

// Define the api client.
let transportApiClient = TransportApiClient(transportApiClientSettings: transportApiClientSettings)

// Make an api call.
transportApiClient.GetAgencies
{
(result: TransportApiResult<[Agency]>) in

// Do fancy things with the results.
print(result.Data)
}

## Installation

TransportApiSdk is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TransportApiSdk"
```

## Author

Chris King - https://twitter.com/crkingza

## License

TransportApiSdk is available under the MIT license. See the LICENSE file for more info.
