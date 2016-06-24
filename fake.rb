require "yaml"
require "rantly"

$x = 0

def getx
  $x
end

def setx( new_x )
  $x = new_x
  nil
end

def sub_getx_const
  1
end

def sub_getx_fixture
  data = YAML.load_file( "fixture.yaml" )
  data[ "$x" ]
end

def sub_getx_fixture_str
  data = YAML.load_file( "fixture.yaml" )
  data[ "$x" ]
end

def sub_getx_random
  Rantly { integer }
end

# sub_getx_next
lambda {
  counter = 0
  Kernel.send(:define_method, :sub_getx_next) {
    result = counter
    counter += 1
    result
  }
}.call

def sub_setx_nop( new_x )
  nil
end

def sub_setx_stdout( new_x )
  puts "$x => #{new_x}"
  nil
end

def sub_setx_log( new_x )
  File.open( "log.txt", "w" ) do |f|
    f.puts "$x => #{new_x}"
  end
  nil
end

def sub_setx_fixture( new_x )
  File.open( "fixture.yaml", "w" ) do |f|
    f.write(({"$x" => new_x}).to_yaml)
  end
  nil
end

def sub_setx_fixture_str( new_x )
  File.open( "fixture.yaml", "w" ) do |f|
    f.write(({"$x" => new_x}).to_yaml)
  end
  nil
end

def load_fixture
  data = YAML.load_file( "fixture.yaml" )
  data.each {|key, value| eval( "#{key} = #{value}" )}
end

def load_fixture_str
  data = YAML.load_file( "fixture.yaml" )
  data.each {|key, value| eval( "#{key} = #{value}" )}
end

def wrap_getx_fixture
  value = getx
  sub_setx_fixture( value )
  value
end

def wrap_getx_fixture_str
  value = getx
  sub_setx_fixture( value )
  value
end

def with_mock( mocks )
end

def random_struct( spec )
end

def next_struct
end

class Thing
  attr_accessor :n, :s, :a
  def initialize( n )
    @n = n
    @s = "abc"
    @a = []
  end

  def do_thing( x )
    @n += x
    @a << x
    @s = @s[-1] + @s[0..-2]

    @s
  end
end

=begin
* mock/fake/stub
** function types
*** original
**** original location
**** test location
*** substitute
*** wrapper
- does the same actions as one or more substitutes and calls the original
- save timestamp
** function has
*** return value
*** side effects
*** both
** substitute return values
*** null or constant
**** boundary
**** typical
*** computed value
**** random
*** from an external source
** substitute side effects
*** none
*** to an external target
** externals
*** stdout/console
*** log file
*** substitute source file
*** substitute database
*** undo information file
*** unit test source code
** target can be used as substitute source
** target can be copied into the original source
** with_mock
* externals
** log4j
*** Logger
** sql
*** Statement
*** ResultSet
*** Connection
*** PreparedStatement
*** Timestamp
** io
*** PrintStream
*** ByteArrayOutputStream
*** StringWriter
*** PrintWriter
** agile
*** IAgileSession
*** IItem
*** ITable
*** IChange
*** IManufacturer
*** IQuery
*** IAttribute
*** IManufacturerPart
*** ICell
*** IRow
*** IAttachmentFile
*** IAttachmentRow
*** IRedlined
*** IAgileList
*** IAdmin
*** IUser
** zip
*** ZipInputStream
*** ZipEntry
** util
*** Date
*** Properties
*** Calendar
*** TimeZone
*** Collections
*** Comparator
** lang
*** Exception
*** System
** crypto
*** SecretKeySpec
*** Cipher
** text
*** SimpleDateFormat
** regex
*** Pattern
*** Matcher
** http
*** HttpServlet
*** HttpServletRequest
*** HttpServletResponse
** apache
*** ReflectionToStringBuilder
** servlet
*** RequestDispatcher
** naming
*** Context
*** InitialContext
** net
*** URL
** xml
*** QName
*** BindingProvider
** mail
*** HtmlEmail
* state/store
** TODO global
** TODO object (Struct)
** TODO environment var
** TODO date/time
** TODO random
** TODO stdin/stdout/stderr
** TODO file
*** TODO log
** TODO file system (dirs)
** TODO database
** TODO web service
** TODO process
** TODO gui component
** TODO socket
** handle
*** TODO object (with methods)
*** TODO array
*** TODO map
*** TODO range
** TODO combination of execution environment states
=end
