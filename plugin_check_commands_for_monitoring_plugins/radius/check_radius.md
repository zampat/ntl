The check_radius plugin checks a RADIUS server to see if it is accepting connections. The server to test must be specified in the invocation, as well as a user name and password. A configuration file may also be present. The format of the configuration file is described in the radiusclient library sources. The password option presents a substantial security issue because the password can possibly be determined by careful watching of the command line in a process listing. This risk is exacerbated because the plugin will typically be executed at regular predictable intervals. Please be sure that the password used does not allow access to sensitive system resources.

   
https://www.monitoring-plugins.org/doc/man/check_radius.html