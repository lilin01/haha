<?php
$mem = new Memcache;
$mem->connect("127.0.0.1", 11211);
echo $mem->add("key1","This is a !");
$val = $mem->get("key");
echo $val;



//echo phpinfo();

?>