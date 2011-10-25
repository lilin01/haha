<?php
/**
 * Rsa主类，包含加密和解密的方法
 * @package modules
 * @subpackage Rsa
 * @author 陈敬钻 <chenjingzuan@corp.the9.com>
 *
 * $Id$
 */

class Rsa
{
	/**
	 * 对密文进行解密
	 *
	 * @param string $enc_text 密文, base64格式
	 * 
	 * @return string 明文
	 */
	static function decrypt($enc_text)
	{
		global $cfg;
		$prikey = $cfg['rsa']['prikey'];

		$prikey = openssl_get_privatekey($prikey,$passphrase);

		$res = openssl_private_decrypt(base64_decode($enc_text), $source, $prikey, OPENSSL_PKCS1_PADDING);

		return ($res) ? $source : false;
	}
	
	/**
	 * 对明文进行加密
	 *
	 * @param string $text 明文
	 * 
	 * @return string 密文，并且进行base64转换
	 */
	static function encrypt($source)
	{
		global $cfg;
		$prikey = $cfg['rsa']['pubkey'];

		openssl_get_publickey($pubkey);

		$res = openssl_public_encrypt($source, $crypttext, $pubkey, OPENSSL_PKCS1_PADDING);

		return ($res) ? base64_encode($crypttext) : false;
	}
	
	/**
	 * 产生钥匙对
	 *
	 * @param string $length 钥匙的长度
	 * 
	 * @return boolean
	 */
	function generateKeyPair($pubkey_path = '', $prikey_path = '', $length=1024)
	{
		global $cfg;

		if (!$pubkey_path)
		{
			$pubkey_path = $cfg['path']['conf'] . 'pubkey';
		}

		if (!$prikey_path)
		{
			$prikey_path = $cfg['path']['conf'] . 'prikey';
		}

		/* 产生私钥 */
		$cmd = "openssl genrsa -out $prikey_path $length";
		$res = shell_exec($cmd);
		if (strpos($res, 'error') !== false)
		{
			return false;
		}
		/* 产生公钥 */
		$cmd = "openssl rsa -pubout -in $prikey_path -out $pubkey_path";
		$res = shell_exec($cmd);
		if (strpos($res, 'error') !== false)
		{
			return false;
		}

		return true;
	}
}

?>