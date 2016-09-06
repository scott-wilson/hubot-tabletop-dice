# Description:
#   Allows Hubot to roll dice
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot roll <num>d<sides> [<num>d<sides>] - Roll a dice a number of times. Adding dice will roll them also.
#
# Author:
#   scott.wilson

module.exports = (robot) ->
  robot.respond /roll (.+)/i, (res) ->
    dice = res.match[1]
    msg = ""
    totValues = []

    for die in getDice(dice)
      num = die[0]
      sides = die[1]
      msg += "Roll #{num}d#{sides}:\n"
      values = []

      for _ in [0...num] by 1
        roll = rollDie(sides)

        if roll == sides
          msg += "#{roll} *\n"
        else
          msg += "#{roll}\n"

        values.push(roll)
        totValues.push(roll)

      min = Math.min.apply(Math, values)
      max = Math.max.apply(Math, values)
      sum = values.reduce (t, s) -> t + s
      mean = Math.round(parseFloat(sum) / values.length * 100) / 100
      median = getMedian(values)
      msg += "min: #{min} max: #{max} sum: #{sum} mean: #{mean} median: #{median}\n\n"

    if not totValues.length
      res.reply("Sorry, I didn't understand you.")

    else
      min = Math.min.apply(Math, totValues)
      max = Math.max.apply(Math, totValues)
      sum = values.reduce (t, s) -> t + s
      mean = Math.round(parseFloat(sum) / values.length * 100) / 100
      median = getMedian(values)
      msg += "Total min: #{min} max: #{max} sum: #{sum} mean: #{mean} median: #{median}\n\n"

      res.reply("#{msg}")

getDice = (diceStr) ->
  regex = /(\d*)\s*d\s*(\d+)/gi
  result = regex.exec(diceStr)
  rolls = []

  while result
    num = result[1]
    sides = result[2]

    if not num
      num = "1"

    rolls.push([parseInt(num), parseInt(sides)])
    result = regex.exec(diceStr)

  return rolls

getMedian = (values) ->
  values.sort (a, b) -> return a - b
  half = Math.floor(values.length/2)

  if values.length % 2
    return values[half]

  return (values[half-1] + values[half]) / 2.0

rollDie = (sides) ->
  return 1 + Math.floor(Math.random() * sides)
