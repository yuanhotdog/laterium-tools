# [LaterIUM Tools](https://raw.githubusercontent.com/yuanhotdog/laterium-tools/refs/heads/main/laterium/__%40LaterIUM.cmd)

This repository contains various tools for Pawn coding, specifically for Windows terminals. If you want to use these tools in Unix/Linux or macOS environments, you'll need to use WineHQ to run the Windows executables.

## Getting Started

### Windows

0. Download the `.cmd` file. from "laterium".
1. Place the `.cmd` file in the main directory of your project.
2. Run the command `$ cat -r` and enter the project name that will be compressed into the LaterIUM Tools Pawn.
3. All ready, for other commands, please start with `$ cat`

### Unix Linux/macOS

If you wish to use these tools on Unix/Linux or macOS, you will need to use WineHQ. WineHQ allows Windows applications to run on Unix-like operating systems.

#### Steps to run tools using WineHQ

1. **Install WineHQ:** Follow the instructions on the [WineHQ website](https://wiki.winehq.org/Download) to install Wine on your system.
2. **Configure Wine:** After installation, configure Wine to ensure it runs the tools correctly.
3. **Run the tools:** Use the following command to run a Windows executable with Wine:

## Commands Option

| Command Option       | Description                                      |
|----------------------|--------------------------------------------------|
| `-c compile`         | Compiles the project.                           |
| `-r running`         | Runs the project.                               |
| `-d debugger server` | Starts the debugger server.                     |
| `-ci compile-running`| Compiles and then runs the project.             |
| `-R rename file`     | Renames a file.                                 |
| `-C clear screen`    | Clears the terminal screen.                     |
| `-F folder check`    | Checks the folder structure.                    |
| `-V vscode tasks`    | Manages VSCode tasks.                           |
| `-T type file`       | Displays the type of a file.                    |
| `-K kill cmd`        | Kills a command.                                |
| `-D directory`       | Changes the directory.                          |
| `-v version`         | Displays the version of the tool.               |
| `-all all options`   | Executes all available options in sequence.     |

## Example Code

```pwn
#include "a_samp"

main ()
{
  print "Hello, World!";
}
```

## Contributing

We welcome contributions! To contribute, follow these steps:

1. **Fork the repository** by clicking the "Fork" button on the top right of the repository page.
2. **Clone your fork** to your local machine:
```bash
$ git clone https://github.com/troubleshoots/laterium-tools.git
```

#
# Enjoy!
