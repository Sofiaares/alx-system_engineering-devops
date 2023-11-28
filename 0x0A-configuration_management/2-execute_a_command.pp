# creating a manifest that kills a process "killmenow"

exec {'pkill -f killmenow':
  path => '/user/bin/:usr/local/bin/:/bin/'
}
