
https://metacpan.org/pod/distribution/jmx4perl/scripts/check_jmx4perl

##NAME

<p>check_jmx4perl - Nagios plugin using jmx4perl for accessing JMX data remotely</p>

##SINOPSIS

<pre><code> # Check for used heap memory (absolute values)
 check_jmx4perl --url http://localhost:8888/jolokia \
                --name memory_used \
                --mbean java.lang:type=Memory \
                --attribute HeapMemoryUsage \ 
                --path used \
                --critical 10000000 \
                --warning   5000000 

 # Check that used heap memory is less than 80% of the available memory
 check_jmx4perl --url http://localhost:8888/jolokia \
                --alias MEMORY_HEAP_USED \
                --base MEMORY_HEAP_MAX \ 
                --critical :80

 # Use predefined checks in a configuration file with a server alias
 # Server alias is &#39;webshop&#39;, check is about requests per minute for the 
 # servlet &#39;socks_shop&#39;
 check_jmx4perl --config /etc/nagios/check_jmx4perl/tomcat.cfg
                --server webshop \
                --check tc_servlet_requests \
                --critical 1000 \
                socks_shop
 
 # Check for string values by comparing them literally
 check_jmx4perl --url http://localhost::8888/jolokia \
                --mbean myDomain:name=myMBean \
                --attribute stringAttribute \
                --string \
                --critical &#39;Stopped&#39; \
                --warning &#39;!Started&#39;


 # Check that no more than 5 threads are started in a minute
 check_jmx4perl --url http://localhost:8888/jolokia \
                --alias THREAD_COUNT_STARTED \
                --delta 60 \
                --critical 5

 # Execute a JMX operation on an MBean and use the return value for threshold
 # Here a thread-deadlock is detected.
 check_jmx4perl --url http://localhost:8888/jolokia \
                --mbean java.lang:type=Threading \
                --operation findDeadlockedThreads \
                --null no-deadlock \
                --string \
                --critical &#39;!no-deadlock&#39; \
                --critical 10

 # Use check_jmx4perl in proxy mode
 check_jmx4perl --url http://localhost:8888/jolokia \
                --alias MEMORY_HEAP_USED \
                --critical 10000000 \
                 --target service:jmx:rmi:///jndi/rmi://bhut:9999/jmxrmi</code></pre>

##DESCRIPTION
<p><code>check_jmx4perl</code> is a Nagios plugin for monitoring Java applications. It uses an agent based approach for accessing JMX exposed information remotely.</p>

<p>Before start using <code>check_jmx4perl</code> an agent must be installed on the target platform. For JEE application server this is a simple webapplication packaged as a <code>war</code> archive. For other platforms, other agents are available, too. Please refer to the <code>README</code> for installation instructions and the supported platforms.</p>

<p><code>check_jmx4perl</code>s can also be used in an agentless mode (i.e. no agent needs to be installed on the target platform). See <a href="#Proxy-mode">&quot;Proxy mode&quot;</a> for details.</p>

<p>This plugin can be configured in two ways: Either, all required parameters for identifying the JMX information can be given via the command line. Or, a configuration file can be used to define one or more Nagios checks. This is the recommended way, since it allows for more advanced features not available when using the command line alone. Each command line argument has an equivalent option in the configuration files, though.</p>

<p>This documentation contains four parts. First, a <a href="#TUTORIAL">tutorial</a> gives a 5 minute quickstart for installing and using <code>check_jmx4perl</code>. The middle part offers some technical background information on JMX itself, the <a href="#REFERENCE">features</a> provided by this plugin and finally the <a href="#COMMAND-LINE">command line arguments</a> and the <a href="#CONFIGURATION">configuration file</a> directives are described.</p>

##TUTORIAL

<p>Before we dive into the more nifty details, this 5 minutes quickstart gives a simple cooking recipe for configuration and setup of <code>check_jmx4perl</code>.</p>

<ul>

<li><p>This tutorial uses <i>tomcat</i> as an application server. Download it from <a href="http://tomcat.apache.org">http://tomcat.apache.org</a> (either version 5 or 6) and extract it:</p>

<pre><code>  $ tar zxvf apache-tomcat-*.tar.gz
  $ # We need this variable later on:
  $ TC=`pwd`/apache-tomcat*</code></pre>

</li>
<li><p>Download <i>jmx4perl</i> from <a href="http://search.cpan.org/~roland/jmx4perl">http://search.cpan.org/~roland/jmx4perl</a> and install it:</p>

<pre><code>  $ tar zxvf jmx4perl-*.tar.gz
  $ cd jmx4perl*
  $ # Store current directory for later reference:
  $ J4P=`pwd`      
  $ perl Build.PL
  $ sudo ./Build install</code></pre>

<p>This is installs the Perl modules around <code>JMX::Jmx4Perl</code> which can be used for programmatic JMX access. There are some CPAN dependencies for jmx4perl, the build will fail if there are missing modules. Please install the missing modules via cpan (<code>cpan <i>module</i></code>). The Nagios plugin <code>check_jmx4perl</code> is installed in a standard location (<i>/usr/bin</i>, <i>/usr/local/bin</i> or whatever your Perl installation thinks is appropriate) as well as the other scripts <code>jmx4perl</code> (a generic tool for accessing JMX) and <code>j4psh</code> (an interactive JMX shell).</p>

</li>
<li><p>Deploy the Jolokia agent in Tomcat:</p>

<pre><code>  $ cd $TC/webapps
  $ jolokia</code></pre>

</li>
<li><p>Start Tomcat:</p>

<pre><code>  $ $TC/bin/startup.sh</code></pre>

</li>
<li><p>Check your setup:</p>

<pre><code>  $ jmx4perl http://localhost:8080/jolokia</code></pre>

<p>This prints out a summary about your application server. <a href="http://localhost:8080/jolokia">http://localhost:8080/jolokia</a> is the URL under which the agent is reachable. Tomcat itself listens on port 8080 by default, and any autodeployed war archive can be reached under its filename without the .war suffix (jolokia in this case).</p>

</li>
<li><p>Try a first Nagios check for checking the amount of available heap memory in relation to the maximal available heap:</p>

<pre><code>  $ check_jmx4perl --url http://localhost:8080/jolokia  \
                   --mbean java.lang:type=Memory    \
                   --attribute HeapMemoryUsage      \
                   --path used                      \
                   --base java.lang:type=Memory/HeapMemoryUsage/max \
                   --warning 80                     \
                   --critical 90        

  OK - [java.lang:type=Memory,HeapMemoryUsage,used] : In range 9.83% (12778136 / 129957888) | 
      &#39;[java.lang:type#Memory,HeapMemoryUsage,used]&#39;=12778136;103966310.4;116962099.2;0;129957888            </code></pre>

<p>where</p>

<dl>

<dt id="-url-http://localhost:8080/jolokia"><a id="url-http:-localhost:8080-jolokia"></a>--url http://localhost:8080/jolokia</dt>
<dd>

<p>is the agent URL</p>

</dd>
<dt id="-mbean-java.lang:type=Memory"><a id="mbean-java.lang:type-Memory"></a>--mbean java.lang:type=Memory</dt>
<dd>

<p>is the MBean name</p>

</dd>
<dt id="-attribute-HeapMemoryUsage"><a id="attribute-HeapMemoryUsage"></a>--attribute HeapMemoryUsage</dt>
<dd>

<p>is the attribute to monitor</p>

</dd>
<dt id="-path-used"><a id="path-used"></a>--path used</dt>
<dd>

<p>is an inner path (see <a href="#Paths">&quot;Paths&quot;</a>), which specifies an inner value within a more complex structure. The value <code>HeapMemoryUsage</code> is a composed value (Jav type: CompositeData) which combines multiple memory related data. The complete value can be viewed with <i>jmx4perl</i>:</p>

<pre><code>   $ jmx4perl http://localhost:8080/jolokia read java.lang:type=Memory HeapMemoryUsage
   {
     committed =&gt; 85000192,
     init =&gt; 0
     max =&gt; 129957888,
     used =&gt; 15106608,
   }</code></pre>

</dd>
<dt id="-base-java.lang:type=Memory/HeapMemoryUsage/max"><a id="base-java.lang:type-Memory-HeapMemoryUsage-max"></a>--base java.lang:type=Memory/HeapMemoryUsage/max</dt>
<dd>

<p>is the base value for which a relative threshold should be applied. This is a shortcut notation in the format <i>mbean</i><code>/</code><i>attribute</i><code>/</code><i>path</i>.</p>

</dd>
<dt id="-warning-80"><a id="warning-80"></a>--warning 80</dt>
<dd>

<p>is the warning threshold in percent. I.e. a <code>WARNING</code> will be raised by this plugin when the heap memory usage is larger than 80% of the maximal available heap memory for the application server (which is <i>smaller</i> than the available memory of the operating system)</p>

</dd>
<dt id="-critical-90"><a id="critical-90"></a>--critical 90</dt>
<dd>

<p>is the critical threshold in percent. If the available heap memory reaches 90% of the available heap, a <code>CRITICAL</code> alert will be returned.</p>

</dd>
</dl>

<p>All available command line options are described in <a href="#COMMAND-LINE">&quot;COMMAND LINE&quot;</a>.</p>

</li>
<li><p>For more complex checks the usage of a configuration file is recommended. This also allows you to keep your Nagios service definitions small and tidy. E.g. for monitoring the number of request per minute for a certain web application, a predefined check is available:</p>

