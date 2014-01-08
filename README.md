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
~~~

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
The bash-completer project contains two main scripts:
* one that will capture the completion requests made to bash-completion and forward them to our second program.
  For your curiosity, this is the file *__completer*.
* one that will handle the completion for your script and manage the list of scripts to complete. This program is named **bash-completer**. The installer will automatically add it to your path.

In bash-completer, we see 3 types of completion:
* **actions**: actions are the values that are accepted by your program without a preceding option (-*). It is for exanple the values proposed by service under ubuntu, or by systemctl in archlinux.

    bash-completer will complete with actions when there is no option before or if that option is not waiting for an argument.

* **options**: options are the list of possible options supported by your program. They may not require completion nor arguments.

    bash-completer will complete with options when you try to complete on a value starting by "-".

* **your particular options**, defined by your script (_e.g._ -l, -s, --version, ...).

    When completion is triggered, bashc-completer will look for the previous value. If it is an option (value starting by "-"), it will ask for your program if there are completion values for the option. If your program do not specify any method for this option, if it explicitly does not require completion or if the option is invalid, completion on the actions will be done instead.

To do the completion, the system will execute your script with specific options. Capturing this option, it will call the appropriated method, defined by you. These methods will return the values for completion.

To improve responsivity, bash-completer uses files to store your completion values, for each context. Therefore, a code is added to the return of the completion functions. Not all values are stored, it will depend on the code returned. You can choose to always complete from the script or store some values. Each time your program is called for completion, you will receive the stream in which are stored the last completion values, allowing you to check if the values are outdated.

### Activate completion on your script
To add a program for completion, you use the following command:

~~~sh
## Assuming that your program is name my_prog
$ bash-completer --register my_prog
~~~

From now on, every time you will type my_prog and hit <Tab>, the system of bash-completer will try to do completion on your script.

To unregister your application, use the opposite command:

~~~sh
$ bash-completer --unregister my_prog
~~~

bash-completer can only work on programs that are in your PATH or for which you gave the absolute path. If not, nothing will happen when you will try to complete.

### Making your script complete
bash-completer provides library files, one for each supported language. The library will handle for you the capture of the completion requests.
The only thing you have to do is to include the appropriated library and code your functions for completion.

### Debugging your completion
Sometimes, you will need to debug your script completion. To do so, bash-completer helps you, by using the same command as the completion hook.

~~~sh
## Assuming that your program is named my_prog and you want completion on the option --repo
$ bash-completer --program my_prog --complete --repo
>> ~/my_awsesome_project ~/jarvis ~/the-ultimate-manager
~~~

We will describe above the rules for create completion functions for each language. You can jump directly to the next section using [this link](#examples)


Examples
--------
The examples directory contains some examples of the usage of bash-completer.
There is at least one exemple par supported language. These are useless programs but they show you how it's done.

If you want to test them, add them to your PATH and the magic will take care of the rest.

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
