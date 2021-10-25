namespace Logger{

let lastTime = new Date().getTime();

export function i(val: string){
    let time = new Date().getTime();
    console.log("[" + (time-lastTime) + "] ");
    lastTime = time;
}

}