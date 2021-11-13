//
//  ArticleListPresenter.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import Foundation

// ViewがPresenterにprotocolを通して通知
protocol ArticleListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelect(articleEntity: ArticleEntity)
}

// PresenterがViewにprotocolを通して通知
protocol ArticleListViewProtocol: AnyObject {
    
    func showArticleList(_ articleEntities: [ArticleEntity])
    func showEmpty()
    func showError(_ error: Error)
}


class ArticleListPresenter {
    
    struct Dependency {
        let router: ArticleListRouterProtocol
        let getArticlesArrayUseCase: UseCase<Void, [ArticleEntity], Error>
    }
    
    weak var view: ArticleListViewProtocol!
    private var di: Dependency
    
    init(view: ArticleListViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
}

extension ArticleListPresenter: ArticleListPresenterProtocol {
    func viewDidLoad() {        
        
        di.getArticlesArrayUseCase.execute(()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                if articles.isEmpty {
                    self.view.showEmpty()
                } else {
                    self.view.showArticleList(articles)
                }
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    func didSelect(articleEntity: ArticleEntity) {
        di.router.showArticleDetail(articleEntity: articleEntity)
    }
}

