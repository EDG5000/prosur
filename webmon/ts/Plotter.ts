namespace Plotter{
	// Main.canvas and context
	export let ctx: CanvasRenderingContext2D = null;

	export function init(){
		// Get DOM nodes and Main.canvas context
		ctx = Main.canvas.getContext("2d");
		Main.mouseValueContainer.innerText = (0).toFixed(2);

		addEventListener("resize", function(){
			if(Main.leftChunkTime == -1){
				// Only redraw upon resize after first frame is drawn
				return;
			}
			requestAnimationFrame(function(){
				draw();
			});
		});
	}


	let yMin = 0;
	let yMax = 0;

	export function onMouseMove(x: number, y: number){
		let yValue = (Math.round(100 * ((yMax - yMin) * (1-(y / (Main.canvas.height-Const.Y_MARGIN))) + yMin))/100).toFixed(2);
		Main.mouseValueContainer.innerText = yValue;
	}
	
	export function draw(){
		//console.log(Main.Settings.pan);
		const leftChunkTime = Main.leftChunkTime;
		const rightChunkTime = Main.rightChunkTime;
		const zoom = Main.Settings.zoom;
		const leftChunk = typeof Main.chunks[zoom][leftChunkTime + ""] != "undefined" ? Main.chunks[zoom][leftChunkTime + ""] : null;
		const rightChunk = typeof Main.chunks[zoom][rightChunkTime + ""] != "undefined" ? Main.chunks[zoom][rightChunkTime + ""] : null;

		//console.log("Leftchunktime: " + leftChunkTime);

		// Calculate additional parameters
		Main.canvas.width = innerWidth - Const.SIDEBAR_WIDTH;
		Main.canvas.height = innerHeight - Const.SCROLL_BAR_SIZE;
		const chunkRange = Const.CHUNK_RANGE[zoom];
		const pan = Main.Settings.pan;
		const columns: Array<string> = [];

		// If there is data in any of the chunks, update legend, obtain user-selected column list and determine y-range
		if(leftChunk != null || rightChunk != null){
			// List numeric columns available in the data by looking at the left chunk
			const allColumns: Array<string> = [];
			// Pick any non-null chunk
			const chunk = leftChunk != null ? leftChunk : rightChunk;

			// Obtain numerical columns
			for(let column in chunk){
				if(typeof chunk[column][0] != "number"){
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
					Main.canvasInvalidated = true;
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
			for(let column of allColumns){
				if(typeof Main.Settings.selectedColumns[column] != "undefined" && Main.Settings.selectedColumns[column]){
					columns.push(column);
				}
			}

			// Determine y-range
			yMin = 0;
			yMax = 0;
			for(let column of columns){
				let chunks = [];
				if(leftChunk != null){
					chunks.push(leftChunk);
				}
				if(rightChunk != null){
					chunks.push(rightChunk);
				}
				for(let chunk of chunks){
					// Fetch value from the correct chunk
					for(let val of chunk[column]){
						// Update min and max as appropriate
						if(val < yMin || yMin == null){
							yMin = val;
						}
						if(val > yMax || yMax == null){
							yMax = val;
						}
					}
				}
			}
		}

		// Apply fallback y-range if needed (in the case of no data or other edge cases)
		if(yMin == null || yMax == 0 || !Number.isFinite(yMin) || !Number.isFinite(yMax) || isNaN(yMin) || isNaN(yMax) || Math.abs(yMax-yMin) == 0){
			// Unable to calculate range, set artifical range 1 below and 1 above current value, which should center the line if there is a line at all
			yMin = 1;
			yMax = 1;
		}

		// Calculate drawing scale
		const scaleY = (Main.canvas.height - Const.Y_MARGIN) / (yMax-yMin);
	
		// Start drawing grid 
		ctx.strokeStyle = "#909090"; // Grid and axis color
		ctx.fillStyle = "white"; // Text color
		ctx.beginPath(); 
		ctx.font = "1em monospace";
		
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
			const xPosition = Const.X_MARGIN + xRelative * (Main.canvas.width - Const.X_MARGIN);
			ctx.moveTo(xPosition, 0);
			ctx.lineTo(xPosition, Main.canvas.height - Const.Y_MARGIN);
			let timeUnix = Main.Settings.pan + Const.CHUNK_RANGE[zoom] * xRelative;
			valueString = Util.createTimeLabel(timeUnix);
			if(xRelative == 0){
				ctx.textAlign = "left";
			}else if(xRelative == 1){ // The rounding here is a bit hacky.
				ctx.textAlign = "right";
			}else{
				ctx.textAlign = "center";
			}
			ctx.fillText(valueString, xPosition, Main.canvas.height - Const.X_LABEL_Y_OFFSET);
			xRelative +=  Const.X_GRID_INTERVAL;
		} 
		ctx.stroke();
	
		// Plot the data if at least one of the chunks are non-null
		if(leftChunk != null || rightChunk != null){
			let startIndex: number;
			let endIndex: number;

			if(leftChunk != null){
				// Starting at left chunk
				startIndex = Math.floor(((pan % chunkRange) / chunkRange) * Const.CHUNK_SIZE);
			}else{
				// First row of right chunk
				startIndex = 0;
			}
			if(rightChunk != null){
				// Inverse of startIndex
				endIndex = Const.CHUNK_SIZE - startIndex;
			}else{
				// Ending at left chunk
				endIndex = Const.CHUNK_SIZE - 1;
			}
			
			// Load new job data if jobId changed. Clear job panel if no job in first frame
			let firstChunk = leftChunk != null ? leftChunk : rightChunk;
			let jobId = -1;
			if(typeof firstChunk["job_id"] != "undefined" && firstChunk["job_id"].length > startIndex){
				jobId = firstChunk["job_id"][startIndex];
			}
			if(jobId != Main.jobId){
				// Job ID has changed; persist it and trigger job load
				Main.jobId = jobId;
				JobInfo.load(jobId);
			}

			// Draw data for each column
			for(let colno = 0; colno < columns.length; colno++){
				// Get colname, set color, start path
				const column = columns[colno];
				let color = Const.SENSOR_COLORS[colno];
				ctx.strokeStyle = color;
				ctx.beginPath();
				
				// Draw a line per value
				let inLeftChunk = leftChunk != null; // Still in left chunk. Set low once right chunk is reached.
				let ready = false;
				let initial = true;
				// Start iterating at startIndex of left chunk if possible. Otherwise, start at leftIndex of right chunk
				// End at endIndex of right chunk or endIndex in left chunk if right chunk is not available
				// Move from left chunk to right chunk as needed
				for(let index = startIndex; !ready; index++){
					let val: number;
					let time: number;
					if(inLeftChunk && index < leftChunk[column].length){
						val = leftChunk[column][index];
						time = leftChunk["time"][index];
					}else if(inLeftChunk && index == Const.CHUNK_SIZE){
						// Left chunk fully traversed
						if(rightChunk == null){
							// There is no right chunk, so all drawing is complete
							break;
						}else{
							// Proceed to right chunk or abort when right chunk is not available
							index = 0;
							inLeftChunk = false;
							continue;
						}
					}else if(rightChunk != null && index < endIndex && index < rightChunk[column].length){
						// In right chunk
						val = rightChunk[column][index];
						time = rightChunk["time"][index];
						if(rightChunk == null){
							// Only the left chunk was present, abort now.
							break;
						}
					}else{
						break;
					}
					let xPos = Const.X_MARGIN + ((time - Main.Settings.pan) / Const.CHUNK_RANGE[zoom]) * (Main.canvas.width - Const.X_MARGIN);
					let yPos = Main.canvas.height - ((val-yMin) * scaleY) - Const.Y_MARGIN;
					if(xPos < 0 || yPos < 0){
						//debugger;
					}
					if(initial){
						//console.log("Move: " + xPos + " - " + xPos);
						ctx.moveTo(xPos, yPos);
						initial = false;
					}else{
						ctx.lineTo(xPos, yPos);
						//console.log("Line: " + xPos + " - " + xPos);
					}
				}
				ctx.stroke();
			}
			// Complete drawing of grid
			ctx.stroke();
		}
	}

}