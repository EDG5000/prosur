namespace Main{

    // Elements
    export let canvas: HTMLCanvasElement = null;
    export let sessionListContainer: HTMLElement;
    export let mouseValueContainer: HTMLElement;
    export let legend: HTMLElement;

    // Settings stored in local storage
    export namespace Settings{
        export let selectedColumns = typeof localStorage.selectedColumns == "undefined" ? {} : JSON.parse(localStorage.selectedColumns);
        export let zoom = isNaN(localStorage.zoom) ? 1 : parseFloat(localStorage.zoom);
        export let pan = isNaN(localStorage.pan) ? 1 : parseFloat(localStorage.pan);
    }

    // Chunk holder (chunky)
    export let chunks: any[] = null;

    let init = function(){
        // Get elements
        sessionListContainer = document.getElementById("session-list");
        mouseValueContainer = document.getElementById("mouse-value");
        legend = document.getElementById("legend");
        canvas = document.getElementsByTagName("canvas")[0];

        // Init
        Const.init();
        Plotter.init();
        MouseControl.init();
        ChunkLoader.init();

        // Load session list
        JobList.init(function(){
            // Load last session
            /*if(typeof localStorage.lastSession != "undefined"){
                ChunkLoader.load(localStorage.lastSession);
            }*/
            /*ChunkManager.tick(function({
                Plotter.rix
            }));*/
            ChunkLoader.tick();
        });
    };

    addEventListener("DOMContentLoaded", init);
}
