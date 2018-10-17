/* amb-c.c$>
  2018 (c) Gunter Liszewski
  from wiki.c2.org */

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

#define AMB_FAILED 42

int
amb (void)
{
  pid_t a = fork ();
  if (a == -1) { perror ("amb"); exit (1);}
  if (a == 0 ) { return 1;}
  else
  {
    int b;
    pid_t c;
    do
    {
      c = waitpid (a, &b, 0);
    } while ((c == -1) && (errno == EINTR));
    if (c == -1) { perror ("amb"); exit (1);}
    if (WIFEXITED (b))
    {
      if (WEXITSTATUS (b) == AMB_FAILED) { return 0;}
      else { _exit (WEXITSTATUS (b));}
    }
    _exit (1);
  }
}
