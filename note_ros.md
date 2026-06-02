>Q:




- is component a cpp exclusive thing?
- how do you make a container_node or components
    - create container node the same way create TSA node?
- how to do compile time composition?
- how to add parameter to a node (in compile time)
- since rclpy.spin block, what if I just run the async without await?
- why getparameter.getparameterValue.type?
- os.path vs pathlib.Path




>A:
## cmake
- consider cmake command like string of code of typical programming language:
    - some create variable: add_library (create a variable of type library)
    - some mutate the variable property: target_link_libraries(target lib1 lib2)
    - to actually create the makefile: run cmake ..
- sensitive to order:
    - find_package allow the code following to find that package
- specific command:
    - rosidl_generate_interfaces actually just create a list of command in the resulting makefile that ended up generating a file instead of compiling it
    - add_custom_command, similar to make, it define the recipe
    

## ros 
- component Name
    - package name = sync from 4 sources:
        - package.xml
        - setup.py
        - setup.cfg
        - [folder name]
    - executables name = setup.py:entry_points
    - node, topic, service, action name are from .py file
- `package.xml`, the dependency there are all ROS package
    - `<depend>`. buildtime + runtime 
    - `<exec_depend>`. runtime 
    - `<build_depend>`. buildtime 
        - `<build_export_depend>` the build time of other package that uses your package's export
- `rosdep` only search dependency in package.xml
- `discovery` when a running node adverties its present (periodically)
- `param` type can only be bool, int, float, string, and their array
    - `Parameter` class = paramName + paramValue + type
    - `ParameterValue` class = is a C union which need to be interpreted using (.type_value)
        - or it can auto detect using parameter_value_to_python 
- `broadcasting` uses topic to communicate
    - `frame` a frame of references/coordinate, broadcasted by a node
    - `tf2` is a broadcast for the type TransformStamped.
        - header.frame_id, child_frame_id, and header.stamp
- `msg` definition
    - `type name default`
    - type[<=5] array of type up to 5 element
    - string<=5[] unbound array of string with length <=5
    - include type in the same package, dont put the package name
    - `type const_name value`
- `action`
    - message reach server ==> send_goal_async return future
    - message accepted ==> future's goalhandle.accepted == true
- `components` 
    - definition:
        - a `node` is an executable (have main() ),
        - `nodelet`/`components` are shared library (plug and play)
            - need to register as a component using rclcpp_components_register_node
        - `container` are process that can accept & manage components
            - it can run all component in a singlethread, mt, isolated(each component different executor)
    - run time composition: `ros2 component`
        - `types` list components from index
        - `list` list runtime components 
        - `load` load into [container_node] from [component_package] a [component]
    - compile time composition?

# ros launch.py
- Mechanism
    - `generate_launch_description` return `LaunchDescription`
    - `LaunchDescription` is a list of `Action`. 
    - `Action`:
        - its parameter can receive `Subtitution`, an object that act as template for a value, it will be resolved using `.perform(ctx)` in LaunchService.run (which will also provide it with a contex)
        - e.g. `Node`. run a node
            - package: package name
            - name: executable name
            - arguments: the things you put after the above
            - parameters: for --ros-args -p
        - e.g. `OpaqueFunction`. run a function you can customize that will receive the `context`, need to return an array of `action`
        - `DeclareArgument`. for default value, and to be visible in ros2 launch show-args 
        - `ExecuteProcess`. run the *single cmd*, it accept [ [] [] ],
            - result = ' '.concat[  ''.concat[]  ''.concat[] ]
                - substitution is seperated from the string
            - if using shell=True, command run through shell -c, dont know what other wise
        - `LogInfo`
    - `LaunchService` take `LaunchDescription` to run each of its `Action` **concurrently**
- launch package
    - launch_ros has ros component: Node,...
    - launch has general component: LaunchDescription

# urdf
- summary
    - robot
        - link [name]
            - visual
                - origin [xyz] [rpy]
                - geometry
                    - box [size]
                    - cylinder [radius] [length]
                    - sphere [radius]
                - material [name]
                    - color [rgba]
            - collision
        - joint [name] [type]



## about python async
- `coroutine` are just snapshot of a program (prolly the function pointer and variable). it is not running
- `task` are coroutine that is added to (referenced by) the event loop
- `future` are abstraction of task, it's any object that gets their value later on
    - the `.result()` will block until `set_result()` 
- when inside a task there is `await`:
    - awaiting other task --> 
        - the current task progress is saved, then converted into that other task's callback, and terminate. 
        - the newly created task will already be in the eventloop at it's creation, before await is even called
    - awaiting coroutine --> the coroutine is treated like a function call (synch-ly)
    - awaiting future --> 
        - the current task progress is saved, then converted into that future's callback. 
        - the future won't be added to the event loop
- the root await is `asyncio.run()` or `.result()`
    


## rclpy
- ros2 and py only send args to sys.args
- ros immediately goes to main, doesnt go to __name__ 
- msg(field1 = _field1,field2 = _field2,...)

## sed
- condition:
    - 3 ==> third line
    - $ ==> last line
    - 3,10 ==> third-tenth line
    - 1~2 ==> 1,3,5,... line
    - /regex/ ==> if match 
    - [condition]! ==> if not condition 
- command:
    - p ==> print line
    - s/regex/replace/
        - p flag to print
- connecting:
    - [condition][command] ==> if (condition){ command }
    - [condition]{c1;c2} ==> if (condition){ c1;c2 }


## tmux
- session > window(tab) > pane(split)
`-t $Session:$window.$pane`

### outside
- `create session` tmux new-session [-s $sessionName] [-d]
- `create window` tmux new-window -t $window [-a] [-n $windowName] 
- `create pane` tmux split-window -t $pane [-h|-v]

- `list` tmux ls 
- `list+` tmux list-panes -a 
- `attach` tmux a [-t]

- `delete all    ` tmux kill-server
- `delete session` tmux kill-session [-t]
- `delete window ` tmux kill-window [-t]
- `delete pane   ` tmux kill-pane [-t]

- `run command` tmux send-keys [-t] "command" Enter


### inside
- every cmd from outside
- `switch session` C-b s
- `switch window` C-b w
- `switch pane` C-b arrow

- `create session here` C-b :new-session
- `create window here` C-b c
- `create pane here` C-b " (slice h) C-b % (slice v)

- `delete currnt session ` C-b :kill-session
- `delete currnt window ` C-b &
- `delete currnt pane ` C-b x

- `modify pane axis` C-b(hold) arrow




## shell note 2
- gnome-terminal 
    - title only work if it is invoked from inside a gnome-terminal
- trap int 
    - SIGINT still allow the next command to continue
    - (here)[https://www.linuxjournal.com/content/bash-trap-command]
