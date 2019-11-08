class Channel {
  float amp, rev;
  int id;

  Channel(int _id) {
    id = _id;
  }

  void run() {
    amp = constrain(amp, fade, 1-fade);
    if (index == id) {

      amp += fade;
      soundfiles[id].amp(amp);
    } else {
      amp -= fade;
      soundfiles[id].amp(amp);
    }
    rate = constrain(rate, 0.4, 1);
    soundfiles[id].rate(rate);
    
  }
}