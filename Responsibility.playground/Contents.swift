import UIKit

/// 责任链模式
/// iOS中消息转发机制以及触摸响应链机制都属于该模式

var greeting = "Hello, playground"

setupData()

func setupData() {
    let amount = 377
//    let arr =  ATM.withdrawCash(amount: amount)
    let arr = ATM.withdraw(amount: amount)
    dump(arr)
}

/// 场景
/// 根据取款数从ATM中取钱 优先根据最大金额取 例如取款 377
///  = 3 * 100 + 1 * 50 + 1 * 20 + 1 * 5 + 2 * 1
///

// enum CurrencyValue: Int, CaseIterable {
//    case hundred = 100
//    case fifty = 50
//    case twenty = 20
//    case ten = 10
//    case five = 5
//    case one = 1
// }

struct MoneyPile {
    /// 面值
    var value = 0
    /// 数量
    var quantity = 0
}

protocol Withdrawing {
    
    var value: Int { get }
    
    var next: Withdrawing? { get }
    /// @param value面值
    /// @param amount 取款金额
    /// @param next下一个面值的取款入口
    func withdraw(amount: Int) -> [MoneyPile]
}


class Withdraw: Withdrawing {
    var value: Int
    
    var next: Withdrawing?
    
    init(value: Int, next: Withdrawing? = nil) {
        self.value = value
        self.next = next
    }
    
    internal func withdraw(amount: Int) -> [MoneyPile] {
        if self.value == 0 {
            return []
        } else {
            let quantity = amount / self.value
            let balance = amount % self.value
            var arr = [MoneyPile(value: self.value, quantity: quantity)]
            if balance > 0 {
                let re = self.next?.withdraw(amount: balance)
                if let re = re {
                    arr += re
                }
            }
            return arr
        }
    }
}

/// 普通方式实现
//class ATM {
//    static let currencyValue: [Int] = [100, 50, 20, 10, 5, 1]
//
//    static func withdrawCash(amount: Int) -> [MoneyPile] {
//        var array: [MoneyPile] = []
//        var re: (quantity: Int, balnace: Int) = (0, amount)
//        var valueIndex = 0
//        repeat {
//            re = Withdraw.withdraw(value: currencyValue[valueIndex], amount: re.balnace)
//            dump(re)
//            
//            if re.quantity > 0 {
//                array.append(MoneyPile(value: currencyValue[valueIndex], quantity: re.quantity))
//            }
//            valueIndex += 1
//        } while re.balnace > 0
//        return array
//    }
//}

/// 响应者链的方式实现
class ATM {
    static let currencyValues: [Int] = [100, 50, 20, 10, 5, 1]
    
    static func withdraw(amount: Int) -> [MoneyPile] {
        var index = currencyValues.count - 1
        var drawer: Withdrawing?
        repeat {
            drawer = Withdraw(value: currencyValues[index], next: drawer)
            index -= 1
        } while index >= 0
        dump(drawer)
        let arr = drawer?.withdraw(amount: amount)
        
        if let arr = arr {
            let newArr = arr.filter { ele in
                ele.quantity > 0
            }
            return newArr
        }
        
        return []
    }
}
