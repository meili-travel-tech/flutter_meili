//
//  MeiliViewFactory.swift
//  meili_flutter_ios
//
//  Created by Henrique Marques on 29/07/2024.
//


import Flutter
import Foundation
import UIKit
import MeiliSDK
import SwiftUI


public class MeiliViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return MeiliPlatformView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}


class MeiliUIView: UIView {
    var meiliParams: MeiliParams
    var meiliView: UIView?
    var channel: FlutterMethodChannel?
    
    
    init(frame: CGRect, meiliParams: MeiliParams, channel: FlutterMethodChannel?) {
        self.meiliParams = meiliParams
        self.channel = channel
        super.init(frame: frame)
        
        initializeMeiliView()
    }
    
    private func initializeMeiliView() {
        let hostingController = UIHostingController(rootView: MeiliView(with: meiliParams))
        
        self.meiliView = hostingController.view
        if let meiliView = self.meiliView {
            self.addSubview(meiliView)
            
            meiliView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                meiliView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                meiliView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                meiliView.topAnchor.constraint(equalTo: self.topAnchor),
                meiliView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        meiliView?.frame = self.bounds
    }
    
    private func sendHeightToFlutter(_ height: CGFloat) {
        channel?.invokeMethod("updateHeight", arguments: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class MeiliPlatformView: NSObject, FlutterPlatformView {
    private let meiliUIView: MeiliUIView
    private let channel: FlutterMethodChannel
    
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        channel = FlutterMethodChannel(name: "flutter_meili/meili_view/\(viewId)", binaryMessenger: messenger)
        
        if let arguments = args as? [String: Any],
           let ptid = arguments["ptid"] as? String,
           let flow = arguments["flow"] as? String,
           let env = arguments["env"] as? String {
            
            let flow = MeiliFlow(rawValue: flow) ?? .connect
            let environment = MeiliEnvironment(rawValue: env) ?? .dev
            let availParams = (arguments["availParams"] as? [String: Any]).flatMap(parseAvailParams)
            let additionalParams = (arguments["additionalParams"] as? [String: Any]).flatMap(parseBookingParams)
            let meiliParams = MeiliParams(ptid: ptid, flow: flow, env: environment, availParams: availParams, additionalParams: additionalParams)
            
            meiliUIView = MeiliUIView(frame: frame, meiliParams: meiliParams, channel: channel)
           
        } else {
            fatalError("Failed to initialize MeiliPlatformView with arguments.")
        }
        
        super.init()
        
        channel.setMethodCallHandler(handle)
    }
    
    func view() -> UIView {
        return meiliUIView
    }
    
     func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            
            case "updateHeight":
                result(nil)
            default:
                result(FlutterMethodNotImplemented)
        }
    }
}



func parseBookingParams(from dict: [String: Any]) -> AdditionalParams? {
    return AdditionalParams(
        partnerLoyaltyAccount: dict["partnerLoyaltyAccount"] as? String,
        partnerLoyaltyAccountTier: dict["partnerLoyaltyAccountTier"] as? String,
        numberOfPassengers: dict["numberOfPassengers"] as? Int,
        customerPartnerCode: dict["customerPartnerCode"] as? String,
        flightNumber: dict["flightNumber"] as? String,
        passengerNameRecord: dict["passengerNameRecord"] as? String,
        superPassengerNameRecord: dict["superPassengerNameRecord"] as? String,
        infant: dict["infant"] as? Int,
        child: dict["child"] as? Int,
        teenager: dict["teenager"] as? Int,
        supplierLoyaltyAccounts: dict["supplierLoyaltyAccount"] as? [String],
        fareTypeAndFlex: dict["fareTypeAndFlex"] as? String,
        departureAirport: dict["departureAirport"] as? String,
        arrivalAirport: dict["arrivalAirport"] as? String,
        ancillaryActivity: dict["ancillaryActivity"] as? String,
        airlineFareAmount: dict["airlineFareAmount"] as? Double,
        airlineFareCurrency: dict["airlineFareCurrency"] as? String,
        partnerCustomerID: dict["partnerCustomerID"] as? String,
        firstName: dict["firstName"] as? String,
        lastName: dict["lastName"] as! String,
        email: dict["email"] as? String,
        phoneNumbers: dict["phoneNumbers"] as? [Int],
        companyName: dict["companyName"] as? String,
        addressLine1: dict["addressLine1"] as? String,
        postCode: dict["postCode"] as? String,
        city: dict["city"] as? String,
        state: dict["state"] as? String,
        confirmationId: dict["confirmationId"] as! String,
        prefillOnly: dict["prefillOnly"] as? Bool
    )
}

func parseAvailParams(from dict: [String: Any]) -> AvailParams? {
    guard let pickupLocation = dict["pickupLocation"] as? String,
          let dropoffLocation = dict["dropoffLocation"] as? String,
          let pickupTime = dict["pickupTime"] as? String,
          let pickupDate = dict["pickupDate"] as? String,
          let dropoffTime = dict["dropoffTime"] as? String,
          let dropoffDate = dict["dropoffDate"] as? String,
          let pickupDateTime = dict["pickupDateTime"] as? String,
          let dropoffDateTime = dict["dropoffDateTime"] as? String,
          let driverAge = dict["driverAge"] as? Int,
          let currencyCode = dict["currencyCode"] as? String,
          let residency = dict["residency"] as? String else {
        return nil
    }
    
    return AvailParams(
        pickupLocation: pickupLocation,
        dropoffLocation: dropoffLocation,
        pickupDate: pickupDate,
        pickupTime: pickupTime,
        dropoffDate: dropoffDate,
        dropoffTime: dropoffTime,
        driverAge: driverAge,
        currencyCode: currencyCode,
        residency: residency,
        pickupDateTime: pickupDateTime,
        dropoffDateTime: dropoffDateTime
    )
}
