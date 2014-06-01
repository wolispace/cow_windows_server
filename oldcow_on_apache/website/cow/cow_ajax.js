var t0 = setInterval("ajaxRead('\/cgi-bin\/cow.pl?p=$p&m=msgr&f=2')",3000); // wait a sec before initialising..
var t0 = setTimeout("ajaxRead('\/cgi-bin\/cow.pl?p=$p&m=input&f=2&c=look')",300); // wait a sec before initialising..
var error_count=0;
function ajaxRead(file){
  var xmlObj = null;
  if(window.XMLHttpRequest){
      xmlObj = new XMLHttpRequest();
  } else if(window.ActiveXObject){
      xmlObj = new ActiveXObject("Microsoft.XMLHTTP");
  } else {
      return;
  }
  //alert('read for '+file);
  xmlObj.onreadystatechange = function(){
		if(xmlObj.readyState == 4){
			if (xmlObj.status == 200) {	 // only if "OK"
				error_count=0;
				var bits = xmlObj.responseText.split("~~~"); // split ~~~msgs~~fopp says hi~~~locs:You are in..
        //document.getElementById('rep').innerHTML=xmlObj.responseText;
        for (var i=0; i < bits.length; i++) {
					var bit = bits[i].split("~~",2);
					//alert(bit[0]+' - '+bit[1]);
					if(bit.length > 0){
    				//document.getElementById('rep').innerHTML = bit[0]+' - '+bit[1]; //xmlObj.responseText;
						if((bit[0].length>1)&&(bit[0].length<7)){
							if(bit[0]=='msgs'){
								with(document.getElementById('msgs')){
									if(bit[1].length>0){
										innerHTML += bit[1]+'<br>';	// add to current contents..
										scrollTop=scrollHeight;
									}
								}
							}else if(bit[0]=='nums'){
		             window.document.title = bit[1];
							}else if(bit[0]=='id'){
								 var flds = bit[1].split('='); // split ~~~id~~last_target=123
		              // alert(bit[1]+'['+flds[0]+']['+flds[1]+']');
		             if(flds[0]=='bannercolour'){
									 //document.getElementById('info').style.background=flds[1];
								 }else{
									 if(document.getElementById(flds[0])){
										 document.getElementById(flds[0]).value = flds[1];
									 }else{
										alert('cant find '+bit[1]+'['+flds[0]+']['+flds[1]+']');
									 }
								 }
							}else	if(bit[0]=='nwin'){
                 newwin = window.open(bit[1]);
							}else if(bit[1].length>1){
								 document.getElementById(bit[0]).innerHTML = bit[1];	// replace contents..
							}
						}

					}else{
						document.getElementById('error').innerHTML = bit[0];	// write out the error msg..
					}
				}
			}else{
				error_count++;
				if(error_count>10){
				  window.document.title="There was a problem accessing cow: " + xmlObj.status;
					error_count=0;
				}else{
					window.document.title="network delay "+error_count;
				}

			}
		}
	}
	xmlObj.open ('POST', file, true);
	xmlObj.send ('');
}

function updateObj(obj, data){
 document.getElementById(obj).firstChild.data = data;
}


function updisp(){
	with(document.forms.cmds.mlist){
		var p = selectedIndex+1;
		if(p<1){
			selectedIndex=-1;
			p=0;
		}
		if(p < length){
			selectedIndex++;
			if(done[options[p].value] > 0){
			}else{
				with(document.getElementById('msgs')){
				  innerHTML += options[p].text+"<br>x";
				  scrollBottom;
				}
				done[options[p].value]=1;
			}
		}
	}
}

function usercmd(mm){
	var url = '\/cgi-bin\/cow.pl?f=2';
	with(document){
		url+='&p='+getElementById('p').value;
		url+='&m='+getElementById('m').value;
		url+='&d='+getElementById('d').value;
		url+='&c='+getElementById('c').value;
		url+='&t='+getElementById('t').value;
		url+='&y='+getElementById('y').value;
		if(getElementById('c').value!=''){
  		getElementById('c').focus();
		}else{
  		getElementById('y').focus();
		}
		getElementById('c').value='';
		getElementById('y').value='';
	}
	window.status=url;
  ajaxRead(url);
}


if(window.Event){
  document.captureEvents(Event.KEYDOWN); document.onkeydown = setkey;
}else{
  document.onkeydown = function(){
   return setkey(event);
  }
}

function setkey(event){
	if((event.which==13)||(event.keyCode==13)){
		usercmd();
	}
}
