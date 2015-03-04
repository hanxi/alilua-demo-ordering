function userording(uid,menuid) {
    var dishnameobj = document.getElementById("dish_name_"+uid);
    var dishpriceobj = document.getElementById("dish_price_"+uid);
    if (dishnameobj && dishpriceobj) {
        if (dishnameobj.value.length<1) {
            alert("请填写菜名");
        } else if (dishpriceobj.value.length<1) {
            alert("请填写菜价");
        } else {
            jsonRPC.request('user_ordering', {
                params: [uid, dishnameobj.value, dishpriceobj.value, menuid],
                success: function (result) {
                    console.log(result);
                    alert(result.result);
                },
                error: function (result) {
                    console.log(result);
                }
            });
        }
    }
}

function loaduserorderlist(menuid) {
    jsonRPC.request('get_user_order_list', {
        params:[menuid],
        success: function(result) {
            console.log(result);
            var userlist = eval('(' + result.result + ')');
            for (var i=0; i<userlist.length; i++) {
                var uid = userlist[i].uid;
                var dishname = userlist[i].dishname;
                var dishprice = userlist[i].dishprice;
                var dishnameobj = document.getElementById("dish_name_"+uid);
                var dishpriceobj = document.getElementById("dish_price_"+uid);
                if (dishnameobj) {
                    dishnameobj.value = dishname;
                }
                if (dishpriceobj) {
                    dishpriceobj.value = dishprice;
                }
            }
        },
        error: function(result) {
            console.log(result);
        }
    });
}

function loaduserlist(menuid) {
    jsonRPC.request('get_user_list', {
        params: [],
        success: function(result){
            console.log(result);
            var userlistview = document.getElementById("userlistview");
            var userlist = eval('(' + result.result + ')');
            var html = "<table>";
            html += "<tr>";
            html += "<th>姓名</th>";
            html += "<th>菜名</th>";
            html += "<th>价格</th>";
            html += "<th></th>";
            html += "</tr>";
            for (var i=0; i<userlist.length; i++) {
                var uid = userlist[i].uid;
                var name = userlist[i].name;
                html += "<tr>";
                html += "<td>" + name + "</td>";
                html += "<td><input id='dish_name_" + uid + "' type='text' placeholder='菜名+菜名'> </input></td>";
                html += "<td><input id='dish_price_" + uid + "' type='text' placeholder='总价格'> </input>元</td>";
                html += "<td><input type='button' value='提交' onclick='userording("+uid+","+menuid+")'></input></td>";
                html += "</tr>";
            }
            html += "</table>";
            userlistview.innerHTML = html;
            loaduserorderlist(menuid);
        },
        error: function(result) {
            console.log(result);
        }
    });
}

function loadmenulist() {
    jsonRPC.request('get_last_menu_list', {
        params: [],
        success: function(result){
            console.log(result);
            var menuview = document.getElementById('menuview');
            var imagearray = eval('(' + result.result + ')');
            var html = "";
            var menuid = 0;
            for (var i=0; i<imagearray.length; i++) {
                menuid = imagearray[i].uploadtime;
                var imgpath = imagearray[i].menupath;
                html += "<img src='"+ imgpath +"'>";
            }
            menuview.innerHTML = html;
            loaduserlist(menuid);
        },
        error: function(result) {
            console.log(result);
        }
    });
}


function uploadfile(file, cb) {
    var reader = new FileReader();
    reader.onloadstart =  function(p) {
        console.log("onloadstart");
    }
    reader.onprogress = function(p) {
        console.log("onprogress");
    }
    reader.onload = function() {
        console.log("load complete:"+file.size);
    }
    reader.onloadend = function()
    {
        if (reader.error) {
            console.log(reader.error);
        } else {
            //document.getElementById("bytesRead").textContent = file.size;
            console.log(typeof(reader.result));
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function() {
                if (xhr.readyState==4) {
                    if (xhr.status==200) {
                        console.log("upload complete, response: "+ xhr.responseText);
                        cb(file.name,xhr.responseText);
                    }
                }
            };
            console.log(file.name);
            xhr.open("POST","/scripts/upload?file_name="+file.name,true);
            xhr.overrideMimeType("application/octet-stream");
            if(!xhr.sendAsBinary){
                xhr.sendAsBinary = function(datastr) {
                    function byteValue(x) {
                        return x.charCodeAt(0) & 0xff;
                    }
                    var ords = Array.prototype.map.call(datastr, byteValue);
                    var ui8a = new Uint8Array(ords);
                    this.send(ui8a.buffer);
                }
            }
            xhr.sendAsBinary(reader.result);
        }
    }
    reader.readAsBinaryString(file);
}

function uploadfiles(fsobj,cb) {
    console.log(fsobj);
    for (var i=0; i<fsobj.files.length; i++) {
        var file = fsobj.files[i];
        uploadfile(file, cb);
    }
}

function uploadcomplete(filename,fpath) {
    console.log("complete upload:" + filename);
    uploadfnames[uploadcompleteidx] = fpath;
    uploadcompleteidx++;
    var obj = document.getElementById('flist_'+filename);
    if (obj) {
        obj.innerHTML = filename + '&radic;';
    }
    console.log(uploadcompleteidx,uploadfnames,uploadfnames.length);
    if (uploadcompleteidx == uploadfnames.length) {
        jsonRPC.request('upload_menu', {
            params: [uploadfnames],
            success: function(result){
                alert(result.result);
                console.log(result);
                location.reload(true);
            },
            error: function(result) {
                console.log(result);
            }
        });
    }
}

function uploadImages() {
    var fileobj = document.getElementById("file");
    if (fileobj.files.length>0) {
        uploadcompleteidx = 0;
        uploadfnames = new Array(fileobj.files.length);
        var fileobj = document.getElementById("file");
        console.log(fileobj.files);
        uploadfiles(fileobj,uploadcomplete);
    } else {
        alert("请先选择文件");
    }
}

function fileselectchanged() {
    var container = document.getElementById("imglist");
    var html = "<ol>";
    var fileobj = document.getElementById("file");
    for (var i=0; i<fileobj.files.length; i++) {
        var name = fileobj.files[i].name;
        html += "<li id='flist_"+ name +"'>" + name + "</li>";
        console.log(fileobj.files);
    }
    html += "</ol>";
    container.innerHTML = html;
}

function generateExcel() {
    jsonRPC.request('generate_csv', {
        params: [],
        success: function (result) {
            document.charset = 'gb2312';
            console.log(result);
            var csvdata = eval('(' + result.result + ')');
            var csvobj = document.getElementById("csv");
            csvobj.download = "订餐结果.csv";
            console.log("\ufeff"+csvdata.data);
            var csvurl = "data:text/csv;charset=gb2312,"+GBEncode(csvdata.data);
            console.log(csvurl);
            csvobj.href = csvurl;
            csvobj.click("return false");
        },
        error: function (result) {
            console.log(result);
        }
    });
}

