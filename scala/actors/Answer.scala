import scala.actors._
import Actor._

class AnsweringService(val folks: String*) extends Actor {
  def act() {
    while(true) {
      receive {
	case (caller: Actor, name: String, msg: String) =>
	  caller ! (
	    if (folks.contains(name))
	      String.format("Hey, it's %s, got message %s", name, msg)
	    else
	      String.format("Hey, there's no-one called %s here", name)
	  )
	case "ping" => println("pong")
	case "quit" => println("Exit stage left")
	  exit
      }

    }
  }
}


val aS1 = new AnsweringService("Sara", "Kara", "John")
println("Starting now?")
aS1 ! (self, "Kara", "coffe?")
aS1 ! (self, "John", "Not sure")
aS1.start()

aS1 ! (self, "Bill", "anyone?")
aS1 ! (self, "Sara", "I'm back")

for (i <- 1 to 4) { receive { case msg => println(msg) }}

Thread.sleep(2000)

aS1 ! "ping"

aS1 ! "quit"
