namespace Main{

export const TEST_MODE = true;
export const SENSOR_LABELS = [
    "Chamber Mid",
    "Chamber Top",
    "Chamber Heater",
    "Motor X", 
    "Motor Y",
    "Motor Z",
    "Motor E"
];
export const SENSOR_COLORS = [
    "red",
    "green",
    "darkmagenta",
    "purple",
    "grey",
    "orange",
    "darkgreen"
];
export let DATA_FOLDER: string;
if(TEST_MODE){
    DATA_FOLDER = "testdata";
}else{
    DATA_FOLDER = "mnt-data";
}
export const CURRENT_LOG_FILE = "hc3d-temp.csv";

export let frames: Array<Frame.Frame> = []; // List of Frame objects currently loaded
export let canvas: HTMLCanvasElement = null;
export let ctx: CanvasRenderingContext2D = null;
export let userZoomFactor: number = parseFloat(localStorage.zoomLevel);
//export let sessionFilenames: Array<string> = []; // List of filenames available
export let loading = false;
export let sessionListContainer = null;

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
