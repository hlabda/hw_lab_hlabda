import Foundation
import Alamofire

class Parser {
    private let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"

    func fetchRepositories(completion: @escaping ([Repository]) -> Void) {
        AF.request(url)
            .validate()
            .responseDecodable(of: Repositories.self) { response in
                switch response.result {
                case .success(let container):
                    completion(container.items)
                case .failure(let error):
                    print("Error fetching repositories: \(error.localizedDescription)")
                    completion([])
                }
            }
    }
}
