//为上传图片前隐藏所有图片（减少动态生成代码）
$("img[alt='src_pic'], #float_div, #drag_logo").css("display", "none");
//初始化选框移动的范围
var left_min = 0; 
var left_max = 0;
var top_min  = 0;
var top_max = 0;
//初始化位置
var move = false; //判断是否处于移动状态
var resize = false; //判断是否处于拉伸状态
//放大图移动的记录点
var pre_scorllTop = 0;
var pre_scorllLeft = 0; 
//展现区放大的基数
var big_base ;

/**
* path      string  图片路径
* s_width   int     选框的初始宽度
* s_height  int     选框的初始高度
* b_width   int     背景图片的宽度
* b_height  int     背景图片的高度
* b_top     int     背景图片的top值
* b_left    int     背景图片的left值
* big_base  int     初始放大的基数
*/

function init(path, s_width, s_height, b_width, b_height, b_top, b_left, big_base)
{
	$("img[alt='src_pic']").attr("src", path).css("display", "block"); //显示图片
	$("#bg_pic").css({width : b_width, height : b_height, "margin-top" : b_top, "margin-left" : b_left}); //初始化背景图位置
	//设置图片移动的范围
	left_min = $("#bg_pic").offset().left; 
	left_max = left_min + $("#bg_pic").width() - $(".select_div").width(); 
	top_min = $("#bg_pic").offset().top;
	top_max = top_min + $("#bg_pic").height() - $(".select_div").height();
	this.big_base = big_base;
	$(".float_div , .select_div").css({top : top_min, left : left_min, "display" : "block"}); //初始化浮层的位置和选框位置
	$(".float_div, #small_bg").css({width : $("#bg_pic").width(), height : $("#bg_pic").height()}); //初始化浮层和选区隐藏背景大小
	$("#larg_bg").css({width : $("#bg_pic").width() * big_base, height : $("#bg_pic").height() * big_base}); //展现区原始图片的大小设定
	$(".select_div").css({ width : s_width, height : s_height});
	$(".show_pic").css({width : $(".select_div").width() * big_base, height : $(".select_div").height() * big_base});
	$("#drag_logo").css({position: "absolute", display : "block", top : top_min + $(".select_div").height() - 16, left : left_min + $(".select_div").width() - 16,  cursor : "nw-resize", "z-index" : 102}); //提示放大图标的定位与显示
	$(".select_div").get(0).scrollLeft = 0;
	$(".select_div").get(0).scrollTop = 0;
	$(".show_pic").get(0).scrollLeft = 0;
	$(".show_pic").get(0).scrollTop = 0;
}

//选区拖动功能
$(".select_div").mousedown(function(event) {
	move = true;
	left_min = $("#bg_pic").offset().left; 
	left_max = left_min + $("#bg_pic").width() - $(".select_div").width(); 
	top_min = $("#bg_pic").offset().top;
	top_max = top_min + $("#bg_pic").height() - $(".select_div").height(); 
	event = event ? event : window.event;
	pre_x = event.clientX; //移动前鼠标的X坐标
	pre_y = event.clientY; //移动前鼠标的Y坐标
	cur_left = div_left = $(this).offset().left;
	cur_top = div_top = $(this).offset().top;
	logo_left = $("#drag_logo").offset().left;
	logo_top = $("#drag_logo").offset().top;
	obj = this;
	$(document).mousemove(function(event) { 
		if ( move == true )
		{
			cur_x = event.clientX; //当前鼠标的X坐标
			cur_y = event.clientY; //当前鼠标的Y坐标
			cur_top = div_top + cur_y - pre_y ; //当前图片的top值
			cur_left = div_left + cur_x - pre_x ; //当面图片的left值
			logo_cur_left = logo_left + cur_x - pre_x;
			logo_cur_top = logo_top + cur_y - pre_y;
			/******图片左右移动时的情况******/
			if ( cur_left >= left_min && cur_left <= left_max )
			{
				$(obj).css( "left", cur_left );
				$("#drag_logo").css("left", logo_cur_left);
				obj.scrollLeft = cur_left - left_min;
				$(".show_pic").get(0).scrollLeft = (cur_x - pre_x) * big_base + pre_scorllLeft;
			}
			else if ( cur_left < left_min )
			{
				$(obj).css( "left", left_min );
				$("#drag_logo").css("left", left_min + $(".select_div").width() - 16);
				obj.scrollLeft = 0;
				$(".show_pic").get(0).scrollLeft = 0;
			}
			else if ( cur_left > left_max )
			{
				$(obj).css( "left", left_max );
				$("#drag_logo").css("left", left_max + $(".select_div").width() - 16);
				obj.scrollLeft = left_max - left_min;
				$(".show_pic").get(0).scrollLeft = (left_max - left_min) * big_base;
			}

			/******图片上下移动时的情况******/
			if ( cur_top >= top_min && cur_top <= top_max )
			{
				$(obj).css( "top", cur_top );
				$("#drag_logo").css("top", logo_cur_top);
				obj.scrollTop = cur_top - top_min ;
				$(".show_pic").get(0).scrollTop = (cur_y - pre_y) * big_base + pre_scorllTop;

			}
			else if ( cur_top < top_min )
			{
				$(obj).css( "top", top_min );
				$("#drag_logo").css("top", top_min + $(".select_div").height() - 16);
				obj.scrollTop = 0;
				$(".show_pic").get(0).scrollTop = 0;
			}
			else if ( cur_top > top_max )
			{
				$(obj).css( "top", top_max );
				$("#drag_logo").css("top", top_max + $(".select_div").height() - 16);
				obj.scrollTop = top_max - top_min;
				$(".show_pic").get(0).scrollTop = (top_max - top_min) * big_base;
			}
		}
		return false;	
	});
	$(document).mouseup(function() {
		pre_scorllTop = $(".show_pic").get(0).scrollTop; //保存DIV移动过的路程
		pre_scorllLeft = $(".show_pic").get(0).scrollLeft;
		move = false;
		return false;
	});
	return false;
});

