catalog = {}
WORK = "~/temp/work"

# setup wrapper targets
# global
$x = 23
# object/struct
# random number
# time/date
# environment variable
# command line arguments
# stdin/stdout/stderr
# directory
# file
# exception throwing expression
# process
# system command
# runtime environment

# sensors
# file
File.read(?)

# client code (to be wrapped)
#   with metadata
# file
f = File.open("#$WORK/test1.txt", "w")
f.puts("hello")
f.close

# notes
