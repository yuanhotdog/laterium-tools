#!/bin/bash

echo -e "\033[47m\033[30m"

mkdir -p .cache
METADAT_FILE=".cache/compiler.log"

CMDSUSERS="$USER@$(hostname)"

echo -ne "\033]0;$CMDSUSERS:~\007"

COMMAND_DIR="$(dirname "$0")"
COMMAND_TITLE=""
COMMAND_NAME="__@LaterIUM.sh"
COMMAND_SERVER="samp03svr"
COMMAND_BUILD="v1-2025"

COMPILER_LTIUM=false
COMPILER_PAWNCC=""

DEL=$(echo -en "\033[2K")

colourtext() {
    echo -ne "\033[${1}m${2}\033[0m"
}

command_typeof() {
    echo -ne "$(colourtext 32 "$CMDSUSERS")"
    echo -ne ":~\$ "
    read -r LATERIUM_F
    next
}

next() {
    CMDSFILE=true
    CMDSOPTION="cat"

    case "$LATERIUM_F" in
        "$CMDSOPTION -c")
            pkill -f "$COMMAND_SERVER" >/dev/null 2>&1

            COMMAND_TITLE="compilers"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            echo

            COMPILER_LTIUM=true
            compilers
            ;;
        "$CMDSOPTION -r")
            pkill -f "$COMMAND_SERVER" >/dev/null 2>&1

            COMMAND_TITLE="running"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            sleep 0
            servers
            ;;
        "$CMDSOPTION -d")
            COMMAND_TITLE="samp server debugger"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            testservers
            ;;
        "$CMDSOPTION -ci")
            pkill -f "$COMMAND_SERVER" >/dev/null 2>&1

            COMMAND_TITLE="compile running"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            COMPILER_LTIUM=false

            echo
            compilers
            grep -i "error" "$METADAT_FILE" >/dev/null && echo || ok_next

            ok_next
            ;;
        "$CMDSOPTION -C")
            COMMAND_TITLE="clear screen"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            clear
            command_typeof
            ;;
        "$CMDSOPTION -V")
            COMMAND_TITLE="vscode tasks"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            if [ -d ".vscode" ]; then
                rm -rf .vscode
            fi
            mkdir .vscode
            cat <<EOF > .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Run LaterIUM",
      "type": "process",
      "command": "\${workspaceFolder}/$COMMAND_NAME",
      "group": {
        "kind": "build",
        "isDefault": true
      },
      "problemMatcher": [],
      "detail": "Task to run the LaterIUM"
    }
  ]
}
EOF
            echo "# C? '.vscode/tasks.json'...: [yes]"
            command_end
            ;;
        "$CMDSOPTION -R")
            read -r nameput

            find "$COMMAND_DIR" -type f -name "$nameput.*" | while read -r file; do
                if [[ "$file" =~ \.io$ ]]; then
                    echo "E: File '$file' can't rename."
                    command_end
                fi

                if [[ ! "$file" =~ \.amx$ ]]; then
                    echo "R: '$file' to '$nameput.io.pwn'"
                    mv "$file" "$nameput.io.pwn"
                fi
            done

            command_end
            ;;
        "$CMDSOPTION -F")
            COMMAND_TITLE="folder check"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            if [ -d "filterscripts" ]; then
                echo
                echo "# filterscripts is .. Ok .."
                echo " [A subdirectory or file filterscripts already exists.]"
                echo -
                sleep 1
            else
                mkdir filterscripts
                echo "# C? '$COMMAND_DIR/filterscripts'...: [yes]"
                sleep 1
            fi

            if [ -d "gamemodes" ]; then
                echo
                echo "# gamemodes is .. Ok .."
                echo " [A subdirectory or file gamemodes already exists.]"
                echo -
                sleep 1
            else
                mkdir gamemodes
                cat <<EOF > "gamemodes/main.io.pwn"
#include <a_samp>

