//
//  ArticleListViewController.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import UIKit

class ArticleListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var presenter: ArticleListPresenterProtocol!
    
    private var articleList = [ArticleEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        presenter.viewDidLoad()
    }

}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = articleList[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelect(articleEntity: articleList[indexPath.row])
    }
}

extension ArticleListViewController: ArticleListViewProtocol {
    func showArticleList(_ articleEntities: [ArticleEntity]) {
        self.articleList = articleEntities
        tableView.reloadData()
    }
    
    func showEmpty() {
        showArticleList([])
    }
    
    func showError(_ error: Error) {
        // TODO  
    }
    
    
}
