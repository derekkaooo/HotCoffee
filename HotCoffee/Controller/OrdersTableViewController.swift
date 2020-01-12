//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by Derek on 2020/1/11.
//  Copyright © 2020 Derek. All rights reserved.
//

import UIKit

class OrdersTableViewController: UITableViewController {
    
    var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOrders()
    }
    
    private func populateOrders() {
        
        //guard let coffeeOrdersURL = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else {
            //fatalError("URL was incorrect")
        //}
        
        //let resource = Resource<[Order]>(url: coffeeOrdersURL)
        
        Webservice().load(resource: Order.all) { [weak self] result in
            switch result {
            case .success(let orders):
                self?.orderListViewModel.ordersViewModel = orders.map(OrderViewModel.init)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = vm.type
        //cell.detailTextLabel?.text = vm.size
        cell.detailTextLabel?.text = vm.email
        
        return cell
    }
}

extension OrdersTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navC = segue.destination as? UINavigationController, let addCoffeeOrderVC = navC.viewControllers.first as? AddOrderViewController else {
            fatalError("Error performing segue!")
        }
        addCoffeeOrderVC.delegate = self
    }
}

extension OrdersTableViewController: AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.ordersViewModel.count - 1, section: 0)], with: .automatic)
        
        //也可以讓他直接重 reload 一次
        //self.populateOrders()
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