main() {
    print "Hello, World!";
}
EOF
                echo
                echo "# C? '$COMMAND_DIR/gamemodes'...: [yes]"
                echo
                sleep 1
            fi

            if [ -d "scriptfiles" ]; then
                echo
                echo "# scriptfiles is .. Ok .."
                echo " [A subdirectory or file scriptfiles already exists.]"
                echo -
                sleep 1
            else
                mkdir scriptfiles
                echo "# C? '$COMMAND_DIR/scriptfiles'...: [yes]"
                sleep 1
            fi

            find "$COMMAND_DIR" -type f -name "*.io*" | while read -r file; do
                if [ -f "$file" ] && [[ ! "$file" =~ \.amx$ ]]; then
                    echo
                    echo "# LaterIUM Pawn file is .. Ok .."
                    echo " [A subdirectory or file $file already exists.]"
                    echo -
                    sleep 1
                fi
            done

            if [ -f "server.cfg" ]; then
                echo
                echo "# server.cfg is .. Ok .."
                echo " [A subdirectory or file server.cfg already exists.]"
            else
                cat <<EOF > "server.cfg"
echo Executing Server Config...
lanmode 0
rcon_password changename
maxplayers 150
port 7777
hostname SA-MP 0.3
gamemode0 main 1
filterscripts
announce 0
chatlogging 0
weburl www.sa-mp.com
onfoot_rate 40
incar_rate 40
weapon_rate 40
stream_distance 300.0
stream_rate 1000
maxnpc 0
logtimeformat [%H:%M:%S]
language English
EOF
                echo "# C? '$COMMAND_DIR/server.cfg'...: [yes]"
                echo
                cat server.cfg
                echo
                command_end
            fi
            ;;
        "$CMDSOPTION -v")
            COMMAND_TITLE="version"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            echo
            echo "~ $COMMAND_BUILD"
            echo
            ;;
        "$CMDSOPTION -T")
            COMMAND_TITLE="type files"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            echo "Example: ~ server.cfg server_log.txt"

            read -r inputTYPES
            cat $inputTYPES
            echo
            ;;
        "$CMDSOPTION -D")
            ls
            ;;
        "$CMDSOPTION -K")
            ./$COMMAND_NAME &
            exit
            ;;
        "help")
            COMMAND_TITLE="help"
            echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"

            _h
            ;;
        "cat .")
            testservers
            ;;
        "cat")
            _h
            ;;
        "")
            command_typeof
            ;;
        " ")
            command_typeof
            ;;
        "$CMDSOPTION ")
            _h
            ;;
        *)
            echo "'$LATERIUM_F' is not recognized as an internal or external command,"
            echo "operable program or batch file."
            echo
            _h
            command_typeof
            ;;
    esac
}

command_end() {
    echo -ne "$(colourtext 32 "# Press any key to return.")"
    echo
    read -n 1 -s
    command_typeof
}

compilers() {
    find "$COMMAND_DIR" -type f -name "pawncc.exe" | while read -r COMPILER_PAWNCC; do
        if [ -f "$COMPILER_PAWNCC" ]; then
            pawncc
        fi
    done

    if [ -z "$COMPILER_PAWNCC" ]; then
        echo
        echo "# pawncc not found.."
        echo

        sleep 2
        xdg-open "https://github.com/pawn-lang/compiler/releases"
        command_typeof
    fi

    CMDSFILE=false
    find "$COMMAND_DIR" -type f -name "*.io*" | while read -r file; do
        if [ -f "$file" ] && [[ ! "$file" =~ \.amx$ ]]; then
            CMDSFILE=true

            echo -ne "\033]0;$file\007"

            AMX_O="${file%.io*}.amx"

            "$COMPILER_PAWNCC" "$file" -o "$AMX_O" -d0 > "$METADAT_FILE" 2>&1

            _r

            sleep 0
            cat "$METADAT_FILE"

            if [ -f "$AMX_O" ]; then
                echo
                echo "~ $AMX_O"

                if [ "$COMPILER_LTIUM" = true ]; then
                    COMMAND_TITLE="compilers -o -d0"
                    echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"
                elif [ "$COMPILER_LTIUM" = false ]; then
                    COMMAND_TITLE="compiler - running -o -d0"
                    echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"
                fi

                echo "end at $(date +%T)"
                echo "total size : $(stat -c%s "$AMX_O") / bytes"
                echo
            else
                if [ "$COMPILER_LTIUM" = false ]; then
                    command_end
                fi
            fi
        fi
    done

    if [ "$CMDSFILE" != true ]; then
        echo "~ \"$COMMAND_DIR.io\" no files found."
        command_end
    fi

    if [ "$COMPILER_LTIUM" = true ]; then
        command_end
    fi

    if [ "$COMPILER_LTIUM" = false ]; then
        ok_next
    fi
}

