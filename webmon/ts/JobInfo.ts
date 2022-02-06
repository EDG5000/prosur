namespace JobInfo{

    let table: HTMLTableElement;

    export function init(){
        // Persist scroll position of the panel (rate limited)
        let frameRequest: number;
        Main.parameterListContainer.addEventListener("scroll", function(e: Event){
            if(frameRequest != -1){
                cancelAnimationFrame(frameRequest);
            }
            frameRequest = requestAnimationFrame(function(){
                frameRequest = -1;
                Main.Settings.parameterListScrollTop = Main.parameterListContainer.scrollTop;
                localStorage.parameterListScrollTop = Main.Settings.parameterListScrollTop;
            });
            
        });
    }

    export function load(jobId: number){
        Main.parameterListContainer.innerHTML = "";
        if(jobId == -1){
            // Only clearing the job panel
            return;
        }
        let url = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/job?job_id=" + jobId;

        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function() {
            // Error checking
            if(xhr.readyState != Const.XHR.DONE){
                return;
            }
            if(xhr.response == null){
                console.error("JobInfo: failed to download, response was null. Is the backend reachable?");
                return;
            }
            if(typeof xhr.response == "undefined"){
                console.error("JobInfo: failed to download, response was undefined. Is the backend reachable?");
                return;
            }
            if(xhr.response.length == 0){
                console.error("JobInfo: Parameter object length is 0");
                return;
            }

            // Construct table
            table = document.createElement("table");
            addRow("Job ID", jobId + "");
            const downloadUrl = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/file?mode=job&job_id=" + jobId;
            addRow("File", "<a href=\"" + downloadUrl + "\">Download</a>");
            for(let key in xhr.response){
                let value = xhr.response[key];
                addRow(key, value);
            }


            // Add table to container
            Main.parameterListContainer.appendChild(table);

            // Restore scroll position
            Main.parameterListContainer.scrollTop = Main.Settings.parameterListScrollTop;
        };
        xhr.send();
    }

    function addRow(key: string, value: string){
        let row = document.createElement("tr");

        // Param name
        let keyCell = document.createElement("td");
        keyCell.innerHTML = key;
        row.appendChild(keyCell);

        // Param value
        let valueCell = document.createElement("td");
        valueCell.innerHTML = value;
        row.appendChild(valueCell);

        // Add row
        table.appendChild(row);
    }
}