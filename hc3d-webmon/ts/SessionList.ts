namespace SessionList{

// Load list of available log files and initiate load of the last-loaded file
export function load(){    
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function(){
        // Display list of files async
        if(this.readyState != 4) return;

        var parser = new DOMParser();
        let doc = parser.parseFromString(xhttp.responseText, "text/html");
        var links = doc.querySelectorAll("td a");

        for(let link of links as any){
            // Skip link to parent directory
            if(link.outerText == "Parent Directory"){
                continue;
            } 
            App.sessionFilenames.push(link.getAttribute("href"));

            // Insert the link node into main window
            link.innerText = link.innerText.replaceAll("hc3d-tm-", "");
            link.innerText = link.innerText.replaceAll(".log", "");
            var newLink = App.sessionListContainer.appendChild(link);
            App.sessionListContainer.appendChild(document.createElement("br"));
            // Invoke loadSession when clicking on link
            newLink.addEventListener("click", function(e){
                localStorage.lastSession = this.getAttribute("href");
                e.preventDefault();
                SessionLoader.load(localStorage.lastSession); 
            });
        }
        // Load last session
        if(typeof localStorage.lastSession != "undefined"){
            SessionLoader.load(localStorage.lastSession);
        }
    };

    var url;
    if(App.TEST_MODE){
        url = "testdata/index-of-mnt-data.html";
    }else{
        url = "mnt-data/?C=M;O=D";
    }
    xhttp.open("GET", url, true);
    xhttp.send();
}

}