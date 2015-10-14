#!/bin/bash

# for Windows
cd "$(dirname $0)"
HOSTSFILE="/c/Windows/System32/drivers/etc/hosts"
FILESPATH="./hosts"
files=$(find $FILESPATH -type f -maxdepth 1 2> /dev/null)

for h in $files; do
    cmp $HOSTSFILE $h &> /dev/null
    if [ $? -eq 0 ]; then
        current=${h##*/}
        echo "Current: [ $current ]"
        echo
        break
    fi

    list="${h}_list"
    if [ -d $list ]; then
        for i in $list/*; do
            a=$(cat $h $i | md5sum)
            b=$(cat $HOSTSFILE | md5sum)
            if [ "$a" = "$b" ]; then
                current=${h##*/}
                break
            fi
        done

        if [ -n "$current" ]; then
            echo "Current: [ $current(${i##*/}) ]"
            echo
            break
        fi
    fi
done


cphosts() {
    cp $1 $HOSTSFILE

    echo "Changed \"$HOSTSFILE\" to [ ${1##*/} ]"
    echo
    cat -n $HOSTSFILE
}

pause() {
    read -n 1 -p "Press any key to continue..." input
    if [ "$input" != '' ]; then
        echo -ne '\b \n'
    fi
}

i=0
for h in $files; do
    (( i++ ))
    if [ "$1" = "$i" ]; then
        cphosts $h
        exit 0
    fi
done

select h in ${files//$FILESPATH\//}; do
    if [ -z "$h" ]; then break; fi

    list="$FILESPATH/${h}_list"
    if [ -d $list ]; then
        cd $list
        select i in *; do
            cd -
            cat $FILESPATH/$h $list/$i > $HOSTSFILE

            echo -ne "\n"
            echo "Changed \"$HOSTSFILE\" to [ $h ]"
            echo
            cat -n $HOSTSFILE
            break
        done
        break
    fi

    if [ "$current" = "$h" ]; then break; fi
    echo -ne "\n"
    cphosts $FILESPATH/$h
    break
done

echo
pause
