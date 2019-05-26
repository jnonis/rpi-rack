import processing.io.GPIO;
import processing.io.I2C;
import java.lang.reflect.Method;

/**
 * Allows access to hardware control using GPIO.
 */
class GPIOControl extends GPIO {
  final RotaryEncoder[] ENCODERS = new RotaryEncoder[] {
    new RotaryEncoder(22, 23),
    new RotaryEncoder(4, 6),
    new RotaryEncoder(16, 26),
    new RotaryEncoder(5, 12)
  };
  final int[] BUTTONS = { 27, 106, 13, 107, 105, 104 };
  int[] buttonStatus = new int[BUTTONS.length];  
  MCP23008 mcp23008;
  PApplet parent;
  Method encoderListener;
  Method buttonListener;
  
  GPIOControl() {
    // Init MCP23008
    mcp23008 = new MCP23008(I2C.list()[0]);
    for (int i = 0; i < 8; i++) {
      mcp23008.pinMode(i, GPIO.INPUT);
      mcp23008.pullUp(i, GPIO.HIGH);
    }
    
    // Init status
    for (int i = 0; i < buttonStatus.length; i++) {
      buttonStatus[i] = HIGH;
    }
        
    // Init GPIO
    for (int i = 0; i < ENCODERS.length; i++) {
      attachInterrupt(ENCODERS[i].pinA, GPIO.CHANGE);
    }
    for (int i = 0; i < BUTTONS.length; i++) {
      initButton(BUTTONS[i]);
    }
    
    // Start MCP23008 pulling
    pullMCP23008();
  }
  
  void initButton(int pinSwitch) {
    if (pinSwitch < 100) {
      GPIO.pinMode(pinSwitch, GPIO.INPUT_PULLUP);
      attachInterrupt(pinSwitch, GPIO.CHANGE);
    }
  }
  
  void handleInterrupt(int pin) { 
    for (int i = 0; i < ENCODERS.length; i++) {
      if (ENCODERS[i].pinA == pin) {
        // Update encoder
        handleEncoder(i);
      } else if (BUTTONS[i] == pin) {
        // Update switch
        handleGPIOButton(i);
      }
    }
  }
  
