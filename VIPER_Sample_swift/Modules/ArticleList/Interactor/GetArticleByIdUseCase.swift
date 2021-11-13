//
//  GetArticleByIdUseCase.swift
//  VIPER_Sample_swift
//
//  Created by park kyung seok on 2021/11/09.
//

import Foundation

// WebApiから記事のIDを指定して、ーつだけ記事を取得し ArticleEntityをreturnするUseCase
class GetArticleByIdUseCase: UseCaseProtocol {
    
    func execute(_ param: Int, completion: ((Result<ArticleEntity, Error>) -> Void)?) {
    
        // 本当は このapiのための repository -> API 順でアクセスする必要がある
        
        let session = URLSession(configuration: .default)
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(param)")!
        let task = session.dataTask(with: URLRequest(url: url)) { data, response, error in
            
            
            if let error = error {
                DispatchQueue.main.sync {
                    completion?(.failure(error))
                    return
                }
            }
            
            guard let data = data, let decode = try? JSONDecoder().decode(ArticleEntity.self, from: data) else {
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
