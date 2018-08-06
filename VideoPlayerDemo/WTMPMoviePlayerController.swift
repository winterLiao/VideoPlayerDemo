//
//  WTMPMoviePlayerController.swift
//  VideoPlayerDemo
//
//  Created by 廖文韬 on 2018/8/3.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import MediaPlayer

class WTMPMoviePlayerController: UIViewController {

    
    var playerController : MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MPMoviePlayerController(9.0后被弃用）"
        self.view.backgroundColor = UIColor.white
        
        playerController = MPMoviePlayerController(contentURL: NSURL(string: urlString) as! URL)
        playerController?.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 300)
        self.view.addSubview((playerController?.view)!)
        //设置为默认风格
        self.playerController?.controlStyle = .default
        //重复播放
        self.playerController?.repeatMode = .one
        //播放视频
        self.playerController?.prepareToPlay()

        //播放完成监听（还有其他很多监听）
        NotificationCenter.default.addObserver(self, selector: #selector(playerStateFinished(notification:)), name: NSNotification.Name(rawValue: MPMoviePlayerPlaybackDidFinishReasonUserInfoKey), object: nil)
    }
    
    deinit {
        //退出界面关闭播放，移除通知
        self.playerController?.stop()
        self.playerController = nil
        NotificationCenter.default.removeObserver(self)
        
    }
}

extension WTMPMoviePlayerController{
    //播放结束监听
    @objc func playerStateFinished(notification:NSNotification){
        print("播放结束")
    }
}
