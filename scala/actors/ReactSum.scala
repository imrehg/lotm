import scala.actors._
import Actor._

val caller = self

def accumulate(sum: Int) {
  reactWithin(500) {
    case number: Int => accumulate(sum + number)
    case TIMEOUT =>
      println("Bye-bye Baby!")
      caller ! sum
  }
}

val accumulator = actor { accumulate(0) }

for (i <- 1 to 9) {
  val n = i *  100
  println("Sending:"+n)
  accumulator ! n
  Thread.sleep(n)
}



receiveWithin(1000) { case result => println("Total: "+result)}
