namespace Main{

export let frames: Array<Frame.Frame> = []; // List of Frame objects currently loaded
export let canvas: HTMLCanvasElement = null;
export let ctx: CanvasRenderingContext2D = null;
export let userZoomFactor: number = parseFloat(localStorage.zoomLevel);
export let loading = false;
export let sessionListContainer = null;
export let currentSensorLabels: Array<string>; // Labels are set either from constants or from deserializing CSV header

let init = function(){
    if(isNaN(userZoomFactor)){
        userZoomFactor = 1;
    }

    // Get DOM nodes and canvas context
    canvas = document.getElementsByTagName("canvas")[0];
    ctx = canvas.getContext("2d");
    sessionListContainer = document.getElementById("session-list");
 
    // Add mouse listener
    canvas.addEventListener("wheel", function(e: any){
        if(e.deltaY > 0){
            userZoomFactor + .1;
        }else{
            userZoomFactor - .1;
        }
        localStorage.zoomLevel = userZoomFactor;
        console.log(localStorage.zoomLevel);
        Drawer.draw();
    });

    // Init units
    SessionLoader.init();

    // Load session list
    SessionList.init();
    
    // Load last session
    if(typeof localStorage.lastSession != "undefined"){
        SessionLoader.load(localStorage.lastSession);
    }
};

addEventListener("DOMContentLoaded", init);

}
