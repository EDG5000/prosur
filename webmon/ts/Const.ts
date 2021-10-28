namespace Const{

// Sensor colors and labels
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

// Data folder and current log fle
export let DATA_FOLDER: string;
if(TEST_MODE){
    DATA_FOLDER = "testdata";
}else{
    DATA_FOLDER = "mnt-data";
}
export const CURRENT_LOG_FILE = "hc3d-temp.csv";

// Graph constants
export const frequencyHz = 1; // Assumed frequency of souce data. (timestamps ignored)
export const windowTimeSpanS = 60 * 60; // Display 1 hr of data in one windows' width
export const baseZoomFactor = windowTimeSpanS / window.innerWidth; // Frames per pixel? TODO
export const canvasHeight = window.innerHeight - 100;
export const xGridInterval = 60; // Seconds
export const yGridInterval = 0.1; // Relative to graph height
export const yMargin = 30;
export const xMargin = 50;
export const labelEdgeOffset = 10;
export const xLabelYOffset = 10;

}