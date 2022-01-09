namespace Main{

    // DOM elements
    export namespace HTMLElements{
        export let scroller: HTMLElement;
        export let scrollerInner: HTMLElement ;
        export let sessionListContainer: HTMLElement;
        export let mouseValueContainer: HTMLElement;
        export let legend: HTMLElement;
    }

    // User settings; stored in local storage
    export namespace UserSettings{
        export let selectedColumns = typeof localStorage.selectedColumns == "undefined" ? {} : JSON.parse(localStorage.selectedColumns);
        export let zoom = isNaN(localStorage.zoom) ? 1 : parseFloat(localStorage.zoom);
    }

    // Data retrieved from Prosurd
    export namespace Data{
        export let frames: any; // Contains one array for each column
        export let parameters: Map<String,String> // Map of parameters belonging to a print job. Received as part of the frames resouce when loading data belonging to a job. Not populated when viewing all frames.
    }

let init = function(){
    // Init DOM nodes
    HTMLElements.sessionListContainer = document.getElementById("session-list");
    HTMLElements.scroller = document.getElementById("scroller");
    HTMLElements.scrollerInner = document.getElementById("scroller-inner");
	HTMLElements.mouseValueContainer = document.getElementById("mouse-value");
    HTMLElements.legend = document.getElementById("legend");

     // Init units
    Plotter.init();
    MouseControl.init();
    FrameLoader.init();

    // Load session list
    JobList.init(function(){
        // Load last session
        if(typeof localStorage.lastSession != "undefined"){
            FrameLoader.load(localStorage.lastSession);
        }
    });
};

addEventListener("DOMContentLoaded", init);

}
