# Copyright (c) Open Enclave SDK contributors.
# Licensed under the MIT License.

# Enable pending breakpoints
set breakpoint pending on

# Set a breakpoint in main (host)
b main
commands 1
    printf "** Hit breakpoint in main"
    printf "** enclave = %s\n", argv[1]
    continue
end

# Set a breakpoint in enc.c (enclave)
# This is a pending break point.
b enc.c:36
commands 2
    printf "** Hit breakpoint in enclave\n"

    # Set debugger test
    set debugger_test = 1
    printf "** debugger_test = %d\n", debugger_test

    if debugger_test != 1
       printf "** Error: failed to set debugger_test\n"
       quit 1
    end

    continue
end

# Set a breakpoint in module constructor
b init_module
commands 3
    # Check that debugger is able to set variable.
    set var is_module_init=1
    continue
end

# Set a breakpoint by line number
b module.c:13
commands 4
    # Check that value has been set.
    if is_module_init != 1
       printf "** Error: is_module_init != 1\n"
       quite 1
    end
    continue
end

# Set a breakpoint in module destructor
b fini_module
commands 5
    # Test ability to call function
    p notify_module_done_wrapper()
    continue
end

# Set breakpoint in square function
b module.c:26
commands 6
    # Evaluate expression
    set var r = a * a
    continue
end

# Set conditional breakpoint
b module.c:38
commands 7
    p t
    set var t = a + b + k
    printf "** t=%d\n", t
    p t
    fini
    continue
end

# Run the program
run
continue

# Run the program again.
# This asserts that module is correctly unloaded by debugger.
run
continue

# Check if program aborted or returned non zero.
if $_isvoid($_exitcode) || $_exitcode
    printf "** Test aborted\n"
    quit 1
end
