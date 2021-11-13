//
//  GetArticlesArrayUseCase.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import Foundation

// WebApiからデータを取得してきて [Article]をreturnするUseCase
class GetArticlesArrayUseCase: UseCaseProtocol {
     
    // この場合、すべてのデータを取得するのでparamは不必要なのでvoidに設定
    func execute(_ param: Void, completion: ((Result<[ArticleEntity], Error>) -> Void)?) {
        
      
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            
            if let error = error {
                DispatchQueue.main.sync {
                    completion?(.failure(error))
                    return
                }
            }
            
            guard let data = data, let decode = try? JSONDecoder().decode([ArticleEntity].self, from: data) else {
                let error = NSError(domain: "parse-error", code: 1, userInfo: nil)
                DispatchQueue.main.sync {
                    completion?(.failure(error))
                }
                return
            }
            DispatchQueue.main.sync {
                completion?(.success(decode))
            }
            
        }
        task.resume()
        
    }
}
