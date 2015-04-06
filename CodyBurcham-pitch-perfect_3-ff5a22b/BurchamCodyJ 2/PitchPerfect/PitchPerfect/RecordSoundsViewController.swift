//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Cody Burcham on 3/17/15.
//  Copyright (c) 2015 Cody Burcham. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordinginProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
   
    var audioRecorder: AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        recordButton.enabled = true
        stopButton.hidden = true
        tapToRecord.hidden = false
     
    }
    
    @IBAction func RecordAudio(sender: UIButton) {
        recordButton.enabled = false
        stopButton.hidden = false
        recordinginProgress.hidden = false
        tapToRecord.hidden = true
  
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
    var currentDateTime = NSDate()
    var formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
    var pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    println(filePath)
        
    //Setup audio session
    var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        //Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder (URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true;
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
        
        
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
        let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    


    @IBAction func stopAudio(sender: UIButton) {
        recordinginProgress.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance();
        audioSession.setActive(false, error: nil)
    }

}

