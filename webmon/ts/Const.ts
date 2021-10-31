namespace Const{

export const zoomAffector = 0.05;


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
    "#e6194B",
    "#3cb44b",
    "#4363d8",
    "#f58231",
    "#911eb4",
    "#42d4f4",
    "#f032e6",
    "#bfef45",
    "#fabed4",
    "#469990",
    "#dcbeff",
    "#9A6324",
    "#fffac8",
    "#800000",
    "#aaffc3",
    "#808000",
    "#ffd8b1",
    "#000075",
    "#a9a9a9",
    "#ffffff",
    "#000000"
];

// Data folder and current log fle
export let DATA_FOLDER: string;
if(Config.testMode){
    DATA_FOLDER = "testdata";
}else{
    DATA_FOLDER = "mnt-data";
}
export const CURRENT_LOG_FILE = "hc3d-temp.csv";

export const sidebarWidth = 170; // px; needs to match with values in CSS

// Graph constants
export const frequencyHz = 1; // Assumed frequency of souce data. (timestamps ignored)
export const windowTimeSpanS = 60 * 60; // Display 1 hr of data in one windows' width
export const baseZoomFactor = windowTimeSpanS / window.innerWidth; // Pixels per frame (pixels per frequencyHz seconds)
export const xGridInterval = 0.1; // Relative to graph width
export const yGridInterval = 0.1; // Relative to graph height
export const yMargin = 40;
export const xMargin = 50;
export const yLabelXOffset = 10;
export const xLabelYOffset = 20;
export const scrollBarSize = 50; // Needs to be set to browser scroll bar size or larger

}