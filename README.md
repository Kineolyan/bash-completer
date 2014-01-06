bash-completer
==============

bash-completer is a tool meant to ease completion on scripts executed in a bash environment.
After installation of the tool, one can include the proper library in her script and define single functions for completion.
These functions will be used automatically to complete possible actions, available options and their completion for the script.

Table of contents
-----------------
* [How it works](#how-it-works)
* [Installation](#installation)
* [Usage](#usage)
* [Examples](#examples)
* [Licence](#licence)
* [Known issues](#known-issues)
* [Notes](#notes)

How it works
------------
bash-completer is a tool working with bash-completion, program
responsible of the completion in bash shells.

Installation
------------
### Automated way
You can use the web-installer that will download the project and install
it in the proper directory.
To use it, copy-paste the above command:

    ~~~ sh
    $ curl https://raw.github.com/Kineolyan/bash-completer/master/web-install | bash
    ~~~

You will be printed all instructions.

### Manual way
You can manual install the project on your computer.
The project must be located in ~/.bash-completer to work correctly.
You can follow these steps, or improvize as you want:
1. Clone the project in your computer

    ~~~ sh
    $ git clone git@github.com:Kineolyan/bash-completer.git ~/.bash-completer
    ~~~~

2. Run the installer. You will be printed all the installation steps.

    ~~~ sh
    $ cd ~/.bash-completer
    $ ./install
    ~~~

3. That's it. You are done !

There is no mechanism to update an existing project. For updates, you
will have to uninstall and do the installation again.

Usage
-----

Examples
--------

Licence
-------

This is released under a MIT licence. You can use it at will, just
notify me if so. I'm always interested in your returns and advices.

Known issues
-----------
None up to now.

Notes
-----
Python support is in the todo list. This is the next step on the
roadmap.

In the future, completion functions will receive previous arguments and values as a context for completion.
This can be usefull for contextual completion such as:

    ~~~ sh
    myprogram --country france --city p
    >> paris  perpignan
    myprogram --country england --city l
    >> liverpool  london
    ~~~

