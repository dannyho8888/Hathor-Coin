//
//  AppDelegate.swift
//  Hathor-menu-bar
//
//  Created by Ho Ho Yin on 19/12/2021.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet weak var Menu: NSMenu!
    var timer : Timer!
    
    // Create menu bar button
    let statusItem = NSStatusBar.system.statusItem(withLength: 55)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Menu.delegate = self
        if let button = statusItem.button {
            
            button.title = "H $\(getCryptoData())"
            button.action = #selector(mouseClickHandler)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(updateHtrPrice), userInfo: nil, repeats: true)
    }
    
    @objc func updateHtrPrice() {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            button.title = "H $\(getCryptoData())"
            print("H $\(getCryptoData())")
        }
    }
    

    @objc func mouseClickHandler() {
        if let event = NSApp.currentEvent {
            switch event.type {
            default:
                statusItem.menu = Menu
                statusItem.button?.performClick(nil)
            }
        }
    }
    
    @IBAction func Quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
}

func getCryptoData() -> Double{
    let address = "https://min-api.cryptocompare.com/data/price?fsym=HTR&tsyms=USD&api_key=5f15b4af86b7dda1b1434c3e913aa7c280a8235cc4ec446e980a47568"
    
    var a : Double  = 0
    if let url = URL(string: address) {
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                if let cryptoData = try? decoder.decode(CryptoData.self, from: data){
                    a = cryptoData.USD
                }
            }
        }.resume()
    }
    sleep(2)
    return a
}

struct CryptoData: Decodable{
    var USD: Double
}

extension AppDelegate: NSMenuDelegate {
    func menuDidClose(_ menu: NSMenu) {
        self.statusItem.menu = nil
    }
}
