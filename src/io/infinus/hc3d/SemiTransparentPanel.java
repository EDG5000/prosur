package io.infinus.hc3d;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.LayoutManager;

import javax.swing.JPanel;


public class SemiTransparentPanel extends JPanel {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public SemiTransparentPanel(LayoutManager layout) {
		super(layout);
		setOpaque(false);
		setBackground(new Color(0, 0, 0, C.UI_BG_OPACITY));
	}
	
	// This fixes a rendering glitch where the background would be overpainted on label-change
	protected void paintComponent(Graphics g)
	{
	    g.setColor( getBackground() );
	    g.fillRect(0, 0, getWidth(), getHeight());
	    super.paintComponent(g);
	}

}
