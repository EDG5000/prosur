namespace SessionList{

// Load list of available log files and initiate load of the last-loaded file
export function init(){    
    // Invoke loadSession when clicking on link
    Main.sessionListContainer.addEventListener("click", function(e){
        let a: HTMLAnchorElement = e.target;
        localStorage.lastSession = a.getAttribute("href").split("/")[1];
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
            timestamps.push(timestamp);
        }
        timestamps.sort();
        timestamps.reverse();
        let linkCurrentFile = document.createElement("a");
        linkCurrentFile.innerText = "Current";
        linkCurrentFile.href = Const.DATA_FOLDER + "/" + Const.CURRENT_LOG_FILE;
        Main.sessionListContainer.appendChild(linkCurrentFile);
        Main.sessionListContainer.appendChild(document.createElement("br"));
        for(let timestamp of timestamps){
            let filename = timestamp + ".csv"
            let link = document.createElement("a");
            link.href = Const.DATA_FOLDER + "/" + filename;
            link.innerText = new Date(timestamp * 1000).toString();
            Main.sessionListContainer.appendChild(link);
            Main.sessionListContainer.appendChild(document.createElement("br"));
        }
        Logger.i("Loaded list of " + (links.length-1) + " sessions.");
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