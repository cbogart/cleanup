# $Id: exit.R 340 2004-05-25 19:12:32Z warnes $

exit <- function(status=0)
  {
    .C("Rfork__exit",
       as.integer(status),
       PACKAGE="fork")
  }
