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
        const liveView = Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] > (Math.floor(new Date().getTime()/1000)-1);
      
        // Every event, mutate zoom level by 1.
        if(e.deltaY < 0 && Main.Settings.zoom < Const.MAX_ZOOM){
            Main.Settings.zoom += 1;
        }else if(e.deltaY > 0 && Main.Settings.zoom > 0){
            Main.Settings.zoom -= 1;
        }
        updateLabel();
        
        if(liveView){
            // Ensure panning to live data as before the zoom changed to ensure auto-refresh stays active
            Main.Settings.pan = Math.floor(new Date().getTime()/1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
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
        // Mouse movement in pixels
        const walkPixels = (e.pageX - startX);

        // Update startX for next event
        startX = e.pageX;
        const plotWidth = (Main.canvas.width - Const.X_MARGIN);
        const walkTime = (walkPixels / plotWidth) * Const.CHUNK_RANGE[Main.Settings.zoom];
        Main.Settings.pan -= Math.round(walkTime);

        // Limit maximum pan to current time
        if(Main.Settings.pan + Const.CHUNK_RANGE[Main.Settings.zoom] > Math.floor(new Date().getTime()/1000)){
            Main.Settings.pan = Math.floor(new Date().getTime()/1000) - Const.CHUNK_RANGE[Main.Settings.zoom];
        }
        
        Main.canvasInvalidated = true;
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.Settings.zoom * 1000) / 1000);
}

}