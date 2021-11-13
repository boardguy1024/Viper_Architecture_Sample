# Viper_Architecture_Sample
UseCaseをジェネリック化したViperArchitecture✨

useCaseジェネリックはこんな感じ 👇🏿👇🏿

```ruby
import Foundation

protocol UseCaseProtocol where Failure: Error {
    associatedtype Parameter
    associatedtype Success
    associatedtype Failure
    
    func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?)
}


class UseCase<Parameter, Success, Failure: Error> {
    
    private let instance: UseCaseInstanceBase<Parameter, Success, Failure>
    
    init<T: UseCaseProtocol>(_ useCase: T) where T.Parameter == Parameter,
                                                 T.Success == Success,
                                                 T.Failure == Failure
    {
        self.instance = UseCaseInstance<T>(useCase)
    }
    
    func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
        instance.execute(param, completion: completion)
    }

}

private extension UseCase {
    
    class UseCaseInstanceBase<Parameter, Success, Failure: Error> {
        
        func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
            fatalError()
        }
    }
 
    class UseCaseInstance<T: UseCaseProtocol>: UseCaseInstanceBase<T.Parameter, T.Success, T.Failure> {
        
        private let useCase: T
        
        init(_ useCase: T) {
            self.useCase = useCase
        }
  
        override func execute(_ param: T.Parameter, completion: ((Result<T.Success, T.Failure>) -> Void)?) {
            useCase.execute(param, completion: completion)
        }
    }
}
```

--------------

#使用はこんな感じ！

## 遷移元のRouter内:
```ruby
  let sampleView = SampleViewController()
        let useCase = UseCase(SampleUseCase())
        let router = SampleRouter()
        sampleView.presenter = SamplePresenter(view: sampleView, inject: SamplePresenter.Dependency(useCase: useCase, router: router))
        
        view.navigationController?.pushViewController(sampleView, animated: true)
 ```       
## presenter内:
```ruby
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
 ``` 
