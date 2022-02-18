namespace Main{

    // Elements
    export let canvas: HTMLCanvasElement = null;
    export let jobListContainer: HTMLElement;
    export let mouseValueContainer: HTMLElement;
    export let legend: HTMLElement;
    export let parameterListContainer: HTMLElement;
    export let timelineContainer: HTMLElement;

    // Settings stored in local storage
    export namespace Settings{
        export let selectedColumns = typeof localStorage.selectedColumns == "undefined" ? {} : JSON.parse(localStorage.selectedColumns);
        export let zoom = isNaN(localStorage.zoom) ? 1 : parseFloat(localStorage.zoom);
        export let pan = isNaN(localStorage.pan) ? Math.floor(new Date().getTime()/1000) : parseFloat(localStorage.pan);
        export let jobListScrollTop =  isNaN(localStorage.jobListScrollTop) ? 0 : parseFloat(localStorage.jobListScrollTop);
        export let parameterListScrollTop =  isNaN(localStorage.parameterListScrollTop) ? 0 : parseFloat(localStorage.parameterListScrollTop);
    }

    // Derrived from Settings before or during drawing each frame
    export let leftChunkTime = -1; // Updated prior
    export let rightChunkTime = -1; // Updated prior
    export let jobId = -1; // Updated during drawing

    // Chunk holder (chunky)
    export let chunks: any[] = null;

    export let canvasInvalidated = true;
    export let liveView = false;

    let init = function(){
        // Get elements
        jobListContainer = document.getElementById("job-list");
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
        JobInfo.init();
        MouseControl.init();

        JobList.init(function(){
            // Start drawing loop
            draw(); 

            // Start timeline update loop. Otherwise while panning a 60fps update rate will be attempted, which floods the server
            setInterval(function(){
                Timeline.tick();
            }, 1000 / 6); // (6 fps)
        });
    };

    export function draw(){
        if(canvasInvalidated){
            canvasInvalidated = false;
            const range = Const.CHUNK_RANGE[Main.Settings.zoom];
            const autoScroll = Main.liveView && MouseControl.getMaxPan() != Main.Settings.pan;
            if(autoScroll){
                Main.Settings.pan = Math.floor(new Date().getTime()/1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
            }
            leftChunkTime = Math.floor(Main.Settings.pan / range) * range;
            rightChunkTime = leftChunkTime + range;
            if(autoScroll){
                delete Main.chunks[Main.Settings.zoom][Main.rightChunkTime + ""];
            }
            ChunkLoader.get(leftChunkTime, Settings.zoom, function(){
                ChunkLoader.get(rightChunkTime, Settings.zoom);
            });

            
            Plotter.draw();
            localStorage.pan = Main.Settings.pan;
            localStorage.zoom = Main.Settings.zoom;
            
        }
        
        requestAnimationFrame(draw);
    }

    addEventListener("DOMContentLoaded", init);
}
