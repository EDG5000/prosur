namespace JobList{
    export let addedLinks: Array<HTMLAnchorElement>; // Used when adjusting selection state

    export function markActiveJob(jobId: number){

        // Mark the correct link as selected
        for(let linkIndex in addedLinks){
            let link = addedLinks[linkIndex];
            if(link.dataset.jobId == (jobId + "")){
                link.style.border = "1px solid black";
            }else{
                link.style.border = "none";
            }
        }
    }

    // Load list of available log files and initiate load of the last-loaded file
    export function init(cb: Function){    

        // Pan the plotter and load job data when clicking on a job
        Main.jobListContainer.addEventListener("click", function(e: Event){
            e.preventDefault();
            let link: HTMLAnchorElement = <HTMLAnchorElement> e.target;
            const time = parseInt(link.dataset.time);
            if(time != Main.Settings.pan){
                if(isNaN(time)){
                    debugger;
                }
                Main.Settings.pan = time;
                //console.log(Main.Settings.pan);
                MouseControl.onPan();
                Main.canvasInvalidated = true;
            }
        });

        // Persist scroll position of the panel (rate limited)
        let frameRequest: number;
        Main.jobListContainer.addEventListener("scroll", function(e: Event){
            if(frameRequest != -1){
                cancelAnimationFrame(frameRequest);
            }
            frameRequest = requestAnimationFrame(function(){
                frameRequest = -1;
                Main.Settings.jobListScrollTop = Main.jobListContainer.scrollTop;
                localStorage.jobListScrollTop = Main.Settings.jobListScrollTop;
            });
            
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
                link.href = "#";
            
                // Cap values beyond ~2032; some test data has timestamps all the way in the upcoming dyson-sphere epoch; within the int64_t allowed limit, but not within JavaScript's 32-bit floating point Numbers.
                if(job.time > 1957071184){
                    job.time = 1957071184;
                }

                link.dataset.time = job.time;
                link.dataset.jobId = job.job_id;
                const dateTimeString = Util.createTimeLabel(job.time);
                const jobName = job.job_file_name.replace("0:/gcodes/", "").replace(".gcode", "");
                link.innerText = jobName + "(" + dateTimeString + ")";
                addedLinks.push(link);
                Main.jobListContainer.appendChild(link);
                Main.jobListContainer.appendChild(document.createElement("br"));
            }

            // Restore scroll position
            Main.jobListContainer.scrollTop = Main.Settings.jobListScrollTop;
            cb();
        };

        // URL is set to Apache directory index containing log file
        let url: string;
        url = "/jobs";
        xhr.open("GET", url, true);

        // Start the XHR request
        xhr.send();
    }

}