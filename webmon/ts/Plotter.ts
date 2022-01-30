namespace Plotter{

	// Main.canvas and context
	export let ctx: CanvasRenderingContext2D = null;


	export function init(){
		// Get DOM nodes and Main.canvas context
		ctx = Main.canvas.getContext("2d");

		let active = false;
		/*
		// Adjust horizontal pan whenever the graph is scrolled horizontally
		Main.canvas.addEventListener("scroll", function(e: Event){
			if(!active){
				requestAnimationFrame(function(){
					Main.Settings.pan = Main.scroller.scrollLeft/Main.scroller.scrollWidth;
					draw();
					active = false;
				});
				active = true;
			}
		});
		*/
		Main.mouseValueContainer.innerText = (0).toFixed(2);

		/*addEventListener("resize", function(){
			requestAnimationFrame(draw);
		});*/
	}

	/*
	export function onMouseMove(x: number, y: number){
		let yValue = (Math.round(100 * ((yMax - yMin) * (1-(y / (Main.canvas.height-Const.Y_MARGIN))) + yMin))/100).toFixed(2);
		Main.mouseValueContainer.innerText = yValue;
	}
	*/

	export function draw(leftChunkTime: number, rightChunkTime: number, leftChunk: any, rightChunk: any, zoom: number){

		// List numeric columns available in the data by looking at the left chunk
		const allColumns: Array<string> = [];
		for(let column in leftChunk){
			if(typeof leftChunk[column][0] != "number"){
				// We are here to plot numbers and numbers only. Understood?
				continue;
			}
			allColumns.push(column);
		}

		// Update legend based on columns present in the data
		// Create checkboxes for toggling the columns and attach a handler for when they are clicked
		Main.legend.innerText = "";
		for(let i = 0; i < allColumns.length; i++){
			let column = allColumns[i];
			let color = typeof Const.SENSOR_COLORS[i] != "undefined" ? Const.SENSOR_COLORS[i] : "white";
			// Create checkbox to toggle column
			const radio = document.createElement("input");
			// Columns are checked off unless a user setting with value "true" is present
			radio.checked = typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column];
			radio.type = "checkbox";
			radio.onclick = function(e){
				// Store choice in memory and flush to local storage
				Main.Settings.selectedColumns[column] = radio.checked;
				localStorage.selectedColumns = JSON.stringify(Main.Settings.selectedColumns);
				ChunkLoader.tick();
			};
			
			radio.value = column;
			const span = document.createElement("span");
			span.style.color = color;
			span.innerText = column.toUpperCase();
			Main.legend.appendChild(radio);
			Main.legend.appendChild(span);
			Main.legend.appendChild(document.createElement("br"));
		}

		// List the user-selected columns if they are also present in the data
		const columns: Array<string> = [];
		for(let column of allColumns){
			if(typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column]){
				columns.push(column);
			}
		}
		
		// Determine dimensions
		Main.canvas.width = innerWidth - Const.SIDEBAR_WIDTH;
		Main.canvas.height = innerHeight - Const.SCROLL_BAR_SIZE;
		const startTimeUnix = leftChunk.time[0];
		const chunkRange = Const.CHUNK_RANGE[zoom];
		const startIndex = Math.floor((chunkRange / (Main.Settings.pan % Math.pow(2, zoom))) * Const.CHUNK_SIZE);
		const endIndex = Const.CHUNK_SIZE + Math.floor((chunkRange / ((Main.Settings.pan + chunkRange) % Math.pow(2, zoom))) * Const.CHUNK_SIZE);
		// Scale is product of base factor and user factor
		// TODO evaluate
		const scaleX = Main.Settings.zoom * Const.BASE_ZOOM_FACTOR;

		const xMax = Main.Settings.pan + Const.CHUNK_RANGE[zoom];

		const modulus = Math.pow(2, zoom);

		// Determine y-range
		let yMin = null;
		let yMax = null;
		for(let column of columns){
			let index = startIndex;
			let val: number;
			// Fetch value from the correct chunk
			for(let time = Main.Settings.pan; time < Main.Settings.pan + chunkRange; time += modulus){
				if(index < Const.CHUNK_SIZE){
					// In left chunk
					val = leftChunk[column][index];
				}else{
					// In right chunk
					val = rightChunk[column][index - Const.CHUNK_SIZE];
				}

				// Update min and max as appropriate
				if(val < yMin || yMin == null){
					yMin = val;
				}
				if(val > yMax || yMax == null){
					yMax = val;
				}
				index++;
			}
		}
		
		// Apply fallback y-range if needed
		if(yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax-yMin) == 0){
			// Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
			yMin -= 1;
			yMax += 1;
		}

		// Calculate drawing scale
		const scaleY = (Main.canvas.height - Const.Y_MARGIN) / (yMax-yMin);
	
		// Start drawing grid 
		ctx.strokeStyle = "#909090"; // Grid and axis color
		ctx.fillStyle = "white"; // Text color
		ctx.beginPath(); 
		ctx.font = "1em monospace";
		/*
		// Draw horizontal grid lines and y axis labels
		let yRelative = 0;
		ctx.textAlign = "right";
		let valueString: string;
		while(yRelative <= 1){
			let yValue = yMin + ((yMax-yMin) * (1-yRelative));
			let yPosition = (Main.canvas.height-Const.Y_MARGIN) * yRelative;
			ctx.moveTo(Const.X_MARGIN, yPosition);
			ctx.lineTo(Main.canvas.width, yPosition);
			valueString = yValue.toFixed(1);
			// These offsets should be constants!
			let ylabelYOffset = 4;
			if(yRelative == 0){
				ylabelYOffset = 10;
			}else if(yRelative == 1){
				ylabelYOffset = -10;
			}
			ctx.fillText(valueString, Const.X_MARGIN - Const.Y_LABEL_X_OFFSET, yPosition + ylabelYOffset);
			yRelative += Const.Y_GRID_INTERVAL;
		}

		// Draw vertical grid lines and x axis labels
		let xRelative = 0;
		while(xRelative <= 1){
			let xValue = Main.Settings.pan + (xMax-Main.Settings.pan) * xRelative;
			let xPosition = Const.X_MARGIN + (xValue - Main.Settings.pan) * scaleX;
			ctx.moveTo(xPosition, 0);
			ctx.lineTo(xPosition, Main.canvas.height - Const.Y_MARGIN);
			let timeUnix = startTimeUnix + (xValue / Const.FREQ_HZ);
			valueString = Util.createTimeLabel(timeUnix);
			if(xValue - Main.Settings.pan == 0){
				ctx.textAlign = "left";
			}else if(Math.round(xValue) == xMax){ // The rounding here is a bit hacky.
				ctx.textAlign = "right";
			}else{
				ctx.textAlign = "center";
			}
			ctx.fillText(valueString, xPosition, Main.canvas.height - Const.X_LABEL_Y_OFFSET);
			xRelative +=  Const.X_GRID_INTERVAL;
		} 

		ctx.stroke();
		*/
		// Draw data for each sensor
		for(let colno = 0; colno < columns.length; colno++){
			// Get colname, set color, start path
			const column = columns[colno];
			let color = Const.SENSOR_COLORS[colno];
			ctx.strokeStyle = color;
			ctx.beginPath();
			
			// Move to first value
			let val = leftChunk[column][0];
			ctx.moveTo(Const.X_MARGIN, Main.canvas.height - ((val-yMin) * scaleY) - Const.Y_MARGIN);
			let index = 0;
			// Draw a line per value
			for(let time = Main.Settings.pan + 1; time < Main.Settings.pan + chunkRange; time += modulus){
				let val: number;
				if(index < Const.CHUNK_SIZE){
					// In left chunk
					val = leftChunk[column][index];
				}else{
					// In right chunk
					val = rightChunk[column][index - Const.CHUNK_SIZE];
				}
				let xPos = ((time - Main.Settings.pan)/Const.FREQ_HZ) * scaleX + Const.X_MARGIN;
				let yPos = Main.canvas.height - ((val-yMin) * scaleY) - Const.Y_MARGIN;
				ctx.lineTo(xPos, yPos);
				index++;
			}
			ctx.stroke();
		}

		// Complete drawing of grid
		ctx.stroke();
	}

}