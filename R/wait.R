# $Id: wait.R,v 1.3 2004/05/25 19:12:32 warnes Exp $

wait <- function(pid, nohang=FALSE, untraced=FALSE)
{
  if(missing(pid) || is.null(pid)) 
    retval <-   .C("Rfork_wait",
                   pid=integer(1),
                   status=integer(1),
                   PACKAGE="fork" )
  else
    retval <- .C("Rfork_waitpid",
                 pid = as.integer(pid),
                 as.integer(nohang),
                 as.integer(untraced),
                 status=integer(1),
                 PACKAGE="fork")

  return(c("pid"=retval$pid,
           "status"=retval$status))
}

