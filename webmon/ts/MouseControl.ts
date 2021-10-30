namespace MouseControl{
    
let label: HTMLElement;

// Mouse panning
let isDown = false;
let startX: number;
let scrollLeft: number;

export function init(){
    label = document.getElementById("zoomLevel");

    Main.zoom = parseFloat(localStorage.zoom);
    if(isNaN(Main.zoom)){
        Main.zoom = 1;
    }

    updateLabel();

    // Add mouse listener
    Main.canvas.addEventListener("wheel", function(e: any){
        if(e.deltaY < 0){
            Main.zoom *= (1 + Const.zoomAffector);
        }else{
            Main.zoom *= (1 - Const.zoomAffector);
        }
        if(Main.zoom == 0){
            Main.zoom = 1;
        }
        localStorage.zoom = Main.zoom;
        updateLabel();
        Drawer.draw();
    });

    addEventListener("mousedown", e => {
        isDown = true;
        Main.canvas.classList.add("active");
        startX = e.pageX - Main.canvas.offsetLeft;
        scrollLeft = Main.canvas.scrollLeft;
    });

    addEventListener("mouseleave", () => {
        isDown = false;
        Main.canvas.classList.remove("active");
    });

    addEventListener("mouseup", () => {
        isDown = false;
        Main.canvas.classList.remove("active");
    });

    addEventListener("mousemove", e => {
        if (!isDown) return;
        e.preventDefault();
        const x = e.pageX - Main.canvas.offsetLeft;
        const walk = x - startX;
        Main.canvas.scrollLeft = scrollLeft - walk;
    });
}

export function updateLabel(){
    label.innerText = "" + (Math.round(Main.zoom * 1000) / 1000);
}

}