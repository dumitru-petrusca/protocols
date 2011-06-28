package protocols

uses junit.framework.TestCase

uses protocols.examplegosu.*
uses protocols.examplejava.*
uses protocols.exampleprotocols.*

class CoreProtocolsTest extends TestCase {

  function testJavaFunctions() {
    var x : SampleProtocol1 = new JavaExample1()
    assertEquals( 1, x.foo() )

    x = new JavaExample2()
    assertEquals( 2, x.foo() )
  }

  function testGosuFunctions() {
    var x : SampleProtocol1 = new GosuExample1()
    assertEquals( 1, x.foo() )

    x = new GosuExample2()
    assertEquals( 2, x.foo() )
  }

  function testJavaProperties() {
    var x : ProtocolWProperty = new JavaExample1()
    assertEquals( 1, x.Prop1 )

    x = new JavaExample2()
    assertEquals( 2, x.Prop1 )
  }

  function testGosuProperties() {
    var x : ProtocolWProperty = new GosuExample1()
    assertEquals( 1, x.Prop1 )

    x = new GosuExample2()
    assertEquals( 2, x.Prop1 )
  }
}