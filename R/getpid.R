# $Id: getpid.R,v 1.3 2004/05/25 19:12:32 warnes Exp $

getpid <- function()
  {
    .C("Rfork_getpid",
       pid=integer(1),
       PACKAGE="fork"
       )$pid
  }