<pre><code> $ check_jmx4perl --url http://localhost:8080/jolokia \
                  --config $J4P/config/tomcat.cfg \
                  --critical 100 \
                  --check tc_servlet_requests \
                  jolokia-agent
 
 OK - 15.00 requests/minute | &#39;Requests jolokia-agent&#39;=15;5000;100</code></pre>

<p>where</p>

<dl>

<dt id="-config-$J4P/config/tomcat.cfg"><a id="config--J4P-config-tomcat.cfg"></a>--config $J4P/config/tomcat.cfg</dt>
<dd>

<p>is the path to configuration file. There a several predefined checks coming with this distribution, which are documented inline. Look there for some inspiration for what to check.</p>

</dd>
<dt id="-critical-100"><a id="critical-100"></a>--critical 100</dt>
<dd>

<p>A threshold von 100, i.e. the checked value must be 100 or less, otherwise a critical alert is raised.</p>

</dd>
<dt id="-check-tc_servlet_requests"><a id="check-tc_servlet_requests"></a>--check tc_servlet_requests</dt>
<dd>

<p>is the name of the check to perform which must be defined in the configuration file</p>

</dd>
<dt id="jolokia-agent"><a id="jolokia"></a>jolokia-agent</dt>
<dd>

<p>is an extra argument used by the predefined check. It is the name of the servlet for which the number of requests should be monitored. To get the name of all registered servlets use <code>jmx4perl list</code>:</p>

<pre><code>  $ jmx4perl http://localhost:8080/jolokia list | grep j2eeType=Servlet</code></pre>

<p>The servlet name is the value of the <code>name</code> property of the listed MBeans.</p>

</dd>
</dl>

<p>Configuration files are very powerful and are the recommended way for configuring <code>check_jmx4perl</code> for any larger installation. Features like multi checks are even only available when using a configuration file. The syntax for configuration files are explained in depth in <a href="#CONFIGURATION">&quot;CONFIGURATION&quot;</a>.</p>

</li>
<li><p>Finally, a Nagios service definition needs to be added. For the memory example above, a command for relative checks can be defined:</p>

<pre><code>  define command {
     command_name         check_jmx4perl_relative
     command_line         $USER3$/check_jmx4perl \
                              --url $ARG1$ \
                              --mbean $ARG2$ \
                              --attribute $ARG3$ \
                              --path $ARG4$ \
                              --base $ARG5$ \
                              $ARG6$
  } </code></pre>

<p>Put this into place where you normally define commands (either in the global Nagios <i>commands.cfg</i> or in a specific commands configuration file in the commands directory). <code>$USER3</code> is a custom variable and should point to the directory where <code>check_jmx4perl</code> is installed (e.g. <i>/usr/local/bin</i>).</p>

<p>The service definition itself then looks like:</p>

<pre><code>  define service {
     service_description    j4p_localhost_memory
     host_name              localhost
     check_command          check_jmx4perl_relative \
                            !http://localhost:8080/jolokia \
                            !java.lang:type=Memory \
                            !HeapMemoryUsage \
                            !used \
                            !java.lang:type=Memory/HeapMemoryUsage/max \
                            !--warning 80 --critical 90
  }  </code></pre>

<p>Add this section to your service definitions (depending on your Nagios installation). This example adds a service to host <code>localhost</code> for checking the heap memory, raising a <code>WARNING</code> if 80% of the available heap is used and a <code>CRITICAL</code> if more than 90% of the heap memory is occupied.</p>

</li>
</ul>

<p>Installing and using jmx4perl is really that easy. The Nagios configuration in this example is rather simplistic, of course a more flexible Nagios setup is possible. The blog post <a href="http://labs.consol.de//blog/jmx4perl/check_jmx4perl-einfache-servicedefinitionen/">http://labs.consol.de//blog/jmx4perl/check_jmx4perl-einfache-servicedefinitionen/</a> (written by Gerhard Lausser) shows some advanced configuration setup. (It is in german, but the automatic translation from <a href="http://bit.ly/bgReAs">http://bit.ly/bgReAs</a> seems to be quite usable).</p>

##REFERENCE

<p>This section explains the JMX basics necessary to better understand the usage of <code>check_jmx4perl</code>. It tries to be as brief as possible, but some theory is required to get the link to the Java world.</p>

###MBeans

<p>JMX&#39;s central entity is an <code>MBean</code>. An MBean exposes management information in a well defined way. Each MBean has a unique name called <i>Object Name</i> with the following structure:</p>

<pre><code>  domain:attribute1=value1,attribute2=value2, .....</code></pre>

<p>E.g.</p>

<pre><code>  java.lang:type=Memory</code></pre>

<p>points to the MBean which lets you access the memory information of the target server.</p>

