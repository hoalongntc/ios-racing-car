//
//  ViewController.swift
//  RacingCar
//
//  Created by Tung Nguyen on 3/18/16.
//  Copyright © 2016 Tung Nguyen. All rights reserved.
//

import UIKit
import CoreMotion
import CocoaAsyncSocket
import SpriteKit
import CocoaMQTT

class ViewController: UIViewController, GCDAsyncSocketDelegate {

    //MARK:- Private variable
    var mqtt: CocoaMQTT?
    //let manager = CMMotionManager()
    var controlller: CarController!
    @IBOutlet weak var skView: SKView?
    @IBOutlet weak var btnUp: UIButton?
    @IBOutlet weak var btnDown: UIButton?
    
    
    //MARK:- Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        controlller = CarController()
        if let previousIp = NSUserDefaults.standardUserDefaults().valueForKey("hoalong/racing-car/esp8266/ip") {
            controlller.config(previousIp as! String, carPort: 23)
        }
        
        mqttSetting()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true
        
        let scence = ControlScene(size: skView!.bounds.size);
        scence.controlDelegate = self
        scence.scaleMode = SKSceneScaleMode.AspectFill
        
        print("Scene width: ", skView!.bounds.size.width)
        print("Scene height: ", skView!.bounds.size.height)
        
        let transition = SKTransition()
        
        skView!.presentScene(scence, transition: transition)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mqtt!.connect()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        mqtt!.disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- MQTT
    func mqttSetting() {
        let clientIdPid = "hoalong/racing-car/ios/" + String(NSProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientId: clientIdPid, host: "test.mosquitto.org", port: 1883)
        if let mqtt = mqtt {
            mqtt.delegate = self
        }
    }
}

extension ViewController: CocoaMQTTDelegate {
    
    func mqtt(mqtt: CocoaMQTT, didConnect host: String, port: Int) {
        print("MQTT connected to \(host):\(port)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if ack == .ACCEPT {
            mqtt.subscribe("hoalong/racing-car/esp8266/ip", qos: CocoaMQTTQOS.QOS1)
            mqtt.ping()
        }
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage with message: \(message.string)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck with id: \(id)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("didReceiveMessage from \(message.topic): \(message.string!)")
        switch message.topic {
        case "hoalong/racing-car/esp8266/ip":
            if let newIp = message.string {
                controlller.config(newIp, carPort: 23)
                NSUserDefaults.standardUserDefaults().setValue(newIp, forKey: "hoalong/racing-car/esp8266/ip")
            }
        default:
            print("unknown")
        }
    }
    
    func mqtt(mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic to \(topic)")
    }
    
    func mqtt(mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic to \(topic)")
    }
    
    func mqttDidPing(mqtt: CocoaMQTT) {
        print("didPing")
    }
    
    func mqttDidReceivePong(mqtt: CocoaMQTT) {
        _console("didReceivePong")
    }
    
    func mqttDidDisconnect(mqtt: CocoaMQTT, withError err: NSError?) {
        _console("mqttDidDisconnect")
    }
    
    func _console(info: String) {
        print("Delegate: \(info)")
    }
}

extension ViewController : ControlSceneDelegate {
    func control(didChange speed: Float, directionX: Float, directionY: Float) {
        let speed = Int(speed * 1100)
        let direction = Int(directionX * 30)
        self.controlller.setDirection(direction)
        self.controlller.setSpeed(speed)
    }
}


