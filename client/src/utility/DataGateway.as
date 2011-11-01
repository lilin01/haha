package utility
{
	
	import com.app.config.UrlConfig;
	import com.framework.utils.Singleton;
	import com.framework.utils.loader.HttpLoader;
	import com.framework.utils.managers.AlertManager;
	
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;	
	
	public class DataGateway
	{
		public function DataGateway()
		{
					
		}
		
		public static function get instance():DataGateway
		{
			return Singleton.getInstance(DataGateway) as DataGateway;
		}	
		
		public function getData(CallBack:Function){
			//HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.MYSHOPLISTPATH,_CallBackValidator , null,null,URLRequestMethod.POST);	
		}
		
		public function getRelicList(CallBack:Function){
			HttpLoader.getInstance().httpJson(UrlConfig.HTTPROOT + UrlConfig.GETRELICLIST,
				CallBack
				, null,null,URLRequestMethod.POST)
		}
		
		
		//用于校验返回的数据并对异常进行统一的处理
		private function _CallBackValidator(CallBack:Function){
			
			
			
		}
	}
}