_r() {
    cache_compiler=".cache/compiler.log"
    _cache_compiler=".cache/.compiler.log"

    if [ -f "$_cache_compiler" ]; then
        rm "$_cache_compiler"
    fi

    while IFS= read -r line; do
        echo "~" >> "$_cache_compiler"
        echo "$line" >> "$_cache_compiler"
    done < "$cache_compiler"

    mv "$_cache_compiler" "$cache_compiler" >/dev/null
}

_h() {
    echo "usage: cat [-c compile] [-r running] [-d debugger server] [-ci compile-running]"
    echo "           [-R rename file] [-C clear screen] [-F folder check] [-V vscode tasks]"
    echo "           [-T type file] [-K kill cmd] [-D directory] [-v version]"
    command_typeof
}

testservers() {
    if [ -f "$COMMAND_DIR/server_log.txt" ]; then
        rm "$COMMAND_DIR/server_log.txt" >/dev/null
    fi

    pkill -f "$COMMAND_SERVER" >/dev/null 2>&1

    sleep 0
    "$COMMAND_SERVER" &
    sleep 1
    cat server_log.txt
    echo
    pkill -f "$COMMAND_SERVER" >/dev/null 2>&1

    command_end
}

servers() {
    if [ -f "$COMMAND_DIR/server_log.txt" ]; then
        rm "$COMMAND_DIR/server_log.txt" >/dev/null
    fi

    chmod +x $COMMAND_SERVER
    ./$COMMAND_SERVER &

    sleep 2
    if ! pgrep -f "$COMMAND_SERVER" >/dev/null; then
        echo "# $COMMAND_SERVER not found or failed to start.."
        sleep 2
        command_typeof
    fi

    if [ $? -ne 0 ]; then
        COMMAND_TITLE="running - failed"
        echo -ne "\033]0;$CMDSUSERS:~/ $COMMAND_TITLE\007"
        echo -ne "$(colourtext 31 "# Fail")"
        echo

        if [ -f "server_log.txt" ]; then
            sleep 2
            cat server_log.txt
        else
            echo "# server_log.txt not found."
        fi

        echo -ne "$(colourtext 32 "# End.")"
        echo
        command_typeof
    else
        echo -ne "$(colourtext 32 "# Success")"
        echo

        sleep 2
        if grep -i "error" server_log.txt >/dev/null; then
            start_true2
        else
            start_false2
        fi
    fi
}

start_true2() {
    echo -ne "$(colourtext 31 "~")"
    echo "    ; \"error\"   .. Yes .. True"
    error_cache
}

start_false2() {
    echo -ne "$(colourtext 32 "~")"
    echo "    ; \"error\"   .. No .. False"
    check2
}

check2() {
    if grep -i "failed" server_log.txt >/dev/null; then
        start_true
    else
        start_false
    fi
}

start_true() {
    echo -ne "$(colourtext 31 "~")"
    echo "    ; \"failed\"  .. Yes .. True"
    failed_cache
}

start_false() {
    echo -ne "$(colourtext 32 "~")"
    echo "    ; \"failed\"  .. No .. False"
    check3
}

check3() {
    if grep -i "invalid" server_log.txt >/dev/null; then
        start_true3
    else
        start_false3
    fi
}

start_true3() {
    echo -ne "$(colourtext 31 "~")"
    echo "    ; \"invalid\" .. Yes .. True"
    invalid_cache
}

start_false3() {
    echo -ne "$(colourtext 32 "~")"
    echo "    ; \"invalid\" .. No .. false"
    echo
    command_end
}

error_cache() {
    echo
    grep -i "error" server_log.txt
    echo
    check2
}

failed_cache() {
    echo
    grep -i "failed" server_log.txt
    echo
    check3
}

invalid_cache() {
    echo
    grep -i "invalid" server_log.txt
    echo
    command_typeof
}

ok_next() {
    echo -ne "$(colourtext 32 "# Press any key to running.")"
    echo
    read -n 1 -s
    servers
}

command_typeof
