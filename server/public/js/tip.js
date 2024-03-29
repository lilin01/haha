/*
* 弹出页绑定
* @param (Option) options 配置选项
*/
;(function($){
	jQuery.fn.extend({
		tip:function(options)
		{
			/*
			* 默认的配置文件
			* @param (String ) title弹出窗口标题
			* @param (String) content 弹出窗口内容
			* @param (String) link 链接地址
			* @param (String)  trigger 触发方式
			* @param (String) show 显示方式
			* @param (String/Number) speed 动画速度
			* @param (Array/String) position 显示位置
			* @param (Number) width 宽度
			* @param (Number) height 高度
			* @param (Boolean) draggable 是否可拖动
			* @param (Function) run 显示结束后的回执函数
			* @param (Array) buttons 弹窗按钮设置
			* @param (String) tpl 弹窗模板
			*/
			var defaultOptions = 
			{
				title : null,
				content: null,
				link : null,
				trigger : 'click',
				show : 'show',
				speed : "normal",
				position : ['center','middle'],
				width : 300,
				height : 400,
				run : null,
				buttons : [{
								value : '关闭',
								//onclick为点击按钮执行的事件
								onclick : function()
											{
													$('#tip_position').remove()
											}
							 }],
				draggable : false,
				tpl: '<div id="tip_position" style="position:absolute;display:none;"><table><tr><td class="topleft"></td><td class="xborder"></td><td class="topright"></td></tr><tr><td class="yborder"></td><td><h3 class="tip_title">{title}</h3><div class="tip_content">{content}</div><div class="tip_btn"></div></td><td class="yborder"></td></tr><tr><td class="bottomleft"></td><td class="xborder"></td><td class="bottomright"></td></tr></table><div>'
			};
			/*
			* 解析地址的算法
			* @param (String) str 解析前的字符串
			* @return (String) _url 真实链接地址
			*/
			var serilize = function(str)
			{
                var _re = /#([.\w]*)(\/([\w\/]*))?/;
                var _ar = _re.exec(str);
                var _url = '';
                _ar[1] && (_url += (_ar[1].replace(/\./g, '/') + '.php'));
                _ar[3] && (_url += ('?' + _ar[3].replace(/\//g, '&')));
                return _url;
            };
			/*
			* 触发函数
			* 点击按钮引发弹窗。
			*/
			var trigger = function()
			{
				if($('#tip_position').length > 0)
				{
					return false;
				}
				if(options.content)
				{
					var _opt = $.extend({},options);
					show(_opt);
				}
				else
				{
					this.link = (options.link || $(this).attr('href') || $(this).attr('alt') );
					//解析
					var url=serilize(this.link);
					$.getJSON(url,function(json)
						{
							var _opt = $.extend({},options, json);
							show(_opt);
						}
					);
				}
			};
			
			/*
			* 设置按钮
			* @param (jQuery) p 弹窗对象
			* @param (Array)  按钮的配置信息
			*/
			var setButton =  function(p , b)
			{
				var _b = $.map( b , function(h)
									{
											return $('<button></button>').text(h.value).bind("click",h.onclick);
									}
							   );
				var _d = p.find('.tip_btn');
				$.each(_b, function()
						   {
								_d.append(this)
                		   }
				);
			};
			/*
			* 解析弹窗的位置
			* @param (jQuery) p 弹窗对象
			* @param (Array/String) pos 定位配置参数
			* @return (Option) 解析后的定位参数 
			*/
			var position = function(p,pos)
			{
				var wnd = $(window), doc = $(document),
				pTop = doc.scrollTop(), pLeft = doc.scrollLeft();
				if( $.inArray(pos, ['center','top','right','bottom','left']) >= 0 ) 
				{
					pos = [
						pos == 'right' || pos == 'left' ? pos : 'center',
						pos == 'top' || pos == 'bottom' ? pos : 'middle'
					];
				}
				if( pos.constructor != Array )
				{
					pos = ['center', 'middle'];
				}
				if( pos[0].constructor == Number )
				{
					pLeft += pos[0];
				}else{
					switch( pos[0] )
					{
						case 'left':
							pLeft += 0;
							break;
						case 'right':
							pLeft += ( doc.width() - p.width() );
							break;
						default:
						case 'center':
							pLeft += ( doc.width() - p.width() )/2;
					}
				}
				if( pos[1].constructor  == Number )
				{
					pTop += 0;
				} else {
					switch(pos[1])
					{
						case 'top':
							pTop += 0;
							break;
						case 'bottom':
							pTop += ( wnd.height() -p.height() );
							break;
						default:
						case 'middle':
							pTop += ( wnd.height() - p.height() )/2;
					}
				}
				return {left:pLeft,top:pTop};
			}
			/*
			* 显示弹窗
			* @param (Option) opt 配置对象
			*/
			var show = function(opt)
			{
				//生成页面
				var page=$(opt.tpl.replace( /\{title\}/, opt.title )
											.replace( /\{content\}/, opt.content )
								  );
				//加入按钮
				setButton( page , opt.buttons );
				//设定高宽,插入页面，
				page.css( { width : opt.width , height:opt.height } )
					   .appendTo('body')
				//定位并设置动画
					   .css( position( page , opt.position ) )[ opt.show ]( opt.speed , opt.run );
				//设置拖动
				opt.draggable && page.draggable( { handle : '.tip_title' } );
			}
			
			//
			options || (options ={});
			//根据参数修改配置
			options = $.extend( {} , defaultOptions , options );
			this.each(function(){
				//绑定到元素
				this.onclick=null;
				$(this).bind( options.trigger , trigger );
			});
			return this;
		}
	});
})(jQuery);