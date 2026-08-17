{ ... }:
{
  services.udev.extraHwdb = ''
    # X1 Carbon internal AT keyboard only; USB keyboards do not match.
    evdev:atkbd:dmi:bvn*:bvr*:bd*:svnLENOVO*:pn21KC002SAU:pvr*
     KEYBOARD_KEY_01=capslock
     KEYBOARD_KEY_3a=esc
  '';
}
