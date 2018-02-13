1. copy deng to /usr/share/X11/xkb/symbols/

2. /usr/share/X11/xkb/rules/xorg.lst, at the end of !layout section:
deng            English with german chars

3. /usr/share/X11/xkb/rules/evdev.xml, at the end of "layoutList" tag:
<layout>
   <configItem>
      <name>deng</name>
        <shortDescription>dg</shortDescription>
        <description>English (US with german chars on AltGr)</description>
        <languageList>
          <iso639Id>eng</iso639Id>
        </languageList>
      </configItem>
      <variantList/>
</layout>

4. sudo dpkg-reconfigure keyboard-configuration

5. restart if does`t work
