
//  UseCase.swift
//  VIPER_Sample_swift

//  Created by park kyung seok on 2021/11/09.
//

import Foundation

//Protocolの中でFailureはErrorに準拠させる
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
    
    //UseCaseのサブクラスとして定義
    class UseCaseInstanceBase<Parameter, Success, Failure: Error> {
        
        //このクラスにもUseCaseクラスと同じようにUseCaseと同じProtocolのシグネチャーのexecuteメソッドを追加
        //このexecuteメソッドは通常通り使用すると通ることのないDeadコードになるので
        //この中身の実装はfatalErrorになるようにする
        func execute(_ param: Parameter, completion: ((Result<Success, Failure>) -> Void)?) {
            fatalError()
        }
    }
    
    //UseCaseのサブクラスとして定義
    // これは「UseCaseInstanceBase」の継承クラスとなる
    // UseCaseProtocolを Tとしたジェネリックタイプを取らせる
    // さらに親クラス「UseCaseInstanceBase」では３つのジェネリックタイプを指定するのだが、これは全部、UseCaseProtocolのものに合わせる
    class UseCaseInstance<T: UseCaseProtocol>: UseCaseInstanceBase<T.Parameter, T.Success, T.Failure> {
        
        // このクラスには UseCaseのprotocolに準拠したオブジェクトを持たせるようにする
        private let useCase: T
        
        // それを渡すためのイニシャライザも定義
        init(_ useCase: T) {
            self.useCase = useCase
        }
        
        // つづいてオーバーライドする形で追加
        // このへんの要素はTのものにする
        override func execute(_ param: T.Parameter, completion: ((Result<T.Success, T.Failure>) -> Void)?) {
            useCase.execute(param, completion: completion)
        }
    }
    
    
}
