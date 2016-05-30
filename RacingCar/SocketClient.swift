//
//  SocketClient.swift
//  RacingCar
//
//  Created by Tung Nguyen on 3/19/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

import CocoaAsyncSocket

protocol SocketClientDelegate {
    
}

class SocketClient: NSObject, GCDAsyncSocketDelegate {
    static let sharedInstance = SocketClient()
    var tcpsocket: GCDAsyncSocket!
    
    private var host: String?
    private var port: UInt16?
    
    private override init() {
        super.init()
        tcpsocket = GCDAsyncSocket.init(delegate: self, delegateQueue: dispatch_get_main_queue())
    }

    //MARK:- Getter/Setter
    func config(host: String!, port: UInt16!) {
        self.host = host
        self.port = port
    }
    
    //MARK:- Delegate
    private var delegate: SocketClientDelegate?;
    
    func setDelegate(delegate: SocketClientDelegate!) {
        self.delegate = delegate
    }
    
    //MARK:- GCDAsyncSocketDelegate
    @objc internal func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        //TODO: Put delegate
    }
    
    @objc internal func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("Socket disconntected")
        //TODO: Put delegate
    }
    
    @objc internal func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        //print("Data sent")
        //TODO: Put delegate
    }
    
    private func connect() -> Bool {
        if self.host == nil || self.port == nil {
            return false
        }
        
        if tcpsocket.isConnected {
            if tcpsocket.connectedHost == self.host && tcpsocket.connectedPort == self.port {
                return true
            } else {
                tcpsocket.disconnect()
            }
        }
        
        do {
            try tcpsocket.connectToHost(self.host!, onPort: self.port!, withTimeout: NSTimeInterval.init(5))
            return true
        } catch _ {
            print("Failed to connect to ", host, ":", port)
            return false
        }
    }
    
    func sendCommand(request: String) {
        if self.connect() {
            //TODO: Put delegate
            let requestString: NSString = request + "\n\r"
            let requestData = requestString.dataUsingEncoding(NSUTF8StringEncoding)
            tcpsocket.writeData(requestData, withTimeout: NSTimeInterval.init(5), tag: 0)
        } else {
            //TODO: Put delegate
        }
    }
}
