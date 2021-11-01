namespace Main{

export let scroller: HTMLElement = null;
export let scrollerInner: HTMLElement = null;
export let frames: Array<Frame.Frame> = []; // List of Frame objects currently loaded
export let canvas: HTMLCanvasElement = null;
export let ctx: CanvasRenderingContext2D = null;
export let zoom: number = 1;
export let loading: boolean = false;
export let sessionListContainer: HTMLElement = null;
export let currentSensorLabels: Array<string>; // Labels are set either from constants or from deserializing CSV header
export let pan: number = 0;

let init = function(){
    // Get DOM nodes and canvas context
    canvas = document.getElementsByTagName("canvas")[0];
    ctx = canvas.getContext("2d");
    // Uncommented, there is suspicion is causes regression with the positioning, more than half a pixel
    //ctx.translate(0.5, 0.5); // Allegedly "fixes" "blurryness" 
    //ctx.lineWidth = 2;
    sessionListContainer = document.getElementById("session-list");
    scroller = document.getElementById("scroller");
    scrollerInner = document.getElementById("scroller-inner");

    Drawer.init();
    MouseControl.init();

    // Init units
    SessionLoader.init();

    // Load session list
    SessionList.init(function(){
        // Load last session
        if(typeof localStorage.lastSession != "undefined"){
            SessionLoader.load(localStorage.lastSession);
        }
    });
    
    addEventListener("resize", function(){
        requestAnimationFrame(Drawer.draw);
    });
};

addEventListener("DOMContentLoaded", init);

}
