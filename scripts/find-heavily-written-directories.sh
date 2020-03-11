
 $ sudo inotifywait -e modify -e attrib -e move -e create -e delete -m -r /tmp
 Setting up watches.  Beware: since -r was given, this may take a while!
 Watches established.
 /tmp/ CREATE test
 /tmp/ MODIFY test

   Unfortunately you will need to guess which directory contains the files being written to. This fails if you
   try to use it on the root directory, though apparently that can be overridden:

 $ sudo inotifywait -e modify -e attrib -e move -e create -e delete -m -r /
 Setting up watches.  Beware: since -r was given, this may take a while!
 Failed to watch /; upper limit on inotify watches reached!
 Please increase the amount of inotify watches allowed per user via `/proc/sys/fs/inotify/max_user_watches'.

use: systemtap

can we use strace on pid 1 or the kernel itself?
