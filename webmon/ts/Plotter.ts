namespace Plotter{

	// Canvas and context
	export let canvas: HTMLCanvasElement = null;
	export let ctx: CanvasRenderingContext2D = null;

	// Values set during plotting
	let scaleY: number; // Pixels per y value
	let yMin: number;
	let yMax: number;
	let scaleX: number; // Pixels per frame
	let xMax: number;
	let startTimeUnix: number;
	let xMin: number;

	export let pan: number = 0;



	export function init(){
		// Get DOM nodes and canvas context
		canvas = document.getElementsByTagName("canvas")[0];
		ctx = canvas.getContext("2d");

		let active = false;
		// Adjust horizontal pan whenever the graph is scrolled horizontally
		Main.HTMLElements.scroller.addEventListener("scroll", function(e: Event){
			if(!active){
				requestAnimationFrame(function(){
					Plotter.pan = Main.HTMLElements.scroller.scrollLeft/Main.HTMLElements.scroller.scrollWidth;
					draw();
					active = false;
				});
				active = true;
			}
		});
		Main.HTMLElements.mouseValueContainer.innerText = (0).toFixed(2);

		addEventListener("resize", function(){
			requestAnimationFrame(Plotter.draw);
		});
	}

	export function onMouseMove(x: number, y: number){
		let yValue = (Math.round(100 * ((yMax - yMin) * (1-(y / (Plotter.canvas.height-Const.Y_MARGIN))) + yMin))/100).toFixed(2);
		Main.HTMLElements.mouseValueContainer.innerText = yValue;
	}

	export function draw(){

		// List numeric columns available in the data
		const allColumns: Array<string> = [];
		for(let column of Object.keys(Main.Data.frames)){
			if(typeof Main.Data.frames[column][0] != "number"){
				// We are here to plot numbers and numbers only
				// Ok?
				continue;
			}
			allColumns.push(column);
		}

		// Update legend based on columns present in the data
		// Create checkboxes for toggling the columns and attach a handler for when they are clicked
		Main.HTMLElements.legend.innerText = "";
		for(let i = 0; i < allColumns.length; i++){
			let column = allColumns[i];
			let color = typeof Const.SENSOR_COLORS[i] != "undefined" ? Const.SENSOR_COLORS[i] : "white";
			// Create checkbox to toggle column
			const radio = document.createElement("input");
			// Columns are checked off unless a user setting with value "true" is present
			radio.checked = typeof Main.UserSettings.selectedColumns[column] != "undefined" && Main.UserSettings.selectedColumns[column];
			radio.type = "checkbox";
			radio.onclick = function(e){
				// Store choice in memory and flush to local storage
				Main.UserSettings.selectedColumns[column] = radio.checked;
				localStorage.selectedColumns = JSON.stringify(Main.UserSettings.selectedColumns);
				draw();
			};
			
			radio.value = column;
			const span = document.createElement("span");
			span.style.color = color;
			span.innerText = column.toUpperCase();
			Main.HTMLElements.legend.appendChild(radio);
			Main.HTMLElements.legend.appendChild(span);
			Main.HTMLElements.legend.appendChild(document.createElement("br"));
		}

		// List the user-selected columns if they are also present in the data
		const columns: Array<string> = [];
		for(let column of allColumns){
			if(typeof Main.UserSettings.selectedColumns[column] != "undefined" && Main.UserSettings.selectedColumns[column]){
				columns.push(column);
			}
		}

		Plotter.canvas.width = innerWidth - Const.SIDEBAR_WIDTH;
		Plotter.canvas.height = innerHeight - Const.SCROLL_BAR_SIZE;
		startTimeUnix = Main.Data.frames.time[0];
		// Scale product of base factor and user factor
		scaleX = Main.UserSettings.zoom * Const.BASE_ZOOM_FACTOR;
		Main.HTMLElements.scrollerInner.style.width = (Main.Data.frames.time.length * scaleX) + "px";
		xMin = Math.floor((Main.Data.frames.time.length-1) * Plotter.pan);
		xMax = Math.floor(xMin + (Plotter.canvas.width-Const.X_MARGIN) / scaleX);
		if(xMax > Main.Data.frames.time.length-1){
			xMax = Main.Data.frames.time.length-1;
		}

		// Determine yRange
		yMin = null;
		yMax = null;
		
		for(let column of columns){
			for(var i = 0; i < Main.Data.frames[column].length; i++){
				const val = Main.Data.frames[column][i];
				if(val < yMin || yMin == null){
					yMin = val;
				}
				if(val > yMax || yMax == null){
					yMax = val;
				}
			}
		}
		
		if(yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax-yMin) == 0){
			// Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
			yMin -= 1;
			yMax += 1;
		}

		// Calculate drawing scale
		scaleY = (Plotter.canvas.height - Const.Y_MARGIN) / (yMax-yMin);
	
		// Start drawing grid 
		Plotter.ctx.strokeStyle = "#909090"; // Grid and axis color
		Plotter.ctx.fillStyle = "white"; // Text color
		Plotter.ctx.beginPath(); 
		Plotter.ctx.font = "1em monospace";

		// Draw horizontal grid lines and y axis labels
		let yRelative = 0;
		Plotter.ctx.textAlign = "right";
		let valueString: string;
		while(yRelative <= 1){
			let yValue = yMin + ((yMax-yMin) * (1-yRelative));
			let yPosition = (Plotter.canvas.height-Const.Y_MARGIN) * yRelative;
			Plotter.ctx.moveTo(Const.X_MARGIN, yPosition);
			Plotter.ctx.lineTo(Plotter.canvas.width, yPosition);
			valueString = yValue.toFixed(1);
			// These offsets should be constants!
			let ylabelYOffset = 4;
			if(yRelative == 0){
				ylabelYOffset = 10;
			}else if(yRelative == 1){
				ylabelYOffset = -10;
			}
			Plotter.ctx.fillText(valueString, Const.X_MARGIN - Const.Y_LABEL_X_OFFSET, yPosition + ylabelYOffset);
			yRelative += Const.Y_GRID_INTERVAL;
		}

		// Draw vertical grid lines and x axis labels
		let xRelative = 0;
		while(xRelative <= 1){
			let xValue = xMin + (xMax-xMin) * xRelative;
			let xPosition = Const.X_MARGIN + (xValue - xMin) * scaleX;
			Plotter.ctx.moveTo(xPosition, 0);
			Plotter.ctx.lineTo(xPosition, Plotter.canvas.height - Const.Y_MARGIN);
			let timeUnix = startTimeUnix + (xValue / Const.FREQ_HZ);
			valueString = Util.createTimeLabel(timeUnix);
			if(xValue - xMin == 0){
				Plotter.ctx.textAlign = "left";
			}else if(Math.round(xValue) == xMax){ // The rounding here is a bit hacky.
				Plotter.ctx.textAlign = "right";
			}else{
				Plotter.ctx.textAlign = "center";
			}
			Plotter.ctx.fillText(valueString, xPosition, Plotter.canvas.height - Const.X_LABEL_Y_OFFSET);
			xRelative +=  Const.X_GRID_INTERVAL;
		} 

		Plotter.ctx.stroke();

		// Draw data for each sensor
		for(let colno = 0; colno < columns.length; colno++){
			let column = columns[colno];
			// Complete drawing of grid
			let color = Const.SENSOR_COLORS[colno];
			Plotter.ctx.strokeStyle = color;
			Plotter.ctx.beginPath();
			
			let val = Main.Data.frames[column][xMin];
			Plotter.ctx.moveTo(Const.X_MARGIN, Plotter.canvas.height - ((val-yMin) * scaleY) - Const.Y_MARGIN);
			for(let frameIndex = xMin; frameIndex < xMax; frameIndex++){
				val = Main.Data.frames[column][frameIndex];
				let xPos = ((frameIndex - xMin)/Const.FREQ_HZ) * scaleX + Const.X_MARGIN;
				let yPos = Plotter.canvas.height - ((val-yMin) * scaleY) - Const.Y_MARGIN;
				Plotter.ctx.lineTo(xPos, yPos);
			}
			Plotter.ctx.stroke();
		}

		// Complete drawing of grid
		Plotter.ctx.stroke();
	}

}