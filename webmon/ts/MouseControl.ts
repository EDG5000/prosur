namespace MouseControl{
    
let label: HTMLElement;

// Mouse panning
let isDown = false;
let startX: number;

export function init(){
    label = document.getElementById("zoom-level");

    updateLabel();

    // Add mouse listener
    Main.canvas.addEventListener("wheel", function(e: any){
        // Every event, mutate zoom level by 1.
        if(e.deltaY < 0 && Main.Settings.zoom < Const.MAX_ZOOM){
            Main.Settings.zoom += 1;
        }else if(e.deltaY > 0 && Main.Settings.zoom > 0){
            Main.Settings.zoom -= 1;
        }
        updateLabel();
        
        if(Main.Settings.liveView){
            //console.log("liveView");
            // Correct pan to ensure right boundary of screen matches with current time
            Main.Settings.pan = getMaxPan();
        }

        Main.canvasInvalidated = true;
    });

    Main.canvas.addEventListener("mousedown", e => {
        if(e.button != 0){
            // Ignore if not left button
            return;
        }
        isDown = true;
        startX = e.pageX;
    }); 

    addEventListener("mouseout", (e: any) => {
        if(e.toElement == null){
            // We moved out of the browser window, stop tracking the mouse, otherwise, keep tracking it
            isDown = false;
        }
    });

    addEventListener("mouseup", (e) => {
        isDown = false;
    });

    addEventListener("mousemove", e => {
        // Update value label
        Plotter.onMouseMove(e.offsetX, e.offsetY);

        if (!isDown) return;
        e.preventDefault();
        // Mouse movement in pixels; reset walk origin
        const walkPixels = (e.pageX - startX);
        startX = e.pageX;

        // Calculated correct pan time offset based on walk pixel distance
        const plotWidth = (Main.canvas.width - Const.X_MARGIN);
        const walkTime = (walkPixels / plotWidth) * Const.CHUNK_RANGE[Main.Settings.zoom];
        Main.Settings.pan -= Math.round(walkTime);

        // When scrolled to maximum or more, set to limit and raise flag.
        if(isPannedToMaximum()){
            Main.Settings.pan = getMaxPan();
            Main.Settings.liveView = true;
            localStorage.liveView = true;
        }else{
            Main.Settings.liveView = false;
            localStorage.liveView = false;
        }

        Main.canvasInvalidated = true;
    });
}

export function getMaxPan(){
    const pan = Math.floor(new Date().getTime()/1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
    if(isNaN(pan)){
        debugger;
    }
    return pan;
}

// When scrolled to maximum or more
function isPannedToMaximum(){
    return Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] > (Math.floor(new Date().getTime()/1000)-1);
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.Settings.zoom * 1000) / 1000);
}

}