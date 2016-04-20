//
//  NN.swift
//  nlp100
//
//  Created by はるふ on 2016/04/20.
//  Copyright © 2016年 はるふ. All rights reserved.
//

import Foundation

struct TeacherData {
    let input: [Double]
    let output: [Double]
}

struct Perceptron {
    private var weights: [Double]
    
    func getOutput(input: [Double]) -> Double? {
        return VectorUtil.calcInnerProduct(input, weights)
    }
    
    mutating func setWeightAtIndex(weight: Double, index: Int) {
        guard index < self.weights.count else {
            return
        }
        self.weights[index] = weight
    }
    
    mutating func setWeights(weights: [Double]) {
        self.weights = weights
    }
    
    func getWeights() -> [Double] {
        return weights
    }
}

class VectorUtil {
    static func calcInnerProduct(a1: [Double], _ a2: [Double]) -> Double? {
        guard a1.count == a2.count else {
            return nil
        }
        
        return zip(a1, a2).map{(i, w) in i*w}.reduce(0, combine: {$0+$1})
    }
    
    static func calcLength(v: [Double]) -> Double {
        return sqrt(v.map({$0*$0}).reduce(0, combine: {$0+$1}))
    }
}

class NNLayer {
    private let perceptrons: [Perceptron]
    var weightFunc: MathFunc
    
    //typealias MathFunc = (Double) -> (Double)
    
    struct MathFunc {
        private var function: (Double) -> (Double)
        private var diffFunc: ((Double) -> (Double))?
        
        static let SMALL_DOUBLE = 0.00001
        
        init(_ function: (Double) -> (Double)) {
            self.function = function
            diffFunc = nil
        }
        
        init(_ function: (Double) -> (Double), diff: (Double) -> (Double)) {
            self.function = function
            self.diffFunc = diff
        }
        
        func getDiff(x: Double) -> Double {
            if let diff = self.diffFunc {
                return diff(x)
            }
            return (function(x+MathFunc.SMALL_DOUBLE) - function(x)) / MathFunc.SMALL_DOUBLE
        }
        
        func getResult(x: Double) -> Double {
            return function(x)
        }
        private static let sigmoidFunc: (Double) -> (Double) = {1.0 / (1 + pow(M_E, $0))}
        static let SIGMOID = MathFunc(sigmoidFunc, diff: {(1 - sigmoidFunc($0)) * sigmoidFunc($0)})
        static let IDENTITY = MathFunc({$0}, diff: {_ in 0.0})
    }
    
    private static func createPerceptrons(perceptronCount: Int, inputLengh: Int) -> [Perceptron] {
        return (0..<perceptronCount).map({_ in
            let weights = (0..<inputLengh).map{_ in Double(arc4random_uniform(1000))/1000*2}
            return Perceptron(weights: weights)
        })
    }
    
    init(perceptronCount: Int, inputLengh: Int) {
        perceptrons = NNLayer.createPerceptrons(perceptronCount, inputLengh: inputLengh)
        weightFunc = MathFunc({$0})
    }
    
    init(perceptronCount: Int, inputLengh: Int, weightFunc: MathFunc) {
        perceptrons = NNLayer.createPerceptrons(perceptronCount, inputLengh: inputLengh)
        self.weightFunc = weightFunc
    }
    
    func getOutput(input: [Double]) -> [Double] {
        return perceptrons.map({$0.getOutput(input)!}).map(weightFunc.getResult)
    }
    
    
    // teacherData, 学習係数
    func learn(teacherData: TeacherData, eta: Double) {
        var weights: [Double] = []
        let output = getOutput(teacherData.input)
        
        // 各入力に対する、出力への係数の合計
        let diff = zip(output, teacherData.output).map({pow(($0-$1), 2)}).reduce(0, combine: {$0+$1})/2
        for (o, t) in zip(output, teacherData.output) {
            
        }
        
    }
}

class NNModel {
    var layers: [NNLayer] = []
}
