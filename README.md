# Viper_Architecture_Sample
UseCaseをジェネリック化したViperArchitecture✨

useCaseジェネリックはこんな感じ 👇🏿👇🏿

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

--------------
--------------

##使用はこんな感じ！

