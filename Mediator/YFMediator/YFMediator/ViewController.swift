//
//  ViewController.swift
//  YFMediator
//
//  Created by feng tian on 2024/9/4.
//

import UIKit
import YFMediatorService
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "首页"
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btn.setTitle("", for: .normal)
        btn.addTarget(self, action: #selector(self.clickBtn(sender:)), for: .touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(CGSizeMake(80, 80))
        }
        

        // Do any additional setup after loading the view.
    }
    
    @objc func clickBtn(sender: UIButton) {
        if let obj = YFMediatorSevice.classForProtocol(protocol: YFReveiveProtocol.self) as? YFReveiveProtocol {
            let controller = obj.toReceiveController(params: ["userName": "张三"]) {
                print("完成回调")
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

