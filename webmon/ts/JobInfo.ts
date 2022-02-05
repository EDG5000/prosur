namespace JobInfo{
	/*
	 * [
    {
        "job_file_name": "0:/gcodes/CFFFP_Electronics Box.gcode",
        "job_id": 1,
        "time": 1109112242
    }
		]
	 */

    //export let parameters: Map<String,String>
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
            let table = document.createElement("table");
            for(let key in xhr.response){
                let value = xhr.response[key];
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

            // Add table to container
            Main.parameterListContainer.appendChild(table);

        };
        xhr.send();
    }
}