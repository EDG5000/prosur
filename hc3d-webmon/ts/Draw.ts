// Obtain handles and environment properties

namespace App{

// Frequency of souce data. Could be derrived from timestamps alternatively.
// TODO indicate gaps in the data?
const frequencyHz = 1;
const windowTimeSpanS = 60 * 60; // Display 1 hr of data in one windows' width
const baseZoomFactor = windowTimeSpanS / window.innerWidth; // Frames per pixel? TODO
const canvasHeight = window.innerHeight;
const xGridInterval = 60; // Seconds
const yGridInterval = 0.1; // Relative to graph height
const yMargin = 10;
const xMargin = 10;
const labelEdgeOffset = 10;

let canvasWidth: number;
let scaleY: number;
let yMin = 0;
let yMax = 1;
//let chartWidth: number;
//let chartHeight: number;
let scaleX: number;
let xMax: number;

// Draw window.frames using localStorage.zoomLevel
export var draw = function(){
	xMax = frames.length;

	// Calculate width of canvas based on time resolution, fixed scale factor and user zoom level
	scaleX = userZoomFactor * baseZoomFactor;
	canvasWidth = frames.length * scaleX;
	// Each plot has different frame count, therefore canvas element has different size	
	canvas.width = canvasWidth;
	canvas.height = canvasHeight;
	canvas.style.width = canvasWidth + "";
	
	// Determine yRange
	for(var frame of frames){
		for(var temp of frame.temps){
			if(temp < yMin || yMin == null){
				yMin = temp;
			}
			if(temp > yMax || yMax == null){
				yMax = temp;
			}
		}
	}
	
	if(yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax-yMin) == 0){
		// Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
		yMin -= 1;
		yMax += 1;
	}

	// Calculate drawing scale
	scaleY = (canvasHeight - yMargin) / (yMax-yMin);

	// Start drawing grid
	ctx.beginPath();
	ctx.font = "1em monospace";
	
	// Draw horizontal grid lines and axis labels
	var yRelative = 0;
	ctx.textAlign = "right";
	while(yRelative <= 1){
		var yValue = yMin + ((yMax-yMin) * (1-yRelative));
		var yPosition = (canvasHeight-yMargin) * yRelative;
		ctx.moveTo(xMargin, yPosition);
		ctx.lineTo(canvasWidth, yPosition);
		var valueString = yValue.toFixed(1);
		// These offsets should be constants!
		var labelYOffset = 4;
		if(yRelative == 0){
			labelYOffset = 10;
		}else if(yRelative == 1){
			labelYOffset = -10;
		}
		ctx.fillText(valueString, xMargin - labelEdgeOffset, yPosition + labelYOffset); // TODO add margin as constant
		yRelative += yGridInterval;
	}

	// Draw vertical grid lines and axis labels
	var xValue = 0;
	while(xValue <= xMax){
		var xPosition = xMargin + xValue * scaleX;
		ctx.moveTo(xPosition, 0);
		ctx.lineTo(xPosition, canvasHeight - yMargin);
		var valueString = createTimeLabel(xValue);
		if(xValue == 0){
			ctx.textAlign = "left";
		}else if(xValue == xMax){
			ctx.textAlign = "right";
		}else{
			ctx.textAlign = "center";
		}
		ctx.fillText(valueString, xPosition, canvasHeight-3); // TODO Add X label Y offset as constant
		xValue += xGridInterval;  
	} 

	// Complete drawing of grid
	ctx.strokeStyle = 'silver';
	ctx.stroke();
	ctx.beginPath();

	for(var sensorIndex = 0; sensorIndex < SENSOR_COLORS.length; sensorIndex++){
		var color = SENSOR_COLORS[sensorIndex];
		ctx.strokeStyle = color;
		// Draw data
		var val = frames[0].temps[sensorIndex];
		ctx.moveTo(xMargin, canvasHeight - ((val-yMin) * scaleY) - yMargin);
		for(var i = 1; i < frames.length; i++){
			val = frames[i].temps[sensorIndex];
			var xPos = (i/frequencyHz) * scaleX + xMargin;
			var yPos = canvasHeight - ((val-yMin) * scaleY) - yMargin;
			ctx.lineTo(xPos, yPos);
		}
	}

	// Complete drawing of grid
	ctx.strokeStyle = 'black';
	ctx.stroke();

	// Start drawing axis labels
	ctx.beginPath();
}

}