//
//  WTPlayerController.swift
//  VideoPlayerDemo
//
//  Created by 廖文韬 on 2018/8/3.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import AVKit

class WTPlayerController: UIViewController {

    var player : AVPlayer!
    var palyerItem : AVPlayerItem!
    var bufferTimeLabel : UILabel!
    
    lazy var slider : UISlider = { [weak self] in
        let slider  = UISlider(frame: CGRect(x: 20, y: 300 + 30, width:(self?.view.frame.width)! - 40, height: 20))
        slider.addTarget(self, action: #selector(sliderValueChange(sender:)), for: .valueChanged)
        return slider
    }()
    
    lazy var loadTimeLabel : UILabel = { [weak self] in
        let loadTimeLabel = UILabel(frame: CGRect(x: 20, y: (self?.slider.frame.maxY)!, width: 100, height: 20))
        loadTimeLabel.text = "00:00:00"
        return loadTimeLabel
    }()
    
    lazy var totalTimeLabel : UILabel = { [weak self] in
        let totalTimeLabel =  UILabel(frame: CGRect(x: (self?.slider.frame.maxX)! - 100, y: (self?.slider.frame.maxY)!, width: 100, height: 20))
        totalTimeLabel.text = "00:00:00"
        return totalTimeLabel
    }()
    
    lazy var pasueButton : UIButton = { [weak self] in
        let button = UIButton(frame: CGRect(x: 20, y: 280, width: 60, height: 30))
        button.setTitle("暂停", for: .normal)
        button.setTitle("播放", for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(pauseButtonSelected(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "AVPlayer播放视频"
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.slider)
        self.view.addSubview(self.loadTimeLabel)
        self.view.addSubview(self.totalTimeLabel)
        self.view.addSubview(self.pasueButton)
        
        //创建媒体资源管理对象
        self.palyerItem = AVPlayerItem(url: NSURL(string: urlString)! as URL)
        //创建ACplayer：负责视频播放
        self.player = AVPlayer.init(playerItem: self.palyerItem)
        self.player.rate = 1.0//播放速度 播放前设置
        //创建显示视频的图层
        let playerLayer = AVPlayerLayer.init(player: self.player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300)
        self.view.layer.addSublayer(playerLayer)
        //观察属性
        self.palyerItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        self.palyerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        self.palyerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.palyerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

        
        self.player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: DispatchQueue.main) { [weak self](time) in
            //当前正在播放的时间
            let loadTime = CMTimeGetSeconds(time)
            //视频总时间
            let totalTime = CMTimeGetSeconds((self?.player.currentItem?.duration)!)
            //滑块进度
            self?.slider.value = Float(loadTime/totalTime)
            self?.loadTimeLabel.text = self?.changeTimeFormat(timeInterval: loadTime)
            self?.totalTimeLabel.text = self?.changeTimeFormat(timeInterval: CMTimeGetSeconds((self?.player.currentItem?.duration)!))
        }
    }
    
    deinit {
        self.palyerItem.removeObserver(self, forKeyPath: "status", context: nil)
        self.palyerItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        self.palyerItem.removeObserver(self, forKeyPath: "playbackBufferEmpty", context: nil)
        self.palyerItem.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp", context: nil)
        NotificationCenter.default.removeObserver(self)
    }
}

extension WTPlayerController{
    //KVO观察
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch self.palyerItem.status{
                case .readyToPlay:
                    self.play()
                case .failed:
                    print("failed")
                case.unknown:
                    print("unkonwn")
            }
        }else if keyPath == "loadedTimeRanges"{
            let loadTimeArray = self.palyerItem.loadedTimeRanges
            //获取最新缓存的区间
            let newTimeRange : CMTimeRange = loadTimeArray.first as! CMTimeRange
            let startSeconds = CMTimeGetSeconds(newTimeRange.start);
            let durationSeconds = CMTimeGetSeconds(newTimeRange.duration);
            let totalBuffer = startSeconds + durationSeconds;//缓冲总长度
            print("当前缓冲时间：%f",totalBuffer)
        }else if keyPath == "playbackBufferEmpty"{
            print("正在缓存视频请稍等")
        }
        else if keyPath == "playbackLikelyToKeepUp"{
            print("缓存好了继续播放")
            self.player.play()
        }
    }
    
    //播放
    func play(){
        self.player.play()
    }
    
    //暂停
    @objc func pauseButtonSelected(sender:UIButton)  {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            self.player.pause()
        }else{
            self.play()
        }
    }
    
    //播放进度
    @objc func sliderValueChange(sender:UISlider){
        if self.player.status == .readyToPlay {
            let time = Float64(sender.value) * CMTimeGetSeconds((self.player.currentItem?.duration)!)
            let seekTime = CMTimeMake(Int64(time), 1)
            self.player.seek(to: seekTime)
        }
    }
    
    //转时间格式
    func changeTimeFormat(timeInterval:TimeInterval) -> String{
        return String(format: "%02d:%02d:%02d",(Int(timeInterval) % 3600) / 60, Int(timeInterval) / 3600,Int(timeInterval) % 60)
    }
    
    @objc func playToEndTime(){
        print("播放完成")
    }
    
}
