namespace JobList{

export let addedLinks: Array<HTMLAnchorElement>; // Used when adjusting selection state

// Load list of available log files and initiate load of the last-loaded file
export function init(cb: () => void){    
    // Invoke loadSession when clicking on link
    Main.HTMLElements.sessionListContainer.addEventListener("click", function(e: Event){
        let link: HTMLAnchorElement = <HTMLAnchorElement> e.target;
        localStorage.lastSession = link.rel;
        e.preventDefault();
        FrameLoader.load(parseInt(localStorage.lastSession)); 
    });
    Logger.i("Loading session list...");
    // Load and display list of files
    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json';
    xhr.onreadystatechange = function(){  
        if(this.readyState != Const.XHR_SUCCESS) return;
        let linkCurrentFile = document.createElement("a");
        linkCurrentFile.rel = "-1";
        linkCurrentFile.innerText = "All data";
        Main.HTMLElements.sessionListContainer.appendChild(linkCurrentFile);
        Main.HTMLElements.sessionListContainer.appendChild(document.createElement("br"));
        addedLinks = [];
        for(let job of xhr.response){
            const filename = "" + ".csv"
            const link = document.createElement("a");
            
            // Link is only used to allow user to navigate to the url, perhaps for downloading data to disk
            link.href = "http://" + Const.HOST + ":" + Const.PORT + "/frames?mode=job&job_id=" + job.job_id;
            link.rel = job.job_id;
            // Cap values beyond ~2032, some test data has timestamps all the way in the upcoming dyson-sphere epoch, which are within the int64_t allowed limit.
            if(job.time > 1957071184){
                job.time = 1957071184;
            }
            const dateTimeString = new Date(job.time * 1000).toJSON().replace("T", " ").slice(0, 19);
            const jobName = job.job_file_name.replace("0:/gcodes/", "").replace(".gcode", "");
            link.innerText = jobName + "(" + dateTimeString + ")";
            addedLinks.push(link);
            Main.HTMLElements.sessionListContainer.appendChild(link);
            Main.HTMLElements.sessionListContainer.appendChild(document.createElement("br"));
        }
        Logger.i("Loaded list of " + (addedLinks.length-1) + " sessions.");
        cb();
    };

    // URL is set to Apache directory index containing log file
    let url: string;
    url = "http://"+Const.HOST+":"+Const.PORT+"/jobs";
    xhr.open("GET", url, true);

    // Start the XHR request
    xhr.send();
}

}