  void handleEncoder(int i) {
    int value = ENCODERS[i].read();
    if (value != 0 && encoderListener != null) {
      try {
        encoderListener.invoke(parent, i, value);
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
  
  void handleGPIOButton(int i) {
    int value = GPIO.digitalRead(BUTTONS[i]); 
    handleButton(i, value);
  }
  
  void handleButton(int i, int value) {
    if (buttonStatus[i] != value) {
      if (buttonListener != null) {
        try {
          buttonListener.invoke(parent, i, 1 - value);
        } catch (Exception e) {
          e.printStackTrace();
        }
      }
      buttonStatus[i] = value;
    }
  }

  void pullMCP23008() {
    Thread t = new Thread(new Runnable() {
      public void run() {
        try {
          while (!Thread.currentThread().isInterrupted()) {
            for (int i = 0; i < BUTTONS.length; i++) {
              if (BUTTONS[i] >= 100) {
                int value = mcp23008.digitalRead(BUTTONS[i] - 100);
                handleButton(i, value);
              }
            }
            Thread.sleep(10);
          }
        } catch (Exception e) {
          // terminate the thread on any unexpected exception that might occur
          System.err.println("Terminating MCP230008 pull after catching: " + e.getMessage());
        }
      }
    }, "PULL MPC23008");

    t.setPriority(Thread.MAX_PRIORITY);
    t.start();
  }
  
  void attachInterrupt(int pin, int mode) {
    if (irqThreads.containsKey(pin)) {
      throw new RuntimeException("You must call releaseInterrupt before attaching another interrupt on the same pin");
    }

    enableInterrupt(pin, mode);

    final int irqPin = pin;
    Thread t = new Thread(new Runnable() {
      public void run() {
        boolean gotInterrupt = false;
        try {
          do {
            try {
              if (waitForInterrupt(irqPin, 100)) {
                gotInterrupt = true;
              }
              if (gotInterrupt && serveInterrupts) {
                handleInterrupt(irqPin);
                gotInterrupt = false;
              }
              // if we received an interrupt while interrupts were disabled
              // we still deliver it the next time interrupts get enabled
              // not sure if everyone agrees with this logic though
            } catch (RuntimeException e) {
              // make sure we're not busy spinning on error
              Thread.sleep(100);
            }
          } while (!Thread.currentThread().isInterrupted());
        } catch (Exception e) {
          // terminate the thread on any unexpected exception that might occur
          System.err.println("Terminating interrupt handling for pin " + irqPin + " after catching: " + e.getMessage());
        }
      }
    }, "GPIO" + pin + " IRQ");

    t.setPriority(Thread.MAX_PRIORITY);
    t.start();

    irqThreads.put(pin, t);
  }
  
  void attachEncoderListener(PApplet parent, String method) {
    try {
      encoderListener = parent.getClass().getMethod(method, int.class, int.class);
      this.parent = parent;
    } catch (NoSuchMethodException e) {
      throw new RuntimeException("Method " + method + " does not exist");
    }
  }
  
  void attachButtonListener(PApplet parent, String method) {
    try {
      buttonListener = parent.getClass().getMethod(method, int.class, int.class);
      this.parent = parent;
    } catch (NoSuchMethodException e) {
      throw new RuntimeException("Method " + method + " does not exist");
    }
  }
}

/**
 * MCP23008 implementation ported from:
 * https://github.com/adafruit/Adafruit-MCP23008-library
 */
class MCP23008 extends I2C {
  // Address
  static final int MCP23008_ADDRESS = 0x20;
  // Registers
  static final int MCP23008_IODIR = 0x00;
  static final int MCP23008_IPOL = 0x01;
  static final int MCP23008_GPINTEN = 0x02;
  static final int MCP23008_DEFVAL = 0x03;
  static final int MCP23008_INTCON = 0x04;
  static final int MCP23008_IOCON = 0x05;
  static final int MCP23008_GPPU = 0x06;
  static final int MCP23008_INTF = 0x07;
  static final int MCP23008_INTCAP = 0x08;
  static final int MCP23008_GPIO = 0x09;
  static final int MCP23008_OLAT = 0x0A;
  
  int i2caddr;
  
  MCP23008(String dev) {
    this(dev, 0);
  }
  
  MCP23008(String dev, int addr) {
    super(dev);

    if (addr > 7) {
      addr = 7;
    }
    i2caddr = addr;
  
    // set defaults!
    beginTransmission(MCP23008_ADDRESS | i2caddr);
    write((byte)MCP23008_IODIR);
    write((byte)0xFF);  // all inputs
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);
    write((byte)0x00);  
    endTransmission();
  }
  
  void pinMode(int p, int d) {
    int iodir;
    
    // only 8 bits!
    if (p > 7)
      return;
    
    iodir = read8(MCP23008_IODIR);
  
    // set the pin and direction
    if (d == GPIO.INPUT) {
      iodir |= 1 << p; 
    } else {
      iodir &= ~(1 << p);
    }
    
    // write the new IODIR
    write8(MCP23008_IODIR, iodir);
  }
  
  int readGPIO() {
    // read the current GPIO input 
    return read8(MCP23008_GPIO);
  }
  
  void writeGPIO(int gpio) {
    write8(MCP23008_GPIO, gpio);
  }
  
  void digitalWrite(int p, int d) {
    int gpio;
    
    // only 8 bits!
    if (p > 7)
      return;
  
    // read the current GPIO output latches
    gpio = readGPIO();
  
    // set the pin and direction
    if (d == GPIO.HIGH) {
      gpio |= 1 << p; 
    } else {
      gpio &= ~(1 << p);
    }
  
    // write the new GPIO
    writeGPIO(gpio);
  }
  
  void pullUp(int p, int d) {
    int gppu;
    
    // only 8 bits!
    if (p > 7)
      return;
  
    gppu = read8(MCP23008_GPPU);
    // set the pin and direction
    if (d == GPIO.HIGH) {
      gppu |= 1 << p; 
    } else {
      gppu &= ~(1 << p);
    }
    // write the new GPIO
    write8(MCP23008_GPPU, gppu);
  }
  
  int digitalRead(int p) {
    // only 8 bits!
    if (p > 7)
      return 0;
  
    // read the current GPIO
    return (readGPIO() >> p) & 0x1;
  }
  
  int read8(int addr) {
    beginTransmission(MCP23008_ADDRESS | i2caddr);
    write((byte)addr);  
    endTransmission();
    beginTransmission(MCP23008_ADDRESS | i2caddr);
    byte[] data = read(1);
    endTransmission();
    return data[0];
  }
  
  void write8(int addr, int data) {
    beginTransmission(MCP23008_ADDRESS | i2caddr);
    write((byte)addr);
    write((byte)data);
    endTransmission();
  }
}

/**
 * Harware rotary encoder handler.
 * - initialize GPIO
 * - read direction
 * - detect velocity
 */
public class RotaryEncoder {
  final int pinA;
  final int pinB;
  private int status = GPIO.HIGH;
  private int lastValue;
  private int lastValueTime;
  private int counter;
  
  public RotaryEncoder(int pinA, int pinB) {
    this.pinA = pinA;
    this.pinB = pinB;
    GPIO.pinMode(pinA, GPIO.INPUT_PULLUP);
    GPIO.pinMode(pinB, GPIO.INPUT_PULLUP);
  }
  
  public int read() {
    int n = GPIO.digitalRead(pinA);
    int value = 0;
    int velocity = 1;
    if ((status == GPIO.LOW) && (n == GPIO.HIGH)) {
      if (GPIO.digitalRead(pinB) == GPIO.LOW) {
        value--;
      } else {
        value++;
      }
      
      if(value == lastValue) {
        counter++;
        int now = millis();
        if(now - lastValueTime < 100) {
            velocity = max((counter / 6) * 5, 1);
        }
        lastValueTime = now;
      } else {
        counter = 0;
      }
      lastValue = value;
    }
    status = n;
    return value * velocity;
  }
}
