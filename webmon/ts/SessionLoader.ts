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
            let fullyScrolled = Math.floor((Main.scroller.scrollLeft + Main.scroller.clientWidth) - Main.scroller.scrollWidth) > -2;
            Drawer.draw();
            if(fullyScrolled){
                Main.scroller.scrollLeft = Main.scroller.scrollWidth - Main.scroller.clientWidth;
            }
        };
        xhr.open("GET", Const.refreshUrl, true);
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
        processSessionData(responseData);
        // Scroll to end when opening current file
        if(filename == Const.CURRENT_LOG_FILE){
            Main.scroller.scrollLeft = Main.scroller.scrollWidth - Main.scroller.clientWidth;
        }
    };
    // URL depends on TEST_MODE flag; make XHR call
    let url: string;
    if(Config.testMode){
        url = "testdata/" + filename
    }else{
        url = "mnt-data/" + filename;
    }
    xhttp.open("GET", url, true);
    xhttp.send();
};

// TSV session data
// First field is unix time in seconds
// Header may be provided optionally, it will be used for the sensor labels
// Default header will be used when no header present in the file
export function processSessionData(sessionData: string){
    Logger.i("Downloaded " + sessionData.length + " bytes.");
    let index: number;
    let lastIndex = 0;
    let line: string;
    let firstLine = true;

    // Parse rows
    while(lastIndex !== -1){
        index = sessionData.indexOf('\n', lastIndex+1);
        line = sessionData.substr(lastIndex, index-lastIndex);


        if(firstLine){
            firstLine = false;
            if(/[a-zA-Z]/.test(line[0])){
                // First row has letter, parse header
                var components = line.split('\t');
                components.splice(0, 1); // Remove first item, which must always be unixtime
                // Remove time label and store labels in memory
                Main.currentSensorLabels = components; 
        
            }else{
                // First row is numeric, header not present.
                Main.currentSensorLabels = Const.SENSOR_LABELS;
            }
        }else if(line.length > 0){
            // Create and store a Frame for each regular row
            let frame = new Frame.Frame(line);
            Main.frames.push(frame);
        }

        if(lastIndex == sessionData.length-1){
            break;
        } 
        lastIndex = index;
    }
    Main.loading = false;
    Logger.i("Loaded " + Main.frames.length + " frames.");
    Drawer.draw(); 
    LegendUpdater.updateLegend();
    Logger.i("Drawing complete.");
}

}