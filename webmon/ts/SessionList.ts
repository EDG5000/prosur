namespace SessionList{

export let addedLinks: Array<HTMLAnchorElement>; // Used when adjusting selection state

// Load list of available log files and initiate load of the last-loaded file
export function init(cb: () => void){    
    // Invoke loadSession when clicking on link
    Main.sessionListContainer.addEventListener("click", function(e: Event){
        let link: HTMLAnchorElement = <HTMLAnchorElement>e.target;
        localStorage.lastSession = link.getAttribute("href").split("/")[1];
        e.preventDefault();
        SessionLoader.load(localStorage.lastSession); 
    });
    Logger.i("Loading session list...");
    // Load and display list of files
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function(){  
        if(this.readyState != 4) return;
        let parser = new DOMParser();
        let doc = parser.parseFromString(xhr.responseText, "text/html");
        let links = doc.querySelectorAll("td a");
        let timestamps: Array<any> = [];
        for(let link of links as any){
            // Skip link to parent directory
            if(link.outerText == "Parent Directory" || link.outerText == "index-of-mnt-data.html" || link.outerText == Const.CURRENT_LOG_FILE){
                continue;
            } 
            let timestamp = parseInt(link.innerText.replace(".csv", ""));
            if(isNaN(timestamp)){
                continue;
            }
            timestamps.push(timestamp);
        }
        timestamps.sort();
        timestamps.reverse();
        let linkCurrentFile = document.createElement("a");
        linkCurrentFile.innerText = "Current";
        linkCurrentFile.href = Const.DATA_FOLDER + "/" + Const.CURRENT_LOG_FILE;
        Main.sessionListContainer.appendChild(linkCurrentFile);
        Main.sessionListContainer.appendChild(document.createElement("br"));
        addedLinks = [];
        for(let timestamp of timestamps){
            const filename = timestamp + ".csv"
            const link = document.createElement("a");
            addedLinks.push(link);
            link.href = Const.DATA_FOLDER + "/" + filename;
            const dateTimeString = new Date(timestamp * 1000).toJSON().replace("T", " ").slice(0, 19);
            link.innerText = dateTimeString;
            Main.sessionListContainer.appendChild(link);
            Main.sessionListContainer.appendChild(document.createElement("br"));
        }
        Logger.i("Loaded list of " + (links.length-1) + " sessions.");
        cb();
    };

    // URL is set to Apache directory index containing log file
    let url: string;
    if(Const.TEST_MODE){
        url = Const.DATA_FOLDER + "/index-of-mnt-data.html";
    }else{
        url = Const.DATA_FOLDER + "/?C=M;O=D";
    }
    xhr.open("GET", url, true);

    // Start the XHR request
    xhr.send();
}

}