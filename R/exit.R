# $Id: exit.R,v 1.2 2004/05/25 19:12:26 warnes Exp $

exit <- function(status=0)
  {
    .C("Rfork__exit",
       as.integer(status),
       PACKAGE="fork")
  }
