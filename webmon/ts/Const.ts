namespace Const{

export const HOST = "localhost";
export const PORT = 8080;

export const SENSOR_COLORS = [
    "#e6194B",
    "#3cb44b",
    "#7d90d6",
    "#f58231",
    "#db7af8",
    "#42d4f4",
    "#f032e6",
    "#469990",
    "#dcbeff",
    "#9A6324",
    "#fffac8",
    "#aaffc3",
    "#ffd8b1",
    "#a9a9a9",// end
    "#e6194B",
    "#3cb44b",
    "#7d90d6",
    "#f58231",
    "#db7af8",
    "#42d4f4",
    "#f032e6",
    "#469990",
    "#dcbeff",
    "#9A6324",
    "#fffac8",
    "#aaffc3",
    "#808000",
    "#ffd8b1",
    "#a9a9a9",
];

export const XHR_SUCCESS = 4;
export const ZOOM_AFFECTOR = 0.05;
export const SIDEBAR_WIDTH = 400; // px; needs to match with values in CSS
export const FREQ_HZ = 1; // Assumed frequency of souce data. (timestamps ignored)
export const WINDOW_TIME_SPAN_S = 60 * 60; // Display 1 hr of data in one windows' width
export const BASE_ZOOM_FACTOR = WINDOW_TIME_SPAN_S / window.innerWidth; // Pixels per frame (pixels per frequencyHz seconds)
export const X_GRID_INTERVAL = 0.1; // Relative to graph width
export const Y_GRID_INTERVAL = 0.1; // Relative to graph height
export const Y_MARGIN = 40;
export const X_MARGIN = 50;
export const Y_LABEL_X_OFFSET = 10;
export const X_LABEL_Y_OFFSET = 20;
export const SCROLL_BAR_SIZE = 50; // Needs to be set to browser scroll bar size or larger

}
