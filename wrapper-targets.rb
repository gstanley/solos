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
# database

# sensors
# file
File.read("#$WORK/test1.txt")

# client code (to be wrapped)
#   with metadata
# global
target = $x
# file
f = File.open("#$WORK/test1.txt", "w")
f.puts("hello")
f.close

# notes
