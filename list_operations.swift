let numbers = [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ]

let odds = numbers.filter { ($0 % 2) == 1 }
println("Odds: \(odds)")

let squares = numbers.map { $0 * $0 }
println("Squares: \(squares)")

let sum = numbers.reduce(0) { $0 + $1 }
println("Sum: \(sum)")
