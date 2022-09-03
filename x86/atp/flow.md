# ATP Flow

## Setup ATP phase
1. Setup network
2. Setup ATP code
3. Discover the scanner device

## Device configuration phase
1. Get the device configuration
2. Parse the configuration string
3. Save the devise configuration string in the device eeprom

## Firmware update
1. Issue any firmware updates if required:
2. Update the device bootloader
3. Update the NICs mac addresses
4. Commit the fw update changes: issue a reboot if required.

## ATP HW validation
1. Start HW validation
2. Create the device HW validation function array (hw-array)
3. Apply exceptions (batch, sn, specific conf options)
4. Walk through the hw-array and issue all tests. Report on an error if any of the tests fails.
* Stop the test procedure and report on the issue on any failures.
5. No issue reported at the test, then issue close manufacturing.

## Update the installed media
1. Deploy OS according to the device configuration.

## Finale
1. Report the validation status
