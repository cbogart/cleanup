# $Id: getpid.R 340 2004-05-25 19:12:32Z warnes $

getpid <- function()
  {
    .C("Rfork_getpid",
       pid=integer(1),
       PACKAGE="fork"
       )$pid
  }

