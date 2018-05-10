//
//  SounViewController.swift
//  SoundBoard
//
//  Created by Tecsup on 9/05/18.
//  Copyright © 2018 Tecsup. All rights reserved.
//

import UIKit
import AVFoundation

class SounViewController: UIViewController {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var audioRecorder :AVAudioRecorder?
    var audioPlayer :AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    func setupRecorder() {
        do{
            //Creando una sesion de audio:
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Creando una direccion para el archivo de audio+
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            //Crear opciones para el grabador de audios
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //Crear el objeto de grabaciones de audio
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            
        }catch let error as NSError{
            print(error)
        }
    }

    @IBAction func recordTapped(_ sender: Any) {
        if audioRecorder!.isRecording{
            //Detener la grabacion
            audioRecorder?.stop()
            //Cambiar el texto del boton grabar
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }
    }
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf:audioURL!)
            audioPlayer!.play()
        }catch{
            
        }
    }
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context:context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)! as Data
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }

}
