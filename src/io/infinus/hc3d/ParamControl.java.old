package io.infinus.hc3d;

import java.awt.Color;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JLabel;

@SuppressWarnings("serial")
public class ParamControl extends JComponent {
	final static int ELEMENT_SIZE = 30; // Each square internal control has this size
	final static int VGAP = 5;
	final static int HGAP = 5;
	
	Param param;
	float increment;
	int precision;
	
	JButton minusButton;
	JButton plusBtutton;
	JLabel valueLabel;
	
	public ParamControl(Param pParam, float pIncrement, int pPrecision) {
		super();
		increment = pIncrement;
		precision = pPrecision;
		param = pParam;
		GridLayout layout = new GridLayout(1, 3);
		layout.setVgap(VGAP);
		layout.setHgap(HGAP);
		setLayout(layout);
		
		JButton buttonMinus = new JButton("-");
		buttonMinus.setFont(C.FONT_MAIN);
		buttonMinus.setSize(ELEMENT_SIZE, ELEMENT_SIZE);
		buttonMinus.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				param.setValue(param.getValue() - increment);
				updateLabel();
			}
		});
		
		JButton buttonPlus = new JButton("+");
		buttonPlus.setFont(C.FONT_MAIN);
		buttonPlus.setSize(ELEMENT_SIZE, ELEMENT_SIZE);
		buttonPlus.addActionListener(new ActionListener() {
			@Override
			public void actionPerformed(ActionEvent e) {
				param.setValue(param.getValue() + increment);
				updateLabel();
			}
		});
		
		valueLabel = new JLabel();
		valueLabel.setForeground(Color.WHITE);
		valueLabel.setHorizontalAlignment(JLabel.CENTER);
		updateLabel();
		valueLabel.setFont(C.FONT_MAIN);
		valueLabel.setSize(ELEMENT_SIZE, ELEMENT_SIZE);
		
		// Add components
		add(buttonMinus);
		add(valueLabel);
		add(buttonPlus);
	}
	
	private void updateLabel() {
		String roundedVal = String.format("%.2f", param.getValue());  //Math.round(param.getValue() * 100f) / 100f
		valueLabel.setText("<html>" + param.getName() + "<br>" + roundedVal + "</div></html>");
	}
}
