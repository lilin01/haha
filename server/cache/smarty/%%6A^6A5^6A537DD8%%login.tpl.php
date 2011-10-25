<?php /* Smarty version 2.6.10, created on 2010-10-26 16:30:19
         compiled from login.tpl */ ?>
<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "header.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>

 <div id="content">
		<div class="wrapper">
                    
                    <div class="body_bg">
                        
						
                        <div class="content">
                            
<form method="post" action="/admin/login">
  <div class="field">
                <label><span class="title"><label for="signin_username">Email</label></span><span class="hint"></span></label>
                <input type="text" id="signin_username" name="signin[username]">
                <div class="spacer">&nbsp;</div>
                
        </div>
        <div class="field">
                <label><span class="title"><label for="signin_password">Password</label></span><span class="hint"></span></label>
                <input type="password" id="signin_password" name="signin[password]">
                <div class="spacer">&nbsp;</div>
                
        </div>
        <div class="field">
                <label><span class="title"><label for="signin_remember">Remember</label></span><span class="hint"></span></label>
                <input type="checkbox" id="signin_remember" name="signin[remember]"></div><div class="spacer">&nbsp;</div>
                
        
          <table class="signin_table">
    <input type="hidden" id="signin__csrf_token" value="7d2c944041f4d2afba920630f10fbe4b" name="signin[_csrf_token]">
                </table>

  <input type="submit" value="sign in">
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