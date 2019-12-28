package io.infinus.hc3d;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;

import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

import au.edu.jcu.v4l4j.CaptureCallback;
import au.edu.jcu.v4l4j.FrameGrabber;
import au.edu.jcu.v4l4j.V4L4JConstants;
import au.edu.jcu.v4l4j.VideoDevice;
import au.edu.jcu.v4l4j.VideoFrame;
import au.edu.jcu.v4l4j.exceptions.StateException;
import au.edu.jcu.v4l4j.exceptions.V4L4JException;

/**
 * An image viewer that displays and image and allows zooming and panning of
 * images.
 * <p>
 * When allowZooming is TRUE, clicking in the image will zoom in. CTRL-click
 * in the image to zoom out.
 *
 * @author Jonathon Hare (jsh2@ecs.soton.ac.uk)
 * @author David Dupplaw (dpd@ecs.soton.ac.uk)
 */
public class WebcamComponent extends JComponent/*, WindowAdapter*/ implements CaptureCallback
{
	//public class SimpleViewer extends WindowAdapter implements CaptureCallback{
	private static int		width, height, std, channel;
	private static String	device;
	private VideoDevice		videoDevice;
	private FrameGrabber	frameGrabber;
	private JFrame 			frame;

	int count = 0;
	
	private static final long serialVersionUID = 1L;

	/** The image being displayed */
	protected BufferedImage image;

	/** Whether to auto resize the component to the content size */
	private boolean autoResize = false;

	/** Whether to pack the component on resize */
	private boolean autoPack = false;

	/** Whether to size the image to fit within the component's given size */
	private boolean autoFit = false;

	/** Gives the image-coord point in the centre of the image */
	private double drawX = 0;

	/** Gives the image-coord point in the centre of the image */
	private double drawY = 0;

	/** Gives the image scale */
	private double scaleFactorX = 1;

	/** Gives the image scale */
	private double scaleFactorY = 1;

	/** The current mouse coordinate */
	private int mouseX = 0;

	/** The current mouse coordinate */
	private int mouseY = 0;

	/** The current pixel colour */
	private Float[] currentPixelColour = null;

	/** The last displayed image */
	private BufferedImage displayedImage = null;

	/**
	 * Default constructor
	 */
	public WebcamComponent()
	{
		/*
		this.autoPack = autoPack;
		this.autoResize = autoResize;
		this.scaleFactorX = initialScale;
		this.scaleFactorY = initialScale;
		 */
		autoResize = true;
		autoFit = true;
		
		Runtime.getRuntime().addShutdownHook(new Thread()
		{
		    @Override
		    public void run()
		    {
		    	System.out.println("Closing.");
		    	windowClosing();
		    }
		});
		
		device = (System.getProperty("test.device") != null) ? System.getProperty("test.device") : "/dev/webcam"; // See README to get persistent shortcut 
		width = (System.getProperty("test.width")!=null) ? Integer.parseInt(System.getProperty("test.width")) : 640;
		height = (System.getProperty("test.height")!=null) ? Integer.parseInt(System.getProperty("test.height")) : 480;
		std = (System.getProperty("test.standard")!=null) ? Integer.parseInt(System.getProperty("test.standard")) : V4L4JConstants.STANDARD_WEBCAM;
		channel = (System.getProperty("test.channel")!=null) ? Integer.parseInt(System.getProperty("test.channel")) : 0;
		
		// Initialise video device and frame grabber
		try {
			// Init frame grabber
			videoDevice = new VideoDevice(device);
			frameGrabber = videoDevice.getJPEGFrameGrabber(width, width, channel, std, 80);
			frameGrabber.setFrameInterval(1, 5);
			frameGrabber.setCaptureCallback(this);
			width = frameGrabber.getWidth();
			height = frameGrabber.getHeight();
		} catch (V4L4JException e1) {
			System.err.println("Error setting up capture");
			e1.printStackTrace();
			cleanupCapture();
			return;
		}
		
		// create and initialise UI
		//frame.addWindowListener(this);
		
		// start capture
		try {
			frameGrabber.startCapture();
		} catch (V4L4JException e){
			System.err.println("Error starting the capture");
			e.printStackTrace();
		}
	}

	/**
	 * this method stops the capture and releases the frame grabber and video device
	 */
	private void cleanupCapture() {
		try {
			frameGrabber.stopCapture();
		} catch (StateException ex) {
			// the frame grabber may be already stopped, so we just ignore
			// any exception and simply continue.
		}

		// release the frame grabber and video device
		videoDevice.releaseFrameGrabber();
		videoDevice.release();
	}

	/**
	 * Catch window closing event so we can free up resources before exiting
	 * @param e
	 */
	public void windowClosing() {
		cleanupCapture();

		// close window
		frame.dispose();            
	}


	@Override
	public void exceptionReceived(V4L4JException e) {
		// This method is called by v4l4j if an exception
		// occurs while waiting for a new frame to be ready.
		// The exception is available through e.getCause()
		e.printStackTrace();
	}
	
	@Override
	public synchronized void nextFrame(VideoFrame frame) {
		System.out.println(count);
		count++;
		if(count == 5) {
			count = 0;
			//label.getGraphics().drawImage(frame.getBufferedImage(), 0, 0, width, height, null);
			setImage(frame.getBufferedImage());
			repaint();
		}
		// recycle the frame
		frame.recycle();
	}
	
