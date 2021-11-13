//
//  ArticleListRouter.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import UIKit

protocol ArticleListRouterProtocol: AnyObject {
    
    func showArticleDetail(articleEntity: ArticleEntity)
}

class ArticleListRouter: ArticleListRouterProtocol {
    
    //画面遷移を行うにはViewControllerの参照が必要
    // 循環参照をさけるために weakをつける
    weak var view: UIViewController!
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func showArticleDetail(articleEntity: ArticleEntity) {
        
        guard let articleDetailViewController = UIStoryboard(name: "ArticleDetail", bundle: nil).instantiateInitialViewController() as? ArticleDetailViewController else {
            fatalError()
        }
        
        articleDetailViewController.article = articleEntity
        articleDetailViewController.presenter = ArticleDetailPresenter(view: articleDetailViewController,
                                                                       inject: .init(getArticleByIdUseCase: UseCase(GetArticleByIdUseCase())))
        
        view.navigationController?.pushViewController(articleDetailViewController, animated: true)
        
    }
}
