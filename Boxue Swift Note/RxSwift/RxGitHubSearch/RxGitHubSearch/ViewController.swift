//
//  ViewController.swift
//  RxGitHubSearch
//
//  Created by Bq Lin on 2021/2/16.
//  Copyright © 2021 Bq. All rights reserved.
//

import Alamofire
import RxCocoa
import RxSwift
import SwiftyJSON
import UIKit

class ViewController: UIViewController {
    @IBOutlet var repositoryName: UITextField!
    @IBOutlet var searchResult: UITableView!

    var bag: DisposeBag! = DisposeBag()

    let repositoryNameRelay = BehaviorRelay<String>(value: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        repositoryName.spellCheckingType = .no
        repositoryName.rx.text.orEmpty.distinctUntilChanged().bind(to: repositoryNameRelay).disposed(by: bag)
        
        repositoryNameRelay
            // 仅当两个字符以上才进行搜索
            .filter {
                $0.count > 2
            }
            // 过滤掉0.5秒之间的事件
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMap { [weak self] (name) -> Observable<RepositoryInfo> in
                print("input: \(name)")
                guard let self = self else { return Observable.empty() }

                return self.searchForGithub(name)
            }
            .subscribe(onNext: {
                let repoCount = $0["total_count"] as! Int
                let repoItems = $0["items"] as! [RepositoryInfo]

                if repoCount != 0 {
                    print("item count: \(repoCount)")

                    for item in repoItems {
                        print("---------------------------------")

                        let name = item["full_name"]!
                        let description = item["description"]!
                        let avatarUrl = item["avatar_url"]!

                        print("full name: \(name)")
                        print("description: \(description)")
                        print("avatar_url: \(avatarUrl)")
                    }
                }

            })
            .disposed(by: bag)
    }

    deinit {
        print("\(#function) in \(type(of: self))")
    }
}

// 网络请求相关代码
extension ViewController {
    typealias RepositoryInfo = [String: Any]

    private func searchForGithub(_ repositoryName: String) -> Observable<RepositoryInfo> {
        return Observable<RepositoryInfo>.create { observer -> Disposable in
            let url = "https://api.github.com/search/repositories"
            let parameters = [
                "q": repositoryName + " stars:>=2000"
            ]

            let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
                .responseJSON { [weak self] response in
                    guard let self = self else { return }

                    switch response.result {
                        case .success(let json):
                            // 增加与最新一项对比
                            //print("\nsearch for \(repositoryName)")
                            guard repositoryName == self.repositoryNameRelay.value else {
                                observer.onCompleted()
                                return
                            }
                            //print(response.request!.url!)
                            
                            let info = self.parseGithubResponse(json)
                            observer.onNext(info)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func parseGithubResponse(_ response: Any) -> RepositoryInfo {
        let json = JSON(response)
        let totalCount = json["total_count"].int!
        var ret: RepositoryInfo = [
            "total_count": totalCount,
            "items": []
        ]

        guard totalCount > 0 else {
            print("empty, json: \(json)")
            return ret
        }

        let items = json["items"]
        // print(items)
        var info: [RepositoryInfo] = []
        for (_, subJson): (String, JSON) in items {
            let fullName = subJson["full_name"].string!
            let description = subJson["description"].string!
            let htmlUrl = subJson["html_url"].string!
            let avatarUrl = subJson["owner"]["avatar_url"].string!
            info.append([
                "full_name": fullName,
                "description": description,
                "html_url": htmlUrl,
                "avatar_url": avatarUrl
            ])
        }
        ret["items"] = info

        return ret
    }
}
