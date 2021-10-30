namespace SessionLoader{

export function init(){
    // Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(refreshCurrentFile, 1000);
}

function refreshCurrentFile(){
    if(Main.loading == false && typeof localStorage.lastSession != "undefined" && localStorage.lastSession == Const.CURRENT_LOG_FILE && Main.frames.length > 0){
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


    // Mark the correct link as selected
    for(let linkIndex in SessionList.addedLinks){
        let link = SessionList.addedLinks[linkIndex];
        let linkFilename = link.href.substring(link.href.lastIndexOf('/')+1);
        if(linkFilename == filename){
            link.style.border = "1px solid black";
        }else{
            link.style.border = "none";
        }
    }
 
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
        
        // Locate first newline
        let index = responseData.indexOf('\n', 1);
        let line = responseData.substr(0, index);

        if(/[a-zA-Z]/.test(line[0])){
            // First row has letter, parse header
            var components = line.split('\t');
            // Remove time label and store labels in memory
            Main.currentSensorLabels = components.splice(0, 1); 
        }else{
            // First row is numeric, header not present.
            Main.currentSensorLabels = Const.SENSOR_LABELS;
        }

        // Parse rows
        while(lastIndex !== -1){
            index = responseData.indexOf('\n', lastIndex+1);
            line = responseData.substr(lastIndex, index-lastIndex);
            if(line.length > 0){
                // Create and store a Frame for each regular ro
                let frame = new Frame.Frame(line);
                Main.frames.push(frame);
            }
            if(lastIndex == responseData.length-1){
            	break;
            } 
            lastIndex = index;
        }
        Main.loading = false;
        Logger.i("Loaded " + Main.frames.length + " frames.");
        Drawer.draw(); 
        LegendUpdater.updateLegend();
        Logger.i("Drawing complete.");
    };
    // URL depends on TEST_MODE flag; make XHR call
    let url: string;
    if(Const.TEST_MODE){
        url = "testdata/" + filename
    }else{
        url = "mnt-data/" + filename;
    }
    xhttp.open("GET", url, true);
    xhttp.send();
};

}