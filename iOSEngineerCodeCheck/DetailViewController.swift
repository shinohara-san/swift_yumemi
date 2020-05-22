//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class TitleLabel: UILabel {
    
    let titleValue: String
    
    init(titleValue: String){
        self.titleValue = titleValue
        super.init(frame: .zero)
        text = titleValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DetailViewController: UIViewController {
        deinit {
            print("deinit2")
        }
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var watcherLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var issueLabel: UILabel!
    
    var viewController: ViewController!
//    let repo = viewController.repo[viewController.index ?? 0]
    let ttlLabel: UILabel = TitleLabel(titleValue: "あああ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = viewController.repo[viewController.index ?? 0]
        
        if let language = repo["language"]{
            languageLabel.text = "Written in \(language)"
        }
        if let stargazersCount = repo["stargazers_count"]{
            starLabel.text = "\(stargazersCount) stars"
        }
        if let watchersCount = repo["watchers_count"]{
           watcherLabel.text = "\(watchersCount) watchers"
        }
        
        if let forksCount = repo["forks_count"]{
            forkLabel.text = "\(forksCount) forks"
        }
        if let openIssuesCount = repo["open_issues_count"]{
            issueLabel.text = "\(openIssuesCount) open issues"
        }
        getTitle()
        getImage()
        
    }
    
    func getTitle(){
        let repo = viewController.repo[viewController.index ?? 0]
        
        if let fullName = repo["full_name"]{
            titleLabel.text =  fullName as? String
        }
        
    }
    
    func getImage(){
        
        let repo = viewController.repo[viewController.index ?? 0]
        
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { [weak self](data, res, err) in
                    
                    if let err = err{
                        print(err.localizedDescription)
                        return
                    }
                    
                    guard let data = data else {return}
                    
                    let img = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.imgView.image = img
                    }
                }.resume()
            }
        }
        
    }
    
}
