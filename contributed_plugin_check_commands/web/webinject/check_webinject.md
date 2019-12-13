https://labs.consol.de/de/nagios/check_webinject/index.html

check_webinject is a Nagios check plugin based on the Webinject Perl Module available on CPAN which is now part of the Webinject project.
We use it heavily at ConSol and did a complete rework including some bugfixes and enhancements for Nagios 3.

Current Version is the 1.84 released on Nov 01, 2013.

## How does it work?

The plugin is written in Perl and uses LWP together with Crypt::SSLeay or IO::Socket::SSL.
check_webinject sends requests to any configured webservice. You may then specify verification settings in your test cases.
A sample testcase file is included in the downloadable tarball.

```
<pre> <testcases> <case id = "1" description1 = "Sample Test Case" method = "get" url = "{BASEURL}/test.jsp" verifypositive = "All tests succeded" warning = "5" critical = "15" label = "testpage" /> </testcases> </pre>
```

A sample command like would look like this:

```
<pre> %>./check_webinject -s baseurl=http://yourwebserver.com:8080 testcase.xml WebInject OK - All tests passed successfully in 0.027 seconds|time=0.027;0;0;0;0 testpage=0.024;5;15;0;0 </pre>

```
Add check_webinject like a normal nagios plugin.


