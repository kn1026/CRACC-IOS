//
//  cameraVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/16/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import CameraManager
import AVKit
import AVFoundation
import KDCircularProgress
import Firebase
import FirebaseStorage

class cameraVC: UIViewController,UIGestureRecognizerDelegate, AVPlayerViewControllerDelegate {

    @IBOutlet weak var cameraView: UIView!
    
    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var changeCameraBtn: UIButton!
    var swipeBack = UISwipeGestureRecognizer()
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordedView: UIView!
    var orientation = ""
    var progress: KDCircularProgress!
    var playerVideo: AVPlayer!
    var playController = AVPlayerViewController()
    var focusRecognizer: UITapGestureRecognizer!
    var focusView: UIView?
    let cameraManager = CameraManager()
    var SavedUrl: URL?
    
    @IBOutlet weak var progessView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeBack.addTarget(self, action: #selector(cameraVC.goback))
        swipeBack.direction = .down
        self.view.addGestureRecognizer(swipeBack)

        
        // load first orientation
        
        orientation = "front"
        
        // ask for permission camera user
        cameraManager.showAccessPermissionPopupAutomatically = true
        // set default output
        cameraManager.cameraOutputMode = .videoWithMic
        
        
        // check camera condition and use
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        
        if currentCameraState == .notDetermined {
            
            askForPermission()
            
        } else {
            addCameraToView()
        }
        
        cameraManager.flashMode = .auto
        
        
        // setup progress
        
        
        focusRecognizer = UITapGestureRecognizer(target: self, action:#selector(cameraVC.focus(_:)))
        focusRecognizer.delegate = self
        self.focusView =  UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        playController.delegate = self
        self.cameraView.addGestureRecognizer(focusRecognizer)
        setupProgress()
        
        
    }
    
    @objc func goback() {
        
        if containerView.isHidden == false {
            
            resumeCamera()
        
            return
        }
    
        self.dismiss(animated: true, completion: nil)
    }

    func setupProgress() {
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        // progress.center = CGPoint(x: progressView.center.x, y: progressView.center.y)
        progress.clockwise = true
        progress.progressThickness = 0.5
        progress.trackThickness = 0.7
        progress.gradientRotateSpeed = 2
        progress.glowMode = .forward
        progress.glowAmount = 0.9
        progress.trackColor = UIColor.groupTableViewBackground.withAlphaComponent(0.5)
        progress.progressColors = [UIColor.red]
        progress.startAngle = -90
        
        progessView.addSubview(progress)
        progessView.addSubview(recordBtn)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // stop camera session
        cameraManager.stopCaptureSession()
    }
    
    @objc func focus(_ recognizer: UITapGestureRecognizer) {
        
        let point = recognizer.location(in: cameraView)
        let viewsize = self.cameraView.bounds.size
        let newPoint = CGPoint(x: point.y/viewsize.height, y: 1.0-point.x/viewsize.width)
        
        
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            
            try device?.lockForConfiguration()
            
        } catch _ {
            
            return
        }
        
        if device?.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) == true {
            
            device?.focusMode = AVCaptureDevice.FocusMode.autoFocus
            device?.focusPointOfInterest = newPoint
        }
        
        if device?.isExposureModeSupported(AVCaptureDevice.ExposureMode.continuousAutoExposure) == true {
            
            device?.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
            device?.exposurePointOfInterest = newPoint
        }
        
        device?.unlockForConfiguration()
        
        self.focusView?.alpha = 0.0
        self.focusView?.center = point
        self.focusView?.backgroundColor = UIColor.clear
        self.focusView?.layer.borderColor = UIColor.white.cgColor
        self.focusView?.layer.borderWidth = 1.0
        self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.cameraView.addSubview(self.focusView!)
        
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3.0, options: UIView.AnimationOptions.curveEaseIn, // UIViewAnimationOptions.BeginFromCurrentState
            animations: {
                self.focusView!.alpha = 1.0
                self.focusView!.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(finished) in
            self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.focusView!.removeFromSuperview()
        })
    }
    
    
    
    // private func add camera to view
    
    fileprivate func addCameraToView()
        
        
    {
        
        cameraManager.cameraDevice = .front
        
        
        // camera camera view
        _ = cameraManager.addPreviewLayerToView(cameraView)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // ask for permission for the first time
    
    fileprivate func askForPermission() {
        cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }

    @IBAction func changeScreenBtnPressed(_ sender: Any) {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            print("front")
            orientation = "front"
        case .back:
            print("back")
            orientation = "back"
        }
    }
    
    @IBAction func recordBtnPressed(_ sender: Any) {
        
        
        recordBtn.isHidden = true
        changeCameraBtn.isHidden = true
        self.view.removeGestureRecognizer(swipeBack)
       
        // open progress bar
        progress.animate(fromAngle: 0, toAngle: 360, duration: 15) { completed in
            
            
            
            if completed {
                self.playVideo()
                
                
                print("animation stopped, completed")
            } else {
                
                
                print("animation stopped, was interrupted")
            }
        }
        
        
        
        
        // setting camera
        cameraManager.cameraOutputMode = .videoWithMic
        cameraManager.startRecordingVideo()
        

        
        
    }
    
    
    func playVideo() {
        
        
        self.view.addGestureRecognizer(swipeBack)
        self.playController.showsPlaybackControls = false
        self.playController.view.isUserInteractionEnabled = false
        playController.removeFromParent()
        cameraManager.stopCaptureSession()
        self.containerView.isHidden = false
        
        if progress.isAnimating() == true {
            progress.stopAnimation()
        }
        
        cameraManager.stopVideoRecording ( { (Videourl, err) in
            
            self.SavedUrl = Videourl
            if let url = Videourl {
                
                DispatchQueue.main.async {
                    self.playerVideo = AVPlayer(url: url)
                    self.playController.player = self.playerVideo
                    self.playController.view.frame = self.view.frame
                    self.addChild(self.playController)
                    self.recordedView.addSubview(self.playController.view)
                    
                    
                    
                    
                    
                    self.recordedView.isHidden = false
                    self.playerVideo.isMuted = false
                    
                    self.playerVideo.play()
                    
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(cameraVC.replay(note:)),
                                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
                    
                }
                
                
                
            }
            
        })
        
        
    }
    
    @objc func replay(note: NSNotification) {
    
        DispatchQueue.main.async {
            self.playerVideo.seek(to: CMTime.zero)
            self.playerVideo.play()
            
            
        }
    
    }

    @IBAction func doneBtnPressed(_ sender: Any) {
        
        
        
        DoneUrl = SavedUrl
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func resumeCamera() {
    
        self.containerView.isHidden = true
        self.recordBtn.isHidden = false
        self.playerVideo.pause()
        playController.removeFromParent()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
        
        self.cameraManager.resumeCaptureSession()
    
    
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        
        self.containerView.isHidden = true
        self.recordBtn.isHidden = false
        self.playerVideo.pause()
        playController.removeFromParent()
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
        
        self.cameraManager.resumeCaptureSession()
        
        
        
    }
    
    
}
