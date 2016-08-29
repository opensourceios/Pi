//
//  RMAnswerGenerator.swift
//  Pi
//
//  Created by Rigoberto Molina on 7/26/16.
//  Copyright © 2016 Rigoberto Molina. All rights reserved.
//

import Foundation

func RMAnswerGenerator(_ id: String, values: [Double]) -> String {
	switch id {
	case "Algebra1-Linear_Equation":
		let m = values[0]
		let b = values[1]
		
		return Algebra1LinearEquation(m, b: b)
	case "Algebra1-Point_Slope":
		let y1 = values[0]
		let m = values[1]
		let x1 = values[2]
		
		return Algebra1PointSlope(y1, m: m, x1: x1)
	case "Algebra1-Pythagorean_Theorem":
		let a = values[0]
		let b = values[1]
		let c = values[2]
		
		return Algebra1PythagoreanTheorem(a, b: b, c: c)
	case "Algebra1-Quadratic":
		let a = values[0]
		let b = values[1]
		let c = values[2]
		
		return Algebra1Quadratic(a, b: b, c: c)
	case "Algebra1-Square_Root":
		let num = values[0]
		
		return Algebra1SquareRoot(num)
	default:
		fatalError("Unrecognized Formula ID.")
	}
}

// MARK: Algebra 1

func Algebra1LinearEquation(_ m: Double, b: Double) -> String {
	return "y = \(m)x + \(b)"
}

func Algebra1PointSlope(_ y1: Double, m: Double, x1: Double) -> String {
	return "y - \(y1) = \(m)(x - \(x1))"
}

func Algebra1PythagoreanTheorem(_ a: Double, b: Double, c: Double) -> String {
	// TODO: Add Diverse Posibilities
	return "C = \(sqrt((a * a) + (b * b)))"
}

func Algebra1Quadratic(_ a: Double, b: Double, c: Double) -> String {
	return "\((-b + sqrt(pow(b, 2) - (4 * (a * c))) / 2 * a))"
}

func Algebra1SquareRoot(_ number: Double) -> String {
	return "\(sqrt(number))"
}

// MARK: Geometry