//选区拉伸功能
$("#drag_logo").mousedown(function(event) {
	resize = true;
	pre_x = event.clientX; //移动前鼠标的X标
	pre_y = event.clientY; 
	pre_width = $(".select_div").width(); //选区框拉伸前的宽度
	pre_height = $(".select_div").height();
	pre_top = $(".select_div").offset().top; //选区框拉伸前的top值
	pre_left = $(".select_div").offset().left;
	logo_top = $(this).offset().top;  //拉伸提示图标的top值
	logo_left = $(this).offset().left; 
	larg_bg_width = $("#larg_bg").width();
	larg_bg_height = $("#larg_bg").height();
	max_drag_width = $("#small_bg").width() - pre_left + left_min - pre_width; //最大拉伸的宽度
	max_drag_height = $("#small_bg").height() - pre_top + top_min - pre_height; //最大拉伸的高度
	if ( max_drag_width < max_drag_height )
	{
		max_is_width = true;
	}
	else
	{	
		max_is_width = false;
	}
	$(document).mousemove(function(event) {
		if ( resize == true )
		{
			cur_x = event.clientX; 
			cur_y = event.clientY;
			min_len = (cur_x - pre_x) > (cur_y - pre_y)?cur_x - pre_x : cur_y -pre_y;
			tmp_width = min_len + pre_width + pre_left - left_min;
			tmp_height = min_len + pre_height + pre_top - top_min;
			if ( min_len > 0 )
			{
				if ( max_is_width )
				{
					if ( tmp_width > $("#small_bg").width() )
					{
						min_len = max_drag_width;
					}
				}
				else
				{
					if ( tmp_height > $("#small_bg").height() )
					{
						min_len = max_drag_height;
					}
				}
			}
			else 
			{
				if( min_len + pre_width <= 0 )
				{
					min_len = (-1) * pre_width;
				}
			}
			$("#test").val(min_len);		
			tmp_x_len = 0;  //放大或缩小的宽度
			tmp_y_len = 0;  //放大或缩小的长度
			if ( min_len < 0 )
			{
					tmp_x_len = (-1) * (($(".show_pic").width()* $("#small_bg").width()) / (pre_width + min_len) - larg_bg_width);
					tmp_y_len = (-1) * (($(".show_pic").height()* $("#small_bg").height()) / (pre_height + min_len) - larg_bg_height);
			}
			else
			{
					tmp_x_len = larg_bg_width - ($(".show_pic").width()* $("#small_bg").width()) / (pre_width + min_len);
					tmp_y_len = larg_bg_height - ($(".show_pic").height()* $("#small_bg").height()) / (pre_height + min_len);
			}
			//放大或缩小时候left值的重新定位
			tmp_bg_left = (larg_bg_width - tmp_x_len) * $(".select_div").get(0).scrollLeft / $("#small_bg").width();
			//放大或缩小时候top值的重新定位
			tmp_bg_top = (larg_bg_height - tmp_y_len) * $(".select_div").get(0).scrollTop / $("#small_bg").height();
			$("#larg_bg").css({width : larg_bg_width - tmp_x_len, height : larg_bg_height - tmp_y_len});
			$(".show_pic").get(0).scrollLeft = tmp_bg_left;
			$(".show_pic").get(0).scrollTop = tmp_bg_top;
			$("#drag_logo").css({ top : logo_top + min_len, left : logo_left + min_len});
			$(".select_div").css({ width : pre_width + min_len, height : pre_height + min_len});
		}
		return false;
	});
	$(document).mouseup(function() {
		resize = false;
		pre_scorllTop = $(".show_pic").get(0).scrollTop;
		pre_scorllLeft = $(".show_pic").get(0).scrollLeft;
		big_base = $("#larg_bg").width()/$("#small_bg").width();
		return false;
	});
	return false;
});

//图片上传
function upload()
{
	pre_scorllTop = 0;
	pre_scorllLeft = 0;
	document.upload_form.submit();
}

//图片截取
function cut_image()
{
	path = $("#small_bg").attr("src"); //原图的路径
	show_top = $(".show_pic").get(0).scrollTop; //选区相对于图片的top值
	show_left = $(".show_pic").get(0).scrollLeft; 
	width = $("#larg_bg").width();
	height = $("#larg_bg").height();
	$.ajax({
		type: "GET",
		url: "cut.php",
		cache: false,
		data: "path=" + path + "&top=" + show_top + "&left=" + show_left + "&big_base=" + big_base + "&width=" + width + "&height=" + height, 
		success: show_cut_pic
 });
}

//展示截取后获得的图片
function show_cut_pic(msg)
{
	var result = eval("("+msg+")");
	if( result == null )
	{
		return false;
	}
	if (response['result'] == "error")
	{
		
	}
	else if (response['result'] == "success")
	{
		if ($("#cut_pic > img").get(0) == undefined)
		{
			$("#cut_pic").append("<img style='display:block' src='"+ response['path'] +"'></img>").append("<br /><span>截取的图片<br />保存于"+response['path']+"</span>");
		}
		else
		{
			$("#cut_pic > img").attr("src", response['path']);
		}
	}

}


