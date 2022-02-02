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
            Main.Settings.zoom += 1;
        }else if(e.deltaY > 0 && Main.Settings.zoom > (Const.MIN_ZOOM + 1)){
            //Main.UserSettings.zoom *= (1 - Const.ZOOM_AFFECTOR);
            Main.Settings.zoom -= 1;
        }
        /*
        if(Main.UserSettings.zoom == 0){
            Main.UserSettings.zoom = 1;
        }
        */
       
        localStorage.zoom = Main.Settings.zoom;
        updateLabel();
        
        //Main.HTMLElements.scroller.scrollLeft = 
        //Main.Settings.pan = Main.Settings.pan - Main.Settings.pan * Main.HTMLElements.scroller.scrollWidth;;
        // TODO set pan
        localStorage.pan = Main.Settings.pan;
        Main.tick();
    });

    Main.canvas.addEventListener("mousedown", e => {
        isDown = true;
        startX = e.pageX;
        Main.tick();
    });

    Main.canvas.addEventListener("mouseleave", () => {
        isDown = false;
    });

    Main.canvas.addEventListener("mouseup", () => {
        isDown = false;
    });

    Main.canvas.addEventListener("mousemove", e => {
        // TODO
        //Plotter.onMouseMove(e.offsetX, e.offsetY);

        if (!isDown) return;
        e.preventDefault();
        const walk = Main.Settings.pan - (e.pageX - startX);
        localStorage.pan = Main.Settings.pan;
        Main.tick();
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.Settings.zoom * 1000) / 1000);
}

}