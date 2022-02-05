namespace Main{

    // Elements
    export let canvas: HTMLCanvasElement = null;
    export let sessionListContainer: HTMLElement;
    export let mouseValueContainer: HTMLElement;
    export let legend: HTMLElement;
    export let parameterListContainer: HTMLElement;
    export let timelineContainer: HTMLElement;

    // Settings stored in local storage
    export namespace Settings{
        export let selectedColumns = typeof localStorage.selectedColumns == "undefined" ? {} : JSON.parse(localStorage.selectedColumns);
        export let zoom = isNaN(localStorage.zoom) ? 1 : parseFloat(localStorage.zoom);
        export let pan = isNaN(localStorage.pan) ? Math.floor(new Date().getTime()/1000) : parseFloat(localStorage.pan);
       
    }

    // Derrived from Settings before or during drawing each frame
    export let leftChunkTime = -1; // Updated prior
    export let rightChunkTime = -1; // Updated prior
    export let jobId = -1; // Updated during drawing

    // Chunk holder (chunky)
    export let chunks: any[] = null;

    export let canvasInvalidated = true;

    let init = function(){
        // Get elements
        sessionListContainer = document.getElementById("session-list");
        mouseValueContainer = document.getElementById("mouse-value");
        parameterListContainer = document.getElementById("parameter-list");
        timelineContainer = document.getElementById("timeline");
        legend = document.getElementById("legend");
        canvas = document.getElementsByTagName("canvas")[0];

        // Init
        Const.init();
        Plotter.init();
        ChunkLoader.init();
        Timeline.init();
        JobList.init()
        MouseControl.init();

        draw();
    };

    export function draw(){
        if(canvasInvalidated){
            canvasInvalidated = false;
            const range = Const.CHUNK_RANGE[Main.Settings.zoom];
            leftChunkTime = Math.floor(Main.Settings.pan / range) * range;
            rightChunkTime = leftChunkTime + range;
    
            ChunkLoader.tick();
            Timeline.tick();
            Plotter.draw();
            localStorage.pan = Main.Settings.pan;
            //console.log("Persisting: " + localStorage.pan);
            localStorage.zoom = Main.Settings.zoom;
            
        }
        
        requestAnimationFrame(draw);
    }

    addEventListener("DOMContentLoaded", init);
}
