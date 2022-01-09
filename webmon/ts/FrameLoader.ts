namespace FrameLoader{

export function init(){
    // Periodically obtain last line if the current open file is a live file hc3d-log.log
	setInterval(refreshCurrentFile, 1000);
}


function refreshCurrentFile(){
    /*if(Main.loading == false && typeof localStorage.lastSession != "undefined" && localStorage.lastSession == Const.CURRENT_LOG_FILE && Main.Data.frames.length > 0){
        let xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function(){
            if(this.readyState != 4) return;
            let frame = new Frame.Frame(this.responseText);
            Main.Data.frames.push(frame);
            let fullyScrolled = Math.floor((Main.HTMLElements.scroller.scrollLeft + Main.HTMLElements.scroller.clientWidth) - Main.HTMLElements.scroller.scrollWidth) > -2;
            Drawer.draw();
            if(fullyScrolled){
                Main.HTMLElements.scroller.scrollLeft = Main.HTMLElements.scroller.scrollWidth - Main.HTMLElements.scroller.clientWidth;
            }
        };
        xhr.open("GET", Const.refreshUrl, true);
        xhr.send();
    }*/
}


// Load session data by filename.  
export function load(job: Number){

    // Mark the correct link as selected
    /*for(let linkIndex in SessionList.addedLinks){
        let link = SessionList.addedLinks[linkIndex];
        let linkFilename = link.href.substring(link.href.lastIndexOf('/')+1);
        if(linkFilename == filename){
            link.style.border = "1px solid black";
        }else{
            link.style.border = "none";
        }
    }*/
 
    Logger.i("Load job " + job + "...");
    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json';
    // XHR callback for loading session list HTML
    xhr.onreadystatechange = function() {
        if(this.readyState != Const.XHR_SUCCESS) return;
        if(typeof xhr.response == "undefined" || xhr.response == null){
            alert("FrameLoader: Failure to obtain response JSON data. Check server response header and browser support for JSON response type support in XHR.");
            return;
        }
        if(typeof xhr.response == "string"){
            alert("FrameLoader: Error from Prosurd: " + xhr.response);
            return;
        }

        if(typeof xhr.response.frames == "undefined"){
            alert("FrameLoader: Response is missing the frames property.");
            return;
        }

        if(typeof xhr.response.parameters == "undefined"){
            alert("FrameLoader: Response is missing the parameters property.");
            return;
        }

        // TODO sessionData.parameters is not used yet, this could be displayed
        Main.Data.frames = xhr.response.frames;
        Main.Data.parameters = xhr.response.parameters;
        if(typeof Main.Data.frames.time == "undefined"){
            alert("FrameLoader: Error: The time column is not present in the receive data. Cannot plot data.");
            return;
        }
        if(Main.Data.frames.time.length < 2){
            // We are not going to bother drawing anything if there are less than 2 frames. A line needs two points after all.
            return;
        }

        Logger.i("Loaded " + Main.Data.frames.time.length + " frames.");
        Plotter.draw();  
        Logger.i("Drawing complete.");
            // Scroll to end when opening current file
            /*if(job == Const.CURRENT_LOG_FILE){
                Main.HTMLElements.scroller.scrollLeft = Main.HTMLElements.scroller.scrollWidth - Main.HTMLElements.scroller.clientWidth;
            }*/
        };
    // URL depends on TEST_MODE flag; make XHR call
    let url: string;
    url = "http://" + Const.HOST + ":" + Const.PORT + "/frames?mode=job&job_id=" + job;
    xhr.open("GET", url, true);
    xhr.send();
};


}