# ApertureTool
AppleScript to preserve image version name of Aperture Library

## Migrate Apple Aperture to Capture One

### Backup Aperture Library

In my case, Capture One Importer seem corrupt the Aperture Library, after been imported to Capture One, the Aperture Library can be opened by Apple Aperture again. So always backup the Aperture Library before importing.

### Prepare in Aperture Library

When using Capture One import and migrate Aperture libraries into Capture One Pro’s Catalogs, the name of image version is ignored.

```
Aperture version to IPTC.applescript
```

The script help to preserve image version name into IPTC tag (Status Title), if the IPTC tag (Status Title) is not empty, run this script before import to Capture One.

### Purify in Capture One

```
Capture One Purify.applescript
```

The script help to purify IPTC tag (Status Title) which is equal to image name, run this script after been imported to Capture One Catalog.

Reference [How to import an Aperture Library][1]

[1]: https://support.captureone.com/hc/en-us/articles/360008801138-How-to-import-an-Aperture-Library