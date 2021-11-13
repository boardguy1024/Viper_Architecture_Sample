//
//  ArticleDetailPresenter.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/10.
//

import Foundation

protocol ArticleDetailPresenterProtocol: AnyObject {
    func viewDidLoad(articleEntity: ArticleEntity)
}

protocol ArticleDetailViewProtocol: AnyObject {
    func showArticle(_ articleEntity: ArticleEntity)
    func showError(_ error: Error)
}

class ArticleDetailPresenter {
    
    struct Dependency {
        let getArticleByIdUseCase: UseCase<Int, ArticleEntity, Error>
    }
    
    weak var view: ArticleDetailViewProtocol!
    private var di: Dependency
    
    init(view: ArticleDetailViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
}

extension ArticleDetailPresenter: ArticleDetailPresenterProtocol {
    func viewDidLoad(articleEntity: ArticleEntity) {
        
        di.getArticleByIdUseCase.execute(articleEntity.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let article):
                self.view.showArticle(article)
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    
}
