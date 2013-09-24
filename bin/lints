#!/bin/bash


FILE=$@
SUFFIX=${FILE##*.}
JSLINT="$HOME/.bin/jslint"
CSSLINT="/usr/local/share/npm/bin/csslint"
CSSLINT_PARAM="--format=compact \
--errors=\
errors,\
display-property-grouping,\
regex-selectors \
--warnings=\
adjoining-classes,\
important,\
box-sizing,\
overqualified-elements,\
fallback-colors,\
duplicate-properties,\
empty-rules,\
rules-count,\
font-sizes,\
font-faces,\
floats,\
outline-none,\
shorthand,\
text-indent,\
universal-selector,\
unqualified-attributes,\
vendor-prefix,\
zero-units \
"
PATTERN="s/: line ([[:digit:]]+), col [[:digit:]]+,/(\1):/"

case "$SUFFIX" in
js|JS|json|JSON|jsx|JSX)
    $JSLINT $FILE;;
css|CSS)
    $CSSLINT $CSSLINT_PARAM $FILE | grep -v "^$" | sed -E "$PATTERN";;
esac

