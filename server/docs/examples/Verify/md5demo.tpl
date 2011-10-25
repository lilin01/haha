<html>
<head>
<title>Form</title>
 
<script type="text/javascript" src="../../../public/js/md5.js"></script>
<script type="text/javascript">
function preprocess(form)
{
  var str = "";
  str += form.verifycode.value;
  form.p.value = md5( form.p.value  +str);
  return true;
}
</script>

</head>
<H1>MD5 </H1><br>
<form id="user_login" name="user_login" 
 autocomplete="off" onSubmit="javascript: return preprocess(user_login)"  method="post" > 
username<input id="u" name="u" tabindex="u" type="text"   />*<br>
    password<input id="p" name="p"   type="password" />*<br>
    verifycode<input id="verifycode" name="verifycode" type="text" size="4" maxlength="4"/>
    <img src="?do=code" border=0><br>
<input type="submit" value="Submit"  /> 
</form>

<pre>
{<$result>}
</pre>
<body>
</body>
</html>