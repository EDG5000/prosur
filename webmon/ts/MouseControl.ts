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
        // Every event, mutate zoom level by 1. Max is Const.MAX_ZOOM. Min = 
        if(e.deltaY < 0 && Main.Settings.zoom < Const.MAX_ZOOM){
            //Main.UserSettings.zoom *= (1 + Const.ZOOM_AFFECTOR);
            //Main.setZoom(Main.Settings.zoom + 1);
            Main.Settings.zoom += 1;
        }else if(e.deltaY > 0 && Main.Settings.zoom > 0){
            //Main.UserSettings.zoom *= (1 - Const.ZOOM_AFFECTOR);
            Main.Settings.zoom -= 1;
        }
        /*
        if(Main.UserSettings.zoom == 0){
            Main.UserSettings.zoom = 1;
        }
        */
       
        //localStorage.zoom = Main.Settings.zoom;
        updateLabel();
        
        //Main.HTMLElements.scroller.scrollLeft = 
        //Main.Settings.pan = Main.Settings.pan - Main.Settings.pan * Main.HTMLElements.scroller.scrollWidth;;
        // TODO set pan
        //localStorage.pan = Main.Settings.pan;
        Main.canvasInvalidated = true;
    });

    Main.canvas.addEventListener("mousedown", e => {
        if(e.button != 0){
            // Ignore if not left button
            return;
        }
        //e.preventDefault();
        isDown = true;
        startX = e.pageX;
    }); 

    addEventListener("mouseout", (e: any) => {
        if(e.toElement == null){
            // We moved out of the browser window, stop tracking the mouse, otherwise, keep tracking it
            //console.log(e);
            //e.preventDefault();
            isDown = false;
        }
    });

    addEventListener("mouseup", (e) => {
        //e.preventDefault();
        isDown = false;
    });

    addEventListener("mousemove", e => {
        //e.preventDefault();
        // TODO
        //Plotter.onMouseMove(e.offsetX, e.offsetY);

        if (!isDown) return;
        e.preventDefault();
        // Mouse movement in pixels
        const walkPixels = (e.pageX - startX);

        // Update startX for next event
        startX = e.pageX;

        //console.log("Walk pixels: " + walkPixels);
        const plotWidth = (Main.canvas.width - Const.X_MARGIN);
        //console.log("Plotwidth: " + plotWidth);
        //console.log("Walkpixels/plotwidth: " + (walkPixels / plotWidth));
        //console.log("Chunk range: " + Const.CHUNK_RANGE[Main.Settings.zoom]);
        
        const walkTime = (walkPixels / plotWidth) * Const.CHUNK_RANGE[Main.Settings.zoom];
        //console.log("Walk time: " + walkTime);
        Main.Settings.pan -= Math.round(walkTime);
        Main.canvasInvalidated = true;
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.Settings.zoom * 1000) / 1000);
}

}