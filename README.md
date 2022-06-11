# Prosur (Production Surveyor) 

*Logging all activity<br>
in your additive production facility.*

A tool which monitors your additive production processes, such as FDM 3D printing.

The tool automatically collects as much data as it can, storing it permanently. A browser-based viewer allows scrolling through the collected data using a single infinitely-scrolling graph. 

Prosur will record continually at 1Hz, whether printing or not, the following info:
- Periodic stills (every 6th second)
- Temperatures
- A job file (such as gcode) when starting a job
- Job parameters (slicer settings)yy

- Axis positions (extruder, gantry)
- Aux. temperatures (such as chamber temperatures)

## Data sources

The following data sources are currently implemented:
- Aux. temperatures from serial port. For use with the supplied AVR program, which can be run on for ATmega and simmilar MCUs connected to temperature sensors.
- Images from a v4l2-supported device (i.e. all USB UVC webcams).
- Data available from the RepRapFirmware over the network.

## Achitecture

All data is stored in a PostgreSQL database. The system consists of three modules:
- AVR MCU firmware for collecting aux. temperatures, written in AVR C (optional).
- Linux daemon (prosurd) which collects the data and listens for HTTP requests from the web viewer. Written in modern C++.
- Web viewer (webmon). It displays the graph, images and print parameters. Written in TypeScript (no JS libraries used). 

The collection is written in modern C++, while the viewer is written in TypeScript. There are no libraries, except libpq for database interaction. Everything is implemented from scratch, using built-in Unix, Linux, STL and DOM libraries and headers. It is tested with both modern GCC and modern Clang.

Please note: Various Linux-specific headers are used for the Camera datasource. For the HTTP server and client, standard Unix headers are used. Some headers may be Linux specific as well. To support other Unix systems. disable the Camera module or reimplement it.

## Installing and configuring PostgreSQL

Whether you are building from source or running a precompiled release, first you must install PostgreSQL.

1. Install using `apt install postgresql` or equivalent when using other package manager. You can also use a GUI tool like Muon to install packages.

2. Ensure the following is present in the table in /etc/postgres/12/main/pg_hba.conf:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

local   all             postgres                                trust
```
3. Restart PostgreSQL: `sudo service postgresql restart`
4. Ensure it is running: `ps aux | grep postgres`. You should see at least 1 process (excluding the grep process...).

Note: Prosurd will auto-create the database on first start of the daemon, there is no need to further configure the database.

## Install

1. Download a release from GitHub on the Releases page. Pick the correct architecture. 
2. Install PostgreSQL by running `apt install postgresql` (or equivalent for other package managers)
3. Enable postgresql peer (local unix socket) connections by setting the value to trust in /etc/postgresql/pg_hba.conf in the authentication table.
4. Check your RepRapFirmware device name, assumed to be `printername`
5. Run as follows:  `./prosurd printername.local`

## Building from source

Note: Before continuing, ensure PostgreSQL is set up. See chapter 'Installing and configuring PostgreSQL'.

Info: The build system is CMake for the backend. For the frontend, TypeScript's built-in tsc command is used.

Info: These instructions use APT as a package source. If you are using another package manager, use equivalent commands.

### Install dependencies

- GCC or Clang
- CMake
- Make
- LibPQ and headers (part of PostgreSQL)
- PostgreqSQL headers
- PostgreSQL

Here is your one-liner:

```
sudo apt install build-essential, cmake, libpq-dev, postgresql, postgresql-dev, postgresql-server-dev, npm
```
### Install TypeScript compiler

Install Typescript compiler using npm. Update NPM and Node. Typescript compiler uses Node.js runtime.
```
sudo npm install -g npm
sudo npm install -g node
sudo npm install -g typescript
```

### Compile prosurd

Configure using CMake. Compile with make.
```
cd prosur
cd prosurd
mkdir build
cd build
cmake ..
make
```

### Compile webmon
```
cd prosur
cd webmon
tsc
```
Note: During development, use the Build command within VS Code (optional) to enable TypeScript 'watch' auto-compilation for convenience.

### Run!
```
cd prosur/prosurd/build
./prosurd mylitleprinter.local
```

IMPORTANT: Replace 'mylittleprinter.local' with the IP or mDNS hostname of your 3D printer. To avoid confusion, use a hostname corresponding to the size of your 3D printer. For example, if you have a large 3D printer, the recommended intuitive hostname is myverylarge3dprinter.local.

Note: In RepRapFirmware, in `config.g`, use `M550 P"MyLittlePrinter` to set the mDNS hostname to `mylittleprinter.local`.

1. Open web browser, type the hostname or IP where `prosurd` is running, suffix with `:8080` e.g. `mylittlepc.local:8080`
2. Power on your RepRapFirmware-based 3D printer.
3. Data is now collected and can be viewed.

# How to use the web viewer

- The web viewer will perform live update when fully scrolled to the right.
- Use the scroll wheel to change the zoom level. A zoom level of 10 means 1 frame of every 10 frames will be shown (modulus 10). Zoom level of 0 will show max detail.
- When fully scrolled to the right, changing the zoom level will keep the graph fully scrolled to the right.
- Whenever a print job was active on the part of the graph being displayed, job info will be shown in the right column.
- The list of print jobs will be shown on the right. Update using the F5 button.
- Webmon will cache a certain amount of data until the browser window refreshed.
- The value under the mouse cursor is displayed in the graph.
- The graph will continually perform auto-ranging.
- To easily enable live view from any viewer position, zoom out quite a bit, then scroll all the way to the right. Then zoom in again.
- See the slicer settings used for a particular print by scrolling to the print session in the live view or clicking on it in the left pane. The right pane will then show the job parameters, and will allow you to download the job file (usually gcodde).

# Why?

Prosur takes the guesswork out of working with 3D printers. No longer do you have to randomly adjust settings. If you broke your settings or forgot what settings you used for a particular print, it will al be easily findable using the web viewer. If you want to see which values produced the best prints, you can use the viewer for that as well. Want to re-print a file from a long time ago, but forgot the print settings? Simply download the gcode file from the archive and print it again. Want to monitor your printers capability in maintaining the correct temperature? You can use the plots for that. If needed for further analysis you can extract CSV files using a PostgreSQL GUI, such as DBeaver.


