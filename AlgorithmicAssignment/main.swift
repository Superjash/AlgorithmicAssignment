//
//  main.swift
//  AlgorithmicAssignment
//
//  Created by 江绍珩 on 2018/11/7.
//  Copyright © 2018 江绍珩. All rights reserved.
//

import Foundation

// 背包问题
class BagItem {
    var id: Int = 0 // 物品序号
    var weight: Int // 重量
    var value: Int // 价格
    init() {
        weight = 10 + Int(arc4random()) % 20 // 物品重量 10 - 29 之间
        value = Int(arc4random()) % 100 // 物品价值 0 - 99 之间
    }
    
    init(_ id: Int, _ weight: Int, _ value: Int) {
        self.id = id
        self.weight = weight
        self.value = value
    }
}

class BagResult {
    var sumValue: Int // 总价值
    var path: [String] // 过程描述
    init() {
        sumValue = 0
        path = []
    }
}

class BagProcessor {
    var bagCapacity: Int = 0
    var items: [BagItem] = []
    init() {
        comonInit()
//        randomInit()
    }
    
    func comonInit() {
        bagCapacity = 10
        
        // id, weight, value
        let item0 = BagItem(1, 2, 6)
        let item1 = BagItem(2, 2, 3)
        let item2 = BagItem(3, 6, 5)
        let item3 = BagItem(4, 5, 5)
        let item4 = BagItem(5, 4, 6)
        
        items = [item0, item1, item2, item3, item4]
    }
    
    func randomInit() {
        bagCapacity = 50 + Int(arc4random()) % 20 // 背包容量 50 - 69 之间
        for i in 0..<8 {
            let item = BagItem()
            item.id = i + 1
            items.append(item)
        }
    }
    
    func start() {
        print("==========")
        print("背包容量 \(bagCapacity)")
        for item in items {
            print("\(item.id) 号物品，价值 \(item.value)，重量 \(item.weight)")
        }
        
//        let result = load01Bag(bagCapacity, items.count)
        let result = loadGeneralizedBag(bagCapacity, items.count)
        
        print("==========")
        for i in 0..<result.path.count {
            print("第 \(i + 1) 步，" + result.path[result.path.count - 1 - i])
        }
        print("总价 \(result.sumValue)")
    }
    
    // currentCapacity: 当前容量 currentBagItemCount: 当前剩余物品数量
    func load01Bag(_ currentCapacity: Int, _ currentBagItemCount: Int) -> BagResult {
        if currentBagItemCount == 0 {
            let result = BagResult()
            return result
        }
        let item = items[currentBagItemCount - 1]
        if currentCapacity >= item.weight {
            // 能放下
            let result1 = load01Bag(currentCapacity - item.weight, currentBagItemCount - 1)
            result1.sumValue += item.value
            let result2 = load01Bag(currentCapacity, currentBagItemCount - 1)
            if result1.sumValue > result2.sumValue {
                result1.path.append("放入第 \(currentBagItemCount) 个物品，剩余容量 \(currentCapacity - item.weight)")
                return result1
            } else {
                result2.path.append("不放第 \(currentBagItemCount) 个物品，剩余容量 \(currentCapacity)")
                return result2
            }
        } else {
            // 放不下
            let result = load01Bag(currentCapacity, currentBagItemCount - 1)
            result.path.append("放不下第 \(currentBagItemCount) 个物品，剩余容量 \(currentCapacity)")
            return result
        }
    }
    
    // currentCapacity: 当前容量 currentBagItemCount: 当前剩余物品数量
    func loadGeneralizedBag(_ currentCapacity: Int, _ currentBagItemCount: Int) -> BagResult {
        if currentBagItemCount == 0 {
            let result = BagResult()
            return result
        }
        let item = items[currentBagItemCount - 1]
        if currentCapacity >= item.weight {
            // 能放下
            var bestBagResult = BagResult()
            for i in 0...currentCapacity / item.weight {
                // 放 i 个
                let result = loadGeneralizedBag(currentCapacity - item.weight * i, currentBagItemCount - 1)
                result.sumValue += item.value * i
                result.path.append("放入第 \(currentBagItemCount) 个物品 \(i) 个，剩余容量 \(currentCapacity - item.weight * i)")
                if result.sumValue >= bestBagResult.sumValue {
                    bestBagResult = result
                }
            }
            return bestBagResult
        } else {
            // 放不下
            let result = loadGeneralizedBag(currentCapacity, currentBagItemCount - 1)
            result.path.append("放不下第 \(currentBagItemCount) 个物品，剩余容量 \(currentCapacity)")
            return result
        }
    }
}

/*
 背包问题结束
 ================================================================================
 ================================================================================
 */

// 工序问题
class ManufactureItem {
    var id: Int
    var t1: Int // 工件在机器1上的加工时间
    var t2: Int // 工件在机器2上的加工时间
    init(_ id: Int, _ t1: Int, _ t2: Int) {
        self.id = id
        self.t1 = t1
        self.t2 = t2
    }
}

class ManufactureResult {
    var cost: Int // 所需时间
    var path: [String]
    init() {
        cost = 0
        path = []
    }
}

class ManufactureProcessor {
    var items: [ManufactureItem] = []
    init() {
        comonInit()
    }
    
    func comonInit() {
        // id, t1, t2
        let item0 = ManufactureItem(1, 2, 6)
        let item1 = ManufactureItem(2, 2, 3)
        let item2 = ManufactureItem(3, 6, 5)
        let item3 = ManufactureItem(4, 5, 5)
        let item4 = ManufactureItem(5, 4, 6)
        
        items = [item0, item1, item2, item3, item4]
    }
    
    func start() {
        print("==========")
        for item in items {
            print("\(item.id) 号工件，t1时间 \(item.t1)，t2时间 \(item.t2)")
        }
        
        let result = machiningItem(items, 0)
        
        print("==========")
        for i in 0..<result.path.count {
            print("第 \(i + 1) 步，" + result.path[result.path.count - 1 - i])
        }
        print("总耗时 \(result.cost)")
    }
    
    func machiningItem(_ waitingItems: [ManufactureItem], _ waitingTime: Int) -> ManufactureResult {
        if waitingItems.count == 0 {
            let result = ManufactureResult()
            result.cost = waitingTime
            return result
        }
        var bestResult = ManufactureResult()
        bestResult.cost = Int.max
        for i in 0..<waitingItems.count {
            // 此次加工待加工工件里面的第 i 个（不一定是全部工件的第 i 个）
            var nextWaitingItems = waitingItems
            nextWaitingItems.remove(at: i)
            var nextWaitingTime: Int // = waitingItems[i].t2 + max(waitingTime - waitingItems[i].t1, 0)
            if waitingTime > waitingItems[i].t1 {
                nextWaitingTime = waitingItems[i].t2 + waitingTime - waitingItems[i].t1
            } else {
                nextWaitingTime = waitingItems[i].t2
            }
            let result = machiningItem(nextWaitingItems, nextWaitingTime)
            result.cost += waitingItems[i].t1
            result.path.append("加工 \(waitingItems[i].id) 号工件")
            if result.cost < bestResult.cost {
                bestResult = result
            }
        }
        return bestResult
    }
}

/*
 工序问题结束
 ================================================================================
 ================================================================================
 */

// TSP问题
// TO DO: TSP问题

/*
 TSP问题结束
 ================================================================================
 ================================================================================
 */

// 入口
print("Hello, World!")

let bp = BagProcessor()
bp.start()

let mp = ManufactureProcessor()
mp.start()















