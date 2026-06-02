>Q:
- what is ```$REPLY```

>A:

## defining variable 

### from String
```bash
    foo="
    define a variable
    quote escape \n
    outside \"\" or (), user \\
    "

    array=("a" "f s" "234")
        IFS=$'\n' #control how () split str into array
        # it also controls split str into array in "for ... in ..."
    array=([0]="hh" [2]="223" [13]="f") 
    array+=("foo") # append
```

### from Process
```bash
    foo=$(ps)

    array=($(ps))
```
### from File
```bash
    mapfile varArr filename
        -t strips newline # other wise ["...\n", "...\n", "...\n", "...\n"]
```
### from User
```bash
    read var ;
        -r --> interpret / normaly 
        -d '' --> use '' as delimiter(\0)
        -a save as array
```

## referencing variable
```bash
    $a1 # $ only dereference the next word
    ${a2} # ${} direferences the inside
        ${foo:-"default"}
        ${foo:0:5} #foo[0:5]
        ${foo/"regex"/replace}
        ${#foo} #length of foo
        "${array[@]}" return the array element as a string
    $(( var + var )) # for operation
    $(cmd) # return the output of command as "string"
        # preserve white space, be sure to echo using "$(cmd)" to see whitespace
    <(cmd) # return the output of command as "file"
```

## special variable
```bash
# special variable
$$ --> pid of current process
$2 --> argv[2]
* --> list of all file in the current directory
```

## connecting process
```bash
cmd1 && cmd2 --> run cmd2, if cmd1 exit-0
cmd1 || cmd2 --> run cmd2, if cmd1 exit-0
cmd1 | cmd2  --> cmd1 output into cmd2 (as std in)
cmd1 <<< var --> var value into cmd1 (as std in)
< file, > file, >> file, 2>file (file redirect) --> file is treated as a file
    # it binds to the directly adjacent command
```

## condition
```bash
any cmd         --> exit-code == 0 -> true, exit-code != 0 -> false
["$x" -lt 10]   --> `test $x -lt 10`
true            --> (exit code 0)
:               --> (exit code 0)
# test option
"str1" = "str2" --> eq
"str1" != "str2" --> ne
-z "str2" --> zero length
-n "str2" --> not null

-e file --> exist
-f file --> isfile
-d file --> isDirectory
-r file --> can read
-w file --> can write
-x file --> can execute

num1 -eq num2 --> ==
num1 -ne num2 --> !=
num1 -lt num2 --> !=
num1 -le num2 --> !=
num1 -gt num2 --> !=
num1 -ge num2 --> !=
```

## loop
```bash
# ';' can be substituted with ';\n..\n' or '\n..\n'
# 'then', 'else', 'do' can be followed by 1 new line
if condition; then cmd;..cmd; else cmd;..cmd; fi 
while condition; do cmd; done
for var in array(else it will be spliced based on IFS); do cmd; done 
```

## function
```bash
foofunc(){ cmd; }
    # $1 $2 are the input
```

## calling other shell
```bash
. shell.sh --> sourcing, shell.sh is in the same scope as the caller
source shell.sh --> same as '.'

bash shell.sh --> different scope (in the subscope)
```


