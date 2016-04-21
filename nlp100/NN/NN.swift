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

class Perceptron {
    private var weights: [Double] = []
    
    init(weights: [Double]) {
        self.weights = weights
    }
    
    func getOutput(input: [Double]) -> Double? {
        return VectorUtil.calcInnerProduct(input, weights)
    }
    
    func setWeightAtIndex(weight: Double, index: Int) {
        guard index < self.weights.count else {
            return
        }
        self.weights[index] = weight
    }
    
    func setWeights(weights: [Double]) {
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

struct MathFunc {
    private var function: (Double) -> (Double)
    private var diffFunc: ((Double) -> (Double))?
    private var diffByOutFunc: ((Double) -> (Double))?
    
    static let SMALL_DOUBLE = 0.00001
    
    init(_ function: (Double) -> (Double)) {
        self.function = function
        diffFunc = nil
    }
    
    init(_ function: (Double) -> (Double), diff: (Double) -> (Double)) {
        self.function = function
        self.diffFunc = diff
    }
    
    init(_ function: (Double) -> (Double), diff: (Double) -> (Double), diffByOut: (Double) -> (Double)) {
        self.function = function
        self.diffFunc = diff
        self.diffByOutFunc = diffByOut
    }
    
    func calcDiff(x: Double) -> Double {
        if let diff = self.diffFunc {
            return diff(x)
        }
        return (function(x+MathFunc.SMALL_DOUBLE) - function(x)) / MathFunc.SMALL_DOUBLE
    }
    
    func calcDiffByOut(out: Double) -> Double {
        if let diff = self.diffByOutFunc {
            return diff(out)
        }
        return 0.0
    }
    
    func calc(x: Double) -> Double {
        return function(x)
    }
    private static let sigmoidFunc: (Double) -> (Double) = {1.0 / (1 + pow(M_E, $0))}
    static let SIGMOID = MathFunc(sigmoidFunc, diff: {i in
        let out = sigmoidFunc(i)
        return (1 - out) * out
        }, diffByOut: {out in (1 - out) * out})
    static let IDENTITY = MathFunc({$0}, diff: {_ in 0.0})
}

class NNLayer {
    private let perceptrons: [Perceptron]
    var weightFunc: MathFunc
    
    //typealias MathFunc = (Double) -> (Double)
    
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
        return perceptrons.map({$0.getOutput(input)!}).map(weightFunc.calc)
    }
    
    func getDiff(teacherData: TeacherData) -> Double {
        return zip(getOutput(teacherData.input), teacherData.output).map({pow(($0-$1), 2)}).reduce(0, combine: {$0+$1})/2
    }
    
    // teacherData, 学習係数
    // 各入力に対する
    func learn(teacherData: TeacherData, coefs: [[Double]], eta: Double) -> [[Double]]{
        let output = getOutput(teacherData.input)
        
        // diffs[i][j] = 出力iへのn層への入力j(=n-1層の出力j)の微分
        // n-1層入力k->n-1層の出力jはw * weightFunc.calcDiff(n-1層入力)
        // n-1層入力->n層出力はweightFunc.calcDiff(n-1層入力) * diff[i][k]をkについて足しあわせ
        let diffs = zip(perceptrons, zip(output, teacherData.output)).map { (p, ot) in
            zip(teacherData.input, p.getWeights()).map{ (input, currentWeight) in
                 (ot.1 - ot.0) * weightFunc.calcDiffByOut(ot.0)
            }
        }
        
        let newDiffs = coefs.enumerate().map{(i,coef) in
            perceptrons.first!.getWeights().enumerate().map{ n, w in
                coef.map({coef in coef * w * weightFunc.calcDiff(teacherData.input[n])}).reduce(0){$0+$1}
            }
        }
        
        for (p, (o, t)) in zip(perceptrons, zip(output, teacherData.output)) {
            let ws = zip(teacherData.input, p.getWeights()).map{ (input, currentWeight) in
                currentWeight - eta * (t - o) * weightFunc.calcDiff(input) * input
            }
            p.setWeights(ws)
        }
        
        return diffs
    }
}

class NNModel {
    var layers: [NNLayer] = [NNLayer(perceptronCount: 40, inputLengh: 81, weightFunc: MathFunc.SIGMOID),
                             NNLayer(perceptronCount: 10, inputLengh: 40, weightFunc: MathFunc.SIGMOID)]
    
    func getOutput(firstInput: [Double]) -> [Double] {
        var input = firstInput
        for layer in layers {
            input = layer.getOutput(input)
        }
        return input
    }
    
    func learn(teacherData: TeacherData) {

        for (i, layer) in layers.reverse().enumerate() {
            //layer.learn(<#T##teacherData: TeacherData##TeacherData#>, coefs: <#T##[Double]#>, eta: <#T##Double#>)
        }
    }
    
    /*func learn(teacherData: TeacherData) {
        var input = teacherData.input
        var output = teacherData.input
        for layer in layers {
            layer.learn(input, eta: <#T##Double#>)
            input = layer.getOutput(input)
        }
    }*/
    
    
    
    
    
    
    
    
    
    
}
