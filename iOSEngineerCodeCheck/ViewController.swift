//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit


class ViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repo = [[String: Any]]()
    var delegate: ViewController?
    
    weak var task: URLSessionTask?
    var word: String?
    var url: URL?
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.text = "Search for Repository on GitHub"
        searchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        word = searchBar.text ?? ""
        
        if word?.count != 0 {
            
            url = URL(string:"https://api.github.com/search/repositories?q=\(word!)")
            
            if let _url = url{
                task = URLSession.shared.dataTask(with: _url) { [weak self](data, res, err) in
                    
                    guard let data = data else {return}
                    
                    if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let items = obj["items"] as? [[String: Any]] {
                            //                    print(items)
                            self?.repo = items
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
            
            // Needs to make the program work
            task?.resume()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Detail"{
            let detailViewController = segue.destination as? DetailViewController
            detailViewController?.viewController = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let _repo = repo[indexPath.row]
        cell.textLabel?.text = _repo["full_name"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Called when screen transition occurs
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
    
    deinit {
           print("deinit1")
       }
}
