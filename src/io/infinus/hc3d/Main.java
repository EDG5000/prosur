package io.infinus.hc3d;

import java.awt.Dimension;
import java.io.File;

import javax.swing.JFrame;

import org.freedesktop.gstreamer.Caps;
import org.freedesktop.gstreamer.Element;
import org.freedesktop.gstreamer.ElementFactory;
import org.freedesktop.gstreamer.Gst;
import org.freedesktop.gstreamer.Pipeline;
import org.freedesktop.gstreamer.State;
import org.freedesktop.gstreamer.elements.PlayBin;
import org.freedesktop.gstreamer.swing.GstVideoComponent;

/*

v4l2-ctl --set-ctrl=exposure_auto=1 --set-ctrl=exposure_absolute=10 #only to change settings on camera
streamer -o test.raw -d -s 3264x2448 -t 1 -w 0 -r 1 -f 422d

-sampling-factor 4:2:0″.
convert -size 800x600 -depth -sample 4:2:0 -interlace plane 8 yuv:image.raw

display -size 3264x2448 -depth 16 -sampling-factor 4:2:2 -interlace none test.yuv

 */

public class Main {
	
	/* gstreamer stuff */

	private static File videoFile;

	
	/* gstreamer stuff */

	private static Pipeline pipe = null;
	private static Element source = null;
	private static Element filter = null;
	private static Element jpegdec = null;
	private static Element[] elements = null;
	//private RGBDataSink sink = null;

	private static Caps caps = null;
	
	private Dimension resolution;
	
//protected static final String SRC_VIDEO_FOR_LINUX_2 = "v4l2src";
	public static final String FORMAT_RGB = "video/x-raw-rgb";
	public static final String FORMAT_YUV = "video/x-raw-yuv";
	public static final String FORMAT_MJPEG = "image/jpeg";
	public static void main(String[] args) {
		
		// Get handle to video device
		videoFile = NixVideoDevUtils.getVideoFiles()[0];
		
		// TODO Auto-generated method stub
		System.out.println("Test");
		String[] cmdArgs = new String[] {
				// "--gst-plugin-path", new File(".").getAbsolutePath(),
				// "--gst-debug-level=3",
			};
		Gst.init("hc3d", cmdArgs);
		
        // Create a Swing video display component
        GstVideoComponent vc = new GstVideoComponent();

        // Create a PlayBin element and set the AppSink from the Swing component
        // as the video sink.
        //PlayBin playbin = new PlayBin("playbin");
        //playbin.setVideoSink(vc.getElement());

        // Create a level component and set it as the audio-filter property
        // on the playbin - this will post audio level messages to the bus -
        // see below how to display them.
        //Element level = ElementFactory.make("level", "level");
        //playbin.set("audio-filter", level);

        // Create a GUI
        JFrame window = new JFrame("Video Player");
        window.add(vc);
        vc.setPreferredSize(new Dimension(800, 600));
        //Box buttons = Box.createHorizontalBox();

        /*
        JButton fileButton = new JButton("File...");
        fileButton.addActionListener(e -> {
            JFileChooser fileChooser = new JFileChooser();
            int returnValue = fileChooser.showOpenDialog(window);
            if (returnValue == JFileChooser.APPROVE_OPTION) {
                playbin.stop();
                playbin.setURI(fileChooser.getSelectedFile().toURI());
                playbin.play();
            }
        });
        */

        /*
        JButton playButton = new JButton("Play");
        playButton.addActionListener(e -> playbin.play());
        JButton pauseButton = new JButton("Pause");
        pauseButton.addActionListener(e -> playbin.pause());
        */


        // quick and dirty level display using JProgressBar
        /*
        Box levels = Box.createVerticalBox();
        JProgressBar leftLevel = new JProgressBar();
        leftLevel.setMaximumSize(new Dimension(200, 20));
        JProgressBar rightLevel = new JProgressBar();
        rightLevel.setMaximumSize(new Dimension(200, 20));
        levels.add(leftLevel);
        levels.add(rightLevel);

        
        buttons.add(fileButton);
        buttons.add(playButton);
        buttons.add(pauseButton);
        buttons.add(position);
        buttons.add(levels);
        window.add(buttons, BorderLayout.SOUTH);
*/
        window.pack();
        window.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        

        window.setVisible(true);
		
		

		pipe = new Pipeline("hc3d");
		
		
		source = ElementFactory.make("v4l2src", "source");

		source.set("device", videoFile.getAbsolutePath());	

		pipe.add(source);
		//pipe.add(filter);
		jpegdec = ElementFactory.make("jpegdec", "jpegdec");

		pipe.add(jpegdec);
		pipe.add(vc.getElement());
		
		pipe.setState(State.PLAYING);
		
		/*PlayBin bin = new PlayBin("hc3d");
		pip.add(bin);
		
		sink = new RGBDataSink(getName(), this);
		sink.setPassDirectBuffer(true);
		sink.getSinkElement().setMaximumLateness(LATENESS, TimeUnit.MILLISECONDS);
		sink.getSinkElement().setQOSEnabled(true);
*/
		//filter = ElementFactory.make("capsfilter", "capsfilter");
		//caps = Caps.fromString(String.format("%s,framerate=30/1,width=%d,height=%d", format, size.width, size.height));
		//filter.setCaps(caps);
		

		
		/*
		pipelineReady();
		resolutions = parseResolutions(source.getPads().get(0));
		pipelineStop	();	
		
		new GStreamerDevice(this, vfile)*/
		
			/*
		
		if (!open.compareAndSet(false, true)) {
			return;
		}


		init();

		starting.set(true);

		Dimension size = getResolution();

		image = new BufferedImage(size.width, size.height, BufferedImage.TYPE_INT_RGB);
		image.setAccelerationPriority(0);
		image.flush();

		if (caps != null) {
			caps.dispose();
		}


*/

		//pipelinePlay();

		/*

		// wait max 20s for image to appear
		synchronized (this) {
			try {
				this.wait(20000);
			} catch (InterruptedException e) {
				return;
			}
		}
		*/
		
		
		Runtime.getRuntime().addShutdownHook(new GStreamerShutdownHook());
		
		
		
	}
	
	
	

	private static final class GStreamerShutdownHook extends Thread {

		public GStreamerShutdownHook() {
			super("gstreamer-shutdown-hook");
		}
	
		@Override
		public void run() {
			Gst.deinit();

			/*
			if (!open.compareAndSet(true, false)) {
				return;
			}

			pipelineStop();

			image = null;


			if (!disposed.compareAndSet(false, true)) {
				return;
			}
			*/


			//close();

			source.dispose();
			filter.dispose();
			jpegdec.dispose();
			caps.dispose();
			//sink.dispose();
			pipe.dispose();
		}
	}
	

/*

	@Override
	public void rgbFrame(boolean preroll, int width, int height, IntBuffer rgb) {

		LOG.trace("New RGB frame");

		if (t1 == -1 || t2 == -1) {
			t1 = System.currentTimeMillis();
			t2 = System.currentTimeMillis();
		}

		BufferedImage tmp = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
		tmp.setAccelerationPriority(0);
		rgb.get(((DataBufferInt) tmp.getRaster().getDataBuffer()).getData(), 0, width * height);
		tmp.flush();

		image = tmp;

		if (starting.compareAndSet(true, false)) {

			synchronized (this) {
				this.notifyAll();
			}

			LOG.debug("GStreamer device ready");
		}

		t1 = t2;
		t2 = System.currentTimeMillis();

		fps = (4 * fps + 1000 / (t2 - t1 + 1)) / 5;
	}
	*/

}
