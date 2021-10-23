namespace SessionLoader{

export function init(){
    // Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(function(){
		if(Main.loading == false && typeof localStorage.currentSession != "undefined" && localStorage.currentSession == "hc3d-temp.log" && Main.frames.length > 0){
			var xhr = new XMLHttpRequest();
			xhr.onreadystatechange = function(){
				if(this.readyState != 4 || this.status != 200) return;
				var frame = new Frame.Frame(this.responseText);
				Main.frames.push(frame);
				Drawer.draw();
			};
			xhr.open("GET", "get_llc_values.php", true);
    		xhr.send();
		} 
    }, 1000);
}

// Load session data by filename.  
export function load(filename: string){
	Main.loading = true;
	Main.frames = [];

    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if(this.readyState != 4) return;
        var responseData = xhttp.responseText;
        var lastIndex = 0;
        while(lastIndex !== -1){
            var index = responseData.indexOf('\n', lastIndex+1);
            var line = responseData.substr(lastIndex, index-lastIndex);
            if(line.length > 0){
                var frame = new Frame.Frame(line);
                Main.frames.push(frame);
            }
            if(lastIndex == responseData.length-1){
            	break;
            } 
            lastIndex = index;
        }
        Main.loading = false;
        Drawer.draw();
    };
    
    if(Main.TEST_MODE){
        var url = "testdata/" + filename
    }else{
        var url = "mnt-data/" + filename;
    }

    xhttp.open("GET", url, true);
    xhttp.send();
};


}