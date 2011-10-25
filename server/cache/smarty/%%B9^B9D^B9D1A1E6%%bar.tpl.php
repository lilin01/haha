<?php /* Smarty version 2.6.10, created on 2010-11-07 18:13:50
         compiled from bar.tpl */ ?>
<!doctype html>
<html>
<head>
<meta http-equiv="Cache-Control" content="no-cache" />
<?php echo '
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.3/jquery.min.js"></script>
<script type="text/javascript">

  $(document).ready(function() {jQuery(function() {
    $("body").hide().fadeIn();
    $.getFbUid = function(str) {
          var w = true;
          var pp = [\'fb_sig_canvas_user\',\'fb_sig_user\', \'fb_user_id\',\'session\'];
          var r = new RegExp(\'[\\\\?&](\'+pp[0]+\'|\'+pp[1]+\'|\'+pp[2]+\'|\'+pp[3]+\')=([^&#]*)\').exec(str);

          if(r && r[1] == \'session\') {
              var jso = jQuery.parseJSON(decodeURIComponent(r[2]));
              return jso.uid || 0;
          }

          if (!r) {
              return 0;
          }
          return r[2] || 0;
      };

    $.urlParam = function(name){
        var r = new RegExp(\'[\\\\?&]\' + name + \'=([^&#]*)\').exec(window.location.href);
        if (!r) { return 0; }
        return r[1] || 0;
    };


    $.autoScroll = function() {
        if (position < maxPosition) {
          $("#c").animate({ left: "-=585px"}, 666);
          position++;
        } else if(position > 1) {
          var scroll = (position-1) * 585;
          position = 1;
          $("#c").animate({ left: "+="+ scroll +"px"}, 666);
        }
        activateControls();
    }


    var uid = $.getFbUid(window.location.href) || $.getFbUid(document.referrer);
    var apid = $.urlParam(\'apid\');

    var units = 0;
    var maxPosition;
    var position = 1;
    var lazyLoad = [];
    var scrollerInterval = null;

    function activateControls() {
      $(".c").addClass("a");
      if (position == maxPosition) {
        $(".c.r").removeClass("a");
      }
      if (position == 1) {
        $(".c.l").removeClass("a");
      }
      clearTimeout(scrollerInterval);
      scrollerInterval = setTimeout($.autoScroll,60000);
    }

    var url = "delivery/jsonbar.php?apid="+apid;
    if(uid != 0) {
        url += "&fbuid="+uid;
    }
	var adcnt = 1;
    url += "&callback=?";
    $.getJSON(url   , function(data) {
      $("#i span").text(data.l.p);
      $("#b span").text(data.l.f);
      $("#i").css("background-image", "url(" + data.l.i + ")");

      $.each(data.g, function(index, game) {
        units += parseInt(game.u);
        var e = $(\'<li id="ad\'+units+\'"><a style="background-image: url(\'+game.i+\')" href="\' + game.l + \'"><img src="\' + game.i + \'" class="default" alt="" /><span>\' + game.d + \'</span></a>\').appendTo("#c");
        e.find(\'a\').data(\'img\',game.h);
      });
      maxPosition = parseInt((units - 1) / 5) + 1;
      $("#c").css({ width: (units / 5 * 590) });
      $.each(data.f, function(index, favorite) {
        $(\'<li><a style="background:url(\' + favorite.i + \') no-repeat;" href="\' + favorite.l + \'">\' + favorite.n + \'</a></li>\').appendTo("#f")
      });
      var cs = function() {
        if ( $.browser.msie ) { this.style.removeAttribute(\'filter\'); }
      }

      var hovering = null;
      $("#c li").hover(
        function() {
          activateControls();
          var t = this;
          $("#o").css({ height: "75px" });
          $("#c li").find("span").stop(true,true).fadeOut(0,cs);
          $(this).find("span").stop(true,true).fadeIn(400,cs);
          var img = $(this).find("img");
          hovering = img;
          if(img.data(\'loaded\') == null) {
            var i = new Image();
             var a = $(t).find(\'a\');
              a.css("background-image",\'url(\' +a.data(\'img\')+ \')\');
              $(i).load(function() {
                img.data(\'loaded\',true);
                if(hovering == img) {
                    img.stop(true,true).fadeTo(300,0);
                }
            }).attr(\'src\',a.data(\'img\'));
          } else {
            img.stop(true,true).fadeTo(300,0);
          }
        },
        function() {
          $("#o").css({ height: "54px" });
          $("#c li").find("span").stop(true,true).fadeOut(0,cs);
          $("#c li").find("img:animated").stop(true,true).fadeTo(300,1);
          $(this).find("img").fadeTo(300,1);
      });

      $(\'<style type="text/css">#i,#c li span,#i span,.c.a{background-color:\' + data.t.b + \';}#b #f li a:hover{color:\' + data.t.b + \';}#i:hover,.c.a:hover{background-color:\' + data.t.h + \';}#c li a:hover{-webkit-box-shadow:0 0 6px \' + data.t.h + \';-moz-box-shadow:0 0 6px \' + data.t.h + \';}#c li span,#i span{border-color:\' + data.t.h + \';}</style>\').prependTo("head");

      $("a").attr("target", "_blank");
      activateControls();
    });


    $(".c.r").click(function() {
      if (position < maxPosition) {
        $("#c").animate({ left: "-=585px"}, 666);
        position++;
        activateControls();
      }
    });

    $(".c.l").click(function() {
        if (position > 1) {
        $("#c").animate({ left: "+=585px"}, 666);
        position--;
        activateControls();
      }
    });
  });});

</script>
<style type="text/css">


a {color:#555;}
html * {background-repeat:no-repeat;}
ul, li, a, a img {margin:0; list-style:none; padding:0; text-decoration:none; border:0;}

#a {
	font-family:"Helvetica Neue", Helvetica, Arial, sans-serif;
	font-size:13px;
	position:absolute;
	top:0px;
	left:0px;
	width:760px;
	height:75px;
	background:url(http://cdn.applifier.com/images/appl-s.png) 0 -126px no-repeat;
	color:#555;
}

#i {
	position:absolute;
	top:1px;
	left:1px;
	height:53px;
	width:134px;
	-webkit-transition: background-color 0.5s linear;
}

#i:hover span {display:block;}

.c {
	width:16px;
	height:54px;
	position:absolute;
	top:1px;
	text-indent:-9999cm;
  background-repeat: no-repeat;
}

.c.r {
	right:1px;
  background-image:url(http://cdn.applifier.com/images/appl-s.png);
  background-position: 0 -354px;
}

.c.l {
	left:136px;
	background-image:url(http://cdn.applifier.com/images/appl-s.png);
	background-position: 0 -250px;
}

.c.a:hover {
	-webkit-transition:background-color 0.25s linear;
	cursor:pointer;
}

#o {
	width:590px;
  overflow: hidden;
  position: absolute;
  height: 54px;
  left:153px;
}

#c {
	position:relative;
    top:0;
}

#c li {
	margin:4px 0 0 14px;
	height:50px;
	float:left;
}

#c li:first-child {
	margin-left:10px;
}

#c li a {display:block; position:relative; height:47px;}

#c li span, #i span {
	position:absolute;
	top:44px;
	left:-10px;
	border-style:solid;
	border-width:1px;
	height:23px;
	color:#fff;
	padding:0 9px;
	line-height:1.0;
	font-size:11px;
	text-align:center;
	-webkit-border-radius:4px;
	-moz-border-radius:4px;
	z-index:1000;
	display:none;
  width: 100%;
}

#i span {
	left:12px;
	width:100px;
	padding:1px 5px;
	height:25px;
}

#c img {
	-webkit-border-radius:4px;
	-moz-border-radius:4px;
	-webkit-box-shadow:0px 1px 3px #111;
	-moz-box-shadow:0px 1px 3px #111;


}

#c li a:hover img {
	
}

#c li a:hover {
	-webkit-border-radius:4px;
	-moz-border-radius:4px;
}

#b {
	height:17px;
	width:740px;
	margin:57px 10px 0 10px;
	font-size:12px;
}

#b #l {
	float:right;
	background:url(http://cdn.applifier.com/images/appl-s.png) no-repeat;
	background-position: 0 -63px;
	text-indent:-9999cm;
	margin-top:2px;
	width:48px;
	height:16px;
}

#b #l:hover {
	background:url(http://cdn.applifier.com/images/appl-s.png) no-repeat;
	background-position: 0 0;
}

#b ul, #b li {display:inline; padding:0 6px;}

#b #f {
	width:600px;
  height:16px;
	display:block;
	float:left;
	overflow:hidden;
	padding-top:1px;
}

#b span {
	float:left;
	width:60px;
	font-weight:bold;
}

#b #f li a {
	padding:1px 0 1px 19px;
}

#b #f li {
	margin:0 8px;
	padding:0;
	height:16px;
}
</style>
  '; ?>

</head>
<body>
<div id="a">
	<a id="i"><span></span></a>
		<div class="c r"></div>

		<div class="c l"></div>

    <div id="o">
      <ul id="c"></ul>
    </div>
	<div id="b">
    <span></span>
		<ul id="f"></ul>
		<a id="l" href="http://applifier.com"></a>

	</div>
</div>

</body>
</html>