#include <R.h>
#include <Rdefines.h>

/*
  Code taken from fork package by Gregory R. Warnes <greg@random-technologies-llc.com>
  
  Before that, taken from a posting to the Gimp-developer mailing list by
  Raphael Quinet quinet at gamers.org accessible at:
  http://lists.xcf.berkeley.edu/lists/gimp-developer/2000-November/013572.html
*/

#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int installed=0;      // Has our sigcld signal hander already been installed?

struct sigaction sa ; // our sigcld signal handler
struct sigaction osa; // original (R) signal hander
SEXP sig_rfunction;
SEXP sig_environment;

/*
    Code by Dirk Eddelbuettel to call R function from C
      https://stat.ethz.ch/pipermail/r-devel/2011-September/062052.html
*/
void callRfunction(SEXP par, SEXP env) {           // essentialy same as the old evaluate
    SEXP fn = Rf_lang1(par);   //fcall
    if (isEnvironment(env)) {
        cat("isEnvironment");
        Rf_eval(fn, env); //env         
    } else {
        cat("R_GlobalEnv");
        Rf_eval(fn, R_GlobalEnv);
    }
}

void sigusr1_handler(int dummy) 
{
  callRfunction(sig_rfunction, sig_environment);
  if (osa.sa_handler != NULL) {
    (*osa.sa_handler)(dummy);
  }
  int st;
  // wait3 returns 0 when no signal is present to retrieve
  while (wait3(&st, WNOHANG, NULL) > 0);
}


void R_install_sigusr1_handler(SEXP rfunction, SEXP environment)
{
  int ret;

  if(installed==0)
    {
      //Rprintf ("Installing SIGUSR1 signal handler...");
      sig_rfunction = rfunction;
      sig_environment = environment;
      sa.sa_handler = sigusr1_handler;
      //sigfillset (&sa.sa_mask);
      //sa.sa_flags = SA_RESTART;
      ret = sigaction (SIGUSR1, &sa, &osa);
      if (ret < 0)
	    {
	      error("Cannot set signal handler");
	    }
      installed=-1;
      Rprintf("Done.\n");
        }
  else
        {
          warning("SIGUSR1 signal handler already installed");
        }

}

void R_restore_sigusr1_handler()
{
  int ret;

  if(installed==-1)
    {
      Rprintf ("Restoring original SIGUSR1 signal handler...");
      ret = sigaction (SIGUSR1, &osa, &sa);
      if (ret < 0)
	    {
	      error("Cannot reset signal handler");
	    }
      installed=0;
      Rprintf("Done.\n");
    }
  else
    {
      warning("SIGUSR1 signal handler not installed: cannot reset.");
    }

}
