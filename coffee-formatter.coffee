# refer to https://github.com/derekchiang/Coffee-Formatter.git

TWO_SPACE_OPERATORS = ['+=', '-=', '==', '<=', '>=', '=', '>', "<", '+', '-', '*', '/']
ONE_SPACE_OPERATORS = [':', '?', ')', '}', ',']

inStringOrComment = (index, line) ->
    for c, i in line
        if c == '#' and i <= index
            return true

        if c == "'" or c == '"'
            subLine = line.substr (i + 1)
            for cc, ii in subLine
                if cc == c
                    if i <= index <= (ii + i + 1)
                        return true
                    else
                        return inStringOrComment (index - (ii + i + 2)), (subLine.substr (ii + 1))

        # match regex
        if c == "/"
            subLine = line.substr (i + 1)
            for cc, ii in subLine
                if cc == c
                    if i <= index <= (ii + i + 1)
                        return true
                    else
                        return inStringOrComment (index - (ii + i + 2)), (subLine.substr (ii + 1))

    return false

notInStringOrComment = (index, line) ->
    return not inStringOrComment(index, line)

formatTwoSpaceOperator = (line) ->
    for operator in TWO_SPACE_OPERATORS
        newLine = ''
        skipNext = false
        for c, i in line
            # test if the operator is at i
            if (line.substr(i).indexOf(operator) == 0) and (notInStringOrComment i, line) and (not
                ((operator.length == 1) and
                    ((line[i + 1] in TWO_SPACE_OPERATORS) or (line[i - 1] in TWO_SPACE_OPERATORS))))
                newLine += " #{operator} " # insert a space before and after
                skipNext = true if operator.length == 2
            else
                newLine += c unless skipNext
                skipNext = false

        line = shortenSpaces newLine
    return line

shortenSpaces = (line) ->
    trimTrailing = (str) ->
        str.replace /\s\s*$/, ""

    prevChar = null
    newLine = ''

    for c, i in line
        if c == ' '
            newLine += c
        else
            line = line.substring(i)
            break

    for c, i in line
        unless notInStringOrComment(i, line) and (c == ' ' == prevChar)
            newLine = newLine + c
        prevChar = c

    return trimTrailing newLine

formatOneSpaceOperator = (line) ->
    for operator in ONE_SPACE_OPERATORS
        newLine = ''
        for c, i in line
            thisCharAndNextOne = line.substr(i, 2)
            if (line.substr(i).indexOf(operator) == 0) and
            (notInStringOrComment i, line) and
            (line.substr(i).indexOf('::') isnt 0) and
            (line.substr(i - 1).indexOf('::') isnt 0) and
            (line.substr(i + 1).indexOf('?') isnt 0) and
            (thisCharAndNextOne isnt "),") and
            (thisCharAndNextOne isnt ").") and
            (thisCharAndNextOne isnt ")[") and
            (thisCharAndNextOne isnt "))")
                newLine += "#{operator} " # insert a space after
            else
                newLine += c

        line = shortenSpaces newLine
    return line

module.exports = (lines) ->
    lines = lines.split "\n"
    result = []
    for line in lines
        newLine = line
        newLine = formatTwoSpaceOperator newLine
        newLine = formatOneSpaceOperator newLine
        newLine = shortenSpaces newLine
        result.push newLine

    return result.join '\n'