	/**
	 * Set the image to draw
	 *
	 * @param image
	 *            the image
	 */
	public void setImage(final BufferedImage image)
	{
		this.image = image;

		if (this.autoFit)
		{
			this.calculateScaleFactorsToFit(image, this.getBounds());
		}
		else if (this.autoResize)
		{
			// If the component isn't the right shape, we'll resize the
			// component.
			if (image.getWidth() != this.getWidth() ||
					image.getHeight() != this.getHeight())
			{
				this.setPreferredSize(new Dimension(
						(int) (image.getWidth() * this.scaleFactorX),
						(int) (image.getHeight() * this.scaleFactorY)));
				this.setSize(new Dimension(
						(int) (image.getWidth() * this.scaleFactorX),
						(int) (image.getHeight() * this.scaleFactorY)));
			}

			final Component c = SwingUtilities.getRoot(this);
			if (c == null)
				return;
			c.validate();

			if (c instanceof JFrame && this.autoPack)
			{
				final JFrame f = (JFrame) c;
				f.pack();
			}
		}

		this.repaint();
	}

	/**
	 * Given an image, will calculate two scale factors for the X and Y
	 * dimensions of the image, such that the image will fit within the
	 * bounds.
	 *
	 * @param image
	 *            The image to fit
	 * @param bounds
	 *            The bounds to fit within
	 */
	private void calculateScaleFactorsToFit(final BufferedImage image,
			final java.awt.Rectangle bounds)
	{
		if (image == null || bounds == null)
			return;

		if (this.autoFit)
		{
				this.scaleFactorX = this.scaleFactorY = Math.min(
						bounds.width / (double) image.getWidth(),
						bounds.height / (double) image.getHeight());
		}
	}


	/**
	 * {@inheritDoc}
	 *
	 * @see javax.swing.JComponent#paint(java.awt.Graphics)
	 */
	@Override
	public void paint(final Graphics gfx)
	{
		if(image == null) return;
		
		// Create a double buffer into which we'll draw first.
		final BufferedImage img = new BufferedImage(this.getWidth(), this.getHeight(), BufferedImage.TYPE_3BYTE_BGR);
		final Graphics2D g = (Graphics2D) img.getGraphics();
	
		// Scale and translate to the image drawing coordinates
		g.scale(this.scaleFactorX, this.scaleFactorY);
		g.translate(-this.drawX, -this.drawY);

		// Blat the image to the screen
		g.drawImage(this.image, 0, 0, this.image.getWidth(),
				this.image.getHeight(), null);

		// Reset the graphics back to the original pixel-based coords
		g.translate(this.drawX, this.drawY);
		g.scale(1 / this.scaleFactorX, 1 / this.scaleFactorY);

		// Blat our offscreen image to the screen
		gfx.drawImage(img, 0, 0, null);

		// Store this displayed image
		this.displayedImage = img;
	}

	/**
	 * Sets whether to automatically size the image to fit within the bounds
	 * of the image component which is being sized externally. This
	 * shouldn't be used in combination with autoResize. When this method is
	 * called with TRUE, zooming and dragging are disabled.
	 *
	 * @param tf
	 *            TRUE to auto fit the image.
	 */
	public void setAutoFit(final boolean tf)
	{
		this.autoFit = tf;
	}

	/**
	 * Sets whether to automatically resize the component to fit image (at
	 * it's given scale factor) within it. Note that in certain
	 * circumstances, where the image component is being sized by external
	 * forces (such as a layout manager), setting this to true can cause
	 * weird results where the image is pulled out and in constantly. This
	 * shouldn't be used in combination with autoFit.
	 *
	 * @param tf
	 *            TRUE to resize the component.
	 */
	public void setAutoResize(final boolean tf)
	{
		this.autoResize = tf;
	}

	/**
	 * Sets whether the component is to attempt to pack a frame into which
	 * it is added. If it is not in a frame this will have no effect. This
	 * allows the frame to resize with the component.
	 *
	 * @param tf
	 *            TRUE to auto pack the parent frame.
	 */
	public void setAutoPack(final boolean tf)
	{
		this.autoPack = tf;
	}

	/**
	 * Returns the current pixel colour at the point of the mouse. The
	 * number of elements in the array will equal be 3, if no original has
	 * been supplied to the image component. The values will be between 0
	 * and 255 and ordered red, green and blue. If the original has been
	 * supplied, then the number of elements will be equal to the number of
	 * bands in the original image and the values will be the original pixel
	 * values in the original image.
	 *
	 * @return The current pixel colour.
	 */
	public Float[] getCurrentPixelColour()
	{
		return this.currentPixelColour;
	}

	/**
	 * Returns the current displayed pixel colour (as an RGB encoded int)
	 * from the currently displayed image.
	 *
	 * @return The current displayed pixel colour.
	 */
	public int getCurrentDisplayedPixelColour()
	{
		return this.displayedImage.getRGB(this.mouseX, this.mouseY);
	}

	/**
	 * Returns the currently displaying image.
	 *
	 * @return The displayed image.
	 */
	public BufferedImage getDisplayedImage()
	{
		return this.displayedImage;
	}
}