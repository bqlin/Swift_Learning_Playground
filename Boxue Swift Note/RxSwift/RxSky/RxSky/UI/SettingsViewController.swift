//
//  SettingsViewController.swift
//  RxSky
//
//  Created by Bq Lin on 2021/2/26.
//  Copyright © 2021 Bq. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func controllerDidChangeTimeMode(
        controller: SettingsViewController)
    func controllerDidChangeTemperatureMode(
        controller: SettingsViewController)
}

class SettingsViewController: UITableViewController {
    weak var delegate: SettingsViewControllerDelegate?
}

extension SettingsViewController {

    // MARK: - Table view data source
    override func numberOfSections(
        in tableView: UITableView) -> Int {
        SettingsViewModel.section.count
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        SettingsViewModel.section[section].count
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String? {
        SettingsViewModel.section[section].name
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.reuseIdentifier,
            for: indexPath) as? SettingsTableViewCell else {
            fatalError("Unexpected table view cell")
        }
        let vmClass: Any = SettingsViewModel.section[indexPath.section]
        var vm: SettingViewModelProtocol!
        switch vmClass {
        case _ as SettingsViewModel.Date.Type:
            guard let dateMode = DateMode(rawValue: indexPath.row) else {
                fatalError("Invalid IndexPath")
            }
            vm = SettingsViewModel.Date(dateMode: dateMode)
        case _ as SettingsViewModel.Temperature.Type:
            guard let temperatureMode = TemperatureMode(rawValue: indexPath.row) else {
                fatalError("Invalid IndexPath")
            }
            vm = SettingsViewModel.Temperature(
                temperatureMode: temperatureMode)
        default:
            break
        }
        cell.accessoryType = vm.accessory
        cell.label.text = vm.labelText
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vmClass: Any = SettingsViewModel.section[indexPath.section]
        switch vmClass {
        case _ as SettingsViewModel.Date.Type:
            guard let dateMode = DateMode(rawValue: indexPath.row) else {
                fatalError("Invalid IndexPath")
            }
            guard UserDefaults.dateMode != dateMode else {
                return
            }
            UserDefaults.dateMode = dateMode
            delegate?.controllerDidChangeTimeMode(controller: self)
        case _ as SettingsViewModel.Temperature.Type:
            guard let temperatureMode = TemperatureMode(rawValue: indexPath.row) else {
                fatalError("Invalid IndexPath")
            }
            guard UserDefaults.temperatureMode != temperatureMode else {
                return
            }
            UserDefaults.temperatureMode = temperatureMode
            delegate?.controllerDidChangeTemperatureMode(controller: self)
        default:
            break
        }
        let sections = IndexSet(integer: indexPath.section)
        tableView.reloadSections(sections, with: .none)
    }
}