<p>Unfortunately, except for so called <i>MXBeans</i> (<a href="http://java.sun.com/j2se/1.5.0/docs/api/java/lang/management/package-summary.html">http://java.sun.com/j2se/1.5.0/docs/api/java/lang/management/package-summary.html</a>) there is no standard naming for MBeans. Each platform uses its own. There used to be a naming standard defined in <b>JSR77</b> (<a href="http://jcp.org/en/jsr/detail?id=77">http://jcp.org/en/jsr/detail?id=77</a>), unfortunately it was never widely adopted.</p>

<p>There are various ways for identifying MBeans on a server:</p>

<ul>

<li><p>Use <code>jmx4perl --list</code> to list all registered MBeans. In addition <code>jmx4perl --attributes</code> dumps out all known MBean attributes along with their values. (Be careful, the output can be quite large)</p>

</li>
<li><p>Use <code>j4psh</code> for interactively exploring the JMX namespace.</p>

</li>
<li><p>Use an alias. An alias is a shortcut for an MBean name, predefined by <a href="/pod/JMX::Jmx4Perl">JMX::Jmx4Perl</a>. All known aliases can be shown with <code>jmx4perl aliases</code>. Since each platform can have slightly different MBean names for the same information, this extra level of indirection might help in identifying MBeans. See <a href="#Aliases">&quot;Aliases&quot;</a> for more about aliases.</p>

</li>
<li><p>Use a predefined check. <code>check_jmx4perl</code> comes with quite some checks predefined in various configuration files. These are ready for use out of the box. <a href="#Predefined-checks">&quot;Predefined checks&quot;</a> are described in an extra section.</p>

</li>
<li><p>Ask your Java application development team for application specific MBean names.</p>

</li>
</ul>

###Attributes and Operations

<p><code>check_jmx4perl</code> can obtain the information to monitor from two sources: Either as MBean <i>attributes</i> or as a return value from JMX <i>operations</i>. Since JMX values can be any Java object, it is important to understand, how <code>check_jmx4perl</code> (or <i>jmx4perl</i> in general) handles this situation.</p>

<p>Simple data types can be used directly in threshold checking. I.e. the following data types can be used directly</p>

<ul>

<li><p>Integer</p>

</li>
<li><p>Long</p>

</li>
<li><p>Float</p>

</li>
<li><p>Double</p>

</li>
<li><p>Boolean</p>

</li>
<li><p>String</p>

</li>
</ul>

<p><code>String</code> and <code>Boolean</code> can be used in <i>string</i> checks only, whereas the others can be used in both, <i>numeric</i> and <i>string</i> checks (see <a href="#String-checks">&quot;String checks&quot;</a>).</p>

<p>For numeric checks, the threhsholds has to be specified according to the format defined in <a href="http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT">http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT</a></p>

<h3 id="Paths">Paths</h3>

<p>For more complex types, <code>check_jmx4perl</code> provides the concept of so called <i>paths</i> for specifying an inner attribute of a more complex value. A path contains parts separated by slashes (/). It is similar to an XPath expression for accessing parts of an XML document. Each part points to an inner level of a complex object.</p>

<p>For example, the MBean <code>java.lang:type=Memory</code> exposes an attribute called <code>HeapMemoryUsage</code>. This attribute is a compound data type which contains multiple entries. Looking with <code>jmx4perl</code> at this attribute</p>

<pre><code> $ jmx4perl http://localhost:8080/jolokia read java.lang:type=Memory HeapMemoryUsage
 {
   committed =&gt; 85000192,
   init =&gt; 0
   max =&gt; 129957888,
   used =&gt; 15106608,
 }</code></pre>

<p>it can be seen, that there are 4 values coming with the reponse. With a path <code>used</code> one can directly pick the used heap memory usage (8135440 bytes in this case) which then can be used for a threshold check.</p>

<pre><code> $ check_jmx4perl --url http://localhost:8080/jolokia \ 
                  --mbean java.lang:type=Memory \ 
                  --attribute HeapMemoryUsage \
                  --path used \
                  --critical 100000000
 OK - [java.lang:type=Memory,HeapMemoryUsage,used] : Value 10136056 in range | ...</code></pre>

<h3 id="Attributes1">Attributes</h3>

<p>Attributes are values obtained from MBean properties. Complex values are translated into a JSON structure on the agent side, which works for most types. To access a single value from a complex value, the path mechanism described above can be used. Thresholds can be applied to simple data types only, so for complex attributes a path is <i>required</i>.</p>

<h3 id="Operations">Operations</h3>

<p>The return values of operations can be used for threshold checking, too. Since a JMX exposed operation can take arguments, these has to be provided as extra arguments on the command line or in the configuration via the <code>Args</code> configuration directive. Due to the agent&#39;s nature and the protocol used (JSON), only simple typed arguments like strings, numbers or booleans (&quot;true&quot;/&quot;false&quot;) can be used.</p>

<p>Example:</p>

<pre><code> $ check_jmx4perl --url http://localhost:8888/jolokia \
                  --mbean jolokia:type=Runtime \
                  --operation getNrQueriesFor \
                  --critical 10 \
                  &quot;operation&quot; \
                  &quot;java.lang:type=Memory&quot; \
                  &quot;gc&quot; </code></pre>

<p>This example contacts a MBean <code>jolokia:type=Runtime</code> registered by the jolokia agent in order to check for the number of queries for a certain MBean via this agent. For this purpose an JMX operation <code>getNrQueriesFor</code> is exposed which takes three arguments: The type (&quot;operation&quot;/&quot;attribute&quot;), the MBean&#39;s ObjectName and the operation/attribute name which was called.</p>

<p>If the operation to be called is an <i>overloaded operation</i> (i.e. an operation whose name exists multiple times on the same MBean but with different parameter types), the argument types must be given within parentheses:</p>

<pre><code>     --operation checkUserCount(java.lang.String,java.lang.String)</code></pre>

<h2 id="Aliases">Aliases</h2>

<p>Aliases are shortcut for common MBean names and attributes. E.g. the alias <code>MEMORY_HEAP_MAX</code> specifies the MBean <code>java.lang:type=Memory</code>, the attribute <code>HeapMemoryUsage</code> and the path <code>max</code>. Aliases can be specified with the <code>--alias</code> option or with the configuration directive <code>Alias</code>. Aliases can be translated to different MBean names on different application server. For this <code>check_jmx4perl</code> uses an autodetection mechanism to determine the target platform. Currently this mechanism uses one or more extra server round-trips. To avoid this overhead, the <code>--product</code> option (configuration: <code>Product</code>) can be used to specify the target platform explicitely. This is highly recommended in case you are using the aliasing feature.</p>

<p>Aliases are not extensible and can not take any parameters. All availables aliases can be viewed with</p>

<pre><code>  jmx4perl aliases</code></pre>

<p>A much more flexible alternative to aliases are <i>parameterized checks</i>, which are defined in a configuration file. See <a href="#CONFIGURATION">&quot;CONFIGURATION&quot;</a> for more details about parameterized checks.</p>

<h2 id="Relative-Checks"><a id="Relative"></a>Relative Checks</h2>

<p>Relative values are often more interesting than absolute numbers. E.g. the knowledge that 140 MBytes heap memory is used is not as important as the knowledge, that 56% of the available memory is used. Relative checks calculate the ratio of a value to a base value. (Another advantage is that Nagios service definitions for relative checks are generic as they can be applied for target servers with different memory footprints).</p>

<p>The base value has to be given with <code>--base</code> (configuration: <code>Base</code>). The argument provided here is first tried as an alias name or checked as an absolute, numeric value. Alternatively, you can use a full MBean/attribute/path specification by using a <code>/</code> as separator, e.g.</p>

<pre><code>  ... --base java.lang:type=Memory/HeapMemoryUsage/max ...</code></pre>

<p>If one of these parts (the path is optional) contains a slash within its name, the slash must be escaped with a backslash (\/). Backslashes in MBean names are escaped with a double backslash (\\).</p>

<p>Alternatively <code>--base-mbean</code>, <code>--base-attribute</code> and <code>--base-path</code> can be used to specify the parts of the base value separately.</p>

<p>Example:</p>

<pre><code>   check_jmx4perl --url http://localhost:8080/jolokia \ 
                  --value java.lang:type=Memory/HeapMemoryUsage/used \ 
                  --base java.lang:type=Memory/HeapMemoryUsage/max \ 
                  --critical 90

   check_jmx4perl --url http://localhost:8080/jolokia \ 
                  --value java.lang:type=Memory/HeapMemoryUsage/used \ 
                  --base-mbean java.lang:type=Memory \
                  --base-attribute HeapMemoryUsage \
                  --base-path max \ 
                  --critical 90</code></pre>

<p>This check will trigger a state change to CRITICAL if the used heap memory will exceed 90% of the available heap memory.</p>

<h2 id="Incremental-Checks"><a id="Incremental"></a>Incremental Checks</h2>

<p>For some values it is worth monitoring the increase rate (velocity). E.g. for threads it can be important to know how fast threads are created.</p>

<p>Incremental checks are switched on with the <code>--delta</code> option (configuration: <code>Delta</code>). This option takes an optional argument which is interpreted as seconds for normalization.</p>

<p>Example:</p>

<pre><code>  check_jmx4perl --url http://localhost:8080/jolokia \ 
                 --mbean java.lang:type=Threading \ 
                 --attribute TotalStartedThreadCount \ 
                 --delta 60 \ 
                 --critical 5</code></pre>

<p>This will fail as CRITICAL if more than 5 threads are created per minute (60 seconds). Technically <code>check_jmx4perl</code> uses the <i>history</i> feature of the jolokia agent deployed on the target server. This will always store the result and the timestamp of the last check on the server side and returns these historical values on the next check so that the velocity can be calculated. If no value is given for <code>--delta</code>, no normalization is used. In the example above, without a normalization value of 60, a CRITICAL is returned if the number of threads created increased more than 5 between two checks.</p>

<p><code>--delta</code> doesn&#39;t work yet with <code>--base</code> (e.g. incremental mode for relative checks is not available).</p>

<h2 id="String-checks"><a id="String"></a>String checks</h2>

<p>In addition to standard numerical checks, direct string comparison can be used. This mode is switched on either explicitely via <code>--string</code> (configuration: <code>String</code>) or by default implicitely if a heuristics determines that a value is non-numeric. Numeric checking can be enforced with the option <code>--numeric</code> (configuration: Numeric).</p>

<p>For string checks, <code>--critical</code> and <code>--warning</code> are not treated as numerical values but as string types. They are compared literally against the value retrieved and yield the corresponding Nagios status if matched. If the threshold is given with a leading <code>!</code>, the condition is negated. E.g. a <code>--critical &#39;!Running&#39;</code> returns <code>CRITICAL</code> if the value <i>not</i> equals to <code>Running</code>. Alternatively you can also use a regular expression by using <code>qr/.../</code> as threshold value (substitute <code>...</code> with the pattern to used for comparison). Boolean values are returned as <code>true</code> or <code>false</code> strings from the agent, so you can check for them as well with this kind of string comparison.</p>

<p>No performance data will be generated for string checks by default. This can be switched on by providing <code>--perfdata on</code> (or &quot;<code>PerfData on</code>&quot; in the configuration). However, this probably doesn&#39;t make much sense, though.</p>

<h2 id="Output-Tuning"><a id="Output"></a>Output Tuning</h2>

<p>The output of <code>check_jmx4perl</code> can be highly customized. A unit-of-measurement can be provided with the option <code>--unit</code> (configuration: <code>Unit</code>) which specifies how the the attribute or an operation&#39;s return value should be interpreted. The units available are</p>

<pre><code>  B  - Byte
  KB - Kilo Byte
  MB - Mega Byte
  GB - Giga Byte
  TB - Terra Byte
  
  us - Microseconds
  ms - Milliseconds
  s  - Seconds
  m  - Minutes
  h  - Hours
  d  - Days</code></pre>

<p>The unit will be used for performance data as well as for the plugin&#39;s output. Large numbers are converted to larger units automatically (and reverse for small number that are smaller than 1). E.g. <code>2048 KB</code> is converted to <code>2 MB</code>. Beautifying by conversion is <i>only</i> performed for the plugin output, <b>not</b> for the performance data for which no conversions happens at all.</p>

<p>Beside unit handling, you can provide your own label for the Nagios output via <code>--label</code>. The provided option is interpreted as a pattern with the following placeholders:</p>

<pre><code> %v   the absolute value 
 %f   the absolute value as floating point number
 %r   the relative value as percentage (--base)
 %q   the relative value as ratio of value to base (--base)
 %u   the value&#39;s unit for the output when --unit is used (after shortening)
 %w   the base value&#39;s unit for the output when --unit is used (after shortening)
 %b   the absolut base value as it is used with --base 
 %c   the Nagios exit code in the Form &quot;OK&quot;, &quot;WARNING&quot;, &quot;CRITICAL&quot; 
      or &quot;UNKNOWN&quot;
 %t   Threshold value which failed (&quot;&quot; when the check doesn&#39;t fail)
 %n   name, either calulated automatically or given with --name
 %d   the delta value used for normalization when using incremental mode
 %y   WARNING threshold as configured
 %z   CRITICAL threshold as configured</code></pre>

<p>Note that <code>%u</code> and <code>%w</code> are typically <i>not</i> the same as the <code>--unit</code> option. They specify the unit <i>after</i> the conversion for the plugin output as described above. You can use the same length modifiers as for <code>sprintf</code> to fine tune the output.</p>

<p>Example:</p>

<pre><code> check_jmx4perl --url http://localhost:8888/jolokia \
                --alias MEMORY_HEAP_USED \
                --base MEMORY_HEAP_MAX \ 
                --critical :80 \
                --label &quot;Heap-Memory: %.2r% used (%.2v %u / %.2b %w)&quot; \
                --unit B</code></pre>

<p>will result in an output like</p>

<pre><code> OK - Heap-Memory: 3.48% used (17.68 MB / 508.06 MB) | &#39;[MEMORY_HEAP_USED]&#39;=3.48%;;:80</code></pre>

<h2 id="Security">Security</h2>

<p>Since the jolokia-agent is usually a simple war-file, it can be secured as any other Java Webapplication. Since setting up authentication is JEE Server specific, a detailed instruction is beyond the scope of this document. Please refer to your appserver documentation, how to do this. At the moment, <code>check_jmx4perl</code> can use Basic-Authentication for authentication purposes only.</p>

<p>In addition to this user/password authentication, the jolokia-agent uses a policy file for fine granular access control. The policy is defined with an XML file packaged within the agent. In order to adapt this to your needs, you need to extract the war file, edit it, and repackage the agent with a policy file. A future version of jmx4perl might provide a more flexible way for changing the policy.</p>

<p>In detail, the following steps are required:</p>

<ul>

<li><p>Download <i>jolokia.war</i> and a sample policy file <i>jolokia-access.xml</i> into a temporary directory:</p>

<pre><code>   $ jolokia
   $ jolokia --policy</code></pre>

</li>
<li><p>Edit the policy according to your needs.</p>

<pre><code>   $ vi jolokia-access.xml
   </code></pre>

</li>
<li><p>Repackage the war file</p>

<pre><code>   $ jolokia repack --policy jolokia.war</code></pre>

</li>
<li><p>Deploy the agent <i>jolokia.war</i> as usual</p>

</li>
</ul>

<p>The downloaded sample policy file <i>jolokia-access.xml</i> contains inline documentation and examples, so you can easily adapt it to your environment.</p>

<p>Restrictions can be set to on various parameters :</p>

<h3 id="Client-IP-address"><a id="Client"></a>Client IP address</h3>

<p>Access to the jolokia-agent can be restricted based on the client IP accessing the agent. A single host, either with hostname or IP address can be set or even a complete subnet.</p>

<p>Example:</p>

<pre><code>  &lt;remote&gt;
    &lt;host&gt;127.0.0.1&lt;/host&gt;
    &lt;host&gt;10.0.0.0/16&lt;/host&gt;
  &lt;/remote&gt;</code></pre>

<p>Only the localhost or any host in the subnet 10.0 is allowed to access the agent. If the <code>&lt;remote&gt;</code> section is missing, access from all hosts is allowed.</p>

<h3 id="Commands">Commands</h3>

<p>The access can be restricted to certain commands.</p>

<p>Example:</p>

<pre><code>   &lt;commands&gt;
     &lt;command&gt;read&lt;/command&gt;
   &lt;/commands&gt;</code></pre>

<p>This will only allow reading of attributes, but no other operation like execution of operations. If the <code>&lt;commands&gt;</code> section is missing, any command is allowed. The commands known are</p>

<dl>

<dt id="read">read</dt>
<dd>

<p>Read an attribute</p>

</dd>
<dt id="write">write</dt>
<dd>

<p>Write an attribute (used by <code>check_jmx4perl</code> only when using incremental checks)</p>

</dd>
<dt id="exec">exec</dt>
<dd>

<p>Execution of an operation</p>

</dd>
<dt id="list">list</dt>
<dd>

<p>List all MBeans (not used by <code>check_jmx4perl</code>)</p>

</dd>
<dt id="version">version</dt>
<dd>

<p>Version command (not used by <code>check_jmx4perl</code>)</p>

</dd>
<dt id="search">search</dt>
<dd>

<p>Search for MBean (not used by <code>check_jmx4perl</code>)</p>

</dd>
</dl>

<h3 id="Specific-MBeans"><a id="Specific"></a>Specific MBeans</h3>

<p>The most specific policy can be put on the MBeans themselves. For this, two sections can be defined, depending on whether a command is globaly enabled or denied.</p>

<dl>

<dt id="&lt;allow&gt;"><a id="allow"></a>&lt;allow&gt;</dt>
<dd>

<p>The <code>&lt;allow&gt;</code> section is used to switch on access for operations and attributes in case <code>read</code>, <code>write</code> or <code>exec</code> are globally disabled (see above). Wildcards can be used for MBean names and attributes/and operations.</p>

<p>Example:</p>

<pre><code>  &lt;allow&gt;
    &lt;mbean&gt;
      &lt;name&gt;jolokia:*&lt;/name&gt;
      &lt;operation&gt;*&lt;/operation&gt;
      &lt;attribute&gt;*&lt;/attribute&gt;
    &lt;/mbean&gt;
    &lt;mbean&gt;
      &lt;name&gt;java.lang:type=Threading&lt;/name&gt;
      &lt;operation&gt;findDeadlockedThreads&lt;/operation&gt;
    &lt;/mbean&gt;
    &lt;mbean&gt;
    &lt;name&gt;java.lang:type=Memory&lt;/name&gt;
      &lt;attribute mode=&quot;read&quot;&gt;Verbose&lt;/attribute&gt;
    &lt;/mbean&gt;

  &lt;/allow&gt;</code></pre>

<p>This will allow access to all operation and attributes of all MBeans in the <code>jolokia:</code> domain and to the operation <code>findDeadlockedThreads</code> on the MBean <code>java.lang:type=Threading</code> regardless whether the <code>read</code> or <code>exec</code> command is enabled globally. The attribute <code>Verbose</code> on <code>java.lang:type=Memory</code> is allowed to be read, but cannot be written (if the <code>mode</code> attribute is not given, both read and write is allowed by default).</p>

</dd>
<dt id="&lt;deny&gt;"><a id="deny"></a>&lt;deny&gt;</dt>
<dd>

<p>The <code>&lt;deny&gt;</code> section forbids access to certain MBean&#39;s operation and/or attributes, even when the command is allowed globally.</p>

<p>Example:</p>

<pre><code>  &lt;deny&gt;
    &lt;mbean&gt;
      &lt;!-- Exposes user/password of data source, so we forbid this one --&gt;
      &lt;name&gt;com.mchange.v2.c3p0:type=PooledDataSource*&lt;/name&gt;
      &lt;attribute&gt;properties&lt;/attribute&gt;
    &lt;/mbean&gt;
  &lt;/deny&gt;</code></pre>

<p>This will forbid the access to the specified attribute, even if <code>read</code> is allowed globally. If there is an overlap between &lt;allow&gt; and &lt;deny&gt;, &lt;allow&gt; takes precedence.</p>

</dd>
</dl>

<h2 id="Proxy-mode"><a id="Proxy"></a>Proxy mode</h2>

<p><code>check_jmx4perl</code> can be used in an <i>agentless mode</i> as well, i.e. no jolokia-agent needs to deployed on the target server. The setup for the agentless mode is a bit more complicated, though:</p>

<ul>

<li><p>The target server needs to export its MBeans via JSR-160. The configuration for JMX export is different for different JEE Server. <a href="http://labs.consol.de">http://labs.consol.de</a> has some cooking recipes for various servers (JBoss, Weblogic).</p>

</li>
<li><p>A dedicated <i>proxy server</i> needs to be setup on which the <i>jolokia.war</i> gets deployed. This can be a simple Tomcat or Jetty servlet container. Of course, an already existing JEE Server can be used as proxy server as well.</p>

</li>
<li><p>For using <code>check_jmx4perl</code> the target JMX URL for accessing the target server is required. This URL typically looks like</p>

<pre><code>  service:jmx:rmi:///jndi/rmi://host:9999/jmxrmi</code></pre>

<p>but this depends on the server to monitor. Please refer to your JEE server&#39;s documentation for how the export JMX URL looks like.</p>

</li>
<li><p><code>check_jmx4perl</code> uses the proxy mody if the option <code>--target</code> (configuration: &lt;Target&gt;) is provided. In this case, this Nagios plugin contacts the proxy server specified as usual with <code>--url</code> (config: Url in Server section) and put the URL specified with <code>--target</code> in the request. The agent in the proxy then dispatches this request to the real target and uses the JMX procotol specified with in the target URL. The answer received is then translated into a JSON response which is returned to <code>check_jmx4perl</code>.</p>

<p>Example:</p>

<pre><code>   check_jmx4perl --url http://proxy:8080/jolokia \
                  --target service:jmx:rmi:///jndi/rmi://jeeserver:9999/jmxrmi
                  --alias MEMORY_HEAP_USED
                  --base MEMORY_HEAP_MAX
                  --critical 90</code></pre>

<p>Here the host <i>proxy</i> is listening on port 8080 for jolokia requests and host <i>jeeserver</i> exports its JMX data via JSR-160 over port 9999. (BTW, <i>proxy</i> can be monitored itself as usual).</p>

<p>So, what mode is more appropriate ? Both, the <i>agent mode</i> and the <i>proxy mode</i> have advantages and disadvantages.</p>

</li>
</ul>

<h3 id="Advantages">Advantages</h3>

<ul>

<li><p>No agent needs to be installed on the target server. This might be useful for policy reasons.</p>

</li>
<li><p>Compared to other Nagios JMX plugin&#39;s no JVM startup is required since the proxy server is already running.</p>

</li>
</ul>

<h3 id="Disadvantages">Disadvantages</h3>

<ul>

<li><p>It takes two hops to get to the target server</p>

</li>
<li><p>Exporting JMX via JSR-160 is often not that easy as it may seem. (See post series on remote JMX on labs.consol.de)</p>

</li>
<li><p>Some features like merging of MBean Servers are not available in proxy mode. (i.e you need to know in advance which MBean-Server on the target you want to contact for a certain MBean, since this information is part of the JMX URL)</p>

</li>
<li><p>Bulk request needs to be detangled into multiple JMX request since JSR-160 doesn&#39;t know anything about bulk requests.</p>

</li>
<li><p>jmx4perl&#39;s fine granular security policy is not available, since JSR-160 JMX is an all-or-nothing thing. (except you are willing to dive deep into Java Security stuff)</p>

</li>
<li><p>For JSR-160 objects to be transferable to the proxy, the proxy needs to know about the Java types and those types must be serializable. If this is not the case, the proxy isn&#39;t able to collect the information from the target. So only a subset of MBeans can be monitored this way.</p>

<p>The agent protocol is more flexible since it translates the data into a JSON structure <i>before</i> putting it on the wire.</p>

</li>
</ul>

<p>To summarize, I would always recommend the <i>agent mode</i> over the <i>proxy mode</i> except when an agentless operation is required (e.g. for policy reasons).</p>

##COMMAND LINE

<p>The pure command line interface (without a configuration file) is mostly suited for simple checks where the predefined defaults are suitable. For all other use cases, a <a href="#CONFIGURATION">configuration</a> file fits better.</p>

<p><code>check_jmx4perl</code> knows about the following command line options:</p>

<dl>

<dt id="-url-(-u)"><a id="url---u"></a>--url (-u)</dt>
<dd>

<p>The URL for accessing the target server (or the jolokia-proxy server, see <a href="#Proxy-Mode">&quot;Proxy Mode&quot;</a> for details about the JMX proxy mode)</p>

<p>Example:</p>

<pre><code>  --url http://localhost:8080/jolokia</code></pre>

</dd>
<dt id="-mbean-(-m)"><a id="mbean---m"></a>--mbean (-m)</dt>
<dd>

<p>Object name of MBean to access</p>

<p>Example:</p>

<pre><code>  --mbean java.lang:type=Runtime</code></pre>

</dd>
<dt id="-attribute-(-a)"><a id="attribute---a"></a>--attribute (-a)</dt>
<dd>

<p>A MBean&#39;s attribute name. The value of this attribute is used for threshold checking.</p>

<p>Example:</p>

<pre><code>  --attribute Uptime</code></pre>

</dd>
<dt id="-operation-(-o)"><a id="operation---o"></a>--operation (-o)</dt>
<dd>

<p>A MBean&#39;s operation name. The operation gets executed on the server side and the return value is used for threshold checking. Any arguments required for this operation has to be given as additional arguments to <code>check_jmx4perl</code>. See <a href="#Attributes-and-Operations">&quot;Attributes and Operations&quot;</a> for details.</p>

<p>Example:</p>

<pre><code>  check_jmx4perl ... --mbean java.lang:type=Threading \
                     --operation getThreadUserTime 1</code></pre>

<p>Operation <code>getThreadUserTime</code> takes a single argument the thread id (a long) which is given as extra argument.</p>

</dd>
<dt id="-path-(-p)"><a id="path---p"></a>--path (-p)</dt>
<dd>

<p>Path for extracting an inner element from an attribute or operation return value. See <a href="#Paths">&quot;Paths&quot;</a> for details about paths.</p>

<p>Example:</p>

<pre><code>   --path used</code></pre>

</dd>
<dt id="-value"><a id="value"></a>--value</dt>
<dd>

<p>Shortcut for giving <code>--mbean</code>, <code>--attribute</code> and <code>--path</code> at once.</p>

<p>Example:</p>

<pre><code>   --value java.lang:type=Memory/HeapMemoryUsage/used</code></pre>

<p>Any slash (/) in the MBean name must be escaped with a backslash (\/). Backslashes in names has to be escaped as \\.</p>

</dd>
<dt id="-base-(-b)"><a id="base---b"></a>--base (-b)</dt>
<dd>

<p>Switches on relative checking. The value given points to an attribute which should be used as base value and has to be given in the shortcut notation described above. Alternatively, the value can be an absolute number or an alias name (<a href="#Aliases">&quot;Aliases&quot;</a>) The threshold are the interpreted as relative values in the range [0,100]. See <a href="#Relative-Checks">&quot;Relative Checks&quot;</a> for details.</p>

<p>Example:</p>

<pre><code>  --base 100000
  --base java.lang:type=Memory/HeapMemoryUsage/max
  --base MEMORY_HEAP_MAX</code></pre>

</dd>
<dt id="-delta-(-d)"><a id="delta---d"></a>--delta (-d)</dt>
<dd>

<p>Switches on incremental checking, i.e. the increase rate (or velocity) of an attribute or operation return value is measured. The value given here is used for normalization (in seconds). E.g. <code>--delta 60</code> normalizes the velocity to &#39;growth per minute&#39;. See <a href="#Incremental-Checks">&quot;Incremental Checks&quot;</a> for details.</p>

</dd>
<dt id="-string"><a id="string"></a>--string</dt>
<dd>

<p>Forces string checking, in which case the threshold values are compared as strings against the measured values. See <a href="#String-checks">&quot;String checks&quot;</a> for more details. By default, a heuristic based on the measured value is applied to determine, whether numerical or string checking should be use</p>

<p>Example:</p>

<pre><code>  --string --critical &#39;!Running&#39;
 </code></pre>

</dd>
<dt id="-numeric"><a id="numeric"></a>--numeric</dt>
<dd>

<p>Forces numeric checking, in which case the measured valued are compared against the given thresholds according to the Nagios developer guideline specification (<a href="http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT">http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT</a>)</p>

<p>Example:</p>

<pre><code>  --numeric --critical ~:80</code></pre>

</dd>
<dt id="-null"><a id="null"></a>--null</dt>
<dd>

<p>The value to be used in case the attribute or the operation&#39;s return value is <code>null</code>. This is useful when doing string checks. By default, this value is &quot;<code>null</code>&quot;.</p>

<p>Example:</p>

<pre><code>  --null &quot;no deadlock&quot; --string --critical &quot;!no deadlock&quot;</code></pre>

</dd>
<dt id="-name-(-n)"><a id="name---n"></a>--name (-n)</dt>
<dd>

<p>Name to be used for the performance data. By default a name is calculated based on the MBean&#39;s name and the attribute/operation to monitor.</p>

<p>Example:</p>

<pre><code>  --name &quot;HeapMemoryUsage&quot;</code></pre>

</dd>
<dt id="-label-(-l)"><a id="label---l"></a>--label (-l)</dt>
<dd>

<p>Label for using in the plugin output which can be a format specifier as described in <a href="#Output-Tuning">&quot;Output Tuning&quot;</a>.</p>

<p>Example:</p>

<pre><code>  --label &quot;%.2r% used (%.2v %u / %.2b %w)&quot;</code></pre>

</dd>
<dt id="-perfdata"><a id="perfdata"></a>--perfdata</dt>
<dd>

<p>Switch off (&quot;off&quot;) or on (&quot;on&quot;) performance data generation. Performance data is generated by default for numerical checks and omitted for string based checks. For relative checks, if the value is &#39;%&#39; then performance data is appended as relative values instead of absolute values.</p>

</dd>
<dt id="-unit"><a id="unit"></a>--unit</dt>
<dd>

<p>Natural unit of the value measured. E.g. when measuring memory, then the memory MXBean exports this number as bytes. The value given here is used for shortening the value&#39;s output by converting to the largest possible unit. See <a href="#Output-Tuning">&quot;Output Tuning&quot;</a> for details.</p>

<p>Example:</p>

<pre><code>   --alias MEMORY_HEAP_USED --unit B</code></pre>

</dd>
<dt id="-critical-(-c)"><a id="critical---c"></a>--critical (-c)</dt>
<dd>

<p>Critical threshold. For string checks, see <a href="#String-checks">&quot;String checks&quot;</a> for how the critical value is interpreted. For other checks, the value given here should conform to the specification defined in <a href="http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT">http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT</a>.</p>

<p>Example:</p>

<pre><code>   --critical :90</code></pre>

</dd>
<dt id="-warning-(-w)"><a id="warning---w"></a>--warning (-w)</dt>
<dd>

<p>Warning threshold, which is interpreted the same way as the <code>--critical</code> threshold (see above). At least a warning or critical threshold must be given.</p>

</dd>
<dt id="-alias"><a id="alias"></a>--alias</dt>
<dd>

<p>An alias is a shortcut for an MBean attribute or operation. See <a href="#Aliases">&quot;Aliases&quot;</a> for details.</p>

<p>Example:</p>

<pre><code>  --alias RUNTIME_UPTIME</code></pre>

</dd>
<dt id="-product"><a id="product"></a>--product</dt>
<dd>

<p>When aliasing is used, <code>check_jmx4perl</code> needs to known about the target server type for resolving the alias. By default it used an autodetection facility, which at least required an additional request. To avoid this, the product can be explicitely specified here</p>

<p>Example:</p>

<pre><code>   --product jboss</code></pre>

</dd>
<dt id="-user,-password"><a id="user--password"></a>--user, --password</dt>
<dd>

<p>User and password needed when the agent is secured with Basic Authentication. By default, no authentication is used.</p>

</dd>
<dt id="-timeout-(-t)"><a id="timeout---t"></a>--timeout (-t)</dt>
<dd>

<p>How long to wait for an answer from the agent at most (in seconds). By default, the timeout is 180s.</p>

</dd>
<dt id="-method"><a id="method"></a>--method</dt>
<dd>

<p>The HTTP metod to use for sending the jmx4perl request. This can be either <code>get</code> or <code>post</code>. By default, an method is determined automatically. <code>get</code> for simple, single requests, <code>post</code> for bulk request or requests using a JMX proxy.</p>

</dd>
<dt id="-proxy"><a id="proxy"></a>--proxy</dt>
<dd>

<p>A HTTP proxy server to use for accessing the jolokia-agent.</p>

<p>Example:</p>

<pre><code>  --proxy http://proxyhost:8001/</code></pre>

</dd>
<dt id="-legacy-escape"><a id="legacy-escape"></a>--legacy-escape</dt>
<dd>

<p>When the deployed Jolokia agent&#39;s version is less than 1.0, then this option should be used since the escape scheme as changed since version 1.0. This option is only important for MBeans whose names contain slashes. It is recommended to upgrade the agent to a post 1.0 version, though.</p>

</dd>
<dt id="-target,-target-user,-target-password"><a id="target--target-user--target-password"></a>--target, --target-user, --target-password</dt>
<dd>

<p>Switches on jolokia-proxy mode and specifies the URL for accessing the target platform. Optionally, user and password for accessing the target can be given, too. See <a href="#Proxy-Mode">&quot;Proxy Mode&quot;</a> for details.</p>

<p>Example:</p>

<pre><code>  --target service:jmx:rmi:///jndi/rmi://bhut:9999/jmxrmi</code></pre>

</dd>
<dt id="-config"><a id="config"></a>--config</dt>
<dd>

<p>Specifies a configuration file from where server and check definitions can be obtained. See <a href="#CONFIGURATION">&quot;CONFIGURATION&quot;</a> for details about the configuration file&#39;s format.</p>

<p>Example:</p>

<pre><code>   --config /etc/jmx4perl/tomcat.cfg</code></pre>

</dd>
<dt id="-server"><a id="server"></a>--server</dt>
<dd>

<p>Specify a symbolic name for a server connection. This name is used to lookup a server in the configuration file specified with <code>--config</code></p>

<p>Example:</p>

<pre><code> servers.cfg:
   &lt;Server tomcat&gt;
      Url http://localhost:8080/jolokia
      User roland
      Password fcn
   &lt;/Server&gt;

   --config /etc/jmx4perl/servers.cfg --server tomcat</code></pre>

<p>See <a href="#CONFIGURATION">&quot;CONFIGURATION&quot;</a> for more about server definitions.</p>

</dd>
<dt id="-check"><a id="check"></a>--check</dt>
<dd>

<p>The name of the check to use as defined in the configuration file. See <a href="#CONFIGURATION">&quot;CONFIGURATION&quot;</a> about the syntax for defining checks and multi checks. Additional arguments for parameterized checks should be given as additional arguments on the command line. Please note, that checks specified with <code>--check</code> have precedence before checks defined explicitely on the command line.</p>

<p>Example:</p>

<pre><code>   --config /etc/jmx4perl/tomcat.cfg --check tc_servlet_requests jolokia-agent</code></pre>

</dd>
<dt id="-version"><a id="version1"></a>--version</dt>
<dd>

<p>Prints out the version of this plugin</p>

</dd>
<dt id="-verbose-(-v)"><a id="verbose---v"></a>--verbose (-v)</dt>
<dd>

<p>Enables verbose output during the check, which is useful for debugging. Don&#39;t use it in production, it will confuse Nagios.</p>

</dd>
<dt id="-doc,-help-(-h),-usage-(-?)"><a id="doc--help---h--usage"></a>--doc, --help (-h), --usage (-?)</dt>
<dd>

<p><code>--usage</code> give a short synopsis, <code>--help</code> prints out a bit longe usage information.</p>

<p><code>--doc</code> prints out this man page. If an argument is given, it will only print out the relevant sections. The following sections are recognized:</p>

<dl>

<dt id="tutorial">tutorial</dt>
<dd>

<p>A 5 minute quickstart</p>

</dd>
<dt id="reference">reference</dt>
<dd>

<p>Reference manual explaining the various operational modes.</p>

</dd>
<dt id="options">options</dt>
<dd>

<p>Command line options available for <code>check_jmx4perl</code></p>

</dd>
<dt id="config1">config</dt>
<dd>

<p>Documentation for the configuration syntax</p>

</dd>
</dl>

</dd>
</dl>

##CONFIGURATION

<p>Using <code>check_jmx4perl</code> with a configuration file is the most powerful way for defining Nagios checks. A simple configuration file looks like</p>

<pre><code>   # Define server connection parameters
   &lt;Server tomcat&gt;
      Url = http://localhost:8080/jolokia
   &lt;/Server&gt;

   # A simple heap memory check with a critical threshold of 
   # 90% of the maximal heap memory. 
   &lt;Check memory_heap&gt;     
     Value = java.lang:type=Memory/HeapMemoryUsage/used
     Base = java.lang:type=Memory/HeapMemoryUsage/max
     Unit = B
     Label = Heap-Memory: %.2r% used (%.2v %u / %.2b %u)
     Name = Heap
     Critical = 90
   &lt;/Check&gt;</code></pre>

<p>A configuration file is provided on the command line with the option <code>--config</code>. It can be divided into two parts: A section defining server connection parameters and a section defining the checks themselves.</p>

<h2 id="&lt;Server&gt;"><a id="Server"></a>&lt;Server&gt;</h2>

<p>With <code>&lt;Server <i>name</i>&gt;</code> the connection parameters for a specific server is defined. In order to select a server the <code>--server <i>name</i></code> command line option has to be used. Within a <code>&lt;Server&gt;</code> configuration element, the following keys can be used:</p>

<dl>

<dt id="Url">Url</dt>
<dd>

<p>The URL under which the jolokia agent can be reached.</p>

</dd>
<dt id="User,-Password"><a id="User"></a><a id="User--Password"></a>User, Password</dt>
<dd>

<p>If authentication is switched on, the user and the credentials can be provided with the <b>User</b> and <b>Password</b> directive, respectively. Currently only Basic Authentication is supported.</p>

</dd>
<dt id="Product">Product</dt>
<dd>

<p>The type of application server to monitor. This configuration can speed up checks significantly, but only when aliases are used. By default when using aliases, <code>check_jmx4perl</code> uses autodetection for determine the target&#39;s platform. This results in at least one additional HTTP-Request. This configuration does not has any effect when MBeans are always used with their full name.</p>

</dd>
<dt id="Proxy1">Proxy</dt>
<dd>

<p>A HTTP Proxy URL and credentials can be given with the <code>&lt;Proxy&gt;</code> sub-section. Example:</p>

<pre><code>  &lt;Server&gt;
  ....
    &lt;Proxy&gt;
      Url = http://proxy.company.com:8001
      User = woody
      Password = buzz
    &lt;/Proxy&gt;
  &lt;/Server&gt;</code></pre>

<dl>

<dt id="Url1">Url</dt>
<dd>

<p>The proxy URL</p>

</dd>
<dt id="User,-Password1"><a id="User1"></a><a id="User--Password1"></a>User, Password</dt>
<dd>

<p>Optional user and credentials for accessing the proxy</p>

</dd>
</dl>

</dd>
<dt id="Target">Target</dt>
<dd>

<p>With this directive, the JMX-Proxy mode can be switched on. As described in section <a href="#Proxy-mode">&quot;Proxy mode&quot;</a>, <code>check_jmx4perl</code> can operate in an agentless mode, where the agent servlet is deployed only on an intermediated, so called JMX-Proxy server, whereas the target platform only needs to export JMX information in the traditional way (e.g. via JSR-160 export). This mode is especially useful if the agent is not allowed to be installed on the target platform. However, this approach has some drawbacks and some functionality is missing there, so the agent-mode is the recommended way. A sample JMX-Proxy configuration looks like:</p>

<pre><code>  &lt;Target&gt;
     Url = service:jmx:rmi:///jndi/rmi://tessin:6666/jmxrmi
     User = max
     Password = frisch 
  &lt;/Target&gt;</code></pre>

<p>For a discussion about the advantages and disadvantages of the JMX-Proxy mode, please have a look at <a href="http://labs.consol.de/">http://labs.consol.de/</a> which contains some evaluations of this mode for various application servers (e.g. JBoss and Weblogic).</p>

<dl>

<dt id="Url2">Url</dt>
<dd>

<p>The JMX-RMI Url to access the target platform.</p>

</dd>
<dt id="User,-Password2"><a id="User2"></a><a id="User--Password2"></a>User, Password</dt>
<dd>

<p>User and password for authentication against the target server.</p>

</dd>
</dl>

</dd>
</dl>

<h2 id="Single-Check"><a id="Single"></a>Single Check</h2>

<p>With <code>&lt;Check&gt;</code> a single check can be defined. It takes any option available also available via the command line. Each check has a name, which can be referenced from the commandline with the option <code>--check <i>name</i></code>.</p>

<p>Example:</p>

<pre><code>  &lt;Check memory_heap&gt;
    Value = java.lang:type=Memory/HeapMemoryUsage/used
    Base = java.lang:type=Memory/HeapMemoryUsage/max
    Label = Heap-Memory:
    Name = Heap
    Critical = 90
  &lt;/Check&gt;</code></pre>

<p>The <code>&lt;Check&gt;</code> section knows about the following directives:</p>

<dl>

<dt id="Mbean">Mbean</dt>
<dd>

<p>The <code>ObjectName</code> of the MBean to monitor.</p>

</dd>
<dt id="Attribute">Attribute</dt>
<dd>

<p>Attribute to monitor.</p>

</dd>
<dt id="Operation">Operation</dt>
<dd>

<p>Operation, whose return value should be monitored. Either <code>Attribute</code> or <code>Operation</code> should be given, but not both. If the operation takes arguments, these need to be given as additional arguments to the <code>check_jmx4perl</code> command line call. In the rare case, you need to call an overloaded operation (i.e. an operation whose name exists multiple times on the same MBean but with different parameter types), the argument types can be given within parentheses:</p>

<pre><code>  &lt;Check&gt;
     ....
     Operation = checkUserCount(java.lang.String,java.lang.String)
     ...
  &lt;/Check&gt;</code></pre>

</dd>
<dt id="Argument">Argument</dt>
<dd>

<p>Used for specifying arguments to operation. This directive can be given multiple times for multiple arguments. The order of the directive determine the order of the arguments.</p>

<pre><code>  &lt;Check&gt;
     ....
     Operation checkUserCount(java.lang.String,java.lang.String)
     Argument  Max
     Argument  Morlock    
  &lt;/Check&gt;
   </code></pre>

</dd>
<dt id="Alias">Alias</dt>
<dd>

<p>Alias, which must be known to <code>check_jmx4perl</code>. Use <code>jmx4perl aliases</code> to get a list of all known aliases. If <code>Alias</code> is given as configuration directive, <code>Operation</code> and/or <code>Attribute</code> is ignored. Please note, that using <code>Alias</code> without <code>Product</code> in the server section leads to at least one additional HTTP request.</p>

</dd>
<dt id="Path">Path</dt>
<dd>

<p>Path to apply to the attribute or operation return value. See <a href="#Paths">&quot;Paths&quot;</a> for more information about paths.</p>

</dd>
<dt id="Value">Value</dt>
<dd>

<p>Value is a shortcut for specifying <code>MBean</code>, <code>Attribute</code> and <code>Path</code> at once. Simply concatenate all three parts via <code>/</code> (the <code>Path</code> part is optional). Slashes within MBean names needs to be escaped with a <code>\</code> (backslash). Example:</p>

<pre><code>  Value = java.lang:type=Memory/HeapMemoryUsage/used</code></pre>

<p>is equivalent to</p>

<pre><code>  MBean = java.lang:type=Memory
  Attribute = HeapMemoryUsage
  Path = used</code></pre>

</dd>
<dt id="Base">Base</dt>
<dd>

<p>Switches on relative checks. See <a href="#Relative-Checks">&quot;Relative Checks&quot;</a> for more information about relative checks. The value specified with this directive defines the base value against which the relative value should be calculated. The format is the same as for <code>Value</code>:</p>

<pre><code>  Base = java.lang:type=Memory/HeapMemoryUsage/max</code></pre>

<p>For relative checks, the <code>Critical</code> and <code>Warning</code> Threshold are interpreted as a value between 0% and 100%.</p>

</dd>
<dt id="BaseMBean,-BaseAttribute-and-BasePath"><a id="BaseMBean"></a><a id="BaseMBean--BaseAttribute-and-BasePath"></a>BaseMBean, BaseAttribute and BasePath</dt>
<dd>

<p>As an alternative to specifying a base value in a combined fashion the different parts can be given separately. <code>BaseMBean</code> and <code>BaseAttribute</code> switches on relative checks and specifies the base value. An optional <code>BasePath</code> can be used to provide the path within this base value.</p>

<p>The example above can be also written as</p>

<pre><code>  BaseMBean = java.lang:type=Memory
  BaseAttribute = HeapMemoryUsage
  BasePath = max</code></pre>

</dd>
<dt id="Delta">Delta</dt>
<dd>

<p>Switches on incremental mode as described in section <a href="#Incremental-Checks">&quot;Incremental Checks&quot;</a>. The value given is used for normalization the increase rate. E.g.</p>

<pre><code>  Delta = 60 </code></pre>

<p>measures the growth rate per minute (60 seconds). If no value is given, the absolute increase between two checks is used.</p>

</dd>
<dt id="Numeric">Numeric</dt>
<dd>

<p>This directive switches on numeric mode, i.e. the given threshold values are compared numerically against the returned JMX value. By default, the check mode is determined by a heuristic algorithm.</p>

</dd>
<dt id="String1">String</dt>
<dd>

<p>String checks, which are switched on with this directive, are useful for non-numeric thresholds. See <a href="#String-checks">&quot;String checks&quot;</a> for more details.</p>

</dd>
<dt id="Name">Name</dt>
<dd>

<p>The name to be used in the performance data. By default, a name is calculated based on the MBean and attribute/operation name.</p>

</dd>
<dt id="MultiCheckPrefix">MultiCheckPrefix</dt>
<dd>

<p>If this check is used within a multi check, this prefix is used to identify this particular check in the output of a multicheck. It can be set to an empty string if no prefix is required. By default the name as configured with <code>Name</code> is used.</p>

</dd>
<dt id="Label">Label</dt>
<dd>

<p>Format for setting the plugin output (not the performance data, use <code>Name</code> for this). It takes a printf like format string which is described in detail in <a href="#Output-Tuning">&quot;Output Tuning&quot;</a>.</p>

</dd>
<dt id="PerfData">PerfData</dt>
<dd>

<p>By default, performance data is appended for numeric checks. This can be tuned by setting this directive to &quot;false&quot; (or &quot;0&quot;, &quot;no&quot;, &quot;off&quot;) in which case performance data is omitted. If using this in a base check, an inherited check can switch performance data generation back on with &quot;true&quot; (or &quot;1&quot;, &quot;yes&quot;, &quot;on&quot;)</p>

<p>For relative checks, the value can be set to &#39;%&#39;. In this case, performance data is added as relative values instead of the absolute value measured.</p>

</dd>
<dt id="Unit">Unit</dt>
<dd>

<p>This specifies how the return value should be interpreted. This value, if given, must conform to the unit returned by the JMX attribute/operation. E.g. for <code>java.lang:type=Memory/HeapMemoryUsage/used</code> unit, if set, must be <code>B</code> since this JMX call returns the used memory measured in bytes. The value given here is only used for shortening the plugin&#39;s output automatically. For more details and for what units are available refer to section <a href="#Output-Tuning">&quot;Output Tuning&quot;</a>.</p>

</dd>
<dt id="Critical">Critical</dt>
<dd>

<p>Specifies the critical threshold. If <code>String</code> is set (or the heuristics determines a string check), this should be a string value as described in <a href="#String-checks">&quot;String checks&quot;</a>. For relative checks, this should be a relative value in ther range [0,100]. Otherwise, it is a simple numeric value which is used as threshold. For numeric checks, the threshhold can be given in the format defined at <a href="http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT">http://nagiosplug.sourceforge.net/developer-guidelines.html#THRESHOLDFORMAT</a>.</p>

</dd>
<dt id="Warning">Warning</dt>
<dd>

<p>Defines the warning threshold the same way as described for the <code>Critical</code> threshold.</p>

</dd>
<dt id="Null">Null</dt>
<dd>

<p>Replacement value when an attribute is null or an operation returns a null value. This value then can be used in string checks in order to check against null values. By default, this value is &quot;<code>null</code>&quot;.</p>

</dd>
<dt id="Method">Method</dt>
<dd>

<p>HTTP Method to use for the check. Available values are <code>GET</code> or <code>POST</code> for GET or POST HTTP-Requests, respectively. By default a method is determined automatically. The value can be given case insensitively.</p>

</dd>
<dt id="Use">Use</dt>
<dd>

<p>In order to use parent checks, this directive specifies the parent along with any parameters passed through. For example,</p>

<pre><code>  Use = memory_relative_base(80,90),base_label</code></pre>

<p>uses a parent check named <code>memory_relative_base</code>, which must be a check defined in the same configuration file (or an imported on). Additionally, the parameters <code>80</code> and <code>90</code> are passed to this check (which can be accessed there via the argument placeholders <code>$0</code> and <code>$1</code>). See <a href="#Parent-checks">&quot;Parent checks&quot;</a> and <a href="#Parameterized-checks">&quot;Parameterized checks&quot;</a> for more information about check inheritance.</p>

<p>Multiple parents can be given by providing them in a comma separated list.</p>

</dd>
<dt id="Script">Script</dt>
<dd>

<p>For complex checks which can not be realized with the configurations described until yet, it is possible to use a Perl script snippet to perfrom arbitrary logic. The content of this script is typically provided as an HERE-document (see example below). It comes with a predefined variable <code>$j4p</code> which is an instance of <a href="/pod/JMX::Jmx4Perl">JMX::Jmx4Perl</a> so that it can be used for a flexible access to the server. Note that this scriptlet is executed separately and doesn&#39;t not benefit from the optimization done for bulk or relative checks. Check parameters can be accessed as ${0}, ${1}, .. but since these are also valid Perl variables (and hence can be overwritten accidentially), it is recommended to assign them to local variable before using them. In summary, script based checks are powerful but might be expensive.</p>

<p>Example:</p>

<pre><code>  Script &lt;&lt;EOT
  
  my $pools = $j4p-&gt;search(&quot;java.lang:type=MemoryPool,*&quot;);
  my @matched_pools;
  my $pattern = &quot;${0}&quot;;
  for my $pool (@$pools) {   
     push @matched_pools,$pool if $pool =~ /$pattern/;   
  }
  return $j4p-&gt;get_attribute($matched_pools[0],&quot;Usage&quot;,&quot;used&quot;);
  
  EOT</code></pre>

</dd>
</dl>

<h2 id="Includes">Includes</h2>

<p>Checks can be organized in multiple configuration files. To include another configuration file, the <code>include</code> directive can be used:</p>

<pre><code>  include tomcat.cfg
  include threads.cfg
  include memory.cfg</code></pre>

<p>If given as relative path, the configuration files are looked up in the same directory as the current configuration file. Absolute paths can be given, too.</p>

<h2 id="Parent-checks"><a id="Parent"></a>Parent checks</h2>

<p>With <code>check_jmx4perl</code> parent checks it is possible to define common base checks, which are usable in various sub-checks. Any <code>&lt;Check&gt;</code> can be a parent check as soon as it is referenced via a <code>Use</code> directive from within another check&#39;s definition. When a check with a parent check is used, its configuration is merged with this from the parent check with own directives having a higher priority. Parent checks can have parent checks as well (and so on).</p>

<p>For example, consider the following configuration:</p>

<pre><code>  &lt;Check grand_parent&gt;
     Name grand_parent
     Label GrandPa
     Critical 10
  &lt;/Check&gt;

  &lt;Check parent_1&gt;
     Use grand_parent
     Name parent_1
     Critical 20
  &lt;/Check&gt;

  &lt;Check parent_2&gt;
     Name parent_2
     Warning 20
  &lt;/Check&gt; 

  &lt;Check check&gt;
     Use parent_1,parent_2
     Warning 40
  &lt;/Check&gt;</code></pre>

<p>In this scenario, when check <code>check</code> is used, it has a <code>Name</code> &quot;<code>parent_2</code>&quot; (last parent check in <code>Use</code>), a <code>Label</code> &quot;GrandPa&quot; (inherited from <code>grand_parent</code> via <code>parent_1</code>), a <code>Critical</code> 20 (inherited from <code>parent_1</code>) and a <code>Warning</code> 40 (directly give in the check definition).</p>

<p>A parent value of a configuration directive can be refered to with the placeholder <code>$BASE</code>. For example:</p>

<pre><code>  &lt;Check parent&gt;
    Name Parent
  &lt;/Check&gt;

  &lt;Check check&gt;
    Use parent
    Name Child: $BASE
  &lt;/Check&gt;</code></pre>

<p>This will lead to a <code>Name</code> &quot;<code>Child: Parent</code>&quot; since <code>$BASE</code> is resolved to the parent checks valus of <code>Name</code>, <code>&quot;Parent&quot;</code> in this case. The base value is searched upwards in the inheritance hierarchy (parent, grand parent, ...) until a value is found. If nonen is found, an empty string is used for <code>$BASE</code>.</p>

<h2 id="Parameterized-checks"><a id="Parameterized"></a>Parameterized checks</h2>

<p>Checks can be parameterized, i.e. they can take arguments which are replaced in the configuration during runtime. Arguments are used in check definition via the positional format <code>$0</code>, <code>$1</code>, .... (e.g. <code>$0</code> is the first argument given). Arguments can either be given on the command line as extra arguments to <code>check_jmx4perl</code> or within the <code>Use</code> directive to provide arguments to parent checks.</p>

<p>Example:</p>

<pre><code>  &lt;Check parent&gt;
    Name $0
    Label $1
  &lt;/Check&gt;

  &lt;Check child_check&gt;
    Use parent($0,&quot;Check-Label&quot;)   
    ....
  &lt;/Check&gt;

  $ check_jmx4perl --check child_check .... &quot;Argument-Name&quot;
  OK - Check-Label | &#39;Argument-Name&#39;= ....</code></pre>

<p>As it can be seen in this example, arguments can be propagated to a parent check. In this case, <code>$0</code> from the command line (<code>Argument-Name</code>) is passed through to the parent check which uses it in the <code>Name</code> directive. <code>$1</code> from the parent check is replaced with the value &quot;<code>Check-Label</code>&quot; given in the <code>Use</code> directive of the child check.</p>

<p>Parameters can have default values. These default values are taken in case an argument is missing (either when declaring the parent check or missing from the command line). Default values are specified with <code>${</code><i>arg-nr</i><code>:</code><i>default</i><code>}</code>. For example,</p>

<pre><code> &lt;Check relative_base&gt;
   Label = %.2r% used (%.2v %u / %.2b %w)
   Critical = ${0:90}
   Warning = ${1:80}
 &lt;/Check&gt;</code></pre>

<p>defines a default value of 90% for the critical threshold and 80% for the warning threshold. If a child check uses this parent definition and only wants to ommit the first parameter (but explicitely specifying the second parameter) it can do so by leaving the first parameter empty:</p>

<pre><code>  &lt;Check child&gt;
     Use relative_base(,70)
  &lt;/Check&gt;</code></pre>

<h2 id="Multichecks">Multichecks</h2>

<p>Multiple checks can be combined to a single <i>MultiCheck</i>. The advantage of a multi check is, that multiple values can be retrieved from the server side with a single HTTP request. The output is conformant to Nagios 3 multiline format. It will lead to a <code>CRITICAL</code> value as soon as one check is critical, same for <code>WARNING</code>. If both, <code>CRITICAL</code> and <code>WARNING</code> is triggered by two or more checks, then <code>CRITICAL</code> take precedence.</p>

<p>If a single check within a multi check fails with an exception (e.g. because an MBean is missing), its state becomes <code>UNKNOWN</code>. <code>UNKNOWN</code> is the highest state in so far that it shadows even <code>CRITICAL</code> (i.e. if a single check is <code>UNKNOWN</code> the whole multi check is <code>UNKNOWN</code>, too). This can be changed by providing the command line option <code>--unknown-is-critical</code> in which case all <code>UNKNOWN</code> errors are mapped to <code>CRITICAL</code>.</p>

<p>A multi-check can be defined with the directive <code>&lt;MultiCheck&gt;</code>, which contain various references to other <code>&lt;Check&gt;</code> definitions or other multi check definitions.</p>

<p>Example:</p>

<pre><code>  &lt;MultiCheck all&gt;
    MultiCheck memory
    MultiCheck threads
  &lt;/MultiCheck&gt;

  &lt;MultiCheck memory&gt;
    Check memory_heap($0,80)
    Check memory_pool_base(&quot;CMS Perm Gen&quot;,90,80)
  &lt;/MultiCheck&gt;

  &lt;MultiCheck threads&gt;
    Check thread_inc
    Check thread_deadlock
  &lt;/MultiCheck&gt;</code></pre>

<p>Here a multi check group <i>memory</i> has been defined with reference to two checks, which must exist somewhere else in the configuration file. As it can be seen, parameters can be given through to the check in the usual way (literally or with references to command line arguments). The group <i>all</i> combines the two groups <i>memory</i> and <i>thread</i>, containing effectively four checks.</p>

<p>A multi-check is referenced from the command line like any other check:</p>

<pre><code>  $ check_jmx4perl .... --check all 90</code></pre>

<p>(90 is the argument which replaces <code>$0</code> in the definition above).</p>

<p>The summary label in a multi check can be configured, too.</p>

<p>Example:</p>

<pre><code>  &lt;MultiCheck memory&gt;
    SummaryOk All %n checks are OK
    SummaryFailure %e of %n checks failed [%d]
    ...
  &lt;/MultiCheck&gt;</code></pre>

<p>These format specifiers can be used:</p>

<pre><code>  %n        Number of all checks executed 
  %e        Number of failed checks
  %d        Details which checks failed</code></pre>

<h2 id="Predefined-checks"><a id="Predefined"></a>Predefined checks</h2>

<p><code>check_jmx4perl</code> comes with a collection of predefined configuration for various application servers. The configurations can be found in the directory <i>config</i> within the toplevel distribution directory. The configurations are fairly well documented inline.</p>

<h3 id="common.cfg"><a id="common"></a>common.cfg</h3>

<p>Common check definitions, which can be used as parents for own checks. E.g. a check <code>relative_base</code> can be used as parent for getting a nicely formatted output message.</p>

<h3 id="memory.cfg"><a id="memory"></a>memory.cfg</h3>

<p>Memory checks for heap and non-heap memoy as well as for various memory pools. Particularly interesting here is the so called <i>Perm Gen</i> pool as it holds the java type information which can overflow e.g after multiple redeployments when the old classloader of the webapp can&#39;t be cleared up by the garbage collector (someone might still hold a reference to it).</p>

<h3 id="threads.cfg"><a id="threads"></a>threads.cfg</h3>

<p>Checks for threads, i.e. checking for the tread count increase rate. A check for finding out deadlocks (on a JDK 6 VM) is provided, too.</p>

<h3 id="jetty.cfg"><a id="jetty"></a>jetty.cfg</h3>

<p>Various checks for jetty like checking for running servlets, thread count within the app server, sessions (number and lifing time) or requests per minute.</p>

<h3 id="tomcat.cfg"><a id="tomcat"></a>tomcat.cfg</h3>

<p>Mostly the same checks as for jetty, but for tomcat as application server.</p>

<h3 id="websphere.cfg"><a id="websphere"></a>websphere.cfg</h3>

<p>WebSphere specific checks, which uses the configuration files below the `websphere/` directory. For this checks to work, a customized Jolokia agent with JSR-77 extensions is required. The GitHub project for this enhanced agents can be found at <a href="https://github.com/rhuss/jolokia-extra">https://github.com/rhuss/jolokia-extra</a> and downloaded at Maven Central (<a href="http://central.maven.org/maven2/org/jolokia/extra/jolokia-extra-war/">http://central.maven.org/maven2/org/jolokia/extra/jolokia-extra-war/</a>)</p>

##LICENSE

<p>This file is part of jmx4perl.</p>

<p>Jmx4perl is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 2 of the License, or (at your option) any later version.</p>

<p>jmx4perl is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.</p>

<p>You should have received a copy of the GNU General Public License along with jmx4perl. If not, see &lt;http://www.gnu.org/licenses/&gt;.</p>

##AUTHOR

<p>roland@cpan.org</p>
