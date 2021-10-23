namespace SessionList{

// Load list of available log files and initiate load of the last-loaded file
export function init(){    
    // Invoke loadSession when clicking on link
    Main.sessionListContainer.addEventListener("click", function(e){
        let a: HTMLAnchorElement = e.target;
        localStorage.lastSession = a.getAttribute("href");
        e.preventDefault();
        SessionLoader.load(localStorage.lastSession); 
    });
 
    // Load and display list of files
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function(){  
        if(this.readyState != 4) return;

        let parser = new DOMParser();
        let doc = parser.parseFromString(xhr.responseText, "text/html");
        let links = doc.querySelectorAll("td a");

        for(let link of links as any){
            // Skip link to parent directory
            if(link.outerText == "Parent Directory"){
                continue;
            } 
            Main.sessionFilenames.push(link.getAttribute("href"));

            // Insert the link node into main window
            link.innerText = link.innerText.replaceAll("hc3d-tm-", "");
            link.innerText = link.innerText.replaceAll(".log", "");
            Main.sessionListContainer.appendChild(link);
            Main.sessionListContainer.appendChild(document.createElement("br"));
        }
    };

    // URL is set to Apache directory index containing log file
    let url: string;
    if(Main.TEST_MODE){
        url = "testdata/index-of-mnt-data.html";
    }else{
        url = "mnt-data/?C=M;O=D";
    }
    xhr.open("GET", url, true);

    // Start the XHR request
    xhr.send();
}

}