//
//  ViewController.swift
//  RxGitHubSearch
//
//  Created by Bq Lin on 2021/2/16.
//  Copyright © 2021 Bq. All rights reserved.
//

import Alamofire
import RxCocoa
import RxDataSources
import RxSwift
import SwiftyJSON
import UIKit

class ViewController: UIViewController {
    @IBOutlet var repositoryName: UITextField!
    @IBOutlet var searchResult: UITableView!

    var bag: DisposeBag! = DisposeBag()

    let repositoryNameRelay = BehaviorRelay<String>(value: "")

    // 带分区的数据类型
    typealias SectionTableModel = SectionModel<String, RepositoryModel>
    let dataSource = RxTableViewSectionedReloadDataSource<SectionTableModel>(configureCell: { _, tableView, indexPath, element in
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "RepositoryInfoCell",
                for: indexPath
            )
            as! RepositoryInfoTableViewCell
        cell.name.text = element.name
        cell.detail.text = element.detail
        return cell
    },titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
    })

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
            .flatMap { [weak self] (name) -> Observable<[RepositoryModel]> in
                print("input: \(name)")
                guard let self = self else { return Observable.empty() }

                return self.searchForGithub(name)
            }
            .subscribe(onNext: { [weak self] results in
                guard let self = self else { return }

                // 清空table view
                self.searchResult.dataSource = nil

                // 使用rx方式构建table view cell
                //typealias O = Observable<[RepositoryModel]>
                //typealias CC = (Int, RepositoryModel, RepositoryInfoTableViewCell) -> Void // index, model, cell type
                //
                //let binder: (O) -> (@escaping CC) -> Disposable =
                //    self.searchResult.rx.items(cellIdentifier: "RepositoryInfoCell",
                //                               cellType: RepositoryInfoTableViewCell.self)
                //let curriedArgument = { (
                //    _: Int,
                //    element: RepositoryModel,
                //    cell: RepositoryInfoTableViewCell
                //) in
                //    cell.name.text = element.name
                //    cell.detail.text = element.detail
                //}
                //Observable.just(results).bind(to: binder, curriedArgument: curriedArgument).disposed(by: self.bag)

                // 若是连起来写会易懂一些
                // Observable.just(results).bind(to: self.searchResult.rx.items(cellIdentifier: "RepositoryInfoCell", cellType: RepositoryInfoTableViewCell.self)) {
                //    _, element, cell in
                //    cell.name.text = element.name
                //    cell.detail.text = element.detail
                // }.disposed(by: self.bag)
                
                // 带分区的绑定
                Observable.just(self.createGithubSearchModel(repoInfo: results)).bind(to: self.searchResult.rx.items(dataSource: self.dataSource)).disposed(by: self.bag)
            }, onError: { error in
                let err = error as NSError
                self.displayErrorAlert(error: err)
            })
            .disposed(by: bag)
        
        searchResult.rx.itemSelected.subscribe(onNext: { (indexPath) in
            print(indexPath)
        }).disposed(by: self.bag)
    }

    deinit {
        print("\(#function) in \(type(of: self))")
    }
}

// 网络请求相关代码
extension ViewController {
    private func createGithubSearchModel(repoInfo: [RepositoryModel]) -> [SectionTableModel] {
        var ret: [SectionTableModel] = []
        var items: [RepositoryModel] = []
        if repoInfo.count <= 10 {
            let sectionLabel = "TOp 1 - 10"
            items = repoInfo

            ret.append(SectionTableModel(model: sectionLabel, items: items))
        } else {
            for i in 1 ... repoInfo.count {
                items.append(repoInfo[i - 1])

                if i / 10 != 0, i % 10 == 0 {
                    let sectionLabel = "Top \(i - 9) - \(i)"
                    ret.append(SectionTableModel(model: sectionLabel, items: items))
                    items = []
                }
            }
        }
        
        return ret
    }

    private func searchForGithub(_ repositoryName: String) -> Observable<[RepositoryModel]> {
        return Observable<[RepositoryModel]>.create { observer -> Disposable in
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
                            // print("\nsearch for \(repositoryName)")
                            guard repositoryName == self.repositoryNameRelay.value else {
                                observer.onCompleted()
                                return
                            }
                            // print(response.request!.url!)

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

    private func parseGithubResponse(_ response: Any) -> [RepositoryModel] {
        let json = JSON(response)
        let totalCount = json["total_count"].int!
        var ret: [RepositoryModel] = [
        ]

        guard totalCount > 0 else {
            print("empty, json: \(json)")
            return ret
        }

        let items = json["items"]
        // print(items)
        for (_, subJson): (String, JSON) in items {
            let fullName = subJson["full_name"].string!
            let description = subJson["description"].string!
            let htmlUrl = subJson["html_url"].string!
            let avatarUrl = subJson["owner"]["avatar_url"].string!
            ret.append(RepositoryModel(name: fullName, detail: description, htmlUrl: htmlUrl, avatar: avatarUrl))
        }

        return ret
    }

    private func displayErrorAlert(error: NSError) {
        let alert = UIAlertController(title: "Network error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))

        present(alert, animated: true, completion: nil)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        view.endEditing(true)
    }
}
