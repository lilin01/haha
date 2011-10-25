function show_hide_div(state,object) {
//alert(object);
if(state) { object.style.display="block"; }
else { object.style.display="none"; }
}


function open_new_window(url,w,h,scrollbars) {
winLeft = (screen.width-800)/2; 
winTop = (screen.height-720)/2; 
new_window = window.open(url,'my_window','scrollbars='+scrollbars+',toolbar=0,menubar=0,resizable=0,dependent=0,status=0,width='+w+',height='+h+',left='+winLeft+',top='+winTop);
}

function go_to_delete(text,url) { if (confirm(text)) { location = url; } }
function checkAll(formId,cName,check) { for (i=0,n=formId.elements.length;i<n;i++) if (formId.elements[i].className.indexOf(cName) !=-1) formId.elements[i].checked = check; }


function openBarPreview(ad_banner_id) {
    if (!isNaN(ad_banner_id)) {
        var popup_desc = escape($('#banner_popup_'+ad_banner_id).val());

        $('#previewbar').load('/admin/common/previewBar?ad_banner_id='+ad_banner_id+'&popup_description='+popup_desc);
        $('#previewbar').dialog({
            width: 800,
            modal: false,
            resizable: false,
            draggable: true,
            title: 'Applifier Bar Preview',
            show: 'fade',
            hide: 'fade',
            close: function(event, ui) {
                $('#previewbar').dialog('destroy');
            }
        });
    }
    return false;
}

function refreshPreviewBar(ad_banner_id) {
    if (!isNaN(ad_banner_id)) {
        var popup_desc = $('#banner_popup_'+ad_banner_id).val();
        if ($('#preview_popup_description').length > 0) {
            $('#preview_popup_description').html(popup_desc);
        }
    }
}

function openHelp(id, content) {
    if (id && content) {
        $('#'+id).qtip({
					content: content,
					position: {
					  corner: {
						 target: 'topRight',
						 tooltip: 'bottomLeft'
					  }
				   },
				   style: {
					 width: 450,
                     name: 'light',
                     'font-family': 'Lucida Grande',
                     'font-size': '12px',
                     border: {
                        width: 1,
                        radius: 4,
                        color: '#6699CC'
                     }
				   },
            show: { ready: true }
                   
				});
    }
}

function showPopupPreview(ad_banner_id) {
    if (!isNaN(ad_banner_id)) {
        if ($('#preview_popup_description').length > 0) {
            $("#o").css({ height: "75px" });
            $('#preview_popup_description').show();
        }
    }
}

function hidePopupPreview(ad_banner_id) {
    if (!isNaN(ad_banner_id)) {
        if ($('#preview_popup_description').length > 0) {
            $("#o").css({ height: "54px" });
            $('#preview_popup_description').hide();
        }
    }
}