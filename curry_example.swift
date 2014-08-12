let lines = [
  "WHAN that Aprille with his shoures soote",
  "The droghte of Marche hath perced to the roote",
  "And bathed every veyne in swich licour",
  "Of which vertu engendred is the flour"
]

// Currying -- instead of appendSeparator(separator:String, string:String) -> String,
func appendSeparator(separator:String)(string:String) -> String {
  return string + separator
}

// Partial Application, deriving a new function by applying a subset of arguments to a function:
let appendNewlineTo:(String) -> String = appendSeparator("\n")
let appendCommaTo:(String) -> String = appendSeparator(", ")

let sentence = lines.reduce("") { $0 + appendCommaTo($1) }
let stanza   = lines.reduce("") { $0 + appendNewlineTo($1) }

println("\n== As a sentence:")
println(sentence)
println("\n== As a stanza:")
println(stanza)
