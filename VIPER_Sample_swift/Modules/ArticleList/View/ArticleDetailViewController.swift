//
//  ArticleDetailViewController.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    enum Row: String {
        case title
        case body
        
        static var rows: [Row] {
            return [.title, .body]
        }
    }
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ArticleDetailPresenterProtocol!
    //外から代入するためpurblic
    var article: ArticleEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad(articleEntity: article)
    }

}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Row.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = Row.rows[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         if row == .title {
            cell.textLabel?.text = article.title
            cell.detailTextLabel?.text = article.body
        } else {
            cell.textLabel?.text = article.body
            cell.detailTextLabel?.text = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ArticleDetailViewController: ArticleDetailViewProtocol {
    func showArticle(_ articleEntity: ArticleEntity) {
        self.article = articleEntity
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        // TODO
    }
    
    
}
