

on.sigterm <- function(action)
  {
    act_then_quit <- function() {
        action();
        quit(save="no");
    }
    .Call("R_install_sigterm_handler", PACKAGE="cleanup", act_then_quit, environment(act_then_quit))
    invisible(NULL)
  }

restore.sigterm <- function()
  {
    .C("R_restore_sigtrm_handler", PACKAGE="cleanup")
    invisible(NULL)
  }
  