<?php /* Smarty version 2.6.10, created on 2010-10-30 15:36:56
         compiled from admin/login/index.tpl */ ?>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>
     	<div id="content">
		<div class="wrapper">
                    <div class="body_bg">
                        <div class="content">
                          
<h1>Login</h1>

<form action="?do=Login" method="post">
  <table class="signin_table">
    
                <div class="form_row">
                    <div class="form_row_title"><label for="signin_username">Email</label></div>
                    <div class="form_row_help"></div>

                    <div style="clear: both;"></div>
                    <div class="form_row_fields">
                        <input type="text" name="signin[username]" id="signin_username" />
                    </div>
                    <div class="form_row_errors">
                        
                    </div>
                    <div class="spacer">&nbsp;</div>
                </div>
                <div class="form_row">

                    <div class="form_row_title"><label for="signin_password">Password</label></div>
                    <div class="form_row_help"></div>
                    <div style="clear: both;"></div>
                    <div class="form_row_fields">
                        <input type="password" name="signin[password]" id="signin_password" />
                    </div>
                    <div class="form_row_errors">
                        
                    </div>

                    <div class="spacer">&nbsp;</div>
                </div>
                <div class="form_row">
                    <div class="form_row_title"><label for="signin_remember">Remember</label></div>
                    <div class="form_row_help"></div>
                    <div style="clear: both;"></div>
                    <div class="form_row_fields">
                        <input type="checkbox" name="signin[remember]" id="signin_remember" /><input type="hidden" name="signin[_csrf_token]" value="74b28b195132df805abcfe25716543b7" id="signin__csrf_token" />

                    </div>
                    <div class="form_row_errors">
                        
                    </div>
                    <div class="spacer">&nbsp;</div>
                </div>  </table>

  <input type="submit" class="login_submit" value="sign in" />
  <a href="/admin/request_password">Forgot your password?</a>

</form>
                        </div>
                        <div class="clr"></div>
                    </div>
                </div>
                <div class="clr"></div>
            </div>


<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "footer.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>