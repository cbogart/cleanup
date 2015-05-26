

on.sigusr1 <- function(action)
  {
    act_then_quit <- function() {
        action();
        system("stty echo");
        quit(save="no");
    }
    .Call("R_install_sigusr1_handler", PACKAGE="cleanup", act_then_quit, environment(act_then_quit))
    invisible(NULL)
  }

restore.sigusr1 <- function()
  {
    .Call("R_restore_sigusr1_handler", PACKAGE="cleanup")
    invisible(NULL)
  }
  
