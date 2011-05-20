import scala.actors._
import Actor._

val caller = self

val expectStrOrInt = actor {
  while(true) {
    receiveWithin(1000) {
      case "quit" => println("NOOOOO!")
         exit
      case str: String => caller ! "You dare to say "+ str
      case num: Int => caller ! "You dare to show " + num + " fingers?"
      case TIMEOUT => println("Why so silent?")
    }
  }
}


expectStrOrInt ! "hello"
expectStrOrInt ! 100
expectStrOrInt ! 12.0
expectStrOrInt ! "bye"
expectStrOrInt ! "quit"
expectStrOrInt ! "bye2"

for (i <- 1 to 6) {
  receiveWithin(3000) { 
    case result: String => println(result)
    case TIMEOUT => println("Why no talk?")
  }
}
// Not sure why for some of the settings it exits, sometimes it stays
