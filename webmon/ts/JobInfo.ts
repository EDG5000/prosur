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

        let url = Const.URL_SCHEME + Const.HOST + ":" + Const.PORT + "/frames?mode=job&job_id=" + jobId;

        let xhr = new XMLHttpRequest();
        xhr.responseType = 'json';
        xhr.open("GET", url, true);
        xhr.onreadystatechange = function() {
            // Error checking
            if(xhr.readyState != Const.XHR.DONE){
                return;
            }
            if(typeof xhr.response == "undefined" || xhr.response == null){
                console.error("XHR response not present. Value: " + xhr.response);
                return;
            }
            let parameters = xhr.response.parameters;
            if(typeof parameters == "undefined" || parameters == null || parameters.length == 0){
                console.error("JobInfo: Parameters not present. Value: " + parameters);
                return;
            }

            // Construct table
            let table = document.createElement("table");
            for(let key in parameters){
                let value = parameters[key];
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
            Main.parameterListContainer.innerHTML = "";
            Main.parameterListContainer.appendChild(table);

        };
        xhr.send();
    }
}