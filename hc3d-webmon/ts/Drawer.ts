namespace Drawer{

// Frequency of souce data. Could be derrived from timestamps alternatively.
// TODO indicate gaps in the data?
const frequencyHz = 1;
const windowTimeSpanS = 60 * 60; // Display 1 hr of data in one windows' width
const baseZoomFactor = windowTimeSpanS / window.innerWidth; // Frames per pixel? TODO
const canvasHeight = window.innerHeight;
const xGridInterval = 60; // Seconds
const yGridInterval = 0.1; // Relative to graph height
const yMargin = 30;
const xMargin = 50;
const labelEdgeOffset = 10;
const xLabelYOffset = 10;

let canvasWidth: number;
let scaleY: number;
let yMin = null;
let yMax = null;
let scaleX: number;
let xMax: number;
let startTimeUnix: number;

export function draw(){
	if(Main.frames.length == 0){
		return;
	}
	xMax = Main.frames.length;
	startTimeUnix = Main.frames[0].timeUnix;

	// Calculate width of canvas based on time resolution, fixed scale factor and user zoom level
	scaleX = Main.userZoomFactor * baseZoomFactor;
	canvasWidth = Main.frames.length * scaleX;
	// Each plot has different frame count, therefore canvas element has different size	
	Main.canvas.width = canvasWidth;
	Main.canvas.height = canvasHeight;
	Main.canvas.style.width = canvasWidth + "";
	
	// Determine yRange
	let frame: Frame.Frame;
	for(frame of Main.frames){
		for(let temp of frame.temps){
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
	Main.ctx.strokeStyle = "#000";
	Main.ctx.beginPath(); 
	Main.ctx.font = "1em monospace";
	

	// Draw horizontal grid lines and axis labels
	let yRelative = 0;
	Main.ctx.textAlign = "right";
	let valueString: string;
	while(yRelative <= 1){
		let yValue = yMin + ((yMax-yMin) * (1-yRelative));
		let yPosition = (canvasHeight-yMargin) * yRelative;
		Main.ctx.moveTo(xMargin, yPosition);
		Main.ctx.lineTo(canvasWidth, yPosition);
		valueString = yValue.toFixed(1);
		// These offsets should be constants!
		let labelYOffset = 4;
		if(yRelative == 0){
			labelYOffset = 10;
		}else if(yRelative == 1){
			labelYOffset = -10;
		}
		Main.ctx.fillText(valueString, xMargin - labelEdgeOffset, yPosition + labelYOffset);
		yRelative += yGridInterval;
	}

	// Draw vertical grid lines and axis labels
	let xValue = 0;
	while(xValue <= xMax){
		let xPosition = xMargin + xValue * scaleX;
		Main.ctx.moveTo(xPosition, 0);
		Main.ctx.lineTo(xPosition, canvasHeight - yMargin);
		let timeUnix = startTimeUnix + (xValue / frequencyHz);
		valueString = Util.createTimeLabel(timeUnix);
		if(xValue == 0){
			Main.ctx.textAlign = "left";
		}else if(xValue == xMax){
			Main.ctx.textAlign = "right";
		}else{
			Main.ctx.textAlign = "center";
		}
		Main.ctx.fillText(valueString, xPosition, canvasHeight - xLabelYOffset);
		xValue += xGridInterval;  
	} 
	Main.ctx.stroke();
//return;
	for(let sensorIndex = 0; sensorIndex < Main.SENSOR_COLORS.length; sensorIndex++){
		// Complete drawing of grid
		let color = Main.SENSOR_COLORS[sensorIndex];
		Main.ctx.strokeStyle = color;
		
		Main.ctx.beginPath();
		
		// Draw data
		let val = Main.frames[0].temps[sensorIndex];
		Main.ctx.moveTo(xMargin, canvasHeight - ((val-yMin) * scaleY) - yMargin);
		for(let frameIndex = 0; frameIndex < Main.frames.length; frameIndex++){
			
			val = Main.frames[frameIndex].temps[sensorIndex];
			let xPos = (frameIndex/frequencyHz) * scaleX + xMargin;
			let yPos = canvasHeight - ((val-yMin) * scaleY) - yMargin;
			Main.ctx.lineTo(xPos, yPos);
			//if(isNaN(yPos)){
				//console.log(yPos);
			//}
		}
		
		Main.ctx.stroke();
	}

	// Complete drawing of grid
	Main.ctx.strokeStyle = 'black';
	Main.ctx.stroke();
}

}