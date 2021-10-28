namespace SessionLoader{

export function init(){
    // Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(refreshCurrentFile, 1000);
}

function refreshCurrentFile(){
    if(Main.loading == false && typeof localStorage.lastSession != "undefined" && localStorage.lastSession == Main.CURRENT_LOG_FILE && 	Main.frames.length > 0){
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function(){
            if(this.readyState != 4) return;
            let frame = new Frame.Frame(this.responseText);
            Main.frames.push(frame);
            Drawer.draw();
        };
        xhr.open("GET", "get_llc_values.php", true);
        xhr.send();
    } 
}

// Load session data by filename.  
export function load(filename: string){
    Main.loading = true;
    Main.frames = [];
    Logger.i("Downloading " + filename + "...");
    let xhttp = new XMLHttpRequest();

    // XHR callback for loading session list HTML
    xhttp.onreadystatechange = function() {
        if(this.readyState != 4) return;
        let responseData = xhttp.responseText;
        Logger.i("Downloaded " + responseData.length + " bytes.");
        let lastIndex = 0;
        // Create and store a Frame for each line
        while(lastIndex !== -1){
            let index = responseData.indexOf('\n', lastIndex+1);
            let line = responseData.substr(lastIndex, index-lastIndex);
            if(line.length > 0){
                if(lastIndex == 0){
	        // First row and letter was found, parse header
                }else{
                    // Parse regular row
                    let frame = new Frame.Frame(line);
                    Main.frames.push(frame);
                }
            }
            if(lastIndex == responseData.length-1){
            	break;
            } 
            lastIndex = index;
        }
        Main.loading = false;
        Logger.i("Loaded " + Main.frames.length + " frames.");
        Drawer.draw(); 
        Logger.i("Drawing complete.");
    };
    // URL depends on TEST_MODE flag; make XHR call
    let url: string;
    if(Main.TEST_MODE){
        url = "testdata/" + filename
    }else{
        url = "mnt-data/" + filename;
    }
    xhttp.open("GET", url, true);
    xhttp.send();
};


}