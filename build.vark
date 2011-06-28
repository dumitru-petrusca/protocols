uses java.lang.*

var srcDir = file("src")
var testDir = file("test")
var buildDir = file("build")
var distDir = file("dist")
var libDir = file("lib")
var classesDir = buildDir.file("classes")
var testClassesDir = buildDir.file("test-classes")
var gosuHome = System.getenv().get( "GOSU_HOME" )
if( gosuHome == null ) throw "Please set GOSU_HOME environment variable!" 
var gosuDir = file( gosuHome + "/jars" )
print( "Using Gosu dist at ${gosuHome}")

/* compile everything */
function compile() {
  Ant.mkdir(:dir = classesDir)
  Ant.javac(:srcdir = path(srcDir),
            :classpath = classpath( gosuDir.fileset() ),
            :destdir = classesDir,
            :includeantruntime = false)
  classesDir.file("META-INF").mkdir()
  classesDir.file( "META-INF/MANIFEST.MF" ).write( "Gosu-Typeloaders: protocols.ProtocolTypeLoader\n\n" )
}

/* compile tests */
function compileTests() {
  Ant.mkdir(:dir = testClassesDir)
  Ant.javac(:srcdir = path(testDir),
            :classpath = classpath( gosuDir.fileset() )
                           .withFileset( libDir.fileset() ),
            :destdir = testClassesDir,
            :includeantruntime = false)
}

/* make jar */
@Depends("compile")
function jar() {
  Ant.mkdir(:dir = buildDir)
  Ant.jar(:destfile = buildDir.file("protocols.jar"),
          :manifest = classesDir.file( "META-INF/MANIFEST.MF" ),
          :basedir = classesDir)
}

/* make jar */
@Depends("jar")
function updateLatest() {
  Ant.copy(:file=buildDir.file("protocols.jar"), :tofile = distDir.file( "protocols-latest.jar" ) )
}

/* Run tests */
@Depends({"updateLatest", "compileTests"})
@Target
function test(debug:boolean = false) {
  var cp = classpath(libDir.fileset())
             .withFileSet(gosuDir.fileset())
             .withFile(distDir.file( "protocols-latest.jar" ))
             .withFile(testDir)
             .withFile(testClassesDir)

  Ant.java(:classpath=cp,
                 :classname="protocols.TestScanner",
                 :jvmargs=debug?"-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5150":"",
                 :fork=true,
                 :failonerror=true,
                 :args=testDir.AbsolutePath)
}




/* clean */
function clean() {
  Ant.delete(:dir = file("out"))
  Ant.delete(:dir = classesDir)
  Ant.delete(:dir = buildDir)
}
