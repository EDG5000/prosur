namespace Drawer{

let canvasWidth: number;
let scaleY: number;
let yMin: number = null;
let yMax: number = null;
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
	scaleX = Main.userZoomFactor * Const.baseZoomFactor;
	canvasWidth = Main.frames.length * scaleX;
	// Each plot has different frame count, therefore canvas element has different size	
	Main.canvas.width = canvasWidth;
	Main.canvas.height = Const.canvasHeight;
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
	scaleY = (Const.canvasHeight - Const.yMargin) / (yMax-yMin);
 
	// Start drawing grid 
	Main.ctx.strokeStyle = "silver";
	Main.ctx.beginPath(); 
	Main.ctx.font = "1em monospace";

	// Draw horizontal grid lines and axis labels
	let yRelative = 0;
	Main.ctx.textAlign = "right";
	let valueString: string;
	while(yRelative <= 1){
		let yValue = yMin + ((yMax-yMin) * (1-yRelative));
		let yPosition = (Const.canvasHeight-Const.yMargin) * yRelative;
		Main.ctx.moveTo(Const.xMargin, yPosition);
		Main.ctx.lineTo(canvasWidth, yPosition);
		valueString = yValue.toFixed(1);
		// These offsets should be constants!
		let labelYOffset = 4;
		if(yRelative == 0){
			labelYOffset = 10;
		}else if(yRelative == 1){
			labelYOffset = -10;
		}
		Main.ctx.fillText(valueString, Const.xMargin - Const.labelEdgeOffset, yPosition + labelYOffset);
		yRelative += Const.yGridInterval;
	}

	// Draw vertical grid lines and axis labels
	let xValue = 0;
	while(xValue <= xMax){
		let xPosition = Const.xMargin + xValue * scaleX;
		Main.ctx.moveTo(xPosition, 0);
		Main.ctx.lineTo(xPosition, Const.canvasHeight - Const.yMargin);
		let timeUnix = startTimeUnix + (xValue / Const.frequencyHz);
		valueString = Util.createTimeLabel(timeUnix);
		if(xValue == 0){
			Main.ctx.textAlign = "left";
		}else if(xValue == xMax){
			Main.ctx.textAlign = "right";
		}else{
			Main.ctx.textAlign = "center";
		}
		Main.ctx.fillText(valueString, xPosition, Const.canvasHeight - Const.xLabelYOffset);
		xValue += Const.xGridInterval;  
	} 
	Main.ctx.stroke();

	for(let sensorIndex = 0; sensorIndex < Const.SENSOR_COLORS.length; sensorIndex++){
		// Complete drawing of grid
		let color = Const.SENSOR_COLORS[sensorIndex];
		Main.ctx.strokeStyle = color;
		
		Main.ctx.beginPath();
		
		// Draw data
		let val = Main.frames[0].temps[sensorIndex];
		Main.ctx.moveTo(Const.xMargin, Const.canvasHeight - ((val-yMin) * scaleY) - Const.yMargin);
		for(let frameIndex = 0; frameIndex < Main.frames.length; frameIndex++){
			
			val = Main.frames[frameIndex].temps[sensorIndex];
			let xPos = (frameIndex/Const.frequencyHz) * scaleX + Const.xMargin;
			let yPos = Const.canvasHeight - ((val-yMin) * scaleY) - Const.yMargin;
			Main.ctx.lineTo(xPos, yPos);
		}
		
		Main.ctx.stroke();
	}

	// Complete drawing of grid
	Main.ctx.strokeStyle = 'black';
	Main.ctx.stroke();
}

}