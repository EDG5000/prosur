namespace JobList{

/*
onClickSession: loadSession:
jobId == -1 ? chunkLoader.tick() : loadSession(jobId)

loadSession(jobId):
mode=job&job_id=${jobId}

onDrag: chunkLoader.tick()

onZoom: chunkLoader.tick()

chunkLoader.tick():
// Is zoomlevel already logorithmic?
ZOOM_MULTIPLIER = 150
modulus = 1.1^zoomLevel || modulus = zoomLevel * ZOOM_MULTIPLIER

leftChunk = Math.floor(startX / chunkSize[modulus]) * chunkSize[modulus]
rightChunk = Math.round(startX / chunkSize[modulus]) * chunkSize[modulus]

if(typeof cache[modulus][leftChunk] == "undefined"){
cache[modulus][leftChunk] = download(mode=range&min = leftChunk & max = leftChunk+chunkSize[modulus] & modulus = modulus)
}

if(undefined){
cache[modulus][leftChunk] = download(mode=range&min = rightChunk & max = rightChunk+chunkSize[modulus] & modulus = modulus)
}


drawer.tick():
for(let x = minX; x < maxX; i++){
chunk = Math.round(x / chunkSize[modulus])
frame = cache[modulus][chunk][x];
render(frame)
}
*/

export let addedLinks: Array<HTMLAnchorElement>; // Used when adjusting selection state

// Load list of available log files and initiate load of the last-loaded file
export function init(){    

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
 
    // Pan the plotter and load job data when clicking on a job
    Main.sessionListContainer.addEventListener("click", function(e: Event){
        e.preventDefault();
        let link: HTMLAnchorElement = <HTMLAnchorElement> e.target;
        const time = parseInt(link.dataset.time);
        if(time != Main.Settings.pan){
            Main.Settings.pan = time;
            console.log(Main.Settings.pan);
            Main.canvasInvalidated = true;
        }
    });

    // Load and display list of files
    let xhr = new XMLHttpRequest();
    xhr.responseType = 'json';
    xhr.onreadystatechange = function(){  
        if(xhr.readyState != Const.XHR.DONE){
            return;
        }
        if(xhr.response == null){
            console.error("JobList: Failed to download, response was null. Is the backend reachable?");
            return;
        }
        addedLinks = [];
        for(let job of xhr.response){
            const link = document.createElement("a");
            
            // Link is only used to allow user to navigate to the url, perhaps for downloading data to disk
            link.href = "http://" + Const.HOST + ":" + Const.PORT + "/frames?mode=job&job_id=" + job.job_id;
           
            // Cap values beyond ~2032; some test data has timestamps all the way in the upcoming dyson-sphere epoch; within the int64_t allowed limit, but not within JavaScript's 32-bit floating point Numbers.
            if(job.time > 1957071184){
                job.time = 1957071184;
            }

            link.dataset.time = job.time;
            const dateTimeString = new Date(job.time * 1000).toJSON().replace("T", " ").slice(0, 19);
            const jobName = job.job_file_name.replace("0:/gcodes/", "").replace(".gcode", "");
            link.innerText = jobName + "(" + dateTimeString + ")";
            //link.innerText = job.time + "";
            addedLinks.push(link);
            Main.sessionListContainer.appendChild(link);
            Main.sessionListContainer.appendChild(document.createElement("br"));
        }
    };

    // URL is set to Apache directory index containing log file
    let url: string;
    url = Const.URL_SCHEME + Const.HOST+":" + Const.PORT + "/jobs";
    xhr.open("GET", url, true);

    // Start the XHR request
    xhr.send();
}

}