# $Id: exit.R,v 1.1 2003/07/17 01:15:23 warnes Exp $

exit <- function(status=0)
  {
    .C("Rfork__exit", as.integer(status))
  }
