# $Id: getpid.R,v 1.2 2003/07/17 01:28:31 warnes Exp $

getpid <- function()
  {
    .C("Rfork_getpid", pid=integer(1))$pid
  }

