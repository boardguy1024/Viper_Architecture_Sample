//
//  UseCase1.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/13.
//

// メモするファイルです。（プロジェクトとは無関係）

// ひとつのファイルにViperの流れを実装

import Foundation
import UIKit

protocol UseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?)
}


// UseCase.swift --------------------------------------------------------------------------------------

protocol SomeRouterProtocol {
    func showSampleViewController()
}

class SomeRouter: SomeRouterProtocol {
    
    weak var view: UIViewController!
    
    init(view: UIViewController) {
        self.view = view
    }

    func showSampleViewController() {
        
        let sampleView = SampleViewController()
        let useCase = UseCase(SampleUseCase())
        let router = SampleRouter()
        sampleView.presenter = SamplePresenter(view: sampleView, inject: SamplePresenter.Dependency(useCase: useCase, router: router))
        
        view.navigationController?.pushViewController(sampleView, animated: true)
    }
}
// ----------------------------------------------------------------------------------------------------




// UseCase.swift --------------------------------------------------------------------------------------
class UseCase<Parameter, Success, Failure: Error> {
    
    private var instance: UseCaseInstanceBase<Parameter, Success, Failure>
    
    // ここでジェネリックの要素とinitのTの要素と比較する理由は
    // presenter内のDIでUseCaseの確定した「Type」とモジュール生成する際に依存性注入するときのinitのTの「type」が当然同じである必要があるため
    init<T: UseCaseProtocol>(_ useCase: T) where T.Parameter == Parameter, T.Success == Success, T.Failure == Failure {
        self.instance = UseCaseInstance<T>(useCase)
    }
    
    // Presenterでこの型をつかうのでUseCaseProtocolと同じシグネチャーのexcuteを追加
    func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
        instance.execute(param, completion: completion)
    }
}

private extension UseCase {
    
    private class UseCaseInstanceBase<Parameter, Success, Failure: Error> {
        
        func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
            //このクラスはoverrideさせて使うため、ダイレクトに使うことを防ぐ意味としてfatalError()を設定
            fatalError()
        }
    }
    
    private class UseCaseInstance<T: UseCaseProtocol>: UseCaseInstanceBase<T.Parameter, T.Success, T.Failure> {
        
        // 外部からのUseCaseProtocolに準拠したUseCaseが代入されて
        private let useCase: T
        
        init(_ useCase: T) {
            self.useCase = useCase
        }
        
        // Tの typeで .excuteを実行
        override func execute(_ param: T.Parameter, completion: ((Result<T.Success, T.Failure>) -> Void)?) {
            useCase.execute(param, completion: completion)
        }
    }
}

// ----------------------------------------------------------------------------------------------------






// SampleUseCase.swift ---------------------------------------------------------------------------------

class SampleUseCase: UseCaseProtocol {
    
    func execute(_ param: Void, completion: ((Result<[ArticleEntity], Error>) -> Void)?) {
        // API 通信後 completion
       // completion?(result)
    }
}

// ----------------------------------------------------------------------------------------------------


// SamplePresenter.swift -------------------------------------------------------------------------

//本来ならViewController.swiftに持つべきだが
// Presenter.swiftにまとめることで一眼でやることがわかりやすいのでここで持たせる
protocol SampleViewProtocol: AnyObject{
    func showData()
    func showError()
    func showLoading()
}

// PresenterProtocol
protocol SamplePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapNextView()
}

class SamplePresenter {
    
    struct Dependency {
        let useCase: UseCase<Void, [ArticleEntity], Error>
        let router: SampleRouterProtocol
    }
    
    // 強参照避けるため weakをつける weakはoptionalのため!をつける
    weak var view: SampleViewProtocol!
    var di: Dependency
    
    init(view: SampleViewProtocol, inject dependency: Dependency) {
        self.view = view
        self.di = dependency
    }
    
}

extension SamplePresenter: SamplePresenterProtocol {
    func viewDidLoad() {
        di.useCase.execute(()) { result in
            switch result {
            case .success(let articleList):
                print(articleList.description)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapNextView() {
        di.router.showNextView()
    }
}



// ------------------------------------------------------------------------------------------------



// SampleViewController.swift -------------------------------------------------------------------------

class SampleViewController: UIViewController {
   
    var presenter: SamplePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension SampleViewController: SampleViewProtocol {
    func showData() {
    }
    func showLoading() {
    }
    func showError() {
    }
}

// ------------------------------------------------------------------------------------------------


// SampleRouter.swift ---------------------------------------------------------------------------------

protocol SampleRouterProtocol {
    func showNextView()
}

class SampleRouter: SampleRouterProtocol {
    func showNextView() {
        
    }
}

// ----------------------------------------------------------------------------------------------------
