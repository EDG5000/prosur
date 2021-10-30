namespace Drawer{

let scaleY: number; // Pixels per y value
let yMin: number = null;
let yMax: number = null;
let scaleX: number; // Pixels per frame
let xMax: number;
let startTimeUnix: number;
let xMin: number;

export function init(){
	let active = false;
	Main.scroller.addEventListener("scroll", function(e: Event){
		if(!active){
			requestAnimationFrame(function(){
				Main.pan = Main.scroller.scrollLeft/Main.scroller.scrollWidth;
				draw();
				active = false;
			});
			active = true;
		}
	});
}

export function draw(){
	if(Main.frames.length == 0){
		return;
	}
	startTimeUnix = Main.frames[0].timeUnix;
	// Scale product base factor and user factor
	scaleX = Main.zoom * Const.baseZoomFactor;
	Main.scrollerInner.style.width = (Main.frames.length * scaleX) + "px";
	Main.canvas.width = Main.canvas.clientWidth;
	Main.canvas.height = Main.canvas.clientHeight;
	xMin = Math.floor(Main.frames.length * Main.pan);
	xMax = Math.floor(xMin + (Main.canvas.width-Const.xMargin) / scaleX);

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
	scaleY = (Main.canvas.height - Const.yMargin) / (yMax-yMin);
 
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
		let yPosition = (Main.canvas.height-Const.yMargin) * yRelative;
		Main.ctx.moveTo(Const.xMargin, yPosition);
		Main.ctx.lineTo(Main.canvas.width, yPosition);
		valueString = yValue.toFixed(1);
		// These offsets should be constants!
		let ylabelYOffset = 4;
		if(yRelative == 0){
			ylabelYOffset = 10;
		}else if(yRelative == 1){
			ylabelYOffset = -10;
		}
		Main.ctx.fillText(valueString, Const.xMargin - Const.yLabelXOffset, yPosition + ylabelYOffset);
		yRelative += Const.yGridInterval;
	}

	// Draw vertical grid lines and axis labels
	let xRelative = 0;
	while(xRelative <= 1){
		let xValue = xMin + (xMax-xMin) * xRelative;
		let xPosition = Const.xMargin + (xValue - xMin) * scaleX;
		Main.ctx.moveTo(xPosition, 0);
		Main.ctx.lineTo(xPosition, Main.canvas.height - Const.yMargin);
		let timeUnix = startTimeUnix + (xValue / Const.frequencyHz);
		valueString = Util.createTimeLabel(timeUnix);
		if(xValue - xMin == 0){
			Main.ctx.textAlign = "left";
		}else if(xValue == xMax){
			Main.ctx.textAlign = "right";
		}else{
			Main.ctx.textAlign = "center";
		}
		Main.ctx.fillText(valueString, xPosition, Main.canvas.height - Const.xLabelYOffset);
		xRelative +=  Const.xGridInterval;
	} 

	Main.ctx.stroke();

	for(let sensorIndex = 0; sensorIndex < Main.currentSensorLabels.length; sensorIndex++){
		// Complete drawing of grid
		let color = Const.SENSOR_COLORS[sensorIndex];
		Main.ctx.strokeStyle = color;
		
		Main.ctx.beginPath();
		
		// Draw data
		if(typeof Main.frames[xMin] == "undefined"){
			console.log(Main.frames[xMin]);
		}
		let val = Main.frames[xMin].temps[sensorIndex];
		Main.ctx.moveTo(Const.xMargin, Main.canvas.height - ((val-yMin) * scaleY) - Const.yMargin);
		for(let frameIndex = xMin; frameIndex < xMax; frameIndex++){
			val = Main.frames[frameIndex].temps[sensorIndex];
			let xPos = ((frameIndex - xMin)/Const.frequencyHz) * scaleX + Const.xMargin;
			let yPos = Main.canvas.height - ((val-yMin) * scaleY) - Const.yMargin;
			Main.ctx.lineTo(xPos, yPos);
		}
		
		Main.ctx.stroke();
	}

	// Complete drawing of grid
	Main.ctx.strokeStyle = 'black';
	Main.ctx.stroke();
}

}