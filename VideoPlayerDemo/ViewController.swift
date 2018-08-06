//
//  ViewController.swift
//  VideoPlayerDemo
//
//  Created by 廖文韬 on 2018/8/3.
//  Copyright © 2018年 廖文韬. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit

let urlString = "http://ok841h9gr.bkt.clouddn.com/testMP4.mp4"

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = ["WKWebView播放视频","AVPlayer","AVPlayerViewController","MPMoviePlayerController(9.0后被弃用）","MPMoviePlayerViewController(9.0后被弃用)",]
    
    let vcName = ["WebViewController","WTPlayerController","AVPlayerViewController","WTMPMoviePlayerController","MPMoviePlayerViewController"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension ViewController : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!;
        let imageView = UIImageView(frame: CGRect(x:0,y:0,width:7,height:15));
        imageView.image = UIImage(named: "control_icon_go_nor");
        cell.accessoryView = imageView;
        cell.textLabel?.text = self.dataSource[indexPath.row];
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14);
        cell.selectionStyle = .none
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pushVC(vcName: vcName[indexPath.row])
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView();
    }
}

extension ViewController{
    func pushVC(vcName:String)  {
        
        if vcName == "MPMoviePlayerViewController"  {
            self.pushMPMoviePlayerViewController()
            return
        }
        
        if vcName == "AVPlayerViewController"  {
            self.pushAVPlayerViewController()
            return
        }
        
        guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
            return
        }
        let cls : AnyClass? = NSClassFromString((clsName as! String) + "." + vcName)
        let viewControllerCls = cls as! UIViewController.Type
        let playerViewController = viewControllerCls.init()
        self.navigationController?.pushViewController(playerViewController, animated: true)
    }
    
    
    func pushAVPlayerViewController(){
        //控制器推出的模式
//        let player = AVPlayer(url: NSURL(string: urlString)! as URL)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true, completion: nil)
        //添加view播放的模式
        let palyerController = WTPlyaerViewController()
        self.navigationController?.pushViewController(palyerController, animated: true)
    }
    
    func pushMPMoviePlayerViewController(){
        let playerViewController = MPMoviePlayerViewController(contentURL: NSURL(string: urlString)! as URL)
        playerViewController?.moviePlayer.scalingMode = .aspectFit
        self.present(playerViewController!, animated: true, completion: nil)
    }
    
    
    
}


