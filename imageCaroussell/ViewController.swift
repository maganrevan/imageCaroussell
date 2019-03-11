//
//  ViewController.swift
//  imageCaroussell
//
//  Created by Magnus Kruschwitz on 10.03.19.
//  Copyright © 2019 Magnus Kruschwitz. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var image1Path: NSTextField!
    @IBOutlet weak var image2Path: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var btnStop: NSButton!
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnChoose1: NSButton!
    @IBOutlet weak var btnChoose2: NSButton!
    
    var timer: Timer!
    
    var imageLoaded: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func btnChooseImage2Clicked(_ sender: Any) {
        openDialog(target: image2Path)
    }
    
    @IBAction func btnChooseImage1Clicked(_ sender: Any) {
        openDialog(target: image1Path)
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func btnStartClicked(_ sender: Any) {
        if image1Path.stringValue.isEmpty || image2Path.stringValue.isEmpty{
            stackModal(headline: "Leere Eingabe", content: "Sie dürfen keine leeren Inhalte angeben. Bitte prüfen Sie Bildquelle 1 und Bildquelle 2.")
            return
        }
        btnStart.isEnabled = false
        btnChoose1.isEnabled = false
        btnChoose2.isEnabled = false
        btnStop.isEnabled = true
        
        timer = Timer.scheduledTimer(
            timeInterval: 5,
            target: self,
            selector: #selector(changeSource),
            userInfo: nil,
            repeats: true
        )
        changeSource()
    }
    
    @IBAction func btnStopClicked(_ sender: Any) {
        btnStart.isEnabled = true
        btnChoose1.isEnabled = true
        btnChoose2.isEnabled = true
        btnStop.isEnabled = false
        timer.invalidate()
    }
    
    func openDialog(target: NSTextField){
        let meinDialog: NSOpenPanel = NSOpenPanel()
        meinDialog.prompt = "Öffnen"
        meinDialog.allowedFileTypes = NSImage.imageTypes
        if meinDialog.runModal() == NSApplication.ModalResponse.OK {
            let meineDatei = meinDialog.url?.path
            target.stringValue = meineDatei!
        }
    }
    
    func stackModal(headline: String, content: String){
        let showModal : NSAlert = NSAlert()
        showModal.messageText = headline
        showModal.informativeText = content
        showModal.runModal()
    }
    
    @objc func changeSource(){
        if imageLoaded == 1{
            if let image = NSImage(contentsOfFile: image1Path.stringValue){
                imageView.image = image
                imageLoaded = 2
            }
            else{
                stackModal(headline: "Fehler", content: "Bild Nr.1 konnte nicht geladen werden.")
                btnStopClicked(self)
            }
            
        }
        else{
            if let image = NSImage(contentsOfFile: image2Path.stringValue){
                imageView.image = image
                imageLoaded = 1
            }
            else{
                stackModal(headline: "Fehler", content: "Bild Nr.2 konnte nicht geladen werden.")
                btnStopClicked(self)
            }
        }
    }